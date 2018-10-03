//
//  TSService.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import "TSService.h"
#import "TSTree.h"
#import <objc/runtime.h>
#import "TSError.h"
#import "TSUtils.h"

@interface TSService ()

@property (nonatomic, strong, nullable) id<TSServiceable> singletonService;

@end

@implementation TSService

+ (instancetype)serviceWithClass:(Class<TSServiceable>)aClass {
    TSService *service = [[TSService alloc] init];
    service.serviceClass = aClass;
    return service;
}

- (id<TSServiceable>)getService {
    return _singleton ? self.singletonService : self.generateService;
}

- (id<TSServiceable>)singletonService {
    @synchronized (self) {
        if (!_singletonService) {
            _singletonService = [self generateService];
        }
    }
    return _singletonService;
}

- (id<TSServiceable>)generateService {
    id service = [_serviceClass ts_create];
    return service;
}


@end


#pragma mark - TSServiceManager
@interface TSTetrisServer ()

@property (nonatomic, strong) TSSyncTree *tree;

@end
@implementation TSTetrisServer

- (instancetype)init {
    if (self = [super init]) {
        _tree = [TSSyncTree new];
    }
    return self;
}

- (void)bindServiceByName:(NSString *)serviceName class:(Class<TSServiceable>)aClass singleton:(BOOL)singleton {
    // check if class valid
    TSAssertion([((Class)aClass) conformsToProtocol:@protocol(TSServiceable)]
                , "Class:[%@] should conforms to protocol: [%@]"
                , NSStringFromClass(aClass)
                , NSStringFromProtocol(@protocol(TSServiceable)));
    NSString *path = [NSString stringWithFormat:@"/%@", serviceName];
    TSService *serviceObject = [TSService serviceWithClass:aClass];
    serviceObject.singleton = singleton;
    [_tree buildTreeWithURLString:path value:serviceObject];
}

- (id<TSServiceable>)serviceByName:(NSString *)name {
    id<TSServiceable> service;
    NSString *path = [NSString stringWithFormat:@"/%@", name];
    TSTreeUrlComponent *comp = [self.tree findByURLString:path];
    if (comp.value && [comp.value isKindOfClass:[TSService class]]) {
        service = ((TSService *)comp.value).getService;
    }
    return service;
}

- (void)bindServiceByProtocol:(Protocol *)aProtocol class:(Class<TSServiceable>)aClass singleton:(BOOL)singleton {
    [self bindServiceByName:NSStringFromProtocol(aProtocol) class:aClass singleton:singleton];
}

- (id<TSServiceable>)serviceByProtoocl:(Protocol *)aProtocol {
    return [self serviceByName:NSStringFromProtocol(aProtocol)];
}

@end