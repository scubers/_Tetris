//
//  TSRouter.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#import <Foundation/Foundation.h>
#import "TSIntercepterManager.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TSRouteResult

typedef NS_ENUM(NSInteger, TSRouteResultStatus) {
    TSRouteResultStatusPass,
    TSRouteResultStatusSwitched,
    TSRouteResultStatusinterrupted,
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
#pragma mark - Listener
#pragma mark - View

- (void)bindUrl:(NSString *)urlString viewController:(Class<TSIntentable>)aClass;

@end

NS_ASSUME_NONNULL_END
