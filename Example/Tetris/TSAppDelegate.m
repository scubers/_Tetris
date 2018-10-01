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

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    TSIntent *intent = [TSIntent pushPopIntentByUrl:@"/menu"];
    [[_Tetris.router prepare:intent source:nil complete:nil] subscribe:^(TSRouteResult * _Nullable obj) {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:obj.destination];
    }];

    [self.window makeKeyAndVisible];
    
    return YES;
}

@end


@interface TSURLPrinterIntercepter : TSIntercepterAdapter

@end

@implementation TSURLPrinterIntercepter

TS_INTERCEPTER(TSIntercepterPriorityMax)

- (void)ts_judgeIntent:(id<TSIntercepterJudger>)judger {
    NSLog(@"URL Routing: [%@]", judger.sourceIntent.urlString);
    [judger doContinue];
}

@end

