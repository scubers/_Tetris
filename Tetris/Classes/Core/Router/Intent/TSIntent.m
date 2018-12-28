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
                                       factory:self.factory];
    intent->_extraParameters = self.extraParameters.mutableCopy;
    intent.urlComponent = self.urlComponent;
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

- (void)sendResult:(id)result source:(id)source for:(NSString *)key {
    [_streams[key] post:[[TSResult alloc] initWithSource:source value:result]];
}

- (TSStream<TSResult *> *)resultWithKey:(NSString *)key {
    TSDrivenStream *driven = _streams[key];
    if (!driven) {
        driven = [TSDrivenStream stream];
        _streams[key] = driven;
    }
    return driven;
}



- (void)dealloc {
    [self sendResult:self source:self for:@"__onDestroy__"];
}


@end

#pragma mark - Creations

@implementation TSIntent (Creations)

+ (instancetype)intentWithUrl:(NSString *)urlString intentClass:(Class<TSIntentable>)intentClass displayer:(id<TSIntentDisplayerProtocol>)displayer factory:(nullable TSIntentableFactoryBlock)factory {
    return [[self alloc] initWithUrl:urlString intentClass:intentClass displayer:displayer factory:factory];
}

- (instancetype)initWithUrl:(NSString *)urlString intentClass:(Class<TSIntentable>)intentClass displayer:(nullable id<TSIntentDisplayerProtocol>)displayer factory:(nullable TSIntentableFactoryBlock)factory {
    if (self = [self init]) {
        _urlString = urlString;
        _intentClass = intentClass;
        _displayer = displayer;
        _factory = [factory copy];
        _streams = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)urlString {
    return [self initWithUrl:urlString intentClass:nil displayer:nil factory:nil];
}

- (instancetype)initWithClass:(Class<TSIntentable>)aClass {
    return [self initWithUrl:nil intentClass:aClass displayer:nil factory:nil];
}

- (instancetype)initWithDisplayer:(id<TSIntentDisplayerProtocol>)displayer {
    return [self initWithUrl:nil intentClass:nil displayer:displayer factory:nil];
}

- (instancetype)initWithFactory:(TSIntentableFactoryBlock)factory {
    return [self initWithUrl:nil intentClass:nil displayer:nil factory:factory];
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

+ (instancetype)intentWithFactory:(TSIntentableFactoryBlock)factory {
    return [[self alloc] initWithFactory:factory];
}

@end


#pragma mark - TSResult

@implementation TSIntent (TSResult)

- (NSString *)keyWithSelector:(SEL)selector {
    return [NSString stringWithFormat:@"__%@__", NSStringFromSelector(selector)];
}

- (TSStream<TSResult *> *)onDestroy {
    return [self resultWithKey:@"__onDestroy__"];
}

- (void)sendNumber:(NSNumber *)number source:(id)sender {
    [self sendResult:number source:sender for:[self keyWithSelector:@selector(onNumber)]];
}
- (TSStream<TSResult<NSNumber *> *> *)onNumber {
    return [self resultWithKey:[self keyWithSelector:@selector(onNumber)]];
}

- (void)sendString:(NSString *)string source:(id)sender {
    [self sendResult:string source:sender for:[self keyWithSelector:@selector(onString)]];
}
- (TSStream<TSResult<NSString *> *> *)onString {
    return [self resultWithKey:[self keyWithSelector:@selector(onString)]];
}

- (void)sendDict:(NSDictionary *)dict source:(id)sender {
    [self sendResult:dict source:sender for:[self keyWithSelector:@selector(onDict)]];
}
- (TSStream<TSResult<NSDictionary *> *> *)onDict {
    return [self resultWithKey:[self keyWithSelector:@selector(onDict)]];
}

- (void)sendSuccessWithSource:(id)sender {
    [self sendResult:self source:sender for:[self keyWithSelector:@selector(onSuccess)]];
}
- (TSStream<TSResult *> *)onSuccess {
    return [self resultByKey:[self keyWithSelector:@selector(onSuccess)]];
}

- (void)sendCancelWithSource:(id)sender {
    [self sendResult:self source:sender for:[self keyWithSelector:@selector(onCancel)]];
}
- (TSStream<TSResult *> *)onCancel {
    return [self resultByKey:[self keyWithSelector:@selector(onCancel)]];
}

@end
