//
//  TSIntercepterProtocol.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#ifndef TSIntercepterProtocol_h
#define TSIntercepterProtocol_h


@class TSIntent;
@class UIViewController;

NS_ASSUME_NONNULL_BEGIN


@protocol TSIntercepterJudger


/**
 Return the input Intent
 
 @return Return the input Intent
 */
- (TSIntent *)sourceIntent;

/**
 Return the source that given by the user
 
 @return Return the source that given by the user
 */
- (UIViewController * _Nullable)source;

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

@end


typedef NS_ENUM(NSInteger, TSIntercepterPriority) {
    
    TSIntercepterPriorityMinimum = NSIntegerMin,
    
    TSIntercepterPriorityLow = 1000,
    
    TSIntercepterPriorityNormal = 5000,
    
    TSIntercepterPriorityHigh = 10000,
    
    TSIntercepterPriorityMax = NSIntegerMax,
};

@protocol TSIntercepterProtocol <NSObject>


@property (nonatomic, assign) TSIntercepterPriority priority;

/**
 Do intercepter logic;
 One intercepter life cycle, should call adjudger's doSwitch or doReject or doContinue once;
 
 @param adjudgement The adjudger
 */
- (void)ts_judgeIntent:(id<TSIntercepterJudger>)judger;


@end
NS_ASSUME_NONNULL_END

#endif /* TSIntercepterProtocol_h */
