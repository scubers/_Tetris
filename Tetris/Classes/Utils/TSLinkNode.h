//
//  TSLinkNode.h
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSLinkNode<T> : NSObject

@property (nonatomic, strong, nullable) TSLinkNode *next;

@property (nonatomic, weak  , nullable) TSLinkNode *previous;

@property (nonatomic, strong, nullable) T value;


- (NSUInteger)index;

- (NSUInteger)count;

- (void)insertBeforeSelf:(TSLinkNode *)node;

- (void)insertAfterSelf:(TSLinkNode *)node;

- (TSLinkNode *)root;
- (BOOL)isRoot;

- (TSLinkNode *)end;
- (BOOL)isEnd;

+ (nullable TSLinkNode *)linkNodeWithArray:(NSArray<T> *)array;

+ (TSLinkNode *)linkNodeWithObject:(T)object;

- (void)enumerateObject:(void (^)(T obj, NSUInteger idx, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
