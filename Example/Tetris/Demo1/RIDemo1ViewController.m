//
//  RIJustRouteViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo1ViewController.h"

@interface ASingleService : NSObject
@end
@implementation ASingleService
- (void)method {
    NSLog(@"%@", self);
}
@end

@import Tetris;

@protocol RIDemo1ServicePrt <NSObject>

- (void)demo1Method;

@end

@interface RIDemo1ViewController ()

TS_AUTOWIRED(RIDemo1ServicePrt, demo1Service)

@end

TS_EXPORT_ROUTE(RIDemo1ViewController, @"/demo1/demo1", lkj)

@implementation RIDemo1ViewController

//TS_ROUTE(@"/demo1")
TS_ROUTE_MSG(@"/demo1", @"Just Route")

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Just Route";
    [_demo1Service demo1Method];
    
    ASingleService *s1 = TS_CREATE_WEAK_SINGLETON(ASingleService);
    ASingleService *s2 = TS_CREATE_WEAK_SINGLETON(ASingleService);
    
    [s1 method];
    [s2 method];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [TS_CREATE_SINGLETON(ASingleService) method];
        [s2 method];
    });
    
}

+ (id<TSIntercepter>)ts_selfIntercepter {
    return [[TSFinalIntercepter alloc] initWithAction:^(id<TSIntercepterJudger>  _Nonnull judger) {
        NSLog(@"-- demo1 self intercepter --");
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
