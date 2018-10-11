//
//  TSServiceCreatorListener.m
//  Tetris
//
//  Created by Junren Wong on 2018/10/11.
//

#import "TSServiceCreatorListener.h"
#import "TSServiceProtocols.h"

@implementation TSServiceCreatorListener

- (void)ts_didCreateObject:(id<TSCreatable>)object {
    if (
        [((id)object) conformsToProtocol:@protocol(TSServiceable)]
        && [((id)object) conformsToProtocol:@protocol(TSAutowireable)]
        ) {
        [((id<TSAutowireable>)object) ts_autowire];
    }
}

@end
