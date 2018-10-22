//
//  TSTrigger.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import "TSTrigger.h"
#import <objc/runtime.h>
#import "TSError.h"



@interface TSTrigger () <TSTriggerProtocol>

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMethodSignature *> *signatures;

@property (nonatomic, weak  ) id<TSTriggerProtocol> target;

@property (nonatomic, copy  ) TSTriggerBlock block;

@end

@implementation TSTrigger

- (instancetype)initWithTarget:(id<TSTriggerProtocol>)target protocol:(nonnull Protocol *)aProtocol {
    if (self = [super init]) {
        _aProtocol = aProtocol;
        _target = target;
        _signatures = @{}.mutableCopy;
        [self setClassConfirmToProtocol:aProtocol];
    }
    return self;
}

- (void)setClassConfirmToProtocol:(Protocol *)aProtocol {
    class_addProtocol(self.class, aProtocol);
}

- (instancetype)initWithProtocol:(Protocol *)aProtocol block:(TSTriggerBlock)block {
    if (self = [self initWithTarget:self protocol:aProtocol]) {
        _block = block;
    }
    return self;
}

- (id)trigger {
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return YES;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    NSMethodSignature *signature = _signatures[NSStringFromSelector(aSelector)];
    
    if (signature) return signature;
    
    struct objc_method_description desc =
    protocol_getMethodDescription(_aProtocol, aSelector, NO, YES);
    
    if (desc.types == NULL) {
        desc = protocol_getMethodDescription(_aProtocol, aSelector, YES, YES);
    }

    if (desc.types == NULL) {
        // 该协议中没有对应方法
        TSAssertion(NO, "Cannot trgger selector [%@] from Protocol<%@>", NSStringFromSelector(aSelector), NSStringFromProtocol(_aProtocol));
        return nil;
    }
    
    signature = [NSMethodSignature signatureWithObjCTypes:desc.types];
    _signatures[NSStringFromSelector(aSelector)] = signature;
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (_target && [_target respondsToSelector:@selector(trigger:didTriggered:)]) {
        [_target trigger:self didTriggered:anInvocation];
    }
}

- (void)trigger:(TSTrigger *)trigger didTriggered:(NSInvocation *)invocation {
    !_block ?: _block(trigger, invocation);
}

@end
