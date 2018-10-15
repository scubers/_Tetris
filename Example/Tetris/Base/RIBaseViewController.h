//
//  RIBaseViewController.h
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Tetris;

@interface RIBaseViewController : UIViewController

- (void)alert:(NSString *)msg complete:(dispatch_block_t)complete;
- (void)alert:(NSString *)msg;

@end


@interface RIBaseTableViewController : RIBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
