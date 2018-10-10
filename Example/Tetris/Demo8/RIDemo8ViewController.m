//
//  RIDemo8ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo8ViewController.h"

@interface RIDemo8Action : NSObject <TSRouteActioner>
@end
@implementation RIDemo8Action

TS_ACTION(@"/action/demo8")

- (TSStream *)getStreamByComponent:(TSTreeUrlComponent *)component {
    return [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        [receiver post:[NSString stringWithFormat:@"action success for url: /action/demo8\nparams: %@, fragment: %@", component.params, component.fragment]];
        [receiver close];
        return nil;
    }];
}

@end


TS_EXPORT_ROUTE(RIDemo8ViewController, @"/demo8", 100)

@interface RIDemo8ViewController ()

@end

@implementation RIDemo8ViewController

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
