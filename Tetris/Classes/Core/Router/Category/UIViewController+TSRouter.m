//
//  UIViewController+TSRouter.m
//  Tetris
//
//  Created by 王俊仁 on 2018/9/30.
//

#import "UIViewController+TSRouter.h"
#import "TSLogger.h"
#import "_TSDefaultFinishDisplayer.h"
#import <objc/runtime.h>

@implementation UIViewController (TSRouter)

#pragma mark - 初始化

+ (instancetype)ts_createWithIntent:(TSIntent *)intent {
    return [[self alloc] initWithNibName:nil bundle:nil];
}

- (NSObject *)ts_kvoInjector {
    return self;
}

+ (id<TSIntercepter>)ts_selfIntercepter {
    return nil;
}

- (void)didCreateWithIntent:(TSIntent *)intent {
    
}

- (void)setTs_sourceIntent:(TSIntent *)ts_sourceIntent {
    objc_setAssociatedObject(self, _cmd, ts_sourceIntent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TSIntent *)ts_sourceIntent {
    return objc_getAssociatedObject(self, @selector(setTs_sourceIntent:));
}

- (UIViewController *)ts_viewController {
    return self;
}

#pragma mark - 跳转

- (TSStream<TSRouteResult *> *)ts_prepare:(TSIntent *)intent complete:(void (^ _Nullable)(void))complete {
    return [_Tetris.router prepare:intent source:self complete:complete];
}

- (TSStream<TSRouteResult *> *)ts_prepare:(TSIntent *)intent {
    return [self ts_prepare:intent complete:nil];
}

- (void)ts_start:(TSIntent *)intent complete:(void (^ _Nullable)(void))complete {
    [[[self ts_prepare:intent complete:complete]
      onError:^(NSError * _Nonnull error) {
          TSLog(@"%@", error);
      }]
     subscribe];
}

- (void)ts_start:(TSIntent *)intent {
    return [self ts_start:intent complete:nil];
}

- (id<TSIntentable>)ts_getIntentable {
    if (![self conformsToProtocol:@protocol(TSIntentable)]) {
        TSLog(@"[%@] didn't conforms to protocol <%@>", NSStringFromClass(self.class), NSStringFromProtocol(@protocol(TSIntentable)));
        return nil;
    }
    return (id<TSIntentable>)self;
}

- (id<TSIntentDisplayerProtocol>)ts_getDisplayer {
    id<TSIntentable> intentable = [self ts_getIntentable];
    if (!intentable.ts_sourceIntent.displayer) {
        TSLog(@"Displayer is nil");
        return nil;
    }
    return intentable.ts_sourceIntent.displayer;
}

- (void)ts_transitionUrl:(NSString *)url viewController:(UIViewController *)vc aClass:(Class<TSIntentable>)aClass builder:(id<TSIntentable> (^)(void))builder displayer:(id<TSIntentDisplayerProtocol>)displayer {
    TSIntent *intent = [[TSIntent alloc] init];
    if (url.length) {
        intent.urlString = url;
    } else if (vc != nil) {
        __weak typeof(vc) wvc = vc;
        intent.builder = [[TSIntentableBuilder alloc] initWithId:nil creation:^id<TSIntentable> _Nullable{
            return wvc;
        }];
    } else if (builder) {
        intent.builder = [[TSIntentableBuilder alloc] initWithId:nil creation:builder];
    } else if (aClass) {
        intent.intentClass = aClass;
    }
    if (displayer) {
        intent.displayer = displayer;
    }
    [self ts_start:intent];
}

- (void)ts_pushViewController:(UIViewController *)vc {
    [self ts_transitionUrl:nil viewController:vc aClass:nil builder:nil displayer:[TSPushPopDisplayer new]];
}
- (void)ts_pushBuilder:(id<TSIntentable>  _Nonnull (^)(void))builder {
    [self ts_transitionUrl:nil viewController:[builder() ts_viewController] aClass:nil builder:nil displayer:[TSPushPopDisplayer new]];
}
- (void)ts_pushUrl:(NSString *)url {
    [self ts_transitionUrl:url viewController:nil aClass:nil builder:nil displayer:[TSPushPopDisplayer new]];
}
- (void)ts_pushClass:(Class<TSIntentable>)aClass {
    [self ts_transitionUrl:nil viewController:nil aClass:aClass builder:nil displayer:[TSPushPopDisplayer new]];
}

- (void)ts_presentViewController:(UIViewController *)vc {
    [self ts_transitionUrl:nil viewController:vc aClass:nil builder:nil displayer:[TSPresentDismissDisplayer new]];
}
- (void)ts_presentBuilder:(id<TSIntentable>  _Nonnull (^)(void))builder {
    [self ts_transitionUrl:nil viewController:nil aClass:nil builder:builder displayer:[TSPresentDismissDisplayer new]];
}
- (void)ts_presentUrl:(NSString *)url {
    [self ts_transitionUrl:url viewController:nil aClass:nil builder:nil displayer:[TSPresentDismissDisplayer new]];
}
- (void)ts_presentClass:(Class<TSIntentable>)aClass {
    [self ts_transitionUrl:nil viewController:nil aClass:aClass builder:nil displayer:[TSPresentDismissDisplayer new]];
}

#pragma mark - Finish

- (void)ts_finishDisplay:(BOOL)animated complete:(void (^)(void))complete {
    id<TSIntentDisplayerProtocol> displayer = [self ts_getDisplayer];
    if (!displayer) {
        displayer = [_TSDefaultFinishDisplayer new];
        TSLog(@"Displayer is nil, will finish by [_TSDefaultFinishDisplayer]");
    }
    [displayer ts_finishDisplayViewController:self animated:animated completion:complete];
}

- (void)ts_finishDisplay:(BOOL)animated {
    [self ts_finishDisplay:animated complete:nil];
}

- (void)ts_finishDisplay {
    [self ts_finishDisplay:YES];
}

- (void)ts_setNeedDisplay:(BOOL)animated complete:(void (^)(void))complete {
    [[self ts_getDisplayer] ts_setNeedDisplay:self animated:animated completion:complete];
}

- (void)ts_setNeedDisplay:(BOOL)animated {
    [self ts_setNeedDisplay:animated complete:nil];
}

- (void)ts_setNeedDisplay {
    [self ts_setNeedDisplay:YES];
}

#pragma mark - Result

- (void)ts_sendResult:(id)object forKey:(NSString *)key {
    [[self ts_getIntentable].ts_sourceIntent sendResult:object source:self for:key];
}

- (void)ts_sendNumber:(NSNumber *)number {
    [[self ts_getIntentable].ts_sourceIntent sendNumber:number source:self];
}

- (void)ts_sendString:(NSString *)string {
    [[self ts_getIntentable].ts_sourceIntent sendString:string source:self];
}

- (void)ts_sendDict:(NSDictionary *)dict {
    [[self ts_getIntentable].ts_sourceIntent sendDict:dict source:self];
}

- (void)ts_sendSuccess {
    [[self ts_getIntentable].ts_sourceIntent sendSuccessWithSource:self];
}

- (void)ts_sendCancel {
    [[self ts_getIntentable].ts_sourceIntent sendCancelWithSource:self];
}

@end
