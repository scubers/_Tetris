//
//  TSStream.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/29.
//

#import "TSStream.h"
#import "TSTrigger.h"

#pragma mark - TSCanceller

@implementation TSCanceller

- (void)cancel {
    
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
    if (_error && self.executable) _error(error);
}

- (void)endReceive {
    if (_complete && self.executable) _complete();
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

- (TSCanceller *)subscribe:(void (^)(id _Nullable))block error:(void (^)(NSError *error))error complete:(dispatch_block_t)complete {
    TSReceiver *receiver = [[TSReceiver alloc] initWithSuccess:block error:error complete:complete];
    TSCanceller *canceller = _creationBlock(receiver);
    return canceller;
}

- (TSCanceller *)subscribe:(void (^)(id _Nullable))success error:(void (^)(NSError * _Nullable))error {
    return [self subscribe:success error:error complete:nil];
}

- (TSCanceller *)subscribe:(void (^)(id _Nullable))success {
    return [self subscribe:success error:nil complete:nil];
}


- (TSStream *)bind:(void (^)(id obj, NSError *error, id<TSReceivable> receiver))block {
    return [[TSStream alloc] initWithBlock:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        return [self subscribe:^(id  _Nullable obj) {
            block(obj, nil, receiver);
        } error:^(NSError * _Nullable error) {
            block(nil, error, receiver);
        } complete:^{
            block(nil, nil, receiver);
        }];
    }];
}

- (TSStream *)onNext:(void (^)(id _Nullable))next {
    return [self bind:^(id obj, NSError *error, id<TSReceivable> receiver) {
        if (!error) {
            next(obj);
        }
        
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

- (TSCanceller *)subscribe:(void (^)(id _Nullable))block
                     error:(void (^)(NSError * _Nonnull))error
                  complete:(dispatch_block_t)complete {
    TSReceiver *receiver = [[TSReceiver alloc] initWithSuccess:block error:error complete:complete];
    [_receivers addObject:receiver];
    return [TSCanceller new];
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


- (void)trigger:(TSTrigger *)trigger didTriggered:(NSInvocation *)invocation {
    [_receivers enumerateObjectsUsingBlock:^(id<TSReceivable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [invocation invokeWithTarget:obj];
    }];
}




@end
