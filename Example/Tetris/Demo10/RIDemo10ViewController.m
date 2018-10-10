//
//  RIDemo10ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo10ViewController.h"

#define please_take_me_as_an_webview @"/please_take_me_as_an_webview/ohyeah"

@interface RIDemo10Intercepter : TSIntercepterAdapter
@end
@implementation RIDemo10Intercepter
TS_INTERCEPTER(TSIntercepterPriorityNormal)

- (NSArray<NSString *> *)matchUrlPatterns {
    return @[@".*/demo10"];
}

- (void)doAdjudgement:(id<TSIntercepterJudger>)adjudger {
    NSLog(@"Demo10 intercepter!!");
    TSIntent *intent = [TSIntent pushPopIntentByUrl:please_take_me_as_an_webview];
    intent.displayer = adjudger.intent.displayer;
    [adjudger doSwitch:intent];
}
@end



/**
 There's no /demo10 url registered,
 */
@interface RIDemo10ViewController ()

@end

@implementation RIDemo10ViewController

TS_VC_ROUTE(please_take_me_as_an_webview)

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Some Webview";

}

@end
