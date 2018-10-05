//
//  RIDemoMenuViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemoMenuViewController.h"




@interface RIDemoMenuViewController ()

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, TSIntent *> *> *intents;

@property (nonatomic, assign) BOOL isSwiftDemo;

@end

@implementation RIDemoMenuViewController

TS_VC_ROUTE("/menu")

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationItem];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1"];

    [self reloadData];

}

- (void)setupNavigationItem {
    self.navigationItem.title = @"OC Demo";
    NSString *itemTitle = @"Switch";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(change:)];
}

- (void)change:(id)sender {
    [_Tetris.router postDrivenByUrl:@"/changeDemo" params:nil];
}

- (void)reloadData {
    _intents = [self getIntents];
    [self.tableView reloadData];
}

- (NSArray<NSDictionary<NSString *,TSIntent *> *> *)getIntents {
    return
    @[
      @{@"1. Just Route" : [TSIntent pushPopIntentByUrl:@"/demo1"]},
      @{@"2. Route with params" : [TSIntent pushPopIntentByUrl:@"/demo2/demo2?p=pp&b=bb&c=cc&name=my_name&number=98#i_am_fragment"]},
      @{@"3. Intercepter: Reject" : [TSIntent pushPopIntentByUrl:@"/demo3"]},
      @{@"4. Intercepter: Continue" : [TSIntent pushPopIntentByUrl:@"/demo4"]},
      @{@"5. Intercepter: Switch" : [TSIntent pushPopIntentByUrl:@"/demo5"]},
      @{@"6. Intercepter: Login or something need preprocess" : [TSIntent pushPopIntentByUrl:@"/demo6"]},
      @{@"7. Global Mismatch" : [TSIntent pushPopIntentByUrl:@"/i_dont_know_where_to_go/lskdjf/ksjdflkj"]},
      @{@"8. Action" : [TSIntent pushPopIntentByUrl:@"/demo8"]},
      @{@"9. Listening" : [TSIntent pushPopIntentByUrl:@"/demo9"]},
      @{@"10. Intercepter: Global Degrade" : [TSIntent pushPopIntentByUrl:@"/demo10"]},
      @{@"11. Get result" : [TSIntent pushPopIntentByUrl:@"/demo11"]},
      @{@"12. Autowire params" : [TSIntent pushPopIntentByUrl:@"/demo12?number=333&string=i_am_string"]},
      @{@"13. Custom transition animation" : [TSIntent pushPopIntentByUrl:@"/demo13"]},
      @{@"14. Scheme host checking" : [TSIntent pushPopIntentByUrl:@"/demo14"]},
      @{@"15. Path parameter" : [TSIntent pushPopIntentByUrl:@"/demo15/100"]},
      @{@"16. Test direct set vc" : [TSIntent pushPopIntentByUrl:@"/demo16"]},
      ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    cell.textLabel.text = self.intents[indexPath.row].allKeys.lastObject;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TSIntent *intent = [self.intents[indexPath.row].allValues.lastObject copy];

    [intent.onResult subscribeNext:^(id  _Nullable obj) {
        [self alert:[NSString stringWithFormat:@"%@", obj]];
    }];

    [[self ts_prepare:intent complete:^{
        NSLog(@"---- finish route ----");
    }] subscribeNext:^(TSRouteResult * _Nullable obj) {

    } error:^(NSError * _Nullable error) {
        [self alert:[NSString stringWithFormat:@"%@", error]];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.intents.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


@end
