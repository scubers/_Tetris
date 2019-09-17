//
//  TSWeakSingleton.m
//  Tetris
//
//  Created by Jrwong on 2019/9/17.
//

#import "TSWeakSingleton.h"

@interface _TSWeakHolder : NSObject
@property (nonatomic, weak) id<TSDestroyable> instance;
@end
@implementation _TSWeakHolder
@end

@interface TSWeakSingleton ()
{
    NSMutableDictionary<NSString *, _TSWeakHolder *> *_instances;
    NSOperationQueue *_queue;
}

@end

@implementation TSWeakSingleton

- (instancetype)init {
    if (self = [super init]) {
        _instances = [NSMutableDictionary dictionary];
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

- (NSString *)getIdentifier:(Class)aClass {
    return NSStringFromClass(aClass);
}

- (void)queueExecute:(void (^)(void))block {
    [_queue addOperations:@[[NSBlockOperation blockOperationWithBlock:block]] waitUntilFinished:YES];
}

@end
