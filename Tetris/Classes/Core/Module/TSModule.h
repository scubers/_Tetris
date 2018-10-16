//
//  TSModule.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import <Foundation/Foundation.h>
#import "TSCreatable.h"

NS_ASSUME_NONNULL_BEGIN



#pragma mark - TSModuleContext

NS_SWIFT_NAME(ModuleContext)
@interface TSModuleContext : NSObject

@property (nonatomic, strong, readonly) id<UIApplicationDelegate> applicationDelegate;
@property (nonatomic, strong, readonly) UIApplication *application;
@property (nonatomic, strong, nullable) NSDictionary *launchOptions;

+ (instancetype)shared;

@end

#pragma mark - TSModularComposable

typedef NSInteger TSModulePriority NS_SWIFT_NAME(ModulePriority);

static TSModulePriority const TSModulePriorityMin = NSIntegerMin;
static TSModulePriority const TSModulePriorityLow = 1000;
static TSModulePriority const TSModulePriorityNormal = 5000;
static TSModulePriority const TSModulePriorityHigh = 10000;
static TSModulePriority const TSModulePriorityMax = NSIntegerMax;


NS_SWIFT_NAME(ModularComposable)
@protocol TSModularComposable <UIApplicationDelegate, TSCreatable>

@property (nonatomic, assign) TSModulePriority priority;

@optional

- (void)tetrisModuleInit:(TSModuleContext *)context;
- (void)tetrisModuleSetup:(TSModuleContext *)context;
- (void)tetrisModuleSplash:(TSModuleContext *)context;

- (void)tetrisModuleDidTriggerEvent:(NSInteger)event userInfo:(nullable NSDictionary *)userInfo NS_SWIFT_NAME(tetrisModuleDidTrigger(event:userInfo:));

@end


#pragma mark - TSTetrisModuler

NS_SWIFT_NAME(TetrisModular)
@interface TSTetrisModular : NSObject

@property (nonatomic, strong, readonly) id<TSModularComposable> trigger;

- (void)registerModuleWithClass:(Class<TSModularComposable>)aClass priority:(TSModulePriority)priority;
- (void)registerModuleWithClass:(Class<TSModularComposable>)aClass;

- (NSUInteger)count;

- (void)enumerateModules:(void (^)(id<TSModularComposable> module, NSUInteger index))block;

@end


NS_ASSUME_NONNULL_END
