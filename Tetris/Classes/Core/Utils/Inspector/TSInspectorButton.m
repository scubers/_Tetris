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
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGRect rect = self.frame;
        CGRect screenRect = [UIScreen mainScreen].bounds;
        rect.origin.x = rect.origin.x > (screenRect.size.width - rect.size.width) / 2.0 ? (screenRect.size.width - rect.size.width) : 0;
        rect.origin.y = MIN(MAX(0, rect.origin.y), screenRect.size.height - rect.size.height);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:0 animations:^{
            self.frame = rect;
        } completion:nil];
    }
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
