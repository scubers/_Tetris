//
//  TSInterceptTokens.m
//  Pods-Tetris_Tests
//
//  Created by 王俊仁 on 2019/4/18.
//

#import "TSInterceptTokens.h"

@interface TSClassToken ()
@property (nonatomic, strong) Class aClass;
@end

@implementation TSClassToken

- (instancetype)initWithClass:(Class)aClass {
    if (self = [super init]) {
        _aClass = aClass;
    }
    return self;
}

- (NSString *)ts_stringToken {
    return NSStringFromClass(_aClass);
}

@end


@implementation NSString (TSInterceptToken)

- (NSString *)ts_stringToken {
    return self;
}

@end
