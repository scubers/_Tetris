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
#import "TSCreator.h"

#pragma mark - _TSRouteAction

@interface _TSRouteAction : NSObject <TSRouteActioner>

@property (nonatomic, copy) TSStream *(^action)(TSTreeUrlComponent *component);

@end

@implementation _TSRouteAction

+ (instancetype)ts_create {
    return [[self alloc] init];
}

- (TSStream *)getStreamByComponent:(TSTreeUrlComponent *)component {
    return _action(component);
}

@end

#pragma mark - TSRouteResult

@implementation TSRouteResult

+ (TSRouteResult *)resultWithStatus:(TSRouteResultStatus)status viewControllable:(id<TSViewControllable>)viewControllable intent:(TSIntent *)intent error:(NSError *)error {
    TSRouteResult *ret = [[TSRouteResult alloc] init];
    ret.status = status;
    ret.viewControllable = viewControllable;
    ret.intent = intent;
    ret.error = error;
    return ret;
}


@end


#pragma mark - TSRouter

// O(n) /x/y/z
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

- (void)bindUrl:(NSString *)url toRouteAction:(id<TSRouteActioner>)action {
    [_actionTree buildTreeWithURLString:url value:action];
}

- (void)bindUrl:(NSString *)url toAction:(TSStream * _Nonnull (^)(TSTreeUrlComponent * _Nonnull))action {
    _TSRouteAction *actionObj = [_TSRouteAction new];
    actionObj.action = action;
    [self bindUrl:url toRouteAction:actionObj];
}

- (TSStream *)actionByUrl:(NSString *)url params:(NSDictionary *)params {
    TSTreeUrlComponent *comp = [_actionTree findByURLString:url];
    if (!comp) {
        return nil;
    }
    [comp.params addEntriesFromDictionary:params];
    id<TSRouteActioner> action = (id<TSRouteActioner>)comp.value;
    return [action getStreamByComponent:comp];
}

- (TSStream *)actionByUrl:(NSString *)url {
    return [self actionByUrl:url params:nil];
}

#pragma mark - Listener

- (void)registerDrivenByUrl:(NSString *)urlString {
    [_drivenTree buildTreeWithURLString:urlString value:[TSDrivenStream stream]];
}

- (TSCanceller *)subscribeDrivenByUrl:(NSString *)urlString callback:(void (^)(TSTreeUrlComponent * _Nonnull))callback {
    
    TSTreeUrlComponent *comp;
    @synchronized (_drivenTree) {
        comp = [_drivenTree findByURLString:urlString];
        if (!comp.value) {
            [self registerDrivenByUrl:urlString];
            comp = [_drivenTree findByURLString:urlString];
        }
    }
    return [((TSDrivenStream<TSTreeUrlComponent *> *)comp.value) subscribeNext:^(TSTreeUrlComponent * _Nullable obj) {
        callback(obj);
    }];
    
}

- (void)postDrivenByUrl:(NSString *)url params:(NSDictionary *)params {
    TSTreeUrlComponent *comp = [_drivenTree findByURLString:url];
    if (!comp.value || ![comp.value isKindOfClass:[TSDrivenStream class]]) {
        return;
    }
    [comp.params addEntriesFromDictionary:params];
    [((TSDrivenStream<TSTreeUrlComponent *> *)comp.value) post:comp];
}

- (void)postStream:(NSString *)urlString params:(NSDictionary *)params {
    TSTreeUrlComponent *comp = [_drivenTree findByURLString:urlString];
    [comp.params addEntriesFromDictionary:params];
    if ([comp.value isKindOfClass:[TSDrivenStream class]]) {
        [((TSDrivenStream *)comp.value) post:comp];
    }
}

- (TSDrivenStream *)drivenByUrl:(NSString *)url {
    return [_drivenTree findByURLString:url].value;
}

#pragma mark - View

- (void)bindUrl:(NSString *)urlString intentable:(Class<TSIntentable>)aClass {
    [_viewTree buildTreeWithURLString:urlString value:aClass];
}

- (TSStream<TSRouteResult *> *)prepare:(TSIntent *)intent source:(nullable id<TSViewControllable>)source complete:(void (^ _Nullable)(void))complete {
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

- (TSStream<TSRouteResult *> *)prepare:(TSIntent *)intent source:(id<TSViewControllable>)source {
    return [self prepare:intent source:source complete:nil];
}

- (TSStream<TSRouteResult *> *)prepare:(TSIntent *)intent {
    return [self prepare:intent source:nil];
}

#pragma mark - private

- (void)_startIntent:(TSIntent *)intent
              source:(id<TSViewControllable>)source
          completion:(void (^)(void))completion
              finish:(void(^)(TSRouteResult *result))finish {

    if (intent.viewControllable != nil) {
        // intent 手动设置对象属于异常情况直接跳转
        finish([self startViewTransition:intent source:source target:intent.viewControllable complete:completion]);
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
                TSRouteResult *ret = [TSRouteResult resultWithStatus:TSRouteResultStatusRejected viewControllable:nil intent:result.intent error:result.error];
                finish(ret);
                break;
            }
                
            case TSIntercepterResultStatusPass:
            {
                if (result.intent.viewControllable) {
                    // 如果有主动设置对象，最高优先级
                    finish([self startViewTransition:result.intent
                                              source:source
                                              target:result.intent.viewControllable
                                            complete:completion]);

                } else if (result.intent.intentClass) {
                    // 找到配置
                    id<TSViewControllable> target = [self generateInstanceForIntent:result.intent];
                    finish([self startViewTransition:result.intent
                                              source:source
                                              target:target
                                            complete:completion]);
                } else {
                    // Lost
                    NSError *lostError = [NSError ts_errorWithCode:-18888 msg:@"Route error: Lost!!!"];
                    TSRouteResult *ret = [TSRouteResult resultWithStatus:TSRouteResultStatusLost viewControllable:nil intent:result.intent error:lostError];
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
                                source:(id<TSViewControllable>)source
                                target:(id<TSViewControllable>)target
                              complete:(void (^)(void))complete {

    TSRouteResult *ret = [TSRouteResult resultWithStatus:TSRouteResultStatusPass viewControllable:target intent:intent error:nil];

    if (!source) return ret;

    if (!intent.displayer) {
        TSLog(@"Displayer is nil.");
    } else {
        UIViewController *sourceVC = [source ts_viewController];
        UIViewController *targetVC = [target ts_viewController];
        [intent.displayer ts_displayFromViewController:sourceVC toViewController:targetVC animated:YES completion:complete];
    }

    return ret;
}

- (id<TSViewControllable>)generateInstanceForIntent:(TSIntent *)intent {
    
    if (intent.viewControllable) return intent.viewControllable;
    
    id<TSIntentable> intentable;
    
    if (!intent.viewControllable && intent.intentClass) {
        intentable = (id<TSIntentable>)[[TSCreator shared] createByClass:intent.intentClass];
        [(id<TSIntentable>)intentable setTs_sourceIntent:intent];
    }

    return intentable;
}

@end
