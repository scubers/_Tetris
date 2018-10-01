//
//  MyPushPop.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "MyPushPop.h"

@interface MyPushPop () <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) id<UINavigationControllerDelegate> oldNavDelegate;
@property (nonatomic, strong) UINavigationController *navController;

@property (nonatomic, assign) UINavigationControllerOperation navOperation;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *panDriven;

@end

@implementation MyPushPop

+ (instancetype)pop {
    MyPushPop *instance = [MyPushPop new];
    instance.navOperation = UINavigationControllerOperationPop;
    return instance;
}

+ (instancetype)push {
    MyPushPop *instance = [MyPushPop new];
    instance.navOperation = UINavigationControllerOperationPush;
    return instance;
}

- (void)ts_displayFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC animated:(BOOL)animated completion:(void (^)(void))completion {
    _navController = fromVC.navigationController;
    _oldNavDelegate = _navController.delegate;
    fromVC.navigationController.delegate = self;
    [super ts_displayFromViewController:fromVC toViewController:toVC animated:animated completion:^{
        if (completion) {
            completion();
        }
        _navController.delegate = _oldNavDelegate;
        _oldNavDelegate = nil;
    }];
}

- (void)ts_finishDisplayViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
    _oldNavDelegate = _navController.delegate;
    _navController.delegate = self;
    [super ts_finishDisplayViewController:vc animated:animated completion:^{
        if (completion) {
            completion();
        }
        _navController.delegate = _oldNavDelegate;
        _navController = nil;
        _oldNavDelegate = nil;
    }];
}

#pragma mark - <UINavigationControllerDelegate>


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [MyPushPop push];
    } else {
        return [MyPushPop pop];
    }
    return nil;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_navOperation == UINavigationControllerOperationPush) {
        [self pushAnimation:transitionContext];
    } else {
        [self popAnimation:transitionContext];
    }
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tovc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    [transitionContext.containerView addSubview:tovc.view];

    CGRect ori = fromvc.view.frame;
    tovc.view.frame = CGRectMake(ori.size.width, ori.origin.y, ori.size.width, ori.size.height);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tovc.view.frame = ori;
        fromvc.view.frame = CGRectInset(ori, 7.8, 7.8);
    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            [fromvc.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        } else {
            [tovc.view removeFromSuperview];
            [transitionContext completeTransition:NO];
        }

    }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tovc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

//    tovc.view.frame = CGRectZero;
    [transitionContext.containerView insertSubview:tovc.view belowSubview:fromvc.view];

    CGRect ori = fromvc.view.frame;
    tovc.view.frame = CGRectInset(ori, 7.8, 7.8);

//    CGRect finalFrame = fromvc.view.frame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tovc.view.frame = ori;
        fromvc.view.frame = CGRectMake(ori.size.width, ori.origin.y, ori.size.width, ori.size.height);
    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            [fromvc.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }
        else {
            [tovc.view removeFromSuperview];
            [transitionContext completeTransition:NO];
        }
    }];
}



- (UIPercentDrivenInteractiveTransition *)panDriven {
    if (!_panDriven) {
        _panDriven = [[UIPercentDrivenInteractiveTransition alloc] init];
    }
    return _panDriven;
}
@end
