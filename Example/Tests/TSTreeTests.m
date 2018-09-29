//
//  TSTreeTests.m
//  Tetris_Tests
//
//  Created by Junren Wong on 2018/9/28.
//  Copyright © 2018 wangjunren. All rights reserved.
//

#import <XCTest/XCTest.h>
@import Tetris;

@interface TSTreeTests : XCTestCase

@property (nonatomic, strong) TSTree *tree;
@property (nonatomic, strong) TSSyncTree *syncTree;

@end

typedef void(^RITestBlock)(id params);

@implementation TSTreeTests


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _tree = [TSTree new];
    
    [_tree buildTree:[TSNodePath nodePathWithPath:@[@"sportip",] value:@1]];
    [_tree buildTree:[TSNodePath nodePathWithPath:@[@"sportip", @"platform", @"user"] value:@1]];
    [_tree buildTree:[TSNodePath nodePathWithPath:@[@"sportip", @"platform", @"video"] value:@2]];
    [_tree buildTree:[TSNodePath nodePathWithPath:@[@"sportip", @"platform", @"order"] value:@3]];
    [_tree buildTree:[TSNodePath nodePathWithPath:@[@"sportip", @"platform", @"order", @"detail"] value:@4]];
    [_tree buildTree:[TSNodePath nodePathWithPath:@[@"sportip", @"platform", @"biz", @"match"] value:@5]];
    [_tree buildTree:[TSNodePath nodePathWithPath:@[@"sportip", @"platform", @"biz", @"match", @":matchId"] value:(id)(^(NSDictionary *params){
        NSLog(@"block: %@", params);
    })]];
    
    NSLog(@"%@", _tree);
    
    _syncTree = [TSSyncTree new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testFind {
    TSTreeResult *result = [_tree findNodeWithPath:@[@"sportip", @"platform", @"biz", @"match", @"10086"]];
    ((RITestBlock)result.node.getValue)(result.params);
}


- (void)testRemove {
    [_tree removeNodeWithPath:@[@"sportip", @"platform", @"user"]];
    NSLog(@"%@", _tree);
    [_tree removeNodeWithPath:@[@"sportip", @"platform", @"biz", @"match", @":matchId"]];
    NSLog(@"%@", _tree);
}

- (void)testSyncTree {
    
//    NSArray *arr = @[[TSNodePath nodePathWithPath:@[@"1"] value:@1],
//    [TSNodePath nodePathWithPath:@[@"1", @"2"] value:@1],
//    [TSNodePath nodePathWithPath:@[@"1", @"2", @"3"] value:@1],
//    [TSNodePath nodePathWithPath:@[@"1", @"2", @"3", @"4"] value:@1]];
    NSArray *urls = @[
                      @"/1",
                      @"/1/2",
                      @"/1/2/3",
                      @"/1/2/3/4",
                      @"/1/2/3/4/5",
                      @"/1/2/3/4/5/6",
                      @"/1/2/3/4/5/6/7",
                      ];
    
    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_syncTree buildTreeWithURLString:obj value:@(idx)];
    }];
    
    id obj1 = [_syncTree findByURLString:@"/1"];
    id obj2 = [_syncTree findByURLString:@"/1/2"];
    id obj3 = [_syncTree findByURLString:@"/1/2/3"];
    id obj4 = [_syncTree findByURLString:@"/1/2/3/4"];
    NSLog(@"%@", _syncTree);
    NSLog(@"obj1: %@", obj1);
    NSLog(@"obj2: %@", obj2);
    NSLog(@"obj3: %@", obj3);
    NSLog(@"obj4: %@", obj4);
    XCTAssert(
              obj1 != nil
              && obj2 != nil
              && obj3 != nil
              && obj4 != nil
              );
}

@end
