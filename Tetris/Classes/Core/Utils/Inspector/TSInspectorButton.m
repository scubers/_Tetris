//
//  TSInspectorButton.m
//  Tetris
//
//  Created by Junren Wong on 2018/11/14.
//

#import "TSInspectorButton.h"
#import "TSTetris.h"
#import "TSPresentDismissDisplayer.h"
#import "TSInspectorVC.h"
#import "UIViewController+TSRouter.h"

@implementation TSInspectorButton

+ (instancetype)create {
    TSInspectorButton *btn = [TSInspectorButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Tetris" forState:UIControlStateNormal];
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    btn.frame = CGRectMake(0, 100, 60, 60);
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 30;
    btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    btn.layer.borderWidth = 1.5;
    return btn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)touch:(id)sender {
    TSIntent *intent = [TSIntent presentDismissByClass:[TSInspectorVC class]];
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    [[self getTop:vc] ts_start:intent complete:^{
        [self.superview bringSubviewToFront:self];
    }];
}

- (UIViewController *)getTop:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self getTop:vc.presentedViewController];
    }
    return vc;
}

@end
