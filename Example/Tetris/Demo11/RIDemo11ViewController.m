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

TS_ROUTE(@"/demo11")

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Send message and finish!!" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 200, self.view.frame.size.width, 100);
    [btn addTarget:self action:@selector(sendWave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    __weak typeof(self) ws = self;
    [[self.ts_sourceIntent resultByCode:@1] subscribeNext:^(id  _Nullable obj) {
        [ws alert:obj complete:^{
            [ws ts_finishDisplay:YES complete:^{
                [ws ts_sendResult:@{@"key" : @"result"}];
            }];
        }];
    }];

    
}

- (void)sendWave:(id)sender {
    [self.ts_sourceIntent sendResult:@"by code msg" byCode:@1];
}

@end
