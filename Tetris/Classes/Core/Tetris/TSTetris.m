//
//  TSTetris.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import "TSTetris.h"
#import "TSServiceCreatorListener.h"
#import "TSViewControllableCreatorListener.h"

@implementation TSTetris

static TSTetris *__sharedInstance;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[TSTetris alloc] init];
    });
    return __sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _server = [TSTetrisServer new];
        _modular = [TSTetrisModular new];
        _router = [TSRouter new];
    }
    return self;
}

#pragma mark - server methods

- (void)enableServiceAutowired {
    [[TSCreator shared] addListener:[TSServiceCreatorListener new]];
}

#pragma mark - moduler methods

#pragma mark - router methods

- (void)enableViewControllableServiceAutowired {
    [[TSCreator shared] addListener:[TSViewControllableCreatorListener new]];
}

- (void)enableViewControllableInjection {
    _Tetris.router.viewControllableParamInject = YES;
}

@end
