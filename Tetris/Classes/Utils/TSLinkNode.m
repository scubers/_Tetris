//
//  TSLinkNode.m
//  Tetris
//
//  Created by Junren Wong on 2018/9/28.
//

#import "TSLinkNode.h"

@implementation TSLinkNode

+ (instancetype)linkNodeWithObject:(id)object {
    TSLinkNode *node = [TSLinkNode new];
    node.value = object;
    return node;
}

+ (instancetype)linkNodeWithArray:(NSArray *)array {
    if (array.count == 0) {
        return nil;
    } else if (array.count == 1) {
        return [TSLinkNode linkNodeWithObject:array.firstObject];
    } else {
        TSLinkNode *root = [TSLinkNode linkNodeWithObject:array.firstObject];
        __block TSLinkNode *current = root;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0) {
                current.next = [TSLinkNode linkNodeWithObject:obj];
                current = current.next;
            }
        }];
        return root;
    }
}

- (NSUInteger)index {
    NSUInteger index = 0;
    TSLinkNode *node = self;
    while (node.previous != nil) {
        node = node.previous;
        index++;
    }
    return index;
}

- (NSUInteger)count {
    NSUInteger count = self.index + 1;
    TSLinkNode *node = self;
    while (node.next != nil) {
        node = node.next;
        count++;
    }
    return count;
}

- (void)insertAfterSelf:(TSLinkNode *)node {
    TSLinkNode *oriNext = self.next;
    
    oriNext.previous = node;
    self.next = node;
    
    node.end.next = oriNext;
    node.previous = self;
}

- (void)insertBeforeSelf:(TSLinkNode *)node {
    TSLinkNode *oriPrevious = self.previous;
    
    oriPrevious.next = node;
    self.previous = node;
    
    node.end.next = self;
    node.previous = oriPrevious;
}

- (TSLinkNode *)root {
    TSLinkNode *root = self;
    while (root.previous) {
        root = root.previous;
    }
    return root;
}

- (BOOL)isRoot {
    return self.previous == nil;
}

- (TSLinkNode *)end {
    TSLinkNode *end = self;
    while (end.next) {
        end = end.next;
    }
    return end;
}

- (BOOL)isEnd {
    return self.next == nil;
}

- (void)enumerateObject:(void (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    
    TSLinkNode *current = self;
    NSUInteger index = 0;
    BOOL stop = NO;
    
    while (current != nil) {
        @autoreleasepool {
            block(current.value, index++, &stop);
            current = current.next;
            if (stop) {
                break;
            }
        }
    }
}

@end
