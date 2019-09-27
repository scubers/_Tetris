//
//  TSParams.m
//  Tetris_Example
//
//  Created by Jrwong on 2019/9/28.
//  Copyright © 2019 wangjunren. All rights reserved.
//

#import "TSParams.h"

@implementation TSParams

- (NSDictionary<NSString *,id> *)ts_toDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"string"] = _string;
    dict[@"number"] = _number;
    dict[@"integer"] = @(_integer);
    return dict;
}

- (instancetype)initFromDict:(NSDictionary<NSString *,id> *)dict {
    TSParams *p = [TSParams new];
    p.string = dict[@"string"];
    p.number = dict[@"number"];
    p.integer = [dict[@"integer"] integerValue];
    return p;
}

+ (instancetype)params:(NSString *)string number:(NSNumber *)number integer:(NSInteger)integer {
    TSParams *p = [TSParams new];
    p.string = string;
    p.number = number;
    p.integer = integer;
    return p;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"params: [string: %@, number: %@, int: %zd]", _string, _number, _integer];
}

@end
