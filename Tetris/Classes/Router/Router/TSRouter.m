//
//  TSRouter.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#import "TSRouter.h"
#import "TSTree.h"
#import "TSError.h"

#pragma mark - TSRouteResult

@implementation TSRouteResult

+ (TSRouteResult *)resultWithStatus:(TSRouteResultStatus)status destination:(UIViewController *)destination intent:(TSIntent *)intent error:(NSError *)error {
    TSRouteResult *ret = [[TSRouteResult alloc] init];
    ret.status = status;
    ret.destination = destination;
    ret.intent = intent;
    ret.error = error;
    return ret;
}


@end


#pragma mark - TSRouter


@interface TSRouter ()

@property (nonatomic, strong) TSSyncTree *syncTree;

@end

@implementation TSRouter

- (instancetype)init {
    if (self = [super init]) {
        _intercepterMgr = [TSIntercepterManager new];
        _syncTree = [TSSyncTree new];
    }
    return self;
}

#pragma mark - Action
#pragma mark - Listener
#pragma mark - View

- (void)bindUrl:(NSString *)urlString viewController:(Class<TSIntentable>)aClass {
    [_syncTree buildTreeWithURLString:urlString value:aClass];
}

#pragma mark - private

- (void)_startIntent:(TSIntent *)intent
              source:(UIViewController *)source
            switched:(BOOL)switched
          completion:(void (^)(void))completion
              finish:(void(^)(TSRouteResult *result, NSError *error))finish {
    // fix intent
    if (intent.intentClass == nil && intent.intentable == nil) {
        TSTreeUrlComponent *comp = [_syncTree findByURLString:intent.urlString];
        intent.urlComponent = comp;
        intent.intentClass = comp.value;
        [intent.extraParameters addEntriesFromDictionary:comp.params];
    }
    
    [_intercepterMgr runIntent:intent source:source finish:^(TSIntercepterResult * _Nonnull result) {
        switch (result.status) {
            case TSIntercepterResultStatusSwitched:
            {
                [self _startIntent:result.intent source:source switched:YES completion:completion finish:finish];
                break;
            }
            case TSIntercepterResultStatusRejected:
            {
                // finih by rejected;
                TSRouteResult *ret = [TSRouteResult resultWithStatus:TSRouteResultStatusinterrupted destination:nil intent:result.intent error:result.error];
                finish(ret, result.error);
                break;
            }
                
            case TSIntercepterResultStatusPass:
            {
                if (result.intent.intentable) {
                    // 如果有主动设置对象，最高优先级
                    finish([self startViewTransition:result.intent viewController:result.intent.intentable], nil);
                } else if (result.intent.intentClass) {
                    // 找到配置
                    UIViewController *vc = [self generateInstanceForIntent:result.intent];
                    finish([self startViewTransition:result.intent viewController:vc], nil);
                } else {
                    // Lost
                    NSError *lostError = [NSError ts_errorWithCode:-18888 msg:@"Route error: Lost!!!"];
                    TSRouteResult *ret = [TSRouteResult resultWithStatus:TSRouteResultStatusLost destination:nil intent:result.intent error:lostError];
                    finish(ret, lostError);
                }
                break;
            }
                
            default:
                break;
        }
    }];
}

- (TSRouteResult *)startViewTransition:(TSIntent *)intent viewController:(UIViewController *)vc {
    // TODO: lskdjf
    return nil;
}

- (UIViewController<TSIntentable> *)generateInstanceForIntent:(TSIntent *)intent {
    
    if (!intent.intentable) return intent.intentable;
    
    UIViewController<TSIntentable> *intentable;
    
    if (!intent.intentable && intent.intentClass) {
         intentable = [[((Class)intent.intentClass) alloc] initWithIntent:intent];
    }
    [intentable ts_setIntent:intent];
    
    return intentable;
}

//- (TSRouteResult *)viewTransitionAction:(TSIntent *)finalIntent source:(UIViewController *)source switched:(BOOL)switched completion:(void (^)(void))completion {
//
//    id<TSIntentable> vc = [[finalIntent.intentClass alloc] initWithIntent:finalIntent];
//    // creation listening
////    [self.creationListeners enumerateObjectsUsingBlock:^(id<RIViewIntentableCreationListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        [obj ri_didCreateViewIntentable:vc];
////    }];
//    // set intent
//    vc.ri_sourceIntent = finalIntent;
//    // auto wire parameters
//    [((NSObject *)vc) ri_autowireRITypesWithDict:finalIntent.params];
//
//    // start transioning
//    if (source) {
//        if (finalIntent.displayer) {
//            [finalIntent.displayer ri_displayFromViewController:source toViewController:(UIViewController *)vc animated:YES completion:completion];
//        } else {
//            NSLog(@"RouteIntent warning: displayer doesn't exists!!!");
//        }
//    }
//
//    return [RIRouteResult resultWithStatus:switched ? RIRouteResultStatusSwitched : RIRouteResultStatusPass destination:(UIViewController *)vc intent:finalIntent error:nil];
//}

@end
