//
//  RIIntercepterAdapter.h
//  RouteIntent
//
//  Created by 王俊仁 on 2017/6/23.
//  Copyright © 2017年 jrwong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSIntercepter.h"
#import "TSUtils.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - TSIntercepterAdapter

/**
 Adapter for RIRouteIntercepter
 Match priority

 urlpatterns > classNamePattern > classes
 */
NS_SWIFT_NAME(IntercepterAdapter)
@interface TSIntercepterAdapter : NSObject <TSIntercepter>

@property (nonatomic, assign) TSIntercepterPriority priority;


/**
 The regexs for the input url

 @return return The regexs for the input url
 */
- (nullable NSArray<NSString *> *)matchUrlPatterns;


/**
 The class names regexs for input class

 @return The class names regexs for input class
 */
- (nullable NSArray<NSString *> *)matchClassNamePatterns;

/**
 The classes for input class

 @return The classes for input class
 */
- (nullable NSArray<Class> *)matchClasses;


/**
 Override this method that adjudge the intent

 @param adjudger The adjudger
 */
- (void)doAdjudgement:(id<TSIntercepterJudger>)judger;

@end


#pragma mark - TSFinalIntercepter

NS_SWIFT_NAME(FinalIntercepter)
TS_FINAL_CLASS
@interface TSFinalIntercepter : TSIntercepterAdapter

- (instancetype)initWithAction:(void (^)(id<TSIntercepterJudger> judger))action;

@end

NS_ASSUME_NONNULL_END
