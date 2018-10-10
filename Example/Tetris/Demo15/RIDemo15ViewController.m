//
//  RIDemo15ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2018/3/29.
//  Copyright © 2018年 scubers. All rights reserved.
//

#import "RIDemo15ViewController.h"

@interface RIDemo15ViewController ()

TSInjectString(identifier);
TSInjectString(keyword);
TSInjectNumber(id);

@end

@implementation RIDemo15ViewController

TS_VC_ROUTE(@"/demo15/:identifier/:keyword/:id/suffix")


- (void)setTs_sourceIntent:(TSIntent *)ts_sourceIntent {
    [super setTs_sourceIntent:ts_sourceIntent];
    [self ts_autowireTSTypesWithDict:self.ts_sourceIntent.urlComponent.params];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self alert:[NSString stringWithFormat:@"id: %@, keyword: %@, identifier: %@", _id, _keyword, _identifier]];
}

@end
