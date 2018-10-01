//
//  RIBaseViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIBaseViewController.h"

@interface RIBaseViewController ()

@end

@implementation RIBaseViewController

- (instancetype)initWithIntent:(TSIntent *)sourceIntent {
    if (self = [super init]) {
        _ts_sourceIntent = sourceIntent;
    }
    return self;
}

- (void)ts_setIntent:(TSIntent *)intent {
    _ts_sourceIntent = intent;
}

- (instancetype)init {
    NSAssert(NO, @"不支持此初始化方法");
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor lightGrayColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (void)back:(id)sender {
    [self.ts_sourceIntent.displayer ts_finishDisplayViewController:self animated:YES completion:nil];
//    [self ri_finishDisplay];
}

- (void)alert:(NSString *)msg {
    [self alert:msg complete:nil];
}

- (void)alert:(NSString *)msg complete:(dispatch_block_t)complete {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (complete) {
            complete();
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end


@interface RIBaseTableViewController ()
@end

@implementation RIBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
