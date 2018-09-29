//
//  TSUtils.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define TSWeak(obj) __weak typeof(obj) weak_##obj = obj;
#define TSString(obj) typeof(weak_##obj) obj = weak_##obj;

@interface TSUtils : NSObject

@end

NS_ASSUME_NONNULL_END
