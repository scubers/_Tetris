//
//  TSStream.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TSCancellable

@interface TSCanceller : NSObject

- (void)cancel;

@end


#pragma mark - TSReceivable

@protocol TSReceivable <NSObject>

- (void)receive:(nullable id)obj;
- (void)receiveError:(NSError *)error;
- (void)endReceive;

@end

#pragma mark - TSStream

@interface TSStream<T> : NSObject

- (instancetype)initWithBlock:(nullable TSCanceller *(^)(id<TSReceivable> receiver))block;

- (nullable TSCanceller *)subscribe:(void (^)(id _Nullable obj))success error:(void (^_Nullable)(NSError * _Nullable error))error complete:(dispatch_block_t _Nullable)complete;

- (nullable TSCanceller *)subscribe:(void (^ _Nullable)(id _Nullable obj))success error:(void (^)(NSError * _Nullable error))error;

- (nullable TSCanceller *)subscribe:(void (^ _Nullable)(id _Nullable obj))success;

- (TSStream<T> *)onNext:(void (^)(T _Nullable obj))next;

@end

#pragma mark - TSDrivenStream

@interface TSDrivenStream<T> : TSStream <TSReceivable>

- (instancetype)initWithBlock:(nullable TSCanceller *(^)(id<TSReceivable> receiver))block NS_UNAVAILABLE;

+ (TSDrivenStream *)stream;

@end

NS_ASSUME_NONNULL_END
