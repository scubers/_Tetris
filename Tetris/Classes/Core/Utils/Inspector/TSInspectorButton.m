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

static TSInspectorButton *__singletonInstance;

+ (void)setVisible:(BOOL)visible {
    [__singletonInstance removeFromSuperview];
    if (visible) {
        __singletonInstance = [TSInspectorButton create];
        [[UIApplication sharedApplication].delegate.window addSubview:__singletonInstance];
    }
}

+ (instancetype)create {
    TSInspectorButton *btn = [TSInspectorButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Inspect" forState:UIControlStateNormal];
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    btn.frame = CGRectMake(0, 100, 80, 80);
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 40;
    return btn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
        [self addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self];
        CGRect rect = self.frame;
        rect.origin.x += point.x;
        rect.origin.y += point.y;
        self.frame = rect;
        [pan setTranslation:CGPointZero inView:self];
    }
}

- (void)touch:(id)sender {
    TSIntent *intent = [TSIntent presentDismissByClass:[TSInspectorVC class]];
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    [[self getTop:vc] ts_start:intent];
}

- (UIViewController *)getTop:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self getTop:vc.presentedViewController];
    }
    return vc;
}

@end
