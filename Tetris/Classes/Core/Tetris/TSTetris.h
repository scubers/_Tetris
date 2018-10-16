//
//  TSTetris.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import <Foundation/Foundation.h>
#import "TSTetrisDefine.h"
#import "TSService.h"
#import "TSModule.h"
#import "TSRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSTetris : NSObject

@property (nonatomic, strong, readonly) TSTetrisServer *server;
@property (nonatomic, strong, readonly) TSTetrisModular *modular;
@property (nonatomic, strong, readonly) TSRouter *router;

+ (instancetype)shared;

#pragma mark - server methods

- (void)enableServiceAutowired;

#pragma mark - moduler methods


#pragma mark - router methods

- (void)enableViewControllableServiceAutowired;

- (void)enableViewControllableInjection;

@end

NS_ASSUME_NONNULL_END

