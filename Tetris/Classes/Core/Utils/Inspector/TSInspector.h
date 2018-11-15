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

#define _TSInspector [TSInspector shared]

@interface TSInspector : NSObject

+ (instancetype)shared;

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, strong) id<TSInspectorHandler> handler;

@end

NS_ASSUME_NONNULL_END
