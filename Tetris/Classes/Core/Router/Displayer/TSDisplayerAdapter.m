//
//  RIDisplayerAdapter.m
//  RouteIntent
//
//  Created by 王俊仁 on 2017/7/12.
//  Copyright © 2017年 jrwong. All rights reserved.
//

#import "TSDisplayerAdapter.h"
#import "UINavigationController+TSCompletion.h"
#import "TSError.h"

@implementation TSDisplayerAdapter

- (void)ts_displayFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC animated:(BOOL)animated completion:(void (^)(void))completion {
    TSAssertion(NO, "Please Override this method %@, %s",self, __FUNCTION__);
}

- (void)ts_finishDisplayViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
    TSAssertion(NO, "Please Override this method %@, %s",self, __FUNCTION__);
}

- (void)ts_setNeedDisplay:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
    [self dismissViewController:vc animated:animated completion:^{
        [vc.navigationController ts_popToViewController:vc animated:animated completion:completion];
    }];
}

- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
    if (vc.presentedViewController) {
        [vc dismissViewControllerAnimated:animated completion:^{
            [self dismissViewController:vc animated:animated completion:completion];
        }];
    } else if(completion) {
        completion();
    }
}

@end