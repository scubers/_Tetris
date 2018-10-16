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

@property (nonatomic, copy  , nullable) NSString *urlString;

@property (nonatomic, assign) BOOL skip; // skip the intercepters or not

@property (nonatomic, strong, nullable) id<TSViewControllable> viewControllable;

@property (nonatomic, strong, nullable) TSTreeUrlComponent *urlComponent;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id> *extraParameters;

@property (nonatomic, strong, nullable) id<TSIntentDisplayerProtocol> displayer;

@property (nonatomic, strong, readonly) TSDrivenStream *onResult;
@property (nonatomic, strong, readonly) TSDrivenStream *onDestroy;


/**
 designated initializer
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// subscript
- (id)objectForKeyedSubscript:(id)key;
/// subscript
- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;



/**
 get string parameter
 */
- (nullable NSString *)getString:(NSString *)key;

/**
 get number parameter
 */
- (nullable NSNumber *)getNumber:(NSString *)key;


- (TSDrivenStream *)resultByKey:(id<NSCopying>)key NS_SWIFT_NAME(result(by:));
- (void)sendResult:(nullable id)result byKey:(id<NSCopying>)key NS_SWIFT_NAME(send(result:by:));

- (void)addParam:(id)object forKey:(NSString *)key;
- (void)addParameters:(nullable NSDictionary *)parameters;


@end

#pragma mark - Creations

@interface TSIntent (Creations)

- (instancetype)initWithUrl:(NSString *)urlString;
- (instancetype)initWithClass:(Class<TSIntentable>)aClass;
- (instancetype)initWithDisplayer:(id<TSIntentDisplayerProtocol>)displayer;
- (instancetype)initWithTarget:(id<TSViewControllable>)target;

- (instancetype)initWithUrl:(nullable NSString *)urlString
                intentClass:(nullable Class<TSIntentable>)intentClass
                  displayer:(nullable id<TSIntentDisplayerProtocol>)displayer
           viewControllable:(nullable id<TSViewControllable>)viewControllable;


+ (instancetype)intentWithUrl:(nullable NSString *)urlString
                  intentClass:(nullable Class<TSIntentable>)intentClass
                    displayer:(nullable id<TSIntentDisplayerProtocol>)displayer
             viewControllable:(nullable id<TSViewControllable>)viewControllable;

+ (instancetype)intentWithUrl:(NSString *)urlString;
+ (instancetype)intentWithClass:(Class<TSIntentable>)aClass;
+ (instancetype)intentWithDisplayer:(id<TSIntentDisplayerProtocol>)displayer;
+ (instancetype)intentWithTarget:(id<TSViewControllable>)target;

@end

NS_ASSUME_NONNULL_END
