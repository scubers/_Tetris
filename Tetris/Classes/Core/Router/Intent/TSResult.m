//
//  TSResult.m
//  Tetris
//
//  Created by Junren Wong on 2018/12/27.
//

#import "TSResult.h"

@implementation TSResult

- (instancetype)initWithSource:(id)source value:(id)value {
    if (self = [super init]) {
        _source = source;
        _value = value;
    }
    return self;
}

@end
