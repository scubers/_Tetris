//
//  TSStream.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/29.
//

#import "TSStream.h"
#import "TSTrigger.h"
#import "TSError.h"
#import <libkern/OSAtomic.h>

#pragma mark - TSCanceller

@interface TSCanceller () {
    BOOL _cancelled;
    NSMutableArray<TSCanceller *> *_cancellers;
    dispatch_block_t _cancelBlock;
}

@end

@implementation TSCanceller

+ (instancetype)cancellerWithBlock:(dispatch_block_t)block {
    TSCanceller *canceller = [TSCanceller new];
    canceller->_cancelBlock = [block copy];
    return canceller;
}

- (instancetype)init {
    if (self = [super init]) {
        _cancellers = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)cancel {
    if (_cancelBlock) _cancelBlock();
    [_cancellers enumerateObjectsUsingBlock:^(TSCanceller * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
}

- (void)addCanceller:(TSCanceller *)canceller {
    if (canceller) {
        [_cancellers addObject:canceller];
    }
}

@end

#pragma mark - TSReceiver

@interface TSReceiver : NSObject <TSReceivable>
{
    void (^_success)(id obj);
    void (^_error)(NSError *error);
    dispatch_block_t _complete;
    BOOL _completed;
}
@end

@implementation TSReceiver

- (instancetype)initWithSuccess:(void (^)(id obj))success
                          error:(void (^)(NSError *error))error
                       complete:(dispatch_block_t)complete {
    if (self = [super init]) {
        _success = success;
        _error = error;
        _complete = complete;
    }
    return self;
}

- (BOOL)executable {
    return !_completed;
}

- (void)receive:(id)obj {
    if (_success && self.executable) _success(obj);
}

- (void)receiveError:(NSError *)error {
    if (_error && self.executable) {
        _completed = YES;
        _error(error);
    };
}

- (void)endReceive {
    if (_complete && self.executable) {
        _completed = YES;
        _complete();
    }
}

- (void)didSubscribeWithCanceller:(TSCanceller *)canceller {
    [canceller addCanceller:[TSCanceller cancellerWithBlock:^{
        self->_completed = YES;
    }]];
}

@end

#pragma mark - TSStream

@interface TSStream ()
{
    void (^_success)(id obj);
    void (^_error)(NSError *error);
    dispatch_block_t _complete;
}
@property (nonatomic, copy  ) TSCanceller *(^creationBlock)(id<TSReceivable> receiver);

@end


@implementation TSStream

- (instancetype)initWithBlock:(TSCanceller * _Nonnull (^)(id<TSReceivable> _Nonnull))block {
    if (self = [super init]) {
        _creationBlock = [block copy];
    }
    return self;
}

+ (TSStream *)create:(TSCanceller * _Nonnull (^)(id<TSReceivable> _Nonnull))block {
    return [[TSStream alloc] initWithBlock:block];
}

- (TSCanceller *)subscribeByReciever:(id<TSReceivable>)reciever {
    TSCanceller *canceller = _creationBlock(reciever);
    TSCanceller *outerCanceller = [TSCanceller cancellerWithBlock:^{
        [canceller cancel];
    }];
    [reciever didSubscribeWithCanceller:outerCanceller];
    return outerCanceller;
}

- (TSCanceller *)subscribe:(void (^)(id _Nullable))block error:(void (^)(NSError *error))error complete:(dispatch_block_t)complete {
    TSReceiver *receiver = [[TSReceiver alloc] initWithSuccess:block error:error complete:complete];
    return [self subscribeByReciever:receiver];
}

- (TSCanceller *)subscribe:(void (^)(id _Nullable))success error:(void (^)(NSError * _Nullable))error {
    return [self subscribe:success error:error complete:nil];
}

- (TSCanceller *)subscribe:(void (^)(id _Nullable))success {
    return [self subscribe:success error:nil complete:nil];
}


- (TSStream *)bind:(TSBindStreamBlock (^)(void))block {
    
    return [[TSStream alloc] initWithBlock:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        
        // 用来记录当前叠加的流数量
        __block volatile int32_t count = 1;

        TSCanceller *canceller = [TSCanceller new];
        
        void (^completeBlock)() = ^() {
            if (OSAtomicDecrement32(&count) == 0) {
                [receiver endReceive];
            }
        };
        
        TSCanceller *innerCanceller =
        [self subscribe:^(id  _Nullable obj) {
           TSBindStreamBlock bindBlock = block();
            
            BOOL stop = NO;
            TSStream *stream = bindBlock(obj, &stop);
            
            [stream subscribe:^(id  _Nullable obj) {
                OSAtomicIncrement32Barrier(&count);
                [receiver receive:obj];
                if (stop) {
                    completeBlock();
                }
                
            } error:^(NSError * _Nullable error) {
                
                [canceller cancel];
                [receiver receiveError:error];
                
            } complete:completeBlock];
            
            
        }];
        
        [canceller addCanceller:innerCanceller];
        
        return canceller;
    }];
}

@end

#pragma mark - TSDrivenStream

@interface TSDrivenStream () <TSTriggerProtocol>
{
    TSTrigger<id<TSReceivable>> *_trigger;
    NSMutableArray<id<TSReceivable>> *_receivers;
}

@end

@implementation TSDrivenStream

+ (TSDrivenStream *)stream {
    return [[TSDrivenStream alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _trigger = [[TSTrigger alloc] initWithTarget:self protocol:@protocol(TSReceivable)];
        _receivers = [NSMutableArray arrayWithCapacity:0];
        self.creationBlock = ^TSCanceller *(id<TSReceivable> receiver) {
            return nil;
        };
    }
    return self;
}

- (TSCanceller *)subscribeByReciever:(id<TSReceivable>)reciever {
    [_receivers addObject:reciever];
    TSCanceller *canceller = [super subscribeByReciever:reciever];
    [canceller addCanceller:[TSCanceller cancellerWithBlock:^{
        [_receivers removeObject:reciever];
    }]];
    return canceller;
}

- (void)receive:(id)obj {
    [_trigger.trigger receive:obj];
}

- (void)receiveError:(NSError *)error {
    [_trigger.trigger receiveError:error];
    [_receivers removeAllObjects];
}

- (void)endReceive {
    [_trigger.trigger endReceive];
    [_receivers removeAllObjects];
}

- (void)didSubscribeWithCanceller:(TSCanceller *)canceller {
    
}

- (void)trigger:(TSTrigger *)trigger didTriggered:(NSInvocation *)invocation {
    [_receivers enumerateObjectsUsingBlock:^(id<TSReceivable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [invocation invokeWithTarget:obj];
    }];
}

@end


#pragma mark - TSStream Category

@implementation TSStream (Methods)

+ (TSStream *)error:(NSError *)error {
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        [receiver receiveError:error];
        return nil;
    }];
}

+ (TSStream *)just:(id)object {
    return [[TSStream alloc] initWithBlock:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        [receiver receive:object];
        [receiver endReceive];
        return nil;
    }];
}

