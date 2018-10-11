//
//  RIDemo13ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo13ViewController.h"
#import "MyPushPop.h"
#import "MyPresentDismiss.h"

@interface RIDemo13ViewController ()

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id<TSIntentDisplayerProtocol>> *> *displayers;

@end

@implementation RIDemo13ViewController

TS_ROUTE(@"/demo13")

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1"];

    _displayers = @[
                    @{@"System Push" : [TSPushPopDisplayer new]},
                    @{@"System Present" : [TSPresentDismissDisplayer new]},
                    @{@"MyPushPop" : [MyPushPop new]},
                    @{@"MyPresentDismiss" : [MyPresentDismiss new]},
                    ];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TSIntent *intent = [[TSIntent alloc] initWithUrl:@"/demo13" intentClass:nil displayer:nil];
    intent.displayer = self.displayers[indexPath.row].allValues.lastObject;
    [self ts_start:intent];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    cell.textLabel.text = self.displayers[indexPath.row].allKeys.lastObject;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayers.count;
}


@end
