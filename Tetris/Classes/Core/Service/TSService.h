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

@property (nonatomic, strong) Class<TSServiceExportable> serviceClass;

@property (nonatomic, assign) BOOL singleton;

- (id<TSServiceExportable>)getService;

+ (instancetype)serviceWithClass:(Class<TSServiceExportable>)aClass;

@end

#pragma mark - TSServiceManager

@interface TSTetrisServer : NSObject

- (void)bindServiceByName:(NSString *)service class:(Class<TSServiceExportable>)aClass singleton:(BOOL)singleton;
- (nullable id<TSServiceExportable>)serviceByName:(NSString *)name;


- (void)bindServiceByProtocol:(Protocol *)aProtocol class:(Class<TSServiceExportable>)aClass singleton:(BOOL)singleton;
- (nullable id<TSServiceExportable>)serviceByProtoocl:(Protocol *)aProtocol;

@end

NS_ASSUME_NONNULL_END
