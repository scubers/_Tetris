//
//  TSInspectorButton.m
//  Tetris
//
//  Created by Junren Wong on 2018/11/14.
//

#import "TSInspectorButton.h"

@implementation TSInspectorButton

+ (instancetype)create {
    TSInspectorButton *btn = [TSInspectorButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Tetris" forState:UIControlStateNormal];
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    btn.frame = CGRectMake(0, 100, 60, 60);
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 30;
    btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    btn.layer.borderWidth = 1.5;
    return btn;
}


@end
