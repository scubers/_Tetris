//
//  RIDemo2ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo2ViewController.h"

@interface RIDemo2ViewController ()

TSInjectString(name);
TSInjectNumber(number);

@end

@implementation RIDemo2ViewController

TS_ROUTE(@"/demo2/demo2")

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self ts_autowireTSTypesWithDict:self.ts_sourceIntent.extraParameters];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    NSString *string = [NSString stringWithFormat:@"fragment: %@\n params: %@\nname: %@\nnumber: %@"
                        , self.ts_sourceIntent.urlComponent.fragment
                        , self.ts_sourceIntent.urlComponent.params
                        , self.name
                        , self.number];

    [self alert:string];
}

@end
