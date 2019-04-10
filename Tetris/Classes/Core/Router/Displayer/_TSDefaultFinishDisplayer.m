//
//  _TSDefaultFinishDisplayer.m
//  Tetris
//
//  Created by Junren Wong on 2019/4/10.
//

#import "_TSDefaultFinishDisplayer.h"

@implementation _TSDefaultFinishDisplayer

- (void)ts_finishDisplayViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
    // 因为考虑到不是全部跳转都会使用到intent的displayer，但是为了兼容ts_finishDisplay，所以提供一个默认的结束器
    // - 首先让自己先展示
    [self ts_setNeedDisplay:vc animated:NO completion:^{
        if (vc.navigationController && vc.navigationController.viewControllers.count > 1) {
            // - 若处于导航栏，并且不是根控制器，则pop
            [vc.navigationController ts_popViewControllerAnimated:animated completion:completion];
        } else if (vc.presentingViewController) {
            // - 若不处于导航栏或者是导航栏的根控制器，则考虑是否处于
            [vc dismissViewControllerAnimated:animated completion:completion];
        } else {
            TSLog(@"[_TSDefaultFinishDisplayer] can not finish vc[%@]", vc);
        }
    }];
}

@end
