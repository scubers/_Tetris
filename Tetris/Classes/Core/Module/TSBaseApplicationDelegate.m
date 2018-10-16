//
//  TSBaseApplicationDelegate.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/29.
//

#import "TSBaseApplicationDelegate.h"
#import "TSModule.h"
#import "TSTetrisDefine.h"
#import "TSTetris.h"

@implementation TSBaseApplicationDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TSModuleContext *context = [TSModuleContext shared];
    context.launchOptions = launchOptions;
    
    [_Tetris.modular.trigger tetrisModuleInit:context];
    [_Tetris.modular.trigger tetrisModuleSetup:context];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_Tetris.modular.trigger tetrisModuleSplash:context];
    });
    [_Tetris.modular.trigger application:application willFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [_Tetris.modular.trigger application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [_Tetris.modular.trigger applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [_Tetris.modular.trigger applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [_Tetris.modular.trigger applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [_Tetris.modular.trigger applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [_Tetris.modular.trigger applicationWillTerminate:application];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [_Tetris.modular.trigger application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [_Tetris.modular.trigger application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [_Tetris.modular.trigger application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [_Tetris.modular.trigger application:application handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [_Tetris.modular.trigger application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (@available(iOS 9.0, *)) {
        [_Tetris.modular.trigger application:app openURL:url options:options];
    } else {
    }
    return YES;
}


@end
