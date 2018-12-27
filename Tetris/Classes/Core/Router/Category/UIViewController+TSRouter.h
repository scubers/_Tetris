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

@interface UIViewController (TSRouter) <TSIntentable>

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

- (void)ts_sendResult:(id)result forKey:(NSString *)key;
- (void)ts_sendNumber:(NSNumber *)number;
- (void)ts_sendString:(NSString *)string;
- (void)ts_sendDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
