//
//  TSModule.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import "TSModule.h"
#import "TSLinkNode.h"
#import "TSError.h"
#import <objc/runtime.h>
#import "TSLogger.h"
#import "TSTrigger.h"
#import "TSCreator.h"

#pragma mark - TSModuleContext

@implementation TSModuleContext

static TSModuleContext *__sharedContext;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedContext = [TSModuleContext new];
    });
    return __sharedContext;
}

- (UIApplication *)application {
    return [UIApplication sharedApplication];
}

- (id<UIApplicationDelegate>)applicationDelegate {
    return self.application.delegate;
}

@end

#pragma mark - TSTetrisModuler

@interface TSTetrisModular () <TSTriggerProtocol>

@property (nonatomic, strong) TSLinkNode<id<TSModularComposable>> *root;

@property (nonatomic, strong) TSTrigger<id<TSModularComposable>> *applicationTrigger;

@property (nonatomic, strong) TSCreator *creator;

@end

@implementation TSTetrisModular

- (instancetype)init {
    if (self = [super init]) {
        _applicationTrigger = [[TSTrigger alloc] initWithTarget:self protocol:@protocol(TSModularComposable)];
        _creator = [TSCreator shared];
    }
    return self;
}

- (void)registerModuleWithClass:(Class<TSModularComposable>)aClass priority:(TSModulePriority)priority {
    TSAssertion([[NSOperationQueue mainQueue] isEqual:[NSOperationQueue currentQueue]], "Register module should execute in main queue");
    id<TSModularComposable> module = (id<TSModularComposable>)[_creator createByClass:aClass];
    module.priority = priority;
    [self addModule:module];
}

- (void)registerModuleWithClass:(Class<TSModularComposable>)aClass {
    TSAssertion([[NSOperationQueue mainQueue] isEqual:[NSOperationQueue currentQueue]], "Register module should execute in main queue");
    [self addModule:(id<TSModularComposable>)([_creator createByClass:aClass])];
}

- (void)addModule:(id<TSModularComposable>)module {
    if (!_root) {
        _root = [TSLinkNode linkNodeWithObject:module];
    } else {
        [self _placeModule:module];
    }
}

- (void)_placeModule:(id<TSModularComposable>)module {
    TSLinkNode<id<TSModularComposable>> *current = _root;
    while (current && current.value.priority > module.priority) {
        current = current.next;
    }
    
    TSLinkNode *node = [TSLinkNode linkNodeWithObject:module];
    if (current) {
        if (current.isRoot) {
            _root = node;
        }
        [current insertBeforeSelf:node];
    } else {
        // the last
        [_root.end insertAfterSelf:node];
    }
    
}

- (NSUInteger)count {
    return _root.count;
}

- (void)enumerateModules:(void (^)(id<TSModularComposable> _Nonnull, NSUInteger))block {
    if (block) {
        [_root enumerateObject:^(id<TSModularComposable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            block(obj, idx);
        }];
    }
}

#pragma mark - TSTriggerProtocol

- (void)trigger:(TSTrigger *)trigger didTriggered:(NSInvocation *)invocation {
    [_root enumerateObject:^(id<TSModularComposable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:obj];
        }
    }];
}

#pragma mark - getter

- (id<TSModularComposable>)trigger {
    return _applicationTrigger.trigger;
}

@end
