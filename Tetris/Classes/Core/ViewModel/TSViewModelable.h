//
//  TSViewModelable.h
//  Tetris
//
//  Created by Junren Wong on 2019/2/11.
//

#ifndef TSViewModelable_h
#define TSViewModelable_h

NS_SWIFT_NAME(Destroyable)
@protocol TSDestroyable
- (void)onDestroy:(void (^)(void))onDestroy;
@end

#endif /* TSViewModelable_h */
