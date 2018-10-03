//
//  TSCreator.m
//  Tetris
//
//  Created by Junren Wong on 2018/10/2.
//

#import "TSCreator.h"

@implementation TSCreator

static TSCreator *__creator;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __creator = [[self alloc] init];
    });
    return __creator;
}

- (id<TSCreatable>)createByClass:(Class<TSCreatable>)aClass {
    id<TSCreatable> obj = [aClass ts_create];
    if ([((id)obj) respondsToSelector:@selector(ts_didCreate)]) {
        [obj ts_didCreate];
    }
    return obj;
}

@end



#pragma mark - NSObject Creatable Support

@implementation NSObject (Creatable)

+ (instancetype)ts_create {
    return [[self alloc] init];
}

@end