+ (TSStream *)stop {
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        return nil;
    }];
}

+ (TSStream *)delay:(NSTimeInterval)interval {
    return [[TSStream just:nil] delay:interval];
}

+ (TSStream *)async {
    return [[TSStream just:nil] async];
}

- (TSStream *)transform:(TSStream * _Nonnull (^)(id _Nullable))transform {
    TSAssertion(transform != nil, "%s: block is nil", __FUNCTION__);
    return [self bind:^TSBindStreamBlock _Nonnull{
        return ^(id obj, BOOL *stop){
            return transform(obj);
        };
    }];
}

- (TSStream *)then:(TSStream * _Nonnull (^)(void))then {
    TSAssertion(then != nil, "%s: block is nil", __FUNCTION__);
    return [self transform:^TSStream * _Nonnull(id  _Nullable object) {
        return then();
    }];
}

- (TSStream *)map:(id  _Nullable (^)(id _Nullable))mapBlock {
    TSAssertion(mapBlock != nil, "%s: block is nil", __FUNCTION__);
    return [self transform:^TSStream * _Nonnull(id  _Nullable object) {
        return [TSStream just:mapBlock(object)];
    }];
}

- (TSStream *)forceMap:(id)object {
    return [self map:^id _Nullable(id  _Nullable obj) {
        return object;
    }];
}

