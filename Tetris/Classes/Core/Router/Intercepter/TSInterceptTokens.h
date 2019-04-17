//
//  TSInterceptTokens.h
//  Pods-Tetris_Tests
//
//  Created by 王俊仁 on 2019/4/18.
//

#import <Foundation/Foundation.h>
#import "TSIntercepter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSClassToken : NSObject <TSInterceptToken>

- (instancetype)initWithClass:(Class)aClass;

@end

#pragma mark - NSString (TSInterceptToken)

@interface NSString (TSInterceptToken) <TSInterceptToken>

@end

NS_ASSUME_NONNULL_END
