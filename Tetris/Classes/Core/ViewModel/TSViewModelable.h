//
//  TSViewModelable.h
//  Tetris
//
//  Created by Junren Wong on 2019/2/11.
//

#ifndef TSViewModelable_h
#define TSViewModelable_h

#import "TSCreatable.h"

NS_SWIFT_NAME(ViewModelable)
@protocol TSViewModelable <TSCreatable>
@end

NS_SWIFT_NAME(ViewModelLifeController)
@protocol TSViewModelLifeController

- (NSString *)lifeIdentifier;

/// listeneing the life ending
- (void)onLifeEnding:(void (^)(void))ending;

@end

NS_SWIFT_NAME(Destroyable)
@protocol TSDestroyable
- (void)onDestroy:(void (^)(void))onDestroy;
@end

#endif /* TSViewModelable_h */
