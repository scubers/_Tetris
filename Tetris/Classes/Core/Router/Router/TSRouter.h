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

#pragma mark - TSRouteActionProtocol

NS_SWIFT_NAME(IRouteAction)
@protocol TSRouteActionProtocol <TSCreatable>

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
@property (nonatomic, strong, nullable) UIViewController *destination;
@property (nonatomic, strong) TSIntent *intent;
@property (nonatomic, strong, nullable) NSError *error;
@end


#pragma mark - TSRouter

NS_SWIFT_NAME(Router)
@interface TSRouter : NSObject

@property (nonatomic, strong) TSIntercepterManager *intercepterMgr;

#pragma mark - Action

- (void)bindUrl:(NSString *)url toAction:(TSStream * (^)(TSTreeUrlComponent *component))action;
- (void)bindUrl:(NSString *)url toRouteAction:(id<TSRouteActionProtocol>)action;

- (nullable TSStream *)actionByUrl:(NSString *)url;

#pragma mark - Listener

- (void)bindUrl:(NSString *)url toDriven:(TSDrivenStream *)stream;

- (nullable TSDrivenStream *)drivenByUrl:(NSString *)url;

#pragma mark - View

- (void)bindUrl:(NSString *)urlString viewController:(Class<TSIntentable>)aClass;

- (TSStream<TSRouteResult *> *)prepare:(TSIntent *)intent source:(nullable UIViewController *)source complete:(void (^ _Nullable)(void))complete;

@end

NS_ASSUME_NONNULL_END
