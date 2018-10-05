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


NS_SWIFT_NAME(Intent)
@interface TSIntent : NSObject <NSCopying>

@property (nonatomic, strong, nullable) Class<TSIntentable> intentClass;

@property (nonatomic, copy, nullable) NSString *urlString;

@property (nonatomic, strong, nullable) id<TSViewControllable> viewControllable;

@property (nonatomic, strong, nullable) TSTreeUrlComponent *urlComponent;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *extraParameters;

@property (nonatomic, strong, nullable) id<TSIntentDisplayerProtocol> displayer;

@property (nonatomic, strong, readonly) TSDrivenStream *onResult;

- (id)objectForKeyedSubscript:(id)key;

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;


- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithUrl:(nullable NSString *)urlString
                intentClass:(nullable Class<TSIntentable>)intentClass
                  displayer:(nullable id<TSIntentDisplayerProtocol>)displayer;

+ (instancetype)intentWithUrl:(nullable NSString *)urlString
                  intentClass:(nullable Class<TSIntentable>)intentClass
                    displayer:(nullable id<TSIntentDisplayerProtocol>)displayer;


- (nullable NSString *)getString:(NSString *)key;
- (nullable NSNumber *)getNumber:(NSString *)key;

- (TSDrivenStream *)resultByCode:(id<NSCopying>)code NS_SWIFT_NAME(result(by:));
- (void)sendResult:(nullable id)result byCode:(id<NSCopying>)code NS_SWIFT_NAME(send(result:by:));


@end

NS_ASSUME_NONNULL_END
