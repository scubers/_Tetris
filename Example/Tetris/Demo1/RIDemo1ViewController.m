//
//  RIJustRouteViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo1ViewController.h"
@import Tetris;

@protocol RIDemo1ServicePrt <NSObject>

- (void)demo1Method;

@end

@interface RIDemo1ViewController ()

@property (nonatomic, strong) id<RIDemo1ServicePrt, TSAutowired> demo1Service;

@end

@implementation RIDemo1ViewController
TS_VC_ROUTE(@"/demo1")

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Just Route";
    [_demo1Service demo1Method];
}

+ (id<TSIntercepter>)ts_SelfIntercepter {
    return [[TSFinalIntercepter alloc] initWithAction:^(id<TSIntercepterJudger>  _Nonnull judger) {
        NSLog(@"-- demo1 final intercepter --");
        [judger doContinue];
    }];
}

@end


@interface RIDemo1ServiceImpl : NSObject <TSServiceable, RIDemo1ServicePrt>
@end

@implementation RIDemo1ServiceImpl

TS_SERVICE(RIDemo1ServicePrt, YES)

- (void)demo1Method {
    NSLog(@"demo1 method execute");
}

@end
