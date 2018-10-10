//
//  UIViewController+TSRouter.m
//  Tetris
//
//  Created by 王俊仁 on 2018/9/30.
//

#import "UIViewController+TSRouter.h"
#import "TSLogger.h"

@implementation UIViewController (TSRouter)

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

- (void)ts_sendResult:(id)stream {
    [[self ts_getIntentable].ts_sourceIntent.onResult post:stream];
}

- (void)ts_sendResult:(id)result byCode:(id<NSCopying>)code {
    [[self ts_getIntentable].ts_sourceIntent sendResult:result byCode:code];
}

@end
