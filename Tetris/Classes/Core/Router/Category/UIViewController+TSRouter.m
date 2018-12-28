//
//  UIViewController+TSRouter.m
//  Tetris
//
//  Created by 王俊仁 on 2018/9/30.
//

#import "UIViewController+TSRouter.h"
#import "TSLogger.h"
#import <objc/runtime.h>

@implementation UIViewController (TSRouter)

- (instancetype)initWithIntent:(TSIntent *)intent {
    if (self = [self init]) {
        self.ts_sourceIntent = intent;
    }
    return self;
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
        TSLog(@"Doesn't conforms to protocol <%@>", NSStringFromProtocol(@protocol(TSIntentable)));
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

- (void)ts_finishDisplay:(BOOL)animated complete:(void (^)(void))complete {
    [[self ts_getDisplayer] ts_finishDisplayViewController:self animated:animated completion:complete];
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

/*
- (void)ts_sendResult:(id)stream {
    [[self ts_getIntentable].ts_sourceIntent.onResult post:stream];
}

- (void)ts_sendResult:(id)result byKey:(id<NSCopying>)key {
    [[self ts_getIntentable].ts_sourceIntent sendResult:result byKey:key];
}

- (void)ts_sendNumber:(NSNumber *)number {
    [[self ts_getIntentable].ts_sourceIntent.onNumberStream post:number];
}

- (void)ts_sendString:(NSString *)string {
    [[self ts_getIntentable].ts_sourceIntent.onStringStream post:string];
}

- (void)ts_sendDict:(NSDictionary *)dict {
    [[self ts_getIntentable].ts_sourceIntent.onDictStream post:dict];
}
*/
@end
