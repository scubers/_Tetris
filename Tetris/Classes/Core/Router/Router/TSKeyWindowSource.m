//
//  TSKeyWindowSource.m
//  Tetris
//
//  Created by Junren Wong on 2018/10/10.
//

#import "TSKeyWindowSource.h"

@implementation TSKeyWindowSource

+ (instancetype)source {
    return [[self alloc] init];
}

- (UIViewController *)ts_viewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

@end
