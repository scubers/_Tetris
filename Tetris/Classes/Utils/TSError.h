//
//  TSError.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import <Foundation/Foundation.h>

#define TSAssertion(assert, msg, ...) NSAssert(assert, @"[Tetris Assertion]: "msg, ##__VA_ARGS__)

NS_ASSUME_NONNULL_BEGIN

@interface NSError (Tetris)

+ (NSError *)ts_errorWithCode:(NSInteger)code msg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
