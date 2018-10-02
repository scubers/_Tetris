//
//  RIDemo5ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo5ViewController.h"


@interface RIDemo5Intercepter : TSIntercepterAdapter
@end

@implementation RIDemo5Intercepter

TS_INTERCEPTER(TSIntercepterPriorityNormal)

- (NSArray<NSString *> *)matchUrlPatterns {
    return @[@"/demo5\\??.*"];
}

- (void)doAdjudgement:(id<TSIntercepterJudger>)adjudger {
    NSLog(@"Demo5 switch intercepter!!");
    TSIntent *intent = [TSIntent pushPopIntentByUrl:@"/interceptered/demo5#intercepted"];
    intent.displayer = adjudger.intent.displayer;
    [adjudger doSwitch:intent];
}

@end


TS_EXPORT_ROUTE(RIDemo5ViewController, "/interceptered/demo5", 100);

@interface RIDemo5ViewController ()

@end

@implementation RIDemo5ViewController

TS_VC_ROUTE("/demo5")
//TS_VC_ROUTE("/demo5")

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.ts_sourceIntent.urlComponent.fragment.length) {
        [self alert:self.ts_sourceIntent.urlComponent.fragment];
    }
}


@end
