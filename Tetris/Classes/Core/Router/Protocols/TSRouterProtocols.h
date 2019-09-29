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

NS_SWIFT_NAME(KVOInjectable)
@protocol TSKVOInjectable
- (nullable NSObject *)ts_kvoInjector;
@end

#pragma mark - TSIntentable

NS_SWIFT_NAME(Intentable)
@protocol TSIntentable <TSCreatable, TSViewControllable, TSKVOInjectable>

@property (nonatomic, strong, nullable) TSIntent *ts_sourceIntent;

- (void)didCreateWithIntent:(TSIntent *)intent;

+ (id<TSIntentable>)ts_createWithIntent:(TSIntent *)intent;

+ (nullable id<TSIntercepter>)ts_selfIntercepter;

@end


NS_ASSUME_NONNULL_END

#endif /* TSRouterProtocols_h */
