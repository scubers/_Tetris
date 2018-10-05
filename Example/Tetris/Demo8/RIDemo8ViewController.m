//
//  RIDemo8ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo8ViewController.h"

TS_EXPORT_ROUTE(RIDemo8ViewController, "/demo8", 100)

@interface RIDemo8ViewController ()

@end

@implementation RIDemo8ViewController

+ (void)load {
//    [_RIRouter registerUrl:@"/action/demo8" withAction:^RIFetchActionCanceller * _Nullable(RIFetchActioner * _Nonnull actioner, NSDictionary * _Nonnull params, NSString * _Nonnull fragment) {
//        NSLog(@"action params: %@", params);
//        NSLog(@"action fragment: %@", fragment);
//        [actioner actionResult:[NSString stringWithFormat:@"action success for url: /action/demo8\nparams: %@", params] error:nil];
//        return nil;
//    }];
    [_Tetris.router bindUrl:@"/action/demo8" toAction:^TSStream * _Nonnull(TSTreeUrlComponent * _Nonnull component) {
        return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
            [receiver post:[NSString stringWithFormat:@"action success for url: /action/demo8\nparams: %@, fragment: %@", component.params, component.fragment]];
            [receiver close];
            return nil;
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Get Message" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 150, 100);
    [btn addTarget:self action:@selector(getMsg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)getMsg:(id)sender {
    [[_Tetris.router actionByUrl:@"/action/demo8?a=b#fragment"] subscribeNext:^(id  _Nullable obj) {
        [self alert:obj];
    }];
}


@end
