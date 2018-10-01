//
//  RIDemo4ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo4ViewController.h"

@interface RIDemo4Intercepter : TSIntercepterAdapter
@end
@implementation RIDemo4Intercepter

TS_INTERCEPTER(TSIntercepterPriorityNormal)

- (NSArray<NSString *> *)matchUrlPatterns {
    return @[@"^((\\w+)://)?(\\w+)?/demo4\\??.*$"];
}

- (void)doAdjudgement:(id<TSIntercepterJudger>)adjudger {
    NSLog(@"Demo4: intercepter continued~~");
    [adjudger doContinue];
}

@end


@interface RIDemo4ViewController ()

@end

@implementation RIDemo4ViewController

TS_VC_ROUTE("/demo4")

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
