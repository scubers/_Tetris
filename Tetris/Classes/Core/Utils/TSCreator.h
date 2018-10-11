//
//  TSCreator.h
//  Tetris
//
//  Created by Junren Wong on 2018/10/2.
//

#import <Foundation/Foundation.h>
#import "TSCreatable.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(CreatorListener)
@protocol TSCreatorListener
- (void)ts_didCreateObject:(id<TSCreatable>)object;
@end

NS_SWIFT_NAME(Creator)
@interface TSCreator : NSObject

+ (instancetype)shared;

- (nullable id<TSCreatable>)createByClass:(Class<TSCreatable>)aClass;

- (void)addListener:(id<TSCreatorListener>)listener;
- (void)removeListener:(id<TSCreatorListener>)listener;

@end

#pragma mark - NSObject Creatable Support

@interface NSObject (Creatable) <TSCreatable>
@end

#pragma mark - NSObject Autowire

@interface NSObject (Autowire) <TSAutowireable>
@end

NS_ASSUME_NONNULL_END
