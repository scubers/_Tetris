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

#pragma mark - TSViewControllable

NS_SWIFT_NAME(ViewControllable)
@protocol TSViewControllable

- (UIViewController *)ts_viewController;

@end

#pragma mark - TSIntentable

NS_SWIFT_NAME(Intentable)
@protocol TSIntentable <TSCreatable, TSViewControllable, NSObject>

@property (nonatomic, strong, nullable) TSIntent *ts_sourceIntent;

//+ (instancetype)ts_createWithIntent:(TSIntent *)intent;
- (instancetype)initWithIntent:(TSIntent *)intent;

@optional

+ (nullable id<TSIntercepter>)ts_selfIntercepter;

@end


NS_ASSUME_NONNULL_END

#endif /* TSRouterProtocols_h */
