//
//  TSRouter.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#import "TSRouter.h"
#import "TSTree.h"
#import "TSError.h"
#import "TSLogger.h"

#pragma mark - _TSRouteAction

@interface _TSRouteAction : NSObject <TSRouteActionProtocol>

@property (nonatomic, copy) TSStream *(^action)(TSTreeUrlComponent *component);

@end

@implementation _TSRouteAction

- (TSStream *)getStreamByComponent:(TSTreeUrlComponent *)component {
    return _action(component);
}

@end

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

@property (nonatomic, strong) TSSyncTree *viewTree;
@property (nonatomic, strong) TSSyncTree *actionTree;
@property (nonatomic, strong) TSSyncTree *drivenTree;

@end

@implementation TSRouter

- (instancetype)init {
    if (self = [super init]) {
        _intercepterMgr = [TSIntercepterManager new];
        _viewTree = [TSSyncTree new];
        _actionTree = [TSSyncTree new];
        _drivenTree = [TSSyncTree new];
    }
    return self;
}

#pragma mark - Action

- (void)bindUrl:(NSString *)url toRouteAction:(id<TSRouteActionProtocol>)action {
    [_actionTree buildTreeWithURLString:url value:action];
}

- (void)bindUrl:(NSString *)url toAction:(TSStream * _Nonnull (^)(TSTreeUrlComponent * _Nonnull))action {
    _TSRouteAction *actionObj = [_TSRouteAction new];
    actionObj.action = action;
    [self bindUrl:url toRouteAction:actionObj];
}

- (TSStream *)actionByUrl:(NSString *)url {
    TSTreeUrlComponent *comp = [_actionTree findByURLString:url];
    if (!comp) {
        return nil;
    }
    id<TSRouteActionProtocol> action = (id<TSRouteActionProtocol>)comp.value;
    return [action getStreamByComponent:comp];
}

#pragma mark - Listener

- (void)bindUrl:(NSString *)url toDriven:(TSDrivenStream *)stream {
    [_drivenTree buildTreeWithURLString:url value:stream];
}

- (TSDrivenStream *)drivenByUrl:(NSString *)url {
    return [_drivenTree findByURLString:url].value;
}

#pragma mark - View

- (void)bindUrl:(NSString *)urlString viewController:(Class<TSIntentable>)aClass {
    [_viewTree buildTreeWithURLString:urlString value:aClass];
}

- (TSStream<TSRouteResult *> *)prepare:(TSIntent *)intent source:(UIViewController *)source complete:(void (^)(void))complete {
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        [self _startIntent:intent source:source completion:complete finish:^(TSRouteResult *result) {
            if (result.error) {
                [receiver postError:result.error];
            } else {
                [receiver post:result];
                [receiver close];
            }
        }];
        return nil;
    }];
}

#pragma mark - private

- (void)_startIntent:(TSIntent *)intent
              source:(UIViewController *)source
          completion:(void (^)(void))completion
              finish:(void(^)(TSRouteResult *result))finish {

    if (intent.intentable != nil) {
        // intent 手动设置对象属于异常情况直接跳转
        finish([self startViewTransition:intent source:source viewController:intent.intentable complete:completion]);
        return;
    }

    // fix intent
    if (intent.intentClass == nil) {
        TSTreeUrlComponent *comp = [_viewTree findByURLString:intent.urlString];
        intent.urlComponent = comp;
        intent.intentClass = comp.value;
        [intent.extraParameters addEntriesFromDictionary:comp.params];
    }
    
    [_intercepterMgr runIntent:intent source:source finish:^(TSIntercepterResult * _Nonnull result) {
        switch (result.status) {
            case TSIntercepterResultStatusSwitched:
            {
                [self _startIntent:result.intent source:source completion:completion finish:finish];
                break;
            }
            case TSIntercepterResultStatusRejected:
            {
                // finih by rejected;
                TSRouteResult *ret = [TSRouteResult resultWithStatus:TSRouteResultStatusRejected destination:nil intent:result.intent error:result.error];
                finish(ret);
                break;
            }
                
            case TSIntercepterResultStatusPass:
            {
                if (result.intent.intentable) {
                    // 如果有主动设置对象，最高优先级
                    finish([self startViewTransition:result.intent
                                              source:source
                                      viewController:result.intent.intentable
                                            complete:completion]);

                } else if (result.intent.intentClass) {
                    // 找到配置
                    UIViewController *vc = [self generateInstanceForIntent:result.intent];
                    finish([self startViewTransition:result.intent
                                              source:source
                                      viewController:vc
                                            complete:completion]);
                } else {
                    // Lost
                    NSError *lostError = [NSError ts_errorWithCode:-18888 msg:@"Route error: Lost!!!"];
                    TSRouteResult *ret = [TSRouteResult resultWithStatus:TSRouteResultStatusLost destination:nil intent:result.intent error:lostError];
                    finish(ret);
                }
                break;
            }
                
            default:
                break;
        }
    }];
}

- (TSRouteResult *)startViewTransition:(TSIntent *)intent
                                source:(UIViewController *)source
                        viewController:(UIViewController *)vc
                              complete:(void (^)(void))complete {

    TSRouteResult *ret = [TSRouteResult resultWithStatus:TSRouteResultStatusPass destination:vc intent:intent error:nil];

    if (!source) return ret;

    if (!intent.displayer) {
        TSLog(@"Displayer is nil.");
    } else {
        [intent.displayer ts_displayFromViewController:source toViewController:vc animated:YES completion:complete];
    }

    return ret;
}

- (UIViewController *)generateInstanceForIntent:(TSIntent *)intent {
    
    if (intent.intentable) return intent.intentable;
    
    UIViewController *intentable;
    
    if (!intent.intentable && intent.intentClass) {
        intentable = [((Class)intent.intentClass) ts_createByIntent:intent];
        [(id<TSIntentable>)intentable setTs_sourceIntent:intent];
    }

    return intentable;
}

@end
