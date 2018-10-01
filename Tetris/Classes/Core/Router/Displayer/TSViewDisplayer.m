//
//  TSViewDisplayer.m
//  RouteIntent
//
//  Created by 王俊仁 on 2017/11/24.
//

#import "TSViewDisplayer.h"

@implementation TSViewDisplayer

+ (instancetype)displayerWith:(TSViewDisplayAction)display finish:(TSViewFinishAction)finish {
    TSViewDisplayer *dis = [[TSViewDisplayer alloc] init];
    dis.displayAction = display;
    dis.finishAction = finish;
    return dis;
}

- (void)ts_displayFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!_displayAction) {
        NSLog(@"Display action doesn't exists!!!");
        return;
    }
    _displayAction(fromVC, toVC, animated, completion);
}

- (void)ts_finishDisplayViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!_finishAction) {
        NSLog(@"Finish action doesn't exists!!!");
        return;
    }
    _finishAction(vc, animated, completion);
}

@end
