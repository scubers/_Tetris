//
//  TSAppDelegate.m
//  Tetris
//
//  Created by wangjunren on 09/28/2018.
//  Copyright (c) 2018 wangjunren. All rights reserved.
//

#import "TSAppDelegate.h"
#import <Tetris/Tetris-umbrella.h>
#import "Tetris_Example-Swift.h"


@interface TSAppDelegate ()

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, assign) BOOL isSwiftDemo;

@end

@implementation TSAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TetrisSwiftStarter start];
    return [super application:application willFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];

    TSDrivenStream *stream = [TSDrivenStream stream];
    
    _Tetris.router.intercepterMgr.finalIntercepter = [[TSFinalIntercepter alloc] initWithAction:^(id<TSIntercepterJudger>  _Nonnull judger) {
        NSLog(@"----- final intercepter ------");
        [judger doContinue];
    }];
    
    [_Tetris.router subscribeDrivenByUrl:@"/changeDemo" callback:^(TSTreeUrlComponent * _Nonnull component) {
        [stream post:nil];
    }];
    
    [[[stream
       map:^id _Nullable(id  _Nullable obj) {
           _isSwiftDemo = !_isSwiftDemo;
           return @(_isSwiftDemo);
       }]
      transform:^TSStream * _Nonnull(id  _Nullable object) {
          if ([object boolValue]) {
              return [_Tetris.router prepare:[TSIntent pushPopIntentByUrl:@"/swift/menu"] source:nil complete:nil];
          }
          return [_Tetris.router prepare:[TSIntent pushPopIntentByUrl:@"/menu"] source:nil complete:nil];
      }]
     subscribeNext:^(TSRouteResult *  _Nullable obj) {
         self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:obj.destination];
     }];


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    // 触发
    _isSwiftDemo = YES;
    [stream post:nil];
    
    [[_Tetris.router actionByUrl:@"/swift/actionDemo"] subscribeNext:^(id  _Nullable obj) {
        
    }];
    
    [[_Tetris.router actionByUrl:@"/oc/action"] subscribeNext:^(id  _Nullable obj) {
        
    }];
    
    [TS_GET_SERVICE(TestProtocolA) methodA];

    [self.window makeKeyAndVisible];
    
    return YES;
}

@end


@interface TSURLPrinterIntercepter : TSIntercepterAdapter
@end
@implementation TSURLPrinterIntercepter

TS_INTERCEPTER(TSIntercepterPriorityMax)

- (void)ts_judgeIntent:(id<TSIntercepterJudger>)judger {
    NSLog(@"URL Routing: [%@]", judger.intent.urlString);
    [judger doContinue];
}

@end

