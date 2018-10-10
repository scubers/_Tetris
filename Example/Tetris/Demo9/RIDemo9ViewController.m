//
//  RIDemo9ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo9ViewController.h"

TS_EXPORT_ROUTE(RIDemo9ViewController, @"/demo9", 100)
@interface RIDemo9ViewController ()

//@property (nonatomic, strong) RIUnListener *unlistener;
@property (nonatomic, strong) TSCanceller *canceller;

@property (nonatomic, strong) TSDrivenStream<TSTreeUrlComponent *> *driven;

@property (nonatomic, strong) UITextField *textfield;

@end

@implementation RIDemo9ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Listening";
    
    [_Tetris.router subscribeDrivenByUrl:@"/list/demo9" callback:^(TSTreeUrlComponent * _Nonnull component) {
        [self alert:[component description]];
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Send message!!" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 150, 100);
    [btn addTarget:self action:@selector(sendWave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];


    _textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 50)];
    _textfield.backgroundColor = [UIColor yellowColor];
    _textfield.placeholder = @"Please input message here";
    [self.view addSubview:_textfield];


}

- (void)sendWave:(id)sender {
    [_Tetris.router postDrivenByUrl:[NSString stringWithFormat:@"/list/demo9?text=%@", self.textfield.text] params:nil];
}

- (void)dealloc {
    [_canceller cancel];
}




@end
