//
//  RIDemo6ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo6ViewController.h"

@interface RIDemo6Intercepter : TSIntercepterAdapter
@end

@implementation RIDemo6Intercepter

TS_INTERCEPTER(TSIntercepterPriorityNormal)

- (NSArray<NSString *> *)matchUrlPatterns {
    return @[@"^/demo6\\??.*"];
}

- (void)doAdjudgement:(id<TSIntercepterJudger>)adjudger {

    if ([adjudger.intent[@"userId"] length]) {
        [adjudger doContinue];
        return;
    }

    TSIntent *intent = [TSIntent pushPopIntentByUrl:@"/login/demo6"];
    intent.displayer = [TSPresentDismissDisplayer new];
    [intent.onResult subscribe:^(id  _Nullable obj) {
        [adjudger.intent.extraParameters addEntriesFromDictionary:@{@"userId" : @"userId"}];
        [adjudger restart];
    }];
    [adjudger doSwitch:intent];
}

@end

TS_EXPORT_ROUTE(RIDemo6ViewController, "/login/demo6", 100);


@interface RIDemo6ViewController ()

@end

@implementation RIDemo6ViewController

TS_VC_ROUTE("/demo6")

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.ts_sourceIntent.urlString containsString:@"login"]) {
        [self setupLogin];
    } else {
        [self setupNomal];
    }

}

- (void)setupLogin {
    self.navigationItem.title = @"Login Page";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
}

- (void)login:(id)sender {
    [self ts_finishDisplay:YES complete:^{
        [self ts_sendStream:nil];
    }];
}

- (void)setupNomal {
    self.navigationItem.title = @"Demo6";

}

@end





