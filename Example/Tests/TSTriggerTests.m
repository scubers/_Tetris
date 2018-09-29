//
//  TSTriggerTests.m
//  Tetris_Tests
//
//  Created by Junren Wong on 2018/9/29.
//  Copyright © 2018 wangjunren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@protocol TriggerAPr <NSObject>
- (void)aMethod;
- (void)aMethodGood:(BOOL)aaa veryGood:(NSNumber *)bbb;
@end

@protocol TriggerBPr <TriggerAPr>
- (int)bMethod:(int)b;
@end

@interface TSTriggerTests : XCTestCase

@end

@implementation TSTriggerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTrigger {
    
    __block BOOL execute = NO;
    TSTrigger<id<UIApplicationDelegate>> *trigger =
    [[TSTrigger alloc] initWithProtocol:@protocol(UIApplicationDelegate) block:^(TSTrigger * _Nonnull trigger, NSInvocation * _Nonnull invocation) {
        NSLog(@"Trigger did triggered: %@", NSStringFromSelector(invocation.selector));
        execute = YES;
    }];
    
    [trigger.trigger applicationWillTerminate:(UIApplication *)@1];
    
    XCTAssert(execute);
    
}

- (void)testSubProtocol {
    __block BOOL execute = NO;
    TSTrigger<id<TriggerBPr>> *trigger =
    [[TSTrigger alloc] initWithProtocol:@protocol(TriggerBPr) block:^(TSTrigger * _Nonnull trigger, NSInvocation * _Nonnull invocation) {
        NSLog(@"Trigger did triggered: %@", NSStringFromSelector(invocation.selector));
        execute = YES;
    }];
    
    [trigger.trigger aMethodGood:YES veryGood:@3];
}


@end
