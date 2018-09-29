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
            [_Tetris.serviceMgr bindServiceByProtocol:@protocol(_protocol) class:self singleton:_singleton];\
        }

/**
 对本类进行导出到对应接口的服务，并实现默认方法
 @param _protocol 接口
 @param _singleton 是否单例
 */
#define TS_DEFAULT_SERVICE(_protocol, _singleton) \
        TS_SERVICE_PROTOCOL(_protocol, _singleton) \
        + (instancetype)ts_serviceInstance { return [[self alloc] init];}


/**
 根据接口获取服务
 @param _protocol 接口
 */
#define TS_GET_SERVICE(_protocol) \
        ((id<_protocol>)([_Tetris.serviceMgr serviceByProtoocl:@protocol(_protocol)]))

#define TS_MODULE(TSModulePriority) \
        + (void)load {\
            [_Tetris registerModuleByClass:self priority:(TSModulePriority)];\
        }


#endif /* TSTetrisDefine_h */
