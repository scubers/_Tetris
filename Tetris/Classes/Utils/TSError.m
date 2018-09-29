//
//  TSError.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import "TSError.h"

static NSString * const TetrisErrorDomain = @"[Tetris Error]";

@implementation NSError (Tetris)

+ (NSError *)ts_errorWithCode:(NSInteger)code msg:(NSString *)msg {
    NSDictionary *dict
    = @{
      NSLocalizedDescriptionKey : msg,
      };
    return [NSError errorWithDomain:TetrisErrorDomain code:code userInfo:dict];
}

@end
