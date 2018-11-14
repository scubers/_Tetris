//
//  TSInspector.m
//  Tetris
//
//  Created by Junren Wong on 2018/11/14.
//

#import "TSInspector.h"
#import "TSInspectorButton.h"

@implementation TSInspector

+ (void)setEnabled:(BOOL)enabled {
    [TSInspectorButton setVisible:enabled];
}

@end
