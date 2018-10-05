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

#if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
    # define TS_FINAL_CLASS __attribute__((objc_subclassing_restricted))
#else
    # define TS_FINAL_CLASS
#endif


#define TS_DEPRECATED(msg) __attribute__((deprecated(msg)))

@interface TSUtils : NSObject

@end

NS_ASSUME_NONNULL_END
