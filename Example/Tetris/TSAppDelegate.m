//
//  TSAppDelegate.m
//  Tetris
//
//  Created by wangjunren on 09/28/2018.
//  Copyright (c) 2018 wangjunren. All rights reserved.
//

#import "TSAppDelegate.h"
#import <Tetris/Tetris-umbrella.h>


@interface TSAppDelegate ()

@property (nonatomic, strong) UIWindow *window;


@end

@implementation TSAppDelegate

@synthesize window = _window;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[[TSStream alloc] initWithBlock:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
//        [receiver receive:@1];
        return nil;
    }] subscribe:^(id  _Nullable obj) {
        
    }];
    
    TSDrivenStream *stream = [TSDrivenStream stream];

    [stream subscribe:^(id  _Nullable obj) {
        
    }];
    [stream subscribe:^(id  _Nullable obj) {
        
    }];
    
    [stream receive:@1];
    [stream receive:@2];
//    [stream endReceive];
    [stream receive:@3];
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

@end
