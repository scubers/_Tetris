//
//  TSKeyWindowSource.h
//  Tetris
//
//  Created by Junren Wong on 2018/10/10.
//

#import <Foundation/Foundation.h>
#import "TSRouterProtocols.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(KeyWindowSource)
@interface TSKeyWindowSource : NSObject <TSViewControllable>
+ (instancetype)source;
@end

NS_ASSUME_NONNULL_END
