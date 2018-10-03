//
//  TSStreamTests.m
//  Tetris_Tests
//
//  Created by Junren Wong on 2018/9/30.
//  Copyright © 2018 wangjunren. All rights reserved.
//

#import <XCTest/XCTest.h>
@import ReactiveObjC;

@interface TSStreamTests : XCTestCase

@property (nonatomic, strong) TSDrivenStream *driven;
@property (nonatomic, strong) NSMutableArray *flags;

@end

@implementation TSStreamTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _driven = [TSDrivenStream stream];
    _flags = [NSMutableArray array];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSubscribe {
    [[TSStream just:@1]
     subscribe:^(id  _Nullable obj) {
         XCTAssert([obj isEqual:@1]);
     } error:^(NSError * _Nullable error) {
         
     } complete:^{
         
     }];
}

- (void)testMap {
    [[[TSStream just:@1]
      forceMap:@"1"]
     subscribe:^(id  _Nullable obj) {
         XCTAssert([obj isEqualToString:@"1"]);
     }];
}

- (void)testError {
    
    [[[[TSStream just:@1]
       transform:^TSStream * _Nonnull(id  _Nullable object) {
           return [TSStream error:[NSError errorWithDomain:@"100" code:100 userInfo:nil]];
       }]
      onError:^(NSError * _Nonnull error) {
          [self addFlag];
      }]
     subscribe:^(id  _Nullable obj) {
         
     }]
    ;
    XCTAssert(_flags.count == 1);
}

- (void)testCatch {
    [[[[[TSStream error:[NSError errorWithDomain:@"" code:1 userInfo:nil]]
        onNext:^(id  _Nullable obj) {
            XCTAssert(NO);
        }]
       catch:^TSStream * _Nonnull(NSError * _Nonnull error) {
           [self addFlag];
           return [TSStream just:@100];
       }]
      onNext:^(id  _Nullable obj) {
          [self addFlag];
      }]
     subscribe:^(id  _Nullable obj) {
         [self addFlag];
     }]
    ;
    XCTAssert(_flags.count == 3);
}

- (void)testMultiple1 {
    TSStream *s = [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        [receiver post:@1];
        [receiver post:@2];
        [receiver close];
        return nil;
    }];
    
    [[[[s
       nonsenese:^id _Nullable(id  _Nullable obj) {
           return obj;
       }]
       onNext:^(id  _Nullable obj) {
           [self addFlag];
       }]
      last:^{
          [self addFlag];
      }]
     subscribe:^(id  _Nullable obj) {
     }];
    XCTAssert(self.flags.count == 3);
}

- (void)testMultiple {
    TSStream *s = [TSStream create:^TSCanceller * _Nonnull(id<TSReceivable>  _Nonnull receiver) {
        [receiver post:@1];
        [receiver post:@2];
        [receiver close];
        return nil;
    }];
    
    [[[[[[s
         forceMap:@10]
         onNext:^(id  _Nullable obj) {
             [self addFlag];
         }]
        onError:^(NSError * _Nonnull error) {
            XCTAssert(NO);
        }]
       catch:^TSStream * _Nonnull(NSError * _Nonnull error) {
           XCTAssert(NO);
           return [TSStream just:@4];
       }]
      onCompleted:^{
          [self addFlag];
      }]
     subscribe:^(id  _Nullable obj) {
         [self addFlag];
     } error:^(NSError * _Nullable error) {
         
     } complete:^{
         
     }]
    ;
    XCTAssert(_flags.count == 5);
}

- (void)testFirstLast {
    [[[[[[TSStream just:@1]
         onNext:^(id  _Nullable obj) {
             [self addFlag];
         }]
        first:^{
            XCTAssert(self.flags.count == 0);
        }]
       last:^{
           XCTAssert(self.flags.count == 3);
       }]
      onNext:^(id  _Nullable obj) {
          [self addFlag];
      }]
     subscribe:^(id  _Nullable obj) {
         [self addFlag];
     }];
}

- (void)testDelay {
    
    XCTestExpectation *exp = [self expectationWithDescription:@"delay expectation"];
    
    [[[TSStream just:@1]
      delay:3]
     subscribe:^(id  _Nullable obj) {
         [exp fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:6 handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

- (void)testAsync {
    XCTestExpectation *exp = [self expectationWithDescription:@"test Async"];
    [[[[[[[[TSStream just:@1]
           async]
          onNext:^(id  _Nullable obj) {
              XCTAssert(![[NSOperationQueue mainQueue] isEqual:[NSOperationQueue currentQueue]]);
          }]
         mainQueue]
        onNext:^(id  _Nullable obj) {
            XCTAssert([[NSOperationQueue mainQueue] isEqual:[NSOperationQueue currentQueue]]);
        }]
       dispatch:[NSOperationQueue new]]
      onNext:^(id  _Nullable obj) {
          XCTAssert(![[NSOperationQueue mainQueue] isEqual:[NSOperationQueue currentQueue]]);
      }]
     subscribe:^(id  _Nullable obj) {
         [exp fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {

    }];
}

- (void)testDriven {
    [[_driven
      onNext:^(id  _Nullable obj) {
          [self addFlag];
      }]
     subscribe:^(id  _Nullable obj) {
        [self addFlag];
    }];
    [_driven subscribe:^(id  _Nullable obj) {
        [self addFlag];
    }];
    [_driven subscribe:^(id  _Nullable obj) {
        [self addFlag];
    }];
    [_driven post:@1];
    XCTAssert(self.flags.count == 4);
}

- (void)testRAC {
    RACSignal *s = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[[[s
       map:^id _Nullable(id  _Nullable value) {
           return value;
       }]
       doNext:^(id  _Nullable x) {
           
       }]
      doCompleted:^{
          
      }]
     subscribeNext:^(id  _Nullable x) {
         
     }];
}

- (void)addFlag {
    [_flags addObject:@""];
}

@end
