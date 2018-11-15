//
//  TSLine.m
//  Tetris
//
//  Created by Junren Wong on 2018/11/15.
//

#import "TSLine.h"

@implementation TSLine

- (instancetype)initWithUrl:(id<TSURLPresentable>)url desc:(NSString *)desc class:(Class<TSIntentable>)aClass {
    if (self = [super init]) {
        _url = url;
        _desc = desc;
        _intentableClass = aClass;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[TSLine] url: %@, desc: %@", _url.ts_url.absoluteString, _desc];
}

@end
