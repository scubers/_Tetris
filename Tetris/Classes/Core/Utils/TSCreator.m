//
//  TSCreator.m
//  Tetris
//
//  Created by Junren Wong on 2018/10/2.
//

#import "TSCreator.h"
#import <objc/runtime.h>
#import "TSTetris.h"
#import "TSError.h"
#import "TSLogger.h"
#import "TSIntent.h"

@interface TSCreator ()

@property (nonatomic, strong) NSMutableArray<id<TSCreatorListener>> *listeners;

@end

@implementation TSCreator

static TSCreator *__creator;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __creator = [[self alloc] init];
        __creator.listeners = [NSMutableArray arrayWithCapacity:0];
    });
    return __creator;
}

- (id<TSCreatable>)createByClass:(Class<TSCreatable>)aClass {
    id<TSCreatable> object = [[aClass alloc] init];
    if ([((id)object) respondsToSelector:@selector(ts_didCreate)]) {
        [object ts_didCreate];
    }
    
    [_listeners enumerateObjectsUsingBlock:^(id<TSCreatorListener>  _Nonnull listener, NSUInteger idx, BOOL * _Nonnull stop) {
        [listener ts_didCreateObject:object];
    }];
    
    return object;
}

- (id<TSIntentable>)createIntentableByClass:(Class<TSIntentable>)aClass intent:(TSIntent *)intent {
    id<TSIntentable> object = [[aClass alloc] initWithIntent:intent];
    if ([((id)object) respondsToSelector:@selector(ts_didCreate)]) {
        [object ts_didCreate];
    }
    
    [_listeners enumerateObjectsUsingBlock:^(id<TSCreatorListener>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj ts_didCreateObject:object];
    }];
    
    return object;
}

- (void)addListener:(id<TSCreatorListener>)listener {
    if (listener) {
        [_listeners addObject:listener];
    }
}

- (void)removeListener:(id<TSCreatorListener>)listener {
    if (listener) {
        [_listeners removeObject:listener];
    }
}

@end



#pragma mark - NSObject Creatable Support

@implementation NSObject (Creatable)

+ (instancetype)ts_create {
    return [[self alloc] init];
}

@end

#pragma mark - NSObject Autowire

@implementation NSObject (Autowire)

- (void)ts_autowire {
    static NSRegularExpression *reg;
    if (!reg) {
        NSError *error;
        reg = [[NSRegularExpression alloc] initWithPattern:@"\\b\\w+\\b" options:NSRegularExpressionCaseInsensitive error:&error];
    }
    [self _ts_autowiredForClass:self.class withReg:reg];
}

- (void)_ts_autowiredForClass:(Class)aClass withReg:(NSRegularExpression *)reg {
    unsigned int outCount = 0;
    Ivar *list = class_copyIvarList(aClass, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = list[i];
        NSString *typeEncoding = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        if ([typeEncoding hasPrefix:@"@\"<"]) {
            NSArray<NSTextCheckingResult *> *result = [reg matchesInString:typeEncoding options:NSMatchingReportProgress range:NSMakeRange(0, typeEncoding.length)];
            if (result.count == 2) {
                
                // 判断是否标记为 MCAutowired
                if (![[typeEncoding substringWithRange:result.lastObject.range] isEqualToString:NSStringFromProtocol(@protocol(TSAutowired))]) {
                    continue;
                }
                
                NSString *protocolName = [typeEncoding substringWithRange:result.firstObject.range];
                
                NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
                
                @try {
                    
                    id service = [[TSTetris shared].server serviceByProtoocl:NSProtocolFromString(protocolName)];
                    [self setValue:service forKey:ivarName];
                } @catch (NSException *exception) {
                    TSLog(@"%@", exception);
                } @finally {
                    
                }
            }
        }
    }
    free(list);
    Class superClass = class_getSuperclass(aClass);
    if (!superClass) return;
    
    [self _ts_autowiredForClass:superClass withReg:reg];
}

@end
