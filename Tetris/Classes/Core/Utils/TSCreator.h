//
//  TSCreator.h
//  Tetris
//
//  Created by Junren Wong on 2018/10/2.
//

#import <Foundation/Foundation.h>
#import "TSCreatable.h"

NS_ASSUME_NONNULL_BEGIN


@interface TSCreator : NSObject

+ (instancetype)shared;

- (nullable id<TSCreatable>)createByClass:(Class<TSCreatable>)aClass;

@end

#pragma mark - NSObject Creatable Support

@interface NSObject (Creatable) <TSCreatable>

@end

NS_ASSUME_NONNULL_END
