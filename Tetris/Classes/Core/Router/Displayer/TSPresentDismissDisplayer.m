//
//  TSPresentDismissDisplayer.m
//  RouteIntent
//
//  Created by 王俊仁 on 2017/6/22.
//  CopyTSght © 2017年 jrwong. All TSghts reserved.
//

#import "TSPresentDismissDisplayer.h"
#import <UIKit/UIKit.h>

@interface TSPresentDismissDisplayer ()

@property (nonatomic, weak) UIViewController *ts_sourceViewController;

@end

@implementation TSPresentDismissDisplayer

- (instancetype)init {
    return [self initWithNav:[UINavigationController class]];
}

- (instancetype)initWithNav:(Class)navClass {
    return [self initWithNav:navClass presentStyle:UIModalPresentationFullScreen];
}

- (instancetype)initWithNav:(Class)navClass presentStyle:(UIModalPresentationStyle)present {
    return [self initWithNav:navClass presentStyle:present transitionStyle:UIModalTransitionStyleCoverVertical];
}

- (instancetype)initWithNav:(Class)navClass presentStyle:(UIModalPresentationStyle)present transitionStyle:(UIModalTransitionStyle)transitionStyle {
    if (self = [super init]) {
        _navigationViewControllerClass = navClass;
        _presentStyle = present;
        _transitionStyle = transitionStyle;
    }
    return self;
}

- (void)ts_displayFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC animated:(BOOL)animated completion:(void (^)(void))completion {
    if (![toVC isKindOfClass:[UINavigationController class]] && _navigationViewControllerClass != nil) {
        toVC = [[_navigationViewControllerClass alloc] initWithRootViewController:toVC];
    }
    toVC.modalPresentationStyle = _presentStyle;
    [fromVC presentViewController:toVC animated:animated completion:^{
        if (completion) {
            completion();
        }
        self.ts_sourceViewController = fromVC;
    }];
}

- (void)ts_finishDisplayViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
//    [vc dismissViewControllerAnimated:animated completion:completion];
//    [(self.ts_sourceViewController ?: vc) dismissViewControllerAnimated:animated completion:^{
    [vc dismissViewControllerAnimated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
}


@end


@implementation TSIntent (PresentDismissInit)

+ (instancetype)presentDismissByUrl:(NSString *)url {
    return [[self alloc] initWithUrl:url intentClass:nil displayer:[TSPresentDismissDisplayer new] builder:nil];
}

+ (instancetype)presentDismissByClass:(Class<TSIntentable>)aClass {
    return [[self alloc] initWithUrl:nil intentClass:aClass displayer:[TSPresentDismissDisplayer new] builder:nil];
}

@end
