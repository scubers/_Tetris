//
//  TSIntent.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#import "TSIntent.h"

@interface TSIntent ()

@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) NSMutableDictionary<id<NSCopying>, TSDrivenStream *> *streams;

@end

@implementation TSIntent

- (id)copyWithZone:(NSZone *)zone {
    TSIntent *intent = [TSIntent intentWithUrl:self.urlString
                                   intentClass:self.intentClass
                                     displayer:self.displayer
                              viewControllable:self.viewControllable];
    intent->_extraParameters = self.extraParameters.mutableCopy;
    intent.urlComponent = self.urlComponent;
    intent.viewControllable = self.viewControllable;
    return intent;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _extraParameters = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return self;
}

- (id)objectForKeyedSubscript:(id)key {
    if (!key) {
        return nil;
    }
    return _extraParameters[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        _extraParameters[key] = obj;
    }
}

- (NSString *)getString:(NSString *)key {
    id obj = _extraParameters[key];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj description];
    }
    return nil;
}

- (NSNumber *)getNumber:(NSString *)key {
    id obj = _extraParameters[key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        return [self.formatter numberFromString:obj];
    }
    return nil;
}

- (void)sendResult:(id)result byKey:(id<NSCopying>)key {
    [_streams[key] post:result];
}

- (TSDrivenStream *)resultByKey:(id<NSCopying>)key {
    TSDrivenStream *driven = _streams[key];
    if (!driven) {
        driven = [TSDrivenStream stream];
        _streams[key] = driven;
    }
    return driven;
}

- (TSDrivenStream *)onResult {
    return [self resultByKey:[NSString stringWithFormat:@"OnResultStream.%@", self]];
}

- (TSDrivenStream *)onDestroy {
    return [self resultByKey:[NSString stringWithFormat:@"OnDestroyStream.%@", self]];
}

- (TSDrivenStream<NSNumber *> *)onNumberStream {
    return [self resultByKey:[NSString stringWithFormat:@"OnNumberStream.%@", self]];
}

- (TSDrivenStream<NSString *> *)onStringStream {
    return [self resultByKey:[NSString stringWithFormat:@"OnStringStream.%@", self]];
}

- (TSDrivenStream<NSDictionary *> *)onDictStream {
    return [self resultByKey:[NSString stringWithFormat:@"OnDictStream.%@", self]];
}

- (void)addParam:(id)object forKey:(NSString *)key {
    if (!object || !key) {
        return;
    }
    _extraParameters[key] = object;
}

- (void)addParameters:(NSDictionary *)parameters {
    [_extraParameters addEntriesFromDictionary:parameters];
}

- (NSNumberFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSNumberFormatter alloc] init];
    }
    return _formatter;
}

- (void)dealloc {
    [self.onDestroy post:self];
}

@end

#pragma mark - Creations

@implementation TSIntent (Creations)

+ (instancetype)intentWithUrl:(NSString *)urlString intentClass:(Class<TSIntentable>)intentClass displayer:(id<TSIntentDisplayerProtocol>)displayer viewControllable:(nullable id<TSViewControllable>)viewControllable {
    return [[self alloc] initWithUrl:urlString intentClass:intentClass displayer:displayer viewControllable:viewControllable];
}

- (instancetype)initWithUrl:(NSString *)urlString intentClass:(Class<TSIntentable>)intentClass displayer:(nullable id<TSIntentDisplayerProtocol>)displayer viewControllable:(nullable id<TSViewControllable>)viewControllable {
    if (self = [self init]) {
        _urlString = urlString;
        _intentClass = intentClass;
        _displayer = displayer;
        _viewControllable = viewControllable;
        _streams = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)urlString {
    return [self initWithUrl:urlString intentClass:nil displayer:nil viewControllable:nil];
}

- (instancetype)initWithClass:(Class<TSIntentable>)aClass {
    return [self initWithUrl:nil intentClass:aClass displayer:nil viewControllable:nil];
}

- (instancetype)initWithDisplayer:(id<TSIntentDisplayerProtocol>)displayer {
    return [self initWithUrl:nil intentClass:nil displayer:displayer viewControllable:nil];
}

- (instancetype)initWithTarget:(id<TSViewControllable>)target {
    return [self initWithUrl:nil intentClass:nil displayer:nil viewControllable:target];
}

+ (instancetype)intentWithUrl:(NSString *)urlString {
    return [[self alloc] initWithUrl:urlString];
}

+ (instancetype)intentWithClass:(Class<TSIntentable>)aClass {
    return [[self alloc] initWithClass:aClass];
}

+ (instancetype)intentWithDisplayer:(id<TSIntentDisplayerProtocol>)displayer {
    return [[self alloc] initWithDisplayer:displayer];
}

+ (instancetype)intentWithTarget:(id<TSViewControllable>)target {
    return [[self alloc] initWithTarget:target];
}

@end

