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

@property (nonatomic, strong) Class navigationViewControllerClass;

@end


@interface TSIntent (PresentDismissInit)

+ (instancetype)presentDismissByUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
