//
//  RIDemo3ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo3ViewController.h"

@interface RIDemo3Intercepter : TSIntercepterAdapter
@end

@implementation RIDemo3Intercepter

TS_INTERCEPTER(TSIntercepterPriorityNormal)


- (NSArray<NSString *> *)matchUrlPatterns {
    return @[@"^((\\w+)://)?(\\w+)?/demo3\\??.*$"];
}

- (void)doAdjudgement:(id<TSIntercepterJudger>)adjudger {
    NSString *msg = [NSString stringWithFormat:@"Reject by Class: %@", NSStringFromClass(self.class)];
    NSLog(@"Demo3: %@", msg);
    [adjudger doReject:[NSError errorWithDomain:msg code:100 userInfo:nil]];
}

@end



@interface RIDemo3ViewController ()

@end

@implementation RIDemo3ViewController

TS_VC_ROUTE("/demo3")

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
