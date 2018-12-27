//
//  TSResult.h
//  Tetris
//
//  Created by Junren Wong on 2018/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSResult<Data> : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithSource:(id)source value:(Data)value;

@property (nonatomic, strong, readonly) id source;
@property (nonatomic, strong, readonly) Data value;

@end

NS_ASSUME_NONNULL_END
