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
    TSIntent *intent = [TSIntent intentWithUrl:self.urlString intentClass:self.intentClass displayer:self.displayer];
    intent->_extraParameters = self.extraParameters.mutableCopy;
    intent.urlComponent = self.urlComponent;
    intent.viewControllable = self.viewControllable;
    return intent;
}

+ (instancetype)intentWithUrl:(NSString *)urlString intentClass:(Class<TSIntentable>)intentClass displayer:(id<TSIntentDisplayerProtocol>)displayer {
    return [[self alloc] initWithUrl:urlString intentClass:intentClass displayer:displayer];
}

- (instancetype)initWithUrl:(NSString *)urlString intentClass:(Class<TSIntentable>)intentClass displayer:(nullable id<TSIntentDisplayerProtocol>)displayer {
    if (self = [self init]) {
        _urlString = urlString;
        _intentClass = intentClass;
        _displayer = displayer;
        _streams = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _extraParameters = [NSMutableDictionary dictionaryWithCapacity:1];
        _onResult = [TSDrivenStream stream];
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
    if (![obj isKindOfClass:[NSString class]]) {
        return nil;
    }
    return obj;
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

- (void)sendResult:(id)result byCode:(id<NSCopying>)code {
    [_streams[code] post:result];
}

- (TSDrivenStream *)resultByCode:(id<NSCopying>)code {
    TSDrivenStream *driven = _streams[code];
    if (!driven) {
        driven = [TSDrivenStream stream];
        _streams[code] = driven;
    }
    return driven;
}

- (NSNumberFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSNumberFormatter alloc] init];
    }
    return _formatter;
}
@end


