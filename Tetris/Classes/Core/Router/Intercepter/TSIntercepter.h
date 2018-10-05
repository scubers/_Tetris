//
//  TSIntercepter.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#ifndef TSIntercepter_h
#define TSIntercepter_h


@class TSIntent;
@class UIViewController;
#import "TSCreatable.h"
#import "TSRouterProtocols.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(IntercepterJudger)
@protocol TSIntercepterJudger


/**
 Return the input Intent
 
 @return Return the input Intent
 */
- (TSIntent *)intent;

/**
 Return the source that given by the user
 
 @return Return the source that given by the user
 */
- (id<TSViewControllable> _Nullable)source;

/**
 Redirect to intent;
 The intercepter manager will restart again
 
 @param intent The new intent redirect to;
 */
- (void)doSwitch:(TSIntent *)intent;

/**
 Reject this intent
 
 @param error Error message
 */
- (void)doReject:(NSError *)error;

/**
 Pass this intercepter
 */
- (void)doContinue;


/**
 execute
 [self.source ts_start:self.intent]
 */
- (void)restart;

@end

NS_SWIFT_NAME(IntercepterPriority)
typedef NSInteger TSIntercepterPriority;

static TSIntercepterPriority const TSIntercepterPriorityMinimum = NSIntegerMin;
static TSIntercepterPriority const TSIntercepterPriorityLow = 1000;
static TSIntercepterPriority const TSIntercepterPriorityNormal = 5000;
static TSIntercepterPriority const TSIntercepterPriorityHigh = 10000;
static TSIntercepterPriority const TSIntercepterPriorityMax = NSIntegerMax;

NS_SWIFT_NAME(Intercepter)
@protocol TSIntercepter <TSCreatable>


@property (nonatomic, assign) TSIntercepterPriority priority;

/**
 Do intercepter logic;
 One intercepter life cycle, should call adjudger's doSwitch or doReject or doContinue once;
 
 @param adjudgement The adjudger
 */
- (void)ts_judgeIntent:(id<TSIntercepterJudger>)judger;


@end
NS_ASSUME_NONNULL_END

#endif /* TSIntercepter_h */
