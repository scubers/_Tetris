//
//  TSWeakSingleton.m
//  Tetris
//
//  Created by Jrwong on 2019/9/17.
//

#import "TSWeakSingleton.h"
#import <objc/runtime.h>
#import "TSStream.h"

@interface _TSWeakHolder : NSObject
@property (nonatomic, weak) id<TSDestroyable> instance;
@end
@implementation _TSWeakHolder
@end

@interface TSWeakSingleton ()
{
    NSMutableDictionary<NSString *, _TSWeakHolder *> *_instances;
    NSMutableDictionary<NSString *, _TSWeakHolder *> *_multipleInstances;
    NSOperationQueue *_queue;
}

@end

@implementation TSWeakSingleton

- (instancetype)init {
    if (self = [super init]) {
        _instances = [NSMutableDictionary dictionary];
        _multipleInstances = [NSMutableDictionary dictionary];
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = [NSString stringWithFormat:@"com.tetris.singleton.%@", self];
    }
    return self;
}

static TSWeakSingleton *__instance;
+ (TSWeakSingleton *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [TSWeakSingleton new];
    });
    return __instance;
}

- (id<TSDestroyable>)createWithType:(Class)aClass {
    NSString *identifier = [self getIdentifier:aClass];
    __block id<TSDestroyable> obj;
    [self queueExecute:^{
        obj = _instances[identifier].instance;
        if (obj == nil) {
            obj = [[aClass alloc] init];
            _TSWeakHolder *holder = [_TSWeakHolder new];
            holder.instance = obj;
            _instances[identifier] = holder;
            NSString *serviceName = [NSString stringWithFormat:@"%@", obj];
            [obj onDestroy:^{
                NSLog(@"Single Service: [%@] destroyed!!", serviceName);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self queueExecute:^{
                        _TSWeakHolder *oldHolder = _instances[identifier];
                        if (oldHolder == holder) {
                            [_instances removeObjectForKey:identifier];
                        }
                    }];
                });
            }];
        }
    }];
    return obj;
}

- (id<TSDestroyable>)createWithType:(Class)aClass lifeCycle:(id<TSDestroyable>)lifeCycle {
    NSString *identifier = [self getLifeCycleIdentifier:lifeCycle withClass:aClass];
    __block id<TSDestroyable> obj;
    [self queueExecute:^{
        obj = _multipleInstances[identifier].instance;
        
        if (obj == nil) {
            obj = [[aClass alloc] init];
            _TSWeakHolder *holder = [_TSWeakHolder new];
            holder.instance = obj;
            
            _multipleInstances[identifier] = holder;
            NSString *serviceName = [NSString stringWithFormat:@"%@", obj];
            
            [lifeCycle onDestroy:^{
                NSLog(@"Service LifeCycle overed: [%@] destroyed!!", serviceName);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self queueExecute:^{
                        _TSWeakHolder *oldHolder = _instances[identifier];
                        if (oldHolder == holder) {
                            [_instances removeObjectForKey:identifier];
                        }
                    }];
                });
            }];
        }
    }];
    return obj;
}

- (NSString *)getIdentifier:(Class)aClass {
    return NSStringFromClass(aClass);
}

- (NSString *)getLifeCycleIdentifier:(id<TSDestroyable>)lifeCycle withClass:(Class<TSDestroyable>)aClass {
    return [NSString stringWithFormat:@"%@_%p", [self getIdentifier:aClass], lifeCycle];
}

- (void)queueExecute:(void (^)(void))block {
    [_queue addOperations:@[[NSBlockOperation blockOperationWithBlock:block]] waitUntilFinished:YES];
}

@end


#pragma mark - NSObject 
@interface _TSHanger : NSObject
@property (nonatomic, strong) TSDrivenStream *stream;
@end
@implementation _TSHanger
- (instancetype)init {
    if (self = [super init]) {
        _stream = [TSDrivenStream new];
    }
    return self;
}
- (void)dealloc {
    [_stream post:self];
    [_stream close];
    _stream = nil;
}
@end

@implementation NSObject (TSViewModelLifeController)

- (void)onDestroy:(void (^)(void))onDestroy {
    [[[self _getTSHanger] stream] subscribeNext:^(id  _Nullable obj) {
        !onDestroy ?: onDestroy();
    }];
}

- (_TSHanger *)_getTSHanger {
    _TSHanger *hanger = objc_getAssociatedObject(self, _cmd);
    if (!hanger) {
        hanger = [_TSHanger new];
        objc_setAssociatedObject(self, _cmd, hanger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return hanger;
}

@end
