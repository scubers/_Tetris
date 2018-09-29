//
//  TSDemoModules.m
//  Tetris_Example
//
//  Created by Junren Wong on 2018/9/29.
//  Copyright © 2018 wangjunren. All rights reserved.
//

#import "TSDemoModules.h"
#import <Tetris/Tetris-umbrella.h>

@interface TSDemoModules () <TSTetrisModulable>
@end
@implementation TSDemoModules

- (void)tetrisModuleInit:(TSModuleContext *)context {
    NSLog(@"%@, %s", self, __FUNCTION__);
}
- (void)tetrisModuleSetup:(TSModuleContext *)context {
    NSLog(@"%@, %s", self, __FUNCTION__);
}
- (void)tetrisModuleSplash:(TSModuleContext *)context {
    NSLog(@"%@, %s", self, __FUNCTION__);
}
@end

@interface Module1 : TSDemoModules <TSTetrisModulable>
@end
@implementation Module1
TS_MODULE(TSModulePriorityHigh)
@end

@interface Module2 : TSDemoModules <TSTetrisModulable>
@end
@implementation Module2
TS_MODULE(TSModulePriorityNormal)
@end

@interface Module3 : TSDemoModules <TSTetrisModulable>
@end
@implementation Module3
TS_MODULE(TSModulePriorityLow)
@end

@interface Module4 : TSDemoModules <TSTetrisModulable>
@end
@implementation Module4
TS_MODULE(TSModulePriorityNormal + 1)
@end
