//
//  MyPresentDismiss.m
//  RouteIntent_Example
//
//  Created by 王俊仁 on 2017/12/7.
//  Copyright © 2017年 scubers. All rights reserved.
//

#import "MyPresentDismiss.h"

// Present 动画，将由 presentingViewController 的 transitioningDelegate 执行


@interface MyPresentDismiss () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isDismiss;

@property (nonatomic, strong) UIViewController *sourceViewController;


@end

@implementation MyPresentDismiss

- (void)ts_displayFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC animated:(BOOL)animated completion:(void (^)(void))completion {

    if (![toVC isKindOfClass:[UINavigationController class]]) {
        toVC = [[self.navigationViewControllerClass alloc] initWithRootViewController:toVC];
    }

    toVC.transitioningDelegate = self;
    toVC.modalPresentationStyle = UIModalPresentationCustom;

    [super ts_displayFromViewController:fromVC toViewController:toVC animated:animated completion:^{
        if (completion) {
            completion();
        }
        _sourceViewController = fromVC;
    }];



}

- (void)ts_finishDisplayViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {

    _sourceViewController.presentedViewController.transitioningDelegate = self;

    [_sourceViewController dismissViewControllerAnimated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _isDismiss = NO;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _isDismiss = YES;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_isDismiss) {
        [self dismissAnimate:transitionContext];
    } else {
        [self presentAnimate:transitionContext];
    }
}

- (void)presentAnimate:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tovc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

//    CGRect finalFromRect = [transitionContext finalFrameForViewController:fromvc];
    CGRect finalToRect = [transitionContext finalFrameForViewController:tovc];
    [transitionContext.containerView addSubview:tovc.view];

    tovc.view.frame = CGRectMake(finalToRect.origin.x, finalToRect.size.height, finalToRect.size.width, finalToRect.size.height);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromvc.view.frame = CGRectInset(finalToRect, 10, 10);
        tovc.view.frame = CGRectMake(finalToRect.origin.x, 50, finalToRect.size.width, finalToRect.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)dismissAnimate:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tovc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    //    CGRect finalFromRect = [transitionContext finalFrameForViewController:fromvc];
    CGRect finalToRect = [transitionContext finalFrameForViewController:tovc];

//    [transitionContext.containerView insertSubview:tovc.view belowSubview:fromvc.view];

    tovc.view.frame = CGRectInset(finalToRect, 10, 10);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromvc.view.frame = CGRectMake(finalToRect.origin.x, finalToRect.size.height, finalToRect.size.width, finalToRect.size.height);
        tovc.view.frame = finalToRect;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end




