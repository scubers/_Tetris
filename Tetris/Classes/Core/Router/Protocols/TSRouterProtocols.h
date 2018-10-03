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

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Intentable)
@protocol TSIntentable <TSCreatable, NSObject>

@property (nonatomic, strong, nullable) TSIntent *ts_sourceIntent;

@optional

+ (void)ts_finalAdjudgement:(id<TSIntercepterJudger>)judger;

@end

NS_ASSUME_NONNULL_END

#endif /* TSRouterProtocols_h */
