//
//  TSInspector.m
//  Tetris
//
//  Created by Junren Wong on 2018/11/14.
//

#import "TSInspector.h"
#import "TSInspectorButton.h"
@interface TSInspectorBubbleVC : UIViewController
@end
@implementation TSInspectorBubbleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    TSInspectorButton *btn = [TSInspectorButton create];
    CGRect rect = CGRectMake(0, 0, 60, 60);
    btn.frame = rect;
    self.view.frame = rect;
    [self.view addSubview:btn];
}

@end

@interface TSInspector ()
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TSInspector

static TSInspector *__shared;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [TSInspector new];
    });
    return __shared;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (enabled) {
            [self.window makeKeyAndVisible];
            [self.window resignKeyWindow];
        } else {
            [self.window resignKeyWindow];
            self.window = nil;
        }
    });
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.window];
        CGRect rect = self.window.frame;
        rect.origin.x += point.x;
        rect.origin.y += point.y;
        self.window.frame = rect;
        [pan setTranslation:CGPointZero inView:self.window];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGRect rect = self.window.frame;
        CGRect screenRect = [UIScreen mainScreen].bounds;
        rect.origin.x = rect.origin.x > (screenRect.size.width - rect.size.width) / 2.0 ? (screenRect.size.width - rect.size.width) : 0;
        rect.origin.y = MIN(MAX(0, rect.origin.y), screenRect.size.height - rect.size.height);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:0 animations:^{
            self.window.frame = rect;
        } completion:nil];
    }
}


- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _window.rootViewController = [TSInspectorBubbleVC new];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_window addGestureRecognizer:pan];
        _window.clipsToBounds = YES;
        _window.layer.cornerRadius = 30;
        _window.windowLevel = UIWindowLevelStatusBar;
    }
    return _window;
}
@end
