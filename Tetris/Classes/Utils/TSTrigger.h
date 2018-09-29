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

/**
 delegate the instance method in protocol
 */
@interface TSTrigger<T> : NSObject

@property (nonatomic, strong, readonly) Protocol *aProtocol;

@property (nonatomic, strong, readonly) T trigger;

/**
 weak!! will not retain target
 */
- (instancetype)initWithTarget:(id<TSTriggerProtocol>)target protocol:(Protocol *)aProtocol;

@end

NS_ASSUME_NONNULL_END
