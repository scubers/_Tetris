//
//  RIIntercepterAdapter.m
//  RouteIntent
//
//  Created by 王俊仁 on 2017/6/23.
//  Copyright © 2017年 jrwong. All rights reserved.
//

#import "TSIntercepterAdapter.h"
#import "TSIntent.h"

@interface TSIntercepterAdapter ()
@property (nonatomic, strong) NSMutableArray<NSPredicate *> *urlPredicates;
@property (nonatomic, strong) NSMutableArray<NSPredicate *> *classNamePredicates;
@end

@implementation TSIntercepterAdapter

- (instancetype)initWithPriority:(TSIntercepterPriority)priority {
    if (self = [super init]) {
        _priority = priority;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _priority = TSIntercepterPriorityNormal;
    }
    return self;
}

- (NSArray<NSString *> *)matchUrlPatterns {
    return nil;
}

- (NSArray<Class> *)matchClasses {
    return nil;
}

- (NSArray<NSString *> *)matchClassNamePatterns {
    return nil;
}

- (void)ts_judgeIntent:(id<TSIntercepterJudger>)adjudgement {
    TSIntent *intent = adjudgement.intent;

    for (NSPredicate *predicate in self.urlPredicates) {
        if ([predicate evaluateWithObject:intent.urlComponent.path]) {
            [self doAdjudgement:adjudgement];
            return;
        }
    }

    for (NSPredicate *predicate in self.classNamePredicates) {
        if ([predicate evaluateWithObject:NSStringFromClass(intent.intentClass)]) {
            [self doAdjudgement:adjudgement];
            return;
        }
    }

    for (Class aClass in [self matchClasses]) {
        if (intent.intentClass == aClass) {
            [self doAdjudgement:adjudgement];
            return;
        }
    }

    [adjudgement doContinue];
}

- (void)doAdjudgement:(id<TSIntercepterJudger>)adjudger {
    [adjudger doContinue];
}


- (NSMutableArray<NSPredicate *> *)classNamePredicates {
    if (!_classNamePredicates) {
        _classNamePredicates = [[NSMutableArray<NSPredicate *> alloc] init];
        [[self matchClassNamePatterns] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_classNamePredicates addObject:[NSPredicate predicateWithFormat:@"SELF MATCHES %@", obj]];
        }];
    }
    return _classNamePredicates;
}

- (NSMutableArray<NSPredicate *> *)urlPredicates {
    if (!_urlPredicates) {
        _urlPredicates = [[NSMutableArray<NSPredicate *> alloc] init];
        [[self matchUrlPatterns] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_urlPredicates addObject:[NSPredicate predicateWithFormat:@"SELF MATCHES %@", obj]];
        }];
    }
    return _urlPredicates;
}

@end
