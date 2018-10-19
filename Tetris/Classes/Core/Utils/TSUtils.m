//
//  TSUtils.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import "TSUtils.h"
#import <objc/runtime.h>

@implementation TSUtils

+ (void)enumerateClasses:(void (^)(Class  _Nonnull __unsafe_unretained, NSUInteger))block {
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        @autoreleasepool {
            block(classes[i], i);
        }
    }
    free(classes);
}

@end
