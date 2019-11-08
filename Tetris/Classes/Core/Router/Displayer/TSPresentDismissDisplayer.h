//
//  TSPresentDismissDisplayer.h
//  RouteIntent
//
//  Created by 王俊仁 on 2017/6/22.
//  CopyTSght © 2017年 jrwong. All TSghts reserved.
//

#import <Foundation/Foundation.h>
#import "TSDisplayerAdapter.h"
#import "TSIntent.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(PresentDismissDisplayer)
@interface TSPresentDismissDisplayer : TSDisplayerAdapter

@property (nonatomic, strong, nullable) Class navigationViewControllerClass;
@property (nonatomic, assign) UIModalPresentationStyle presentStyle;
@property (nonatomic, assign) UIModalTransitionStyle transitionStyle;

- (instancetype)initWithNav:(nullable Class)navClass;
- (instancetype)initWithNav:(nullable Class)navClass presentStyle:(UIModalPresentationStyle)present;
- (instancetype)initWithNav:(nullable Class)navClass presentStyle:(UIModalPresentationStyle)present transitionStyle:(UIModalTransitionStyle)transitionStyle NS_DESIGNATED_INITIALIZER;

@end


@interface TSIntent (PresentDismissInit)

+ (instancetype)presentDismissByUrl:(NSString *)url;
+ (instancetype)presentDismissByClass:(Class<TSIntentable>)aClass;

@end

NS_ASSUME_NONNULL_END
