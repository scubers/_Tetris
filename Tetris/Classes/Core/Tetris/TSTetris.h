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


#pragma mark - moduler methods


#pragma mark - router methods


@end

NS_ASSUME_NONNULL_END

