//
//  TSModule.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



#pragma mark - TSModuleContext

@interface TSModuleContext : NSObject

@property (nonatomic, strong, readonly) id<UIApplicationDelegate> applicationDelegate;
@property (nonatomic, strong, readonly) UIApplication *application;
@property (nonatomic, strong, nullable) NSDictionary *launchOptions;

+ (instancetype)shared;

@end

#pragma mark - TSTetrisModulable

@protocol TSTetrisModulable <UIApplicationDelegate>

@optional

- (void)tetrisModuleInit:(TSModuleContext *)context;
- (void)tetrisModuleSetup:(TSModuleContext *)context;
- (void)tetrisModuleSplash:(TSModuleContext *)context;

- (void)tetrisModuleDidTriggerEvent:(NSInteger)event userInfo:(nullable NSDictionary *)userInfo;

@end


typedef NSInteger TSModulePriority;

static TSModulePriority const TSModulePriorityMin = NSIntegerMin;
static TSModulePriority const TSModulePriorityLow = 1000;
static TSModulePriority const TSModulePriorityNormal = 5000;
static TSModulePriority const TSModulePriorityHigh = 10000;
static TSModulePriority const TSModulePriorityMax = NSIntegerMax;

#pragma mark - TSModule

@interface TSModule : NSObject

@property (nonatomic, assign, readonly) TSModulePriority priority;
@property (nonatomic, strong, readonly) id<TSTetrisModulable> moduleInstance;

+ (TSModule *)moduleWithClass:(Class<TSTetrisModulable>)aClass priority:(TSModulePriority)priority;

@end


#pragma mark - TSTetrisModuler

@interface TSTetrisModuler : NSObject

@property (nonatomic, strong, readonly) id<TSTetrisModulable> trigger;

- (void)registerModuleWithClass:(Class<TSTetrisModulable>)aClass priority:(TSModulePriority)priority;

- (void)registerModule:(TSModule *)module;

- (NSUInteger)count;

- (void)enumerateModules:(void (^)(TSModule *module, NSUInteger index))block;

@end


NS_ASSUME_NONNULL_END
