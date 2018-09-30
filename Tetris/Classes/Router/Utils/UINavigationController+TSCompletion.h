//
//  UINavigationController+RIAnimationCompletion.h
//  RouteIntent
//
//  Created by 王俊仁 on 2017/11/24.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (TSCompletion)


- (void)ts_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)ts_pushViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion;

- (UIViewController *)ts_popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray<UIViewController *> *)ts_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray<UIViewController *> *)ts_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
