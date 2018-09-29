//
//  TSLogger.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import <Foundation/Foundation.h>
#import "TSError.h"

#define TSLog(msg, ...) [TSLogger log:msg, __VA_ARGS__]
#define TSLogErr(error) [TSLogger logError:error]

NS_ASSUME_NONNULL_BEGIN

@interface TSLogger : NSObject

+ (void)log:(NSString *)msg, ...;

+ (void)logError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
