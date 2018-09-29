//
//  TSServiceTests.m
//  Tetris_Tests
//
//  Created by Junren Wong on 2018/9/28.
//  Copyright © 2018 wangjunren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Tetris/Tetris-umbrella.h>

@protocol TestAProtocol <NSObject>
- (void)aMethod;
@end

@protocol TestBProtocol <NSObject>
- (void)bMethod;
@end

@interface TestServiceClassA : NSObject <TestAProtocol, TSServiceExportable>
@end
@implementation TestServiceClassA

TS_DEFAULT_SERVICE(TestAProtocol, YES)

- (void)aMethod {
    NSLog(@"%@ a method", self);
}

@end



@interface TSServiceTests : XCTestCase

@property (nonatomic, strong) TSTetrisServer *serviceManager;

@end

@implementation TSServiceTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _serviceManager = [TSTetrisServer new];
    
    [_serviceManager bindServiceByName:@"aservice" class:[TestServiceClassA class] singleton:YES];
    [_serviceManager bindServiceByName:@"aaservice" class:[TestServiceClassA class] singleton:YES];
    
    [_serviceManager bindServiceByProtocol:@protocol(TestAProtocol) class:[TestServiceClassA class] singleton:NO];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _serviceManager = nil;
}

- (void)testGet {
    id ser1 = [_serviceManager serviceByName:@"aservice"];
    XCTAssert(ser1 != nil);
}

- (void)testGetNone {
    id ser1 = [_serviceManager serviceByName:@""];
    XCTAssert(!ser1);
}

- (void)testGetSingleton {
    id ser1 = [_serviceManager serviceByName:@"aservice"];
    id ser2 = [_serviceManager serviceByName:@"aservice"];
    XCTAssert([ser1 isEqual:ser2]);
}

- (void)testGetDiffSingleton {
    id ser1 = [_serviceManager serviceByName:@"aservice"];
    id ser2 = [_serviceManager serviceByName:@"aaservice"];
    XCTAssert(![ser1 isEqual:ser2]);
}

- (void)testGetByProtocol {
    id<TestAProtocol> ser1 = TS_GET_SERVICE(TestAProtocol);
    XCTAssert(ser1 != nil);
}

@end
