//
//  TSStream.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/29.
//

#import <Foundation/Foundation.h>

/**
 异步编程
 */

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TSCancellable

@interface TSCanceller : NSObject

+ (instancetype)cancellerWithBlock:(dispatch_block_t)block;

- (void)cancel;

- (void)addCanceller:(TSCanceller *)canceller;

- (void)removeCanceller:(TSCanceller *)canceller;

+ (instancetype)canceller;

@end


#pragma mark - TSReceivable

@protocol TSReceivable <NSObject>

- (void)post:(nullable id)obj;
- (void)postError:(NSError *)error;
- (void)close;

- (void)didSubscribeWithCanceller:(TSCanceller *)canceller;

@end

#pragma mark - TSStream

@interface TSStream<__covariant T> : NSObject

typedef TSStream *(^TSBindStreamBlock)(T _Nullable value, BOOL *stop);

+ (instancetype)create:(TSCanceller * _Nullable (^)(id<TSReceivable> receiver))block;

- (instancetype)initWithBlock:(TSCanceller * _Nullable (^)(id<TSReceivable> receiver))block;

- (TSCanceller *)subscribe:(void (^)(T _Nullable obj))next
                              error:(void (^_Nullable)(NSError * error))error
                           complete:(dispatch_block_t _Nullable)complete;

- (TSCanceller *)subscribe:(void (^ _Nullable)(T _Nullable obj))next
                              error:(void (^)(NSError * error))error;

- (TSCanceller *)subscribe:(void (^ _Nullable)(T _Nullable obj))next;

- (TSCanceller *)subscribeByReciever:(id<TSReceivable>)reciever;

- (TSStream *)bind:(TSBindStreamBlock (^)(void))block;

@end

#pragma mark - TSDrivenStream

@interface TSDrivenStream<__covariant T> : TSStream<T> <TSReceivable>

- (instancetype)initWithBlock:(nullable TSCanceller *(^)(id<TSReceivable> receiver))block NS_UNAVAILABLE;

+ (TSDrivenStream<T> *)stream;

@end

#pragma mark - TSStream Category

@interface TSStream<__covariant T> (Methods)

#pragma mark - creations

+ (TSStream<T> *)just:(nullable T)object;

+ (TSStream *)stop;

+ (TSStream *)delay:(NSTimeInterval)interval;

+ (TSStream *)error:(NSError *)error;

+ (TSStream *)async;


#pragma mark - instance method

- (TSStream *)transform:(TSStream *(^)(T _Nullable object))transform;

- (TSStream *)then:(TSStream *(^)(void))then;

- (TSStream *)map:(id _Nullable (^)(T _Nullable obj))mapBlock;

- (TSStream *)forceMap:(nullable id)object;

- (TSStream<T> *)onNext:(void (^)(id _Nullable obj))onNext;

- (TSStream *)onError:(void (^)(NSError *error))onError;

- (TSStream *)onCompleted:(void (^)(void))onCompleted;

- (TSStream *)catch:(TSStream *(^)(NSError *error))catchBlock;

- (TSStream *)first:(void (^)(void))first;

- (TSStream *)last:(void (^)(void))last;

- (TSStream *)delay:(NSTimeInterval)interval;

- (TSStream *)dispatch:(NSOperationQueue *)queue;

- (TSStream *)async;

- (TSStream *)mainQueue;

- (TSStream *)nonsenese:(nullable id)obj;

@end

NS_ASSUME_NONNULL_END
