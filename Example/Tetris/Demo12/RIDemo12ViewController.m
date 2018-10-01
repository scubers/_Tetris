//
//  RIDemo12ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo12ViewController.h"

@interface RIDemo12ViewController ()

TSInjectNumber(number)
TSInjectString(string)

@end

@implementation RIDemo12ViewController

TS_VC_ROUTE("/demo12")

- (void)viewDidLoad {
    [super viewDidLoad];
    // Autowired property to self
    [self ts_autowireTSTypesWithDict:self.ts_sourceIntent.urlComponent.params];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *msg = [NSString stringWithFormat:@"number: %@\nstring: %@", self.number, self.string];
    [self alert:msg];
}

@end
