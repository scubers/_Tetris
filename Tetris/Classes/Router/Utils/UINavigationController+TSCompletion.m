//
//  UINavigationController+RIAnimationCompletion.m
//  RouteIntent
//
//  Created by 王俊仁 on 2017/11/24.
//

#import "UINavigationController+TSCompletion.h"


@implementation UINavigationController (TSCompletion)

- (void)ts_executeWithCompletion:(void (^)(void))complete animated:(BOOL)animated {
    if (!animated) {
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete();
            });
        }
        return;
    }
    [self.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (complete) {
            complete();
        }
    }];
}

- (void)ts_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(void))completion {
    [self setViewControllers:viewControllers animated:animated];
    [self ts_executeWithCompletion:completion animated:animated];
}

- (void)ts_pushViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
    [self pushViewController:vc animated:animated];
    [self ts_executeWithCompletion:completion animated:animated];
}

- (UIViewController *)ts_popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *vc = [self popViewControllerAnimated:animated];
    [self ts_executeWithCompletion:completion animated:animated];
    return vc;
}

- (NSArray<UIViewController *> *)ts_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    id vcs = [self popToViewController:viewController animated:animated];
    [self ts_executeWithCompletion:completion animated:animated];
    return vcs;
}

- (NSArray<UIViewController *> *)ts_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    id vcs = [self popToRootViewControllerAnimated:animated];
    [self ts_executeWithCompletion:completion animated:animated];
    return vcs;
}

@end
