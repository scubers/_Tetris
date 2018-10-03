//
//  TSService.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import <Foundation/Foundation.h>
#import "TSServiceProtocols.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TSService

@interface TSService : NSObject

@property (nonatomic, strong) Class<TSServiceable> serviceClass;

@property (nonatomic, assign) BOOL singleton;

- (id<TSServiceable>)getService;

+ (instancetype)serviceWithClass:(Class<TSServiceable>)aClass;

@end

#pragma mark - TSServiceManager

NS_SWIFT_NAME(TetrisServer)
@interface TSTetrisServer : NSObject

- (void)bindServiceByName:(NSString *)service class:(Class<TSServiceable>)aClass singleton:(BOOL)singleton;
- (nullable id<TSServiceable>)serviceByName:(NSString *)name;


- (void)bindServiceByProtocol:(Protocol *)aProtocol class:(Class<TSServiceable>)aClass singleton:(BOOL)singleton;
- (nullable id<TSServiceable>)serviceByProtoocl:(Protocol *)aProtocol;

@end

NS_ASSUME_NONNULL_END
