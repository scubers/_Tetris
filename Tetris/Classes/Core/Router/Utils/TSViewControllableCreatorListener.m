//
//  TSViewControllableCreatorListener.m
//  Tetris
//
//  Created by Junren Wong on 2018/10/11.
//

#import "TSViewControllableCreatorListener.h"
#import "TSRouterProtocols.h"

@implementation TSViewControllableCreatorListener

- (void)ts_didCreateObject:(id<TSCreatable>)object {
    // autowire service
    if (
        [((id)object) conformsToProtocol:@protocol(TSViewControllable)]
        && [((id)object) conformsToProtocol:@protocol(TSAutowireable)]
        ) {
        [((id<TSAutowireable>)object) ts_autowire];
    }
}

@end
