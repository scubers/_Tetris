//
//  TSIntentableFactory.m
//  Pods-Tetris_Tests
//
//  Created by 王俊仁 on 2019/4/20.
//

#import "TSIntentableBuilder.h"

@implementation TSIntentableBuilder

- (instancetype)initWithId:(id)builderId creation:(TSIntentableFactoryBlock)creation {
    if (self = [super init]) {
        _builderId = builderId;
        _creation = creation;
    }
    return self;
}

@end
