//
//  TSIntent.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#import <Foundation/Foundation.h>
#import "TSTree.h"
#import "TSRouterProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSIntent : NSObject

@property (nonatomic, strong, nullable) Class<TSIntentable> intentClass;

@property (nonatomic, copy, nullable) NSString *urlString;

@property (nonatomic, strong, nullable) UIViewController<TSIntentable> *intentable;

@property (nonatomic, strong, nullable) TSTreeUrlComponent *urlComponent;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *extraParameters;


- (id)objectForKeyedSubscript:(id)key;

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;


@end

NS_ASSUME_NONNULL_END
