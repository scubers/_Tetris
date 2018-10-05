//
//  TSRouterProtocols.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#ifndef TSRouterProtocols_h
#define TSRouterProtocols_h

#import "TSCreatable.h"
@class TSIntent;
@protocol TSIntercepterJudger;
@protocol TSIntercepter;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ViewControllable)
@protocol TSViewControllable

- (UIViewController *)ts_viewController;

@end


NS_SWIFT_NAME(Intentable)
@protocol TSIntentable <TSCreatable, TSViewControllable, NSObject>

@property (nonatomic, strong, nullable) TSIntent *ts_sourceIntent;

@optional

+ (nullable id<TSIntercepter>)ts_finalIntercepter;

@end




NS_ASSUME_NONNULL_END

#endif /* TSRouterProtocols_h */
