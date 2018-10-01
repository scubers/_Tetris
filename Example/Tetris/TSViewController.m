//
//  TSViewController.m
//  Tetris
//
//  Created by wangjunren on 09/28/2018.
//  Copyright (c) 2018 wangjunren. All rights reserved.
//

#import "TSViewController.h"
@import Tetris;

@protocol AAA <NSObject> @end
@protocol BBB <AAA> @end



@interface TSViewController () <BBB>

@end

@implementation TSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [TSTreeNode nodeWithKey:@"" value:nil depth:0];
//    [TSLogger log:@"sss%@  %@", @1, @2];
//    [TSLogger logError:[NSError ts_errorWithCode:100 msg:@"错了"]];
//    TSLog(@"sss %@", @1);
//    TSLogErr([NSError ts_errorWithCode:1000 msg:@"报错"]);
//    NSError *err = [NSError ts_errorWithCode:200 msg:@"some"];
//    TSLog(@"%@", err.localizedDescription);
//    
//    NSLog(@"%d", [self.class conformsToProtocol:@protocol(UIDataSourceTranslating)]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
