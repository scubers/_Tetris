//
//  RIIntercepterManager.m
//  RouteIntent
//
//  Created by 王俊仁 on 2017/6/22.
//  Copyright © 2017年 jrwong. All rights reserved.
//

#import "TSIntercepterManager.h"
#import "TSIntent.h"
#import "TSError.h"
#import "UIViewController+TSRouter.h"

@interface _TSIntercepterJudger : NSObject <TSIntercepterJudger>

@property (nonatomic, strong) TSIntent *intent;

@property (nonatomic, strong) UIViewController *source;

@property (nonatomic, copy) void (^doSwitchAction)(TSIntent *intent);
@property (nonatomic, copy) void (^doRejectAction)(NSError *error);
@property (nonatomic, copy) void (^doContinueAction)(void);

@property (nonatomic, assign) BOOL rejectFlag;
@property (nonatomic, assign) BOOL switchFlag;
@property (nonatomic, assign) BOOL continueFlag;


@end

@implementation _TSIntercepterJudger

+ (instancetype)adjudgerWithSourceIntent:(TSIntent *)sourceIntent
                                  source:(UIViewController *)source
                                continue:(void (^)(void))doContinue
                                  switch:(void (^)(TSIntent *intent))doSwtich
                                  reject:(void (^)(NSError *error))doReject {
    _TSIntercepterJudger *adjudger = [[self alloc] init];
    adjudger.intent = sourceIntent;
    adjudger.doSwitchAction = doSwtich;
    adjudger.doRejectAction = doReject;
    adjudger.doContinueAction = doContinue;
    adjudger.source = source;
    return adjudger;
}

- (void)doReject:(NSError *)error {
    TSAssertion(!_continueFlag && !_switchFlag, "has call continue or switch before");
    _doRejectAction(error);
    _rejectFlag = YES;
}

- (void)doContinue {
    TSAssertion(!_rejectFlag && !_switchFlag, "has call reject or switch before");
    _doContinueAction();
    _continueFlag = YES;
}

- (void)doSwitch:(TSIntent *)intent {
    TSAssertion(!_rejectFlag && !_continueFlag, "has call continue or reject before");
    _doSwitchAction(intent);
    _switchFlag = YES;
}

- (void)dealloc {
    TSAssertion(_rejectFlag || _continueFlag || _switchFlag, "you should call reject or continue or switch in Intercepter");
}

- (void)restart {
    [self.source ts_start:self.intent];
}


@end

////////////////////////////////////////////////////////////////////////


@implementation TSIntercepterResult

+ (TSIntercepterResult *)resultWithStatus:(TSIntercepterResultStatus)status intent:(TSIntent *)intent error:(NSError *)error {
    TSIntercepterResult *ret = [[TSIntercepterResult alloc] init];
    ret.status = status;
    ret.intent = intent;
    ret.error = error;
    return ret;
}

@end



@interface TSIntercepterManager ()

@property (nonatomic, strong) NSMutableArray<id<TSIntercepter>> *intercepters;

@end

@implementation TSIntercepterManager

+ (instancetype)manager {
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _intercepters = [NSMutableArray array];
    }
    return self;
}

- (void)addIntercepter:(id<TSIntercepter>)intercepter {
    NSUInteger index = [_intercepters indexOfObjectPassingTest:^BOOL(id<TSIntercepter>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.priority < intercepter.priority) {
            return YES;
        }
        return NO;
    }];

    if (index == NSNotFound) {
        [_intercepters addObject:intercepter];
    } else {
        [_intercepters insertObject:intercepter atIndex:index];
    }
}

- (void)_runIntent:(TSIntent *)intent
            source:(UIViewController *)source
  intercepterIndex:(NSUInteger)index
      intercepters:(NSArray<id<TSIntercepter>> *)intercepters
            finish:(TSRunIntercepterFinish)finish {


    // declare a block that generate the adjudger;
    _TSIntercepterJudger *(^getAdjudger)() = ^() {
        return [_TSIntercepterJudger adjudgerWithSourceIntent:intent source:source continue:^{

            [self _runIntent:intent source:source intercepterIndex:index + 1 intercepters:intercepters finish:finish];

        } switch:^(TSIntent *newIntent) {
                TSAssertion(newIntent != intent, "Intercepter Error: can not switch the same intent");
                finish([TSIntercepterResult resultWithStatus:TSIntercepterResultStatusSwitched intent:newIntent error:nil]);

        } reject:^(NSError *error) {
            finish([TSIntercepterResult resultWithStatus:TSIntercepterResultStatusRejected intent:nil error:error]);
        }];
    };

    // passed all intercepters
    if (index > intercepters.count) {
        finish([TSIntercepterResult resultWithStatus:TSIntercepterResultStatusPass intent:intent error:nil]);
        return;
    }

    // exec if class implement the final adjudgement
    if (index == intercepters.count) {
        if (intent.intentClass && [intent.intentClass respondsToSelector:@selector(ts_finalAdjudgement:)]) {
            Class<TSIntentable> aClass = intent.intentClass;
            [aClass ts_finalAdjudgement:getAdjudger()];
        } else {
            finish([TSIntercepterResult resultWithStatus:TSIntercepterResultStatusPass intent:intent error:nil]);
        }
        return;
    }

    // exec the intercepter
    id<TSIntercepter> intercepter = intercepters[index];
    [intercepter ts_judgeIntent:getAdjudger()];
}

- (void)runIntent:(TSIntent *)intent source:(UIViewController *)source finish:(TSRunIntercepterFinish)finish {
    [self _runIntent:intent source:source intercepterIndex:0 intercepters:_intercepters finish:finish];
}



@end
