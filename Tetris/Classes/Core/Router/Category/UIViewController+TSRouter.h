//
//  UIViewController+TSRouter.h
//  Tetris
//
//  Created by 王俊仁 on 2018/9/30.
//

#import <UIKit/UIKit.h>
#import "TSTetris.h"
#import "TSRouter.h"


NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TSRouter)

- (TSStream<TSRouteResult *> *)ts_prepare:(TSIntent *)intent;
- (TSStream<TSRouteResult *> *)ts_prepare:(TSIntent *)intent complete:(void (^ _Nullable)(void))complete;

- (void)ts_start:(TSIntent *)intent;
- (void)ts_start:(TSIntent *)intent complete:(void (^ _Nullable)(void))complete;

- (void)ts_finishDisplay;
- (void)ts_finishDisplay:(BOOL)animated;
- (void)ts_finishDisplay:(BOOL)animated complete:(void (^ _Nullable)(void))complete;

- (void)ts_setNeedDisplay;
- (void)ts_setNeedDisplay:(BOOL)animated;
- (void)ts_setNeedDisplay:(BOOL)animated complete:(void (^ _Nullable)(void))complete;

- (void)ts_sendStream:(nullable id)stream;

@end

NS_ASSUME_NONNULL_END
