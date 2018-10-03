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

- (void)removeCanceller:(TSCanceller *)canceller {
    [_cancellers removeObject:canceller];
}

+ (instancetype)canceller {
    return [[self alloc] init];
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
        _success = success ?: ^(id obj){};
        _error = error ?: ^(NSError *err){};
        _complete = complete ?: ^(){};
    }
    return self;
}

- (BOOL)executable {
    return !_completed;
}

- (void)post:(id)obj {
    if (_success && self.executable) _success(obj);
}

- (void)postError:(NSError *)error {
    if (_error && self.executable) {
        _completed = YES;
        _error(error);
    };
}

- (void)close {
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
    return [[self alloc] initWithBlock:block];
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
    return [self subscribe:success error:error complete:^{
        
    }];
}

- (TSCanceller *)subscribe:(void (^)(id _Nullable))success {
    return [self subscribe:success error:^(NSError * _Nullable error) {
        
    } complete:^{
        
    }];
}


- (TSStream *)bind:(TSBindStreamBlock (^)(void))block {
    
    // can not understand RAC implementation, just copy the code
    
    return [[TSStream alloc] initWithBlock:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        TSBindStreamBlock bindingBlock = block();
        
        __block volatile int32_t signalCount = 1;   // indicates self
        
        TSCanceller *compoundDisposable = [TSCanceller canceller];
        
        void (^completeSignal)(TSCanceller *) = ^(TSCanceller *finishedDisposable) {
            if (OSAtomicDecrement32Barrier(&signalCount) == 0) {
                [receiver close];
                [compoundDisposable cancel];
            } else {
                [compoundDisposable removeCanceller:finishedDisposable];
            }
        };
        
        void (^addStream)(TSStream *) = ^(TSStream *signal) {
            OSAtomicIncrement32Barrier(&signalCount);
            
            TSCanceller *selfDisposable = [[TSCanceller alloc] init];
            [compoundDisposable addCanceller:selfDisposable];
            
            TSCanceller *disposable = [signal subscribe:^(id  _Nullable obj) {
                [receiver post:obj];
            } error:^(NSError * _Nullable error) {
                [receiver postError:error];
                [compoundDisposable cancel];
            } complete:^{
                @autoreleasepool {
                    completeSignal(selfDisposable);
                }
            }];
            
            [selfDisposable addCanceller:disposable];
        };
        
        @autoreleasepool {
            TSCanceller *selfDisposable = [[TSCanceller alloc] init];
            [compoundDisposable addCanceller:selfDisposable];
            
            TSCanceller *bindingCanceller =
            [self subscribe:^(id  _Nullable obj) {
                
                BOOL stop = NO;
                id signal = bindingBlock(obj, &stop);
                
                @autoreleasepool {
                    if (signal != nil) addStream(signal);
                    if (signal == nil || stop) {
                        [selfDisposable cancel];
                        completeSignal(selfDisposable);
                    }
                }
                
            } error:^(NSError * _Nullable error) {
                [compoundDisposable cancel];
                [receiver postError:error];
            } complete:^{
                @autoreleasepool {
                    completeSignal(selfDisposable);
                }
            }];
            
            [selfDisposable addCanceller:bindingCanceller];
        }
        
        return compoundDisposable;
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

- (void)post:(id)obj {
    [_trigger.trigger post:obj];
}

- (void)postError:(NSError *)error {
    [_trigger.trigger postError:error];
    [_receivers removeAllObjects];
}

- (void)close {
    [_trigger.trigger close];
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
        [receiver postError:error];
        return nil;
    }];
}

+ (TSStream *)just:(id)object {
    return [[TSStream alloc] initWithBlock:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        [receiver post:object];
        [receiver close];
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
            [receiver post:obj];
        } error:^(NSError * _Nullable error) {
            [receiver postError:error];
        } complete:^{
            [receiver close];
        }];
    }];
}

- (TSStream *)onError:(void (^)(NSError * _Nonnull))onError {
    TSAssertion(onError != nil, "%s: block is nil", __FUNCTION__);
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        return [self subscribe:^(id  _Nullable obj) {
            [receiver post:obj];
        } error:^(NSError * _Nullable error) {
            onError(error);
            [receiver postError:error];
        } complete:^{
            [receiver close];
        }];
    }];
}

- (TSStream *)onCompleted:(void (^)(void))onCompleted {
    TSAssertion(onCompleted != nil, "%s: block is nil", __FUNCTION__);
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        return [self subscribe:^(id  _Nullable obj) {
            [receiver post:obj];
        } error:^(NSError * _Nullable error) {
            [receiver postError:error];
        } complete:^{
            onCompleted();
            [receiver close];
        }];
    }];
}

- (TSStream *)catch:(TSStream * _Nonnull (^)(NSError * _Nonnull))catchBlock {
    TSAssertion(catchBlock != nil, "%s: block is nil", __FUNCTION__);
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
       
        TSCanceller *outterCanceller = [TSCanceller new];
        
        TSCanceller *canceller =
        [self subscribe:^(id  _Nullable obj) {
            [receiver post:obj];
        } error:^(NSError * _Nullable error) {
            
            TSStream *stream = catchBlock(error);
            TSAssertion(stream != nil, "%s: block is nil", __FUNCTION__);
            
            TSCanceller *catchCanceller = [stream subscribeByReciever:receiver];
            [outterCanceller addCanceller:catchCanceller];
            
        } complete:^{
            [receiver close];
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
            [receiver post:obj];
        } error:^(NSError * _Nullable error) {
            [receiver postError:error];
            last();
        } complete:^{
            [receiver close];
            last();
        }];
    }];
}

- (TSStream *)delay:(NSTimeInterval)interval {
    return [self bind:^TSBindStreamBlock _Nonnull{
        return ^(id obj, BOOL *stop) {
            return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [receiver post:obj];
                    [receiver close];
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
                    [receiver post:obj];
                    [receiver close];
                }];
                return nil;
            }];
        };
    }];
}

- (TSStream *)async {
    return [self transform:^TSStream * _Nonnull(id  _Nullable object) {
        return [TSStream create:^TSCanceller * _Nullable(id<TSReceivable>  _Nonnull receiver) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [receiver post:object];
                [receiver close];
            });
            return nil;
        }];
    }];
}

- (TSStream *)mainQueue {
    return [self dispatch:[NSOperationQueue mainQueue]];
}

- (TSStream *)nonsenese:(id)obj {
    return self;
}

@end
