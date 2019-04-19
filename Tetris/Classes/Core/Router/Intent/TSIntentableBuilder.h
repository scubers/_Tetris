//
//  TSIntentableFactory.h
//  Pods-Tetris_Tests
//
//  Created by 王俊仁 on 2019/4/20.
//

#import <Foundation/Foundation.h>
#import "TSRouterProtocols.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(IntentableBuilder)
@interface TSIntentableBuilder : NSObject

typedef id<TSIntentable> _Nullable (^TSIntentableFactoryBlock)(void);
@property (nonatomic, strong, readonly, nullable) id builderId;
@property (nonatomic, copy, readonly) TSIntentableFactoryBlock creation;

- (instancetype)initWithId:(nullable id)builderId creation:(TSIntentableFactoryBlock)creation;


@end

NS_ASSUME_NONNULL_END
