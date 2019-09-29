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
#import "TSTypesAutowire.h"

#pragma mark - _TSRouteAction

@interface _TSRouteAction : NSObject <TSRouteActioner>

@property (nonatomic, copy) TSStream *(^action)(TSTreeUrlComponent *component);

@end

@implementation _TSRouteAction

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

- (void)bindUrl:(id<TSURLPresentable>)url toRouteAction:(id<TSRouteActioner>)action {
    [_actionTree buildWithURL:url value:action];
}

- (void)bindUrl:(id<TSURLPresentable>)url toAction:(TSStream * _Nonnull (^)(TSTreeUrlComponent * _Nonnull))action {
    _TSRouteAction *actionObj = [_TSRouteAction new];
    actionObj.action = action;
    [self bindUrl:url toRouteAction:actionObj];
}

- (TSStream *)actionByUrl:(id<TSURLPresentable>)url params:(nullable NSDictionary *)params {
    TSTreeUrlComponent *comp = [_actionTree findByURL:url];
    if (!comp) {
        return nil;
    }
    [comp.params addEntriesFromDictionary:params];
    id<TSRouteActioner> action = (id<TSRouteActioner>)comp.value;
    return [action getStreamByComponent:comp];
}

- (TSStream *)actionByUrl:(id<TSURLPresentable>)url {
    return [self actionByUrl:url params:nil];
}

#pragma mark - Listener

- (void)registerDrivenByUrl:(id<TSURLPresentable>)urlString {
    [_drivenTree buildWithURL:urlString value:[TSDrivenStream stream]];
}


- (TSCanceller *)subscribeDrivenByUrl:(id<TSURLPresentable>)urlString callback:(void (^)(TSTreeUrlComponent * _Nonnull))callback {
    TSTreeUrlComponent *comp;
    @synchronized (_drivenTree) {
        comp = [_drivenTree findByURL:urlString];
        if (!comp.value) {
            [self registerDrivenByUrl:urlString];
            comp = [_drivenTree findByURL:urlString];
        }
    }
    return [((TSDrivenStream<TSTreeUrlComponent *> *)comp.value) subscribeNext:^(TSTreeUrlComponent * _Nullable obj) {
        callback(obj);
    }];
    
}

- (void)postDrivenByUrl:(id<TSURLPresentable>)url params:(NSDictionary *)params {
    TSTreeUrlComponent *comp = [_drivenTree findByURL:url];
    if (!comp.value || ![comp.value isKindOfClass:[TSDrivenStream class]]) {
        return;
    }
    [comp.params addEntriesFromDictionary:params];
    [((TSDrivenStream<TSTreeUrlComponent *> *)comp.value) post:comp];
}

- (void)postStream:(id<TSURLPresentable>)urlString params:(NSDictionary *)params {
    TSTreeUrlComponent *comp = [_drivenTree findByURL:urlString];
    [comp.params addEntriesFromDictionary:params];
    if ([comp.value isKindOfClass:[TSDrivenStream class]]) {
        [((TSDrivenStream *)comp.value) post:comp];
    }
}

- (TSDrivenStream *)drivenByUrl:(id<TSURLPresentable>)url {
    return [_drivenTree findByURL:url].value;
}

#pragma mark - View

- (void)bindUrl:(id<TSURLPresentable>)urlString intentable:(Class<TSIntentable>)aClass {
    [self bindLine:[[TSLine alloc] initWithUrl:urlString desc:@"" class:aClass]];
}

- (void)bindLine:(TSLine *)line {
    [_viewTree buildWithURL:line.url value:line];
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
    
    // 当前intent不能构造target的时候，需要查询树
    if (!intent.isCreatable && intent.urlString.length > 0) {
        TSTreeUrlComponent *comp = [_viewTree findByURL:intent.urlString];
        intent.urlComponent = comp;
        intent.intentClass = ((TSLine *)(comp.value)).intentableClass;
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
                
                id<TSViewControllable> target = [self generateInstanceFromIntent:result.intent];
                
                if (target) {
                    // 找到配置
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

- (id<TSIntentable>)generateInstanceFromIntent:(TSIntent *)intent {
    
    id<TSIntentable> intentable;
    
    if (intent.builder) {
        intentable = intent.builder.creation();
    } else if (intent.intentClass) {
        intentable = [[TSCreator shared] createIntentableByClass:intent.intentClass intent:intent];
    }
    
    if (intentable) {
        [(id<TSIntentable>)intentable setTs_sourceIntent:intent];
        NSObject *injector = [intentable ts_kvoInjector];
        if (_viewControllableParamInject && injector != nil) {
            [injector ts_autowireTSTypesWithDict:intent.extraParameters];
        }
    }

    if (intent.didCreate) {
        intent.didCreate(intentable);
    }

    return intentable;
}

@end
