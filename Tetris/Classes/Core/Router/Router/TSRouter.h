//
//  TSRouter.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#import <Foundation/Foundation.h>
#import "TSIntercepterManager.h"
#import "TSStream.h"
#import "TSTree.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TSRouteActioner

NS_SWIFT_NAME(RouteActioner)
@protocol TSRouteActioner <TSCreatable>

- (TSStream *)getStreamByComponent:(TSTreeUrlComponent *)component;

@end

#pragma mark - TSRouteResult

NS_SWIFT_NAME(RouteResultStatus)
typedef NS_ENUM(NSInteger, TSRouteResultStatus) {
    TSRouteResultStatusPass,
    TSRouteResultStatusRejected,
    TSRouteResultStatusLost,
};

NS_SWIFT_NAME(RouteResult)
@interface TSRouteResult : NSObject
@property (nonatomic, assign) TSRouteResultStatus status;
@property (nonatomic, strong, nullable) id<TSViewControllable> viewControllable;
@property (nonatomic, strong) TSIntent *intent;
@property (nonatomic, strong, nullable) NSError *error;
@end


#pragma mark - TSRouter

NS_SWIFT_NAME(Router)
@interface TSRouter : NSObject

@property (nonatomic, strong) TSIntercepterManager *intercepterMgr;

@property (nonatomic, assign) BOOL viewControllableParamInject;

#pragma mark - Action

- (void)bindUrl:(NSString *)url toAction:(TSStream * (^)(TSTreeUrlComponent *component))action;
- (void)bindUrl:(NSString *)url toRouteAction:(id<TSRouteActioner>)action;

- (nullable TSStream *)actionByUrl:(NSString *)url;
- (nullable TSStream *)actionByUrl:(NSString *)url params:(nullable NSDictionary *)params;

#pragma mark - Listener

- (nullable TSCanceller *)subscribeDrivenByUrl:(NSString *)urlString callback:(void (^)(TSTreeUrlComponent *component))callback;
- (void)postDrivenByUrl:(NSString *)url params:(nullable NSDictionary *)params;

#pragma mark - View

- (void)bindUrl:(NSString *)urlString intentable:(Class<TSIntentable>)aClass;

- (TSStream<TSRouteResult *> *)prepare:(TSIntent *)intent source:(nullable id<TSViewControllable>)source complete:(void (^ _Nullable)(void))complete;

- (TSStream<TSRouteResult *> *)prepare:(TSIntent *)intent source:(nullable id<TSViewControllable>)source;

- (TSStream<TSRouteResult *> *)prepare:(TSIntent *)intent;

@end

NS_ASSUME_NONNULL_END
