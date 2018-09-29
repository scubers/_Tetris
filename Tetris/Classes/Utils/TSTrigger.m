//
//  TSTrigger.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import "TSTrigger.h"
#import <objc/runtime.h>
#import "TSError.h"



@interface TSTrigger ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMethodSignature *> *signatures;

@property (nonatomic, weak  ) id<TSTriggerProtocol> target;

@end

@implementation TSTrigger

- (instancetype)initWithTarget:(id<TSTriggerProtocol>)target protocol:(nonnull Protocol *)aProtocol {
    if (self = [super init]) {
        _aProtocol = aProtocol;
        _target = target;
        _signatures = @{}.mutableCopy;
    }
    return self;
}

- (id)trigger {
    return self;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
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
    [_target trigger:self didTriggered:anInvocation];
}

@end
