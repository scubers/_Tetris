//
//  TSWeakSingleton.h
//  Tetris
//
//  Created by Jrwong on 2019/9/17.
//

#import <Foundation/Foundation.h>
#import "TSViewModelable.h"

NS_ASSUME_NONNULL_BEGIN

#define TS_CREATE_WEAK_SINGLETON(_type) ((_type *)[[TSWeakSingleton shared] createWithType:[_type class]])

NS_SWIFT_NAME(WeakSingleton)
@interface TSWeakSingleton : NSObject

- (id<TSDestroyable>)createWithType:(Class<TSDestroyable>)aClass;

- (id<TSDestroyable>)createWithType:(Class<TSDestroyable>)aClass lifeCycle:(id<TSDestroyable>)lifeCycle;

+ (TSWeakSingleton *)shared;

@end

NS_ASSUME_NONNULL_END
