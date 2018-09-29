//
//  TSModuleTests.m
//  Tetris_Tests
//
//  Created by Junren Wong on 2018/9/29.
//  Copyright © 2018 wangjunren. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TSModuleTests : XCTestCase <TSTetrisModulable>

@property (nonatomic, strong) TSTetrisModuler *moduler;

@end

@implementation TSModuleTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _moduler = [TSTetrisModuler new];
    
    [_moduler registerModuleWithClass:[TSModuleTests class] priority:2];
    [_moduler registerModuleWithClass:[TSModuleTests class] priority:3];
    [_moduler registerModuleWithClass:[TSModuleTests class] priority:5];
    [_moduler registerModuleWithClass:[TSModuleTests class] priority:100];
    [_moduler registerModuleWithClass:[TSModuleTests class] priority:135];
    [_moduler registerModuleWithClass:[TSModuleTests class] priority:35];
    [_moduler registerModuleWithClass:[TSModuleTests class] priority:3];
    [_moduler registerModuleWithClass:[TSModuleTests class] priority:44];
    [_moduler registerModuleWithClass:[TSModuleTests class] priority:1];
}

- (void)tearDown {
    _moduler = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testModulePriority {
    __block TSModulePriority last = TSModulePriorityMax;
    [_moduler enumerateModules:^(TSModule * _Nonnull module, NSUInteger index) {
        NSLog(@"Priority test: current: %zd, last: %zd", module.priority, last);
        XCTAssert(module.priority <= last);
        last = module.priority;
    }];
}

@end
