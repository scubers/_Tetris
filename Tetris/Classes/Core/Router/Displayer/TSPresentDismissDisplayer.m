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

@property (nonatomic, strong) UIViewController *ts_sourceViewController;

@end

@implementation TSPresentDismissDisplayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _navigationViewControllerClass = [UINavigationController class];
    }
    return self;
}

- (void)ts_displayFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC animated:(BOOL)animated completion:(void (^)(void))completion {
    if (![toVC isKindOfClass:[UINavigationController class]]) {
        toVC = [[_navigationViewControllerClass alloc] initWithRootViewController:toVC];
    }
    [fromVC presentViewController:toVC animated:animated completion:^{
        if (completion) {
            completion();
        }
        _ts_sourceViewController = fromVC;
    }];
}

- (void)ts_finishDisplayViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
//    [vc dismissViewControllerAnimated:animated completion:completion];
    [(_ts_sourceViewController ?: vc) dismissViewControllerAnimated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
}


@end


@implementation TSIntent (PresentDismissInit)

+ (instancetype)presentDismissByUrl:(NSString *)url {
    return [[self alloc] initWithUrl:url intentClass:nil displayer:[TSPresentDismissDisplayer new] factory:nil];
}

+ (instancetype)presentDismissByClass:(Class<TSIntentable>)aClass {
    return [[self alloc] initWithUrl:nil intentClass:aClass displayer:[TSPresentDismissDisplayer new] factory:nil];
}

@end
