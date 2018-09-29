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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    TSModuleContext *context = [TSModuleContext shared];
    context.launchOptions = launchOptions;
    
    [_Tetris.moduler.trigger tetrisModuleInit:context];
    [_Tetris.moduler.trigger tetrisModuleSetup:context];
    [_Tetris.moduler.trigger tetrisModuleSplash:context];
    [_Tetris.moduler.trigger application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [_Tetris.moduler.trigger applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [_Tetris.moduler.trigger applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [_Tetris.moduler.trigger applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [_Tetris.moduler.trigger applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [_Tetris.moduler.trigger applicationWillTerminate:application];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [_Tetris.moduler.trigger application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [_Tetris.moduler.trigger application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [_Tetris.moduler.trigger application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [_Tetris.moduler.trigger application:application handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [_Tetris.moduler.trigger application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (@available(iOS 9.0, *)) {
        [_Tetris.moduler.trigger application:app openURL:url options:options];
    } else {
    }
    return YES;
}


@end
