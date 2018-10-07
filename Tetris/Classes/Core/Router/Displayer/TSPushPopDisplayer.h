//
//  TSPushPopDisplayer.h
//  RouteIntent
//
//  Created by 王俊仁 on 2017/6/22.
//  CopyTSght © 2017年 jrwong. All TSghts reserved.
//

#import <Foundation/Foundation.h>
#import "TSViewDisplayer.h"
#import "TSIntent.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(PushPopDisplayer)
@interface TSPushPopDisplayer : TSViewDisplayer

+ (instancetype)pushDisplayerWithFinish:(TSViewFinishAction)finish;

@end


@interface TSIntent (PushPopInit)

+ (instancetype)pushPopIntentByUrl:(NSString *)url;

@end


NS_ASSUME_NONNULL_END
