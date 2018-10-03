//
//  RIIntercepterManager.h
//  RouteIntent
//
//  Created by 王俊仁 on 2017/6/22.
//  Copyright © 2017年 jrwong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSIntercepterProtocol.h"
#import "TSIntent.h"

NS_ASSUME_NONNULL_BEGIN

/////////////////////////////////////////////////////////////////

NS_SWIFT_NAME(IntercepterResultStatus)
typedef NS_ENUM(NSInteger, TSIntercepterResultStatus) {
    TSIntercepterResultStatusPass,
    TSIntercepterResultStatusSwitched,
    TSIntercepterResultStatusRejected
};

NS_SWIFT_NAME(IntercepterResult)
@interface TSIntercepterResult : NSObject

@property (nonatomic, assign) TSIntercepterResultStatus status;

@property (nonatomic, strong, nullable) TSIntent *intent;

@property (nonatomic, strong, nullable) NSError *error;

+ (TSIntercepterResult *)resultWithStatus:(TSIntercepterResultStatus)status intent:(nullable TSIntent *)intent error:(nullable NSError *)error;

@end

/////////////////////////////////////////////////////////////////

typedef void(^TSRunIntercepterFinish)(TSIntercepterResult *result);

NS_SWIFT_NAME(IntercepterManager)
@interface TSIntercepterManager : NSObject

+ (instancetype)manager;

- (void)addIntercepter:(id<TSIntercepterProtocol>)intercepter
NS_SWIFT_NAME(add(intercepter:));


- (void)runIntent:(TSIntent *)intent
           source:(nullable UIViewController *)source
           finish:(TSRunIntercepterFinish)finish;




@end


NS_ASSUME_NONNULL_END