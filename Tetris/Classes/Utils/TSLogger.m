//
//  TSLogger.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import "TSLogger.h"

@implementation TSLogger

+ (void)log:(NSString *)msg, ... {
    va_list ap;
    va_start(ap, msg);
    NSLogv([NSString stringWithFormat:@"[Tetris Log]: %@", msg], ap);
    va_end(ap);
}

+ (void)logError:(NSError *)error {
    NSLog(@"[Tetris error]: %@", error);
}

@end
