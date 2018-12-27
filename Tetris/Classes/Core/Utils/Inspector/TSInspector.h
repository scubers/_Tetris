//
//  TSInspector.h
//  Tetris
//
//  Created by Junren Wong on 2018/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TSIntent;

@protocol TSInspectorHandler
- (void)ts_handleIntent:(TSIntent *)intent;
@end

@protocol TSInspectorBubbleIntercepter <NSObject>
- (void)ts_didClickBubble;
@end

#define _TSInspector [TSInspector shared]

@interface TSInspector : NSObject

+ (instancetype)shared;

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, weak  ) id<TSInspectorHandler> handler;
@property (nonatomic, weak  ) id<TSInspectorBubbleIntercepter> bubbleIntercepter;

- (void)presentInspector;

- (UIViewController *)getTopViewController;

@end

NS_ASSUME_NONNULL_END
