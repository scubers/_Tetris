//
//  RIJustRouteViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo1ViewController.h"
@import Tetris;

@interface RIDemo1ViewController ()

@end

@implementation RIDemo1ViewController
TS_VC_ROUTE("/demo1")

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Just Route";
}

+ (void)ts_finalAdjudgement:(id<TSIntercepterJudger>)judger {
    [judger doContinue];
}

@end