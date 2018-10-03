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

#pragma mark - TSModule

//@interface TSModule ()
//
//@property (nonatomic, strong) Class<TSTetrisModulable> moduleClass;
//
//@end
//
//@implementation TSModule
//
//+ (instancetype)moduleWithClass:(Class<TSTetrisModulable>)aClass priority:(TSModulePriority)priority {
//    TSModule *module = [TSModule new];
//    module.moduleClass = aClass;
//    module->_priority = priority;
//    return module;
//}
//
//
//@synthesize moduleInstance = _moduleInstance;
//
//- (id<TSTetrisModulable>)moduleInstance {
//    if (!_moduleInstance) {
//        _moduleInstance = [[(Class)_moduleClass alloc] init];
//    }
//    return _moduleInstance;
//}
//
//@end


#pragma mark - TSTetrisModuler

@interface TSTetrisModuler () <TSTriggerProtocol>

@property (nonatomic, strong) TSLinkNode<id<TSTetrisModulable>> *root;

@property (nonatomic, strong) TSTrigger<id<TSTetrisModulable>> *applicationTrigger;

@property (nonatomic, strong) TSCreator *creator;

@end

@implementation TSTetrisModuler

- (instancetype)init {
    if (self = [super init]) {
        _applicationTrigger = [[TSTrigger alloc] initWithTarget:self protocol:@protocol(TSTetrisModulable)];
        _creator = [TSCreator shared];
    }
    return self;
}

- (void)registerModuleWithClass:(Class<TSTetrisModulable>)aClass priority:(TSModulePriority)priority {
    TSAssertion([[NSOperationQueue mainQueue] isEqual:[NSOperationQueue currentQueue]], "Register module should execute in main queue");
    id<TSTetrisModulable> module = (id<TSTetrisModulable>)[_creator createByClass:aClass];
    module.priority = priority;
    [self addModule:module];
}

- (void)registerModuleWithClass:(Class<TSTetrisModulable>)aClass {
    TSAssertion([[NSOperationQueue mainQueue] isEqual:[NSOperationQueue currentQueue]], "Register module should execute in main queue");
    [self addModule:(id<TSTetrisModulable>)([_creator createByClass:aClass])];
}

- (void)addModule:(id<TSTetrisModulable>)module {
    if (!_root) {
        _root = [TSLinkNode linkNodeWithObject:module];
    } else {
        [self _placeModule:module];
    }
}

- (void)_placeModule:(id<TSTetrisModulable>)module {
    TSLinkNode<id<TSTetrisModulable>> *current = _root;
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

- (void)enumerateModules:(void (^)(id<TSTetrisModulable> _Nonnull, NSUInteger))block {
    if (block) {
        [_root enumerateObject:^(id<TSTetrisModulable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            block(obj, idx);
        }];
    }
}

#pragma mark - TSTriggerProtocol

- (void)trigger:(TSTrigger *)trigger didTriggered:(NSInvocation *)invocation {
    [_root enumerateObject:^(id<TSTetrisModulable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:obj];
        }
    }];
}

#pragma mark - getter

- (id<UIApplicationDelegate>)trigger {
    return _applicationTrigger.trigger;
}

@end
