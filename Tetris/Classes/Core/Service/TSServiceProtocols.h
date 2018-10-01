//
//  TSServiceProtocols.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#ifndef TSServiceProtocols_h
#define TSServiceProtocols_h

NS_SWIFT_NAME(ServiceExportable)
@protocol TSServiceExportable

+ (instancetype)ts_serviceInstance;

@end

#endif /* TSServiceProtocols_h */
