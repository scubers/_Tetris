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
    
    

    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

@end
