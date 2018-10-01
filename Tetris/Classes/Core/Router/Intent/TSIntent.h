//
//  TSIntent.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/30.
//

#import <Foundation/Foundation.h>
#import "TSTree.h"
#import "TSRouterProtocols.h"
#import "TSIntentDisplayerProtocol.h"
#import "TSStream.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSIntent<T> : NSObject

@property (nonatomic, strong, nullable) Class<TSIntentable> intentClass;

@property (nonatomic, copy, nullable) NSString *urlString;

@property (nonatomic, strong, nullable) UIViewController<TSIntentable> *intentable;

@property (nonatomic, strong, nullable) TSTreeUrlComponent *urlComponent;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *extraParameters;

@property (nonatomic, strong) id<TSIntentDisplayerProtocol> displayer;

@property (nonatomic, strong, readonly) TSDrivenStream<T> *onResult;

- (id)objectForKeyedSubscript:(id)key;

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;


- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithUrl:(nullable NSString *)urlString
                intentClass:(nullable Class<TSIntentable>)intentClass
                  displayer:(nullable id<TSIntentDisplayerProtocol>)displayer;

+ (instancetype)intentWithUrl:(nullable NSString *)urlString
                  intentClass:(nullable Class<TSIntentable>)intentClass
                    displayer:(nullable id<TSIntentDisplayerProtocol>)displayer;


@end

NS_ASSUME_NONNULL_END
