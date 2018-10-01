//
//  TSRouter.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#import <Foundation/Foundation.h>
#import "TSIntercepterManager.h"
#import "TSStream.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TSRouteResult

typedef NS_ENUM(NSInteger, TSRouteResultStatus) {
    TSRouteResultStatusPass,
    TSRouteResultStatusRejected,
    TSRouteResultStatusLost,
};

@interface TSRouteResult : NSObject
@property (nonatomic, assign) TSRouteResultStatus status;
@property (nonatomic, strong, nullable) UIViewController *destination;
@property (nonatomic, strong) TSIntent *intent;
@property (nonatomic, strong, nullable) NSError *error;
@end


#pragma mark - TSRouter

@interface TSRouter : NSObject

@property (nonatomic, strong) TSIntercepterManager *intercepterMgr;

#pragma mark - Action

- (void)bindUrl:(NSString *)url toAction:(TSStream * (^)(TSTreeUrlComponent *component))action;

- (nullable TSStream *)actionByUrl:(NSString *)url;

#pragma mark - Listener

- (void)bindUrl:(NSString *)url toDriven:(TSDrivenStream *)stream;

- (nullable TSDrivenStream *)drivenByUrl:(NSString *)url;

#pragma mark - View

- (void)bindUrl:(NSString *)urlString viewController:(Class<TSIntentable>)aClass;

- (TSStream<TSRouteResult *> *)prepare:(TSIntent *)intent source:(nullable UIViewController *)source complete:(void (^ _Nullable)(void))complete;

@end

NS_ASSUME_NONNULL_END
