//
//  TSInspector.m
//  Tetris
//
//  Created by Junren Wong on 2018/11/14.
//

#import "TSInspector.h"
#import "TSInspectorButton.h"

@implementation TSInspector

static TSInspector *__shared;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [TSInspector new];
    });
    return __shared;
}

+ (void)setEnabled:(BOOL)enabled {
    [TSInspectorButton setVisible:enabled];
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [TSInspectorButton setVisible:enabled];
}

@end
