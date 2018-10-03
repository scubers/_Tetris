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
@property (nonatomic, strong, readonly) TSTetrisModuler *moduler;
@property (nonatomic, strong, readonly) TSRouter *router;

+ (instancetype)shared;

- (void)tetrisStart;

#pragma mark - server methods

- (void)registerServiceByProtocol:(Protocol *)aProtocol class:(Class<TSServiceable>)aClass singleton:(BOOL)singleton;

#pragma mark - moduler methods

- (void)registerModuleByClass:(Class<TSTetrisModulable>)aClass priority:(TSModulePriority)priority;

- (void)registerModuleByClass:(Class<TSTetrisModulable>)aClass;

#pragma mark - router methods

- (void)bindUrl:(NSString *)url viewController:(Class<TSIntentable>)aClass;

@end

NS_ASSUME_NONNULL_END

