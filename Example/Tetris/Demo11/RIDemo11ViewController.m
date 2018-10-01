//
//  RIDemo11ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo11ViewController.h"

@interface RIDemo11ViewController ()

@end

@implementation RIDemo11ViewController

TS_VC_ROUTE("/demo11")

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Send message and finish!!" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 200, self.view.frame.size.width, 100);
    [btn addTarget:self action:@selector(sendWave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    
}

- (void)sendWave:(id)sender {
    [self ts_finishDisplay:YES complete:^{
        [self ts_sendStream:@{@"key" : @"result"}];
    }];
}

@end
