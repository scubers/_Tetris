//
//  TSParams.h
//  Tetris_Example
//
//  Created by Jrwong on 2019/9/28.
//  Copyright © 2019 wangjunren. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Tetris;

NS_ASSUME_NONNULL_BEGIN

@interface TSParams : NSObject <TSIntentSerializable>

@property (nonatomic, strong, nullable) NSString *string;
@property (nonatomic, strong, nullable) NSNumber *number;
@property (nonatomic, assign) NSInteger integer;

+ (instancetype)params:(NSString *)string number:(NSNumber *)number integer:(NSInteger)integer;

@end

NS_ASSUME_NONNULL_END
