//
//  RIDemo9ViewController.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/8.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "RIDemo9ViewController.h"

TS_EXPORT_ROUTE(RIDemo9ViewController, "/demo9", 100)
@interface RIDemo9ViewController ()

//@property (nonatomic, strong) RIUnListener *unlistener;
@property (nonatomic, strong) TSCanceller *canceller;

@property (nonatomic, strong) TSDrivenStream *driven;

@property (nonatomic, strong) UITextField *textfield;

@end

@implementation RIDemo9ViewController

+ (void)load {
    [_Tetris.router bindUrl:@"/listen/demo9" toDriven:[TSDrivenStream stream]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Listening";

//    _pod = [_RIRouter podCastWithUrl:@"/listen/demo9"];
    _driven = [_Tetris.router drivenByUrl:@"/listen/demo9"];

    __weak typeof(self) ws = self;
//    _unlistener = [_pod listening:^(id wave) {
//        [ws alert:wave];
//    }];
    _canceller = [_driven subscribe:^(id  _Nullable obj) {
        [ws alert:obj];
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
    [_driven post:self.textfield.text];
//    [_pod postWave:self.textfield.text];
}

- (void)dealloc {
    [_canceller cancel];
//    [_unlistener unlisten];
}




@end
