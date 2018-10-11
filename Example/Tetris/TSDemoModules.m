//
//  TSDemoModules.m
//  Tetris_Example
//
//  Created by Junren Wong on 2018/9/29.
//  Copyright © 2018 wangjunren. All rights reserved.
//

#import "TSDemoModules.h"
@import Tetris;

@protocol TSServiceA <NSObject>
- (void)methodA;
@end

@protocol TSServiceB <NSObject>
- (void)methodB;
@end



@interface TSDemoModules () <TSModularComposable>

@end
@implementation TSDemoModules

+ (instancetype)ts_create {
    return [[self alloc] init];
}

- (void)ts_didCreate {
    
}

- (void)tetrisModuleInit:(TSModuleContext *)context {
    NSLog(@"%@, %s", self, __FUNCTION__);
}
- (void)tetrisModuleSetup:(TSModuleContext *)context {
    NSLog(@"%@, %s", self, __FUNCTION__);
}
- (void)tetrisModuleSplash:(TSModuleContext *)context {
    NSLog(@"%@, %s", self, __FUNCTION__);
}

@end

@interface Module1 : TSDemoModules <TSModularComposable>
@end
@implementation Module1
TS_MODULE(TSModulePriorityHigh)
@end

@interface Module2 : TSDemoModules <TSModularComposable>
@end
@implementation Module2
TS_MODULE(TSModulePriorityNormal)
@end

@interface Module3 : TSDemoModules <TSModularComposable>
@end
@implementation Module3
TS_MODULE(TSModulePriorityLow)
@end

@interface Module4 : TSDemoModules <TSModularComposable>
@end
@implementation Module4
TS_MODULE(TSModulePriorityNormal + 1)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TS_GET_SERVICE(TSServiceA) methodA];
    return YES;
}

@end


@interface TestAction : NSObject <TSRouteActioner>

@end

@implementation TestAction

TS_ACTION(@"/oc/action")

- (nonnull TSStream *)getStreamByComponent:(nonnull TSTreeUrlComponent *)component {
    return [TSStream create:^TSCanceller * _Nullable(id<TSReceivable>  _Nonnull receiver) {
        [receiver post:@200];
        [receiver close];
        return nil;
    }];
}

@end


@interface TSServiceAImpl : NSObject<TSServiceA, TSServiceable>

@property (nonatomic, strong) id<TSServiceB, TSAutowired> serviceB;

@end

@implementation TSServiceAImpl

TS_SERVICE(TSServiceA, YES)

- (void)methodA {
    NSLog(@"method a execute");
    [_serviceB methodB];
}

@end


@interface TSServiceBImpl : NSObject<TSServiceB, TSServiceable>

@end

@implementation TSServiceBImpl

TS_SERVICE(TSServiceB, YES)

- (void)methodB {
    NSLog(@"method b execute");
}

@end


