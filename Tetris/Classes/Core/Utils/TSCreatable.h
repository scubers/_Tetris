//
//  TSCreatable.h
//  Tetris
//
//  Created by Junren Wong on 2018/10/2.
//

#ifndef TSCreatable_h
#define TSCreatable_h

NS_SWIFT_NAME(Creatable)
@protocol TSCreatable

+ (instancetype)ts_create;

@optional

- (void)ts_didCreate;

@end


NS_SWIFT_NAME(Autowired)
@protocol TSAutowired
@end


@protocol TSAutowireable

- (void)ts_autowire NS_SWIFT_UNAVAILABLE("Because swift cannot use runtime to inject properties");

@end

#endif /* TSCreatable_h */
