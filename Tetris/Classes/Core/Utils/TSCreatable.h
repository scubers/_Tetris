//
//  TSCreatable.h
//  Tetris
//
//  Created by Junren Wong on 2018/10/2.
//

#ifndef TSCreatable_h
#define TSCreatable_h

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Creatable)
@protocol TSCreatable

- (instancetype)init;
+ (instancetype)alloc NS_SWIFT_UNAVAILABLE("unavaliable");


@optional


- (void)ts_didCreate;

@end


NS_SWIFT_NAME(Autowired)
@protocol TSAutowired
@end


@protocol TSAutowireable

- (void)ts_autowire NS_SWIFT_UNAVAILABLE("Because swift cannot use runtime to inject properties");

@end

NS_ASSUME_NONNULL_END

#endif /* TSCreatable_h */
