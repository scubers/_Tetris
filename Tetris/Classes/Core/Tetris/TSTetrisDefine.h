//
//  TSTetrisDefine.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#ifndef TSTetrisDefine_h
#define TSTetrisDefine_h

#pragma mark - Global namespace

#define _Tetris ([TSTetris shared])


#pragma mark - Service

/**
 对本类进行导出到对应接口的服务
 @param _protocol 接口
 @param _singleton 是否单例
 */
#define TS_SERVICE_PROTOCOL(_protocol, _singleton) \
        + (void)load {\
            [_Tetris.server bindServiceByProtocol:@protocol(_protocol) class:self singleton:_singleton];\
        }

/**
 对本类进行导出到对应接口的服务，并实现默认方法
 @param _protocol 接口
 @param _singleton 是否单例
 */
#define TS_DEFAULT_SERVICE(_protocol, _singleton) \
        TS_SERVICE_PROTOCOL(_protocol, _singleton) \
        + (instancetype)ts_create { return [[self alloc] init];}


/**
 根据接口获取服务
 @param _protocol 接口
 */
#define TS_GET_SERVICE(_protocol) \
        ((id<_protocol>)([_Tetris.server serviceByProtoocl:@protocol(_protocol)]))


#pragma mark - module

#define TS_MODULE(TSModulePriority) \
        + (void)load {\
            [_Tetris registerModuleByClass:self priority:(TSModulePriority)];\
        }

#pragma mark - router


#define TS_EXPORT_ROUTE(className, url, anyDifferentSuffix) \
        @implementation className (IntentExport_##className##_##anyDifferentSuffix)\
        + (void)load { [_Tetris.router bindUrl:@url viewController:self];} \
        @end

#define TS_VC_ROUTE(_url) \
        + (void)load { [_Tetris.router bindUrl:@_url viewController:self];}

#define TS_INTERCEPTER(TSIntercepterPriority) \
        + (void)load { \
            id<TSIntercepterProtocol> inter = [self ts_create];\
            inter.priority = TSIntercepterPriority;\
            [_Tetris.router.intercepterMgr addIntercepter:inter];\
        }

#endif /* TSTetrisDefine_h */