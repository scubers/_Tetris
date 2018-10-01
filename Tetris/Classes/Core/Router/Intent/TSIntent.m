//
//  TSIntent.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#import "TSIntent.h"

@implementation TSIntent

+ (instancetype)intentWithUrl:(NSString *)urlString intentClass:(Class<TSIntentable>)intentClass displayer:(id<TSIntentDisplayerProtocol>)displayer {
    return [[self alloc] initWithUrl:urlString intentClass:intentClass displayer:displayer];
}

- (instancetype)initWithUrl:(NSString *)urlString intentClass:(Class<TSIntentable>)intentClass displayer:(nullable id<TSIntentDisplayerProtocol>)displayer {
    if (self = [self init]) {
        _urlString = urlString;
        _intentClass = intentClass;
        _displayer = displayer;
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

@end
