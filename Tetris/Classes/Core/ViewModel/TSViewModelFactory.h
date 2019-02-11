//
//  TSViewModelFactory.h
//  Tetris
//
//  Created by Junren Wong on 2019/2/11.
//

#import <Foundation/Foundation.h>
#import "TSViewModelable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A singleton factory
 */
@interface TSViewModelFactory : NSObject

/**
 get instance
 */
@property (nonatomic, class, readonly, strong) TSViewModelFactory *shared;

/**
 create viewmodel with giving life cycle controller
 */
- (nullable id<TSViewModelable>)createViewModel:(Class<TSViewModelable>)aType lifeController:(id<TSViewModelLifeController>)lifeController;

@end

#pragma mark - UIViewController

@interface UIViewController (TSViewModelLifeController) <TSViewModelLifeController>

@end


NS_ASSUME_NONNULL_END
