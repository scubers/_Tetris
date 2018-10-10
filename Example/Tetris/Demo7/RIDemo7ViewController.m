//
//  RIDemo7ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo7ViewController.h"

@interface RIDemo7Intercepter : TSIntercepterAdapter
@end
@implementation RIDemo7Intercepter

TS_INTERCEPTER(TSIntercepterPriorityMinimum)

- (void)ts_judgeIntent:(id<TSIntercepterJudger>)adjudgement {
    if (!adjudgement.intent.intentClass) {
        NSLog(@"Demo7 Intercepter, onlost+++");
        [adjudgement doSwitch:[TSIntent presentDismissByUrl:@"/demo7"]];
    } else {
        [adjudgement doContinue];
    }
}


@end

@interface RIDemo7ViewController ()

@end

@implementation RIDemo7ViewController

TS_VC_ROUTE(@"/demo7")

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"404 Page Not Found";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (void)back:(id)sender {
    [self ts_finishDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
