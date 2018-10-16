//
//  TSTrigger.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TSTrigger;

@protocol TSTriggerProtocol <NSObject>

- (void)trigger:(TSTrigger *)trigger didTriggered:(NSInvocation *)invocation;

@end

#pragma mark - TSTrigger<T>

/**
 delegate the instance method in protocol
 */
@interface TSTrigger<T> : NSObject

typedef void(^TSTriggerBlock)(TSTrigger<T> *trigger, NSInvocation *invocation);

@property (nonatomic, strong, readonly) Protocol *aProtocol;

@property (nonatomic, strong, readonly) T trigger;

/**
 weak!! will not retain target
 */
- (instancetype)initWithTarget:(id<TSTriggerProtocol>)target protocol:(Protocol *)aProtocol;

- (instancetype)initWithProtocol:(Protocol *)aProtocol block:(TSTriggerBlock)block;

@end

#pragma mark - TSSaftyTrigger



NS_ASSUME_NONNULL_END
