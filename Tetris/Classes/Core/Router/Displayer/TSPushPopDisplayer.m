//
//  TSPushPopDisplayer.m
//  RouteIntent
//
//  Created by 王俊仁 on 2017/6/22.
//  CopyTSght © 2017年 jrwong. All TSghts reserved.
//

#import "TSPushPopDisplayer.h"
#import "UINavigationController+TSCompletion.h"
#import <UIKit/UIKit.h>

@implementation TSPushPopDisplayer

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self setDisplayAction:^(UIViewController *fromVC, UIViewController *target, BOOL animated, void (^completion)(void)) {
            if (!fromVC.navigationController) {
                NSLog(@"TSPushPopDisplayer display [vc: %@] error, because source vc doesn't in a navigation hierarchy", fromVC);
                return;
            }
            [fromVC.navigationController ts_pushViewController:target animated:animated completion:completion];
        }];

        [self setFinishAction:^(UIViewController *vc, BOOL animated, void (^completion)(void)) {
            if (!vc.navigationController) {
                NSLog(@"TSPushPopDisplayer display [vc: %@] error, because source vc doesn't in a navigation hierarchy", vc);
                return;
            }
            NSUInteger idx = [vc.navigationController.viewControllers indexOfObject:vc];
            if (idx != NSNotFound && idx != 0) {
                UIViewController *preVC = [vc.navigationController.viewControllers objectAtIndex:idx - 1];
                [vc.navigationController ts_popToViewController:preVC animated:animated completion:completion];
            } else {
                [vc.navigationController ts_popViewControllerAnimated:animated completion:completion];
            }
        }];
    }
    return self;
}

+ (instancetype)pushDisplayerWithFinish:(TSViewFinishAction)finish {
    TSPushPopDisplayer *handler = [[TSPushPopDisplayer alloc] init];
    [handler setFinishAction:finish];
    return handler;
}


@end


@implementation TSIntent (PushPopInit)

+ (instancetype)pushPopIntentByUrl:(NSString *)url {
    return [[self alloc] initWithUrl:url intentClass:nil displayer:[TSPushPopDisplayer new]];
}

@end
