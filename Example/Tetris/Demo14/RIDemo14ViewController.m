//
//  RIDemo14ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2018/3/29.
//  Copyright © 2018年 scubers. All rights reserved.
//

#import "RIDemo14ViewController.h"

@interface RIDemo14Intercepter : TSIntercepterAdapter
@end
@implementation RIDemo14Intercepter

TS_INTERCEPTER(TSIntercepterPriorityHigh)

- (void)ts_judgeIntent:(id<TSIntercepterJudger>)adjudgement {
    // 过滤scheme host port
    TSIntent *intent = adjudgement.intent;

    if (intent.urlComponent.scheme.length || intent.urlComponent.host.length || intent.urlComponent.port) {
        // 只放行允许的前缀
        if (
            [intent.urlComponent.scheme hasPrefix:@"http"] ||
            ([intent.urlComponent.scheme isEqualToString:@"scheme"] && [intent.urlComponent.host isEqualToString:@"route"])
            ) {
            [adjudgement doContinue];
        } else {
            NSLog(@"wrong url scheme or host, please use [scheme://route/xxxx]");
            [adjudgement doReject:[NSError errorWithDomain:@"Wrong url scheme or host!!!" code:100 userInfo:nil]];
        }
    } else {
        [adjudgement doContinue];
    }
}

@end

@interface RIDemo14ViewController ()
@end


@implementation RIDemo14ViewController

TS_VC_ROUTE("/demo14")

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"right url: scheme://route/demo14" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 100, self.view.frame.size.width, 50);
    [self.view addSubview:rightBtn];

    UIButton *wrongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wrongBtn setTitle:@"wrong url: wrong://wrong/demo14" forState:UIControlStateNormal];
    [wrongBtn addTarget:self action:@selector(wrongClick:) forControlEvents:UIControlEventTouchUpInside];
    wrongBtn.frame = CGRectMake(0, 200, self.view.frame.size.width, 50);
    [self.view addSubview:wrongBtn];
}

- (void)wrongClick:(id)sender {
    TSIntent *intent = [TSIntent pushPopIntentByUrl:@"wrong://wrong/demo14"];
    [[[self ts_prepare:intent]
      onError:^(NSError * _Nonnull error) {
          [self alert:error.description];
      }]
     subscribe];
}

- (void)rightClick:(id)sender {
    TSIntent *intent = [TSIntent pushPopIntentByUrl:@"scheme://route/demo14"];
    [self ts_start:intent];
}

@end