- (TSStream *)onNext:(void (^)(id _Nullable))onNext {
    TSAssertion(onNext != nil, "%s: block is nil", __FUNCTION__);
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        return [self subscribe:^(id  _Nullable obj) {
            onNext(obj);
            [receiver receive:obj];
        } error:^(NSError * _Nullable error) {
            [receiver receiveError:error];
        } complete:^{
            [receiver endReceive];
        }];
    }];
}

- (TSStream *)onError:(void (^)(NSError * _Nonnull))onError {
    TSAssertion(onError != nil, "%s: block is nil", __FUNCTION__);
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        return [self subscribe:^(id  _Nullable obj) {
            [receiver receive:obj];
        } error:^(NSError * _Nullable error) {
            onError(error);
            [receiver receiveError:error];
        } complete:^{
            [receiver endReceive];
        }];
    }];
}

- (TSStream *)onCompleted:(void (^)(void))onCompleted {
    TSAssertion(onCompleted != nil, "%s: block is nil", __FUNCTION__);
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        return [self subscribe:^(id  _Nullable obj) {
            [receiver receive:obj];
        } error:^(NSError * _Nullable error) {
            [receiver receiveError:error];
        } complete:^{
            onCompleted();
            [receiver endReceive];
        }];
    }];
}

- (TSStream *)catch:(TSStream * _Nonnull (^)(NSError * _Nonnull))catchBlock {
    TSAssertion(catchBlock != nil, "%s: block is nil", __FUNCTION__);
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
       
        TSCanceller *outterCanceller = [TSCanceller new];
        
        TSCanceller *canceller =
        [self subscribe:^(id  _Nullable obj) {
            [receiver receive:obj];
        } error:^(NSError * _Nullable error) {
            
            TSStream *stream = catchBlock(error);
            TSAssertion(stream != nil, "%s: block is nil", __FUNCTION__);
            
            TSCanceller *catchCanceller = [stream subscribeByReciever:receiver];
            [outterCanceller addCanceller:catchCanceller];
            
        } complete:^{
            [receiver endReceive];
        }];
        
        [outterCanceller addCanceller:canceller];
        
        return outterCanceller;
        
    }];
}

- (TSStream *)first:(void (^)(void))first {
    TSAssertion(first != nil, "%s: block is nil", __FUNCTION__);
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        first();
        return [self subscribeByReciever:receiver];
    }];
}

- (TSStream *)last:(void (^)(void))last {
    TSAssertion(last != nil, "%s: block is nil", __FUNCTION__);
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        return [self subscribe:^(id  _Nullable obj) {
            [receiver receive:obj];
        } error:^(NSError * _Nullable error) {
            [receiver receiveError:error];
            last();
        } complete:^{
            [receiver endReceive];
            last();
        }];
    }];
}

- (TSStream *)delay:(NSTimeInterval)interval {
    return [self bind:^TSBindStreamBlock _Nonnull{
        return ^(id obj, BOOL *stop) {
            return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [receiver receive:obj];
                    [receiver endReceive];
                });
                return nil;
            }];
        };
    }];
}

- (TSStream *)dispatch:(NSOperationQueue *)queue {
    return [self bind:^TSBindStreamBlock _Nonnull{
        return ^(id obj, BOOL *stop) {
            return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
                [queue addOperationWithBlock:^{
                    [receiver receive:obj];
                    [receiver endReceive];
                }];
                return nil;
            }];
        };
    }];
}

- (TSStream *)async {
    return [self bind:^TSBindStreamBlock _Nonnull{
        return ^(id obj, BOOL *stop) {
            return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [receiver receive:obj];
                    [receiver endReceive];
                });
                return nil;
            }];
        };
    }];
}

- (TSStream *)mainQueue {
    return [self dispatch:[NSOperationQueue mainQueue]];
}

- (TSStream *)nonsenese:(id)obj {
    return self;
}

@end
