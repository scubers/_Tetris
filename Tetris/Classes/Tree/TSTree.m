//
//  RITree.m
//  RouteIntent
//
//  Created by 王俊仁 on 2018/2/24.
//

#import "TSTree.h"
#import "TSError.h"

#pragma mark - RINodePath

@implementation TSNodePath

+ (instancetype)nodePathWithPath:(NSArray<NSString *> *)path value:(id)value {
    TSNodePath *np = [TSNodePath new];
    np->_path = path;
    np->_value = value;
    return np;
}

@end


#pragma mark - RITreeNode

@interface TSTreeNode ()

@property (nonatomic, copy, nonnull ) NSString *key;
@property (nonatomic, copy, nullable) id value;
@property (nonatomic, weak, nullable) TSTreeNode *parent;

@end

@implementation TSTreeNode

- (instancetype)init {
    if (self = [super init]) {
        _children = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (TSTreeNode *)nodeWithKey:(NSString *)key value:(id)value depth:(NSInteger)depth {
    TSTreeNode *node = [[TSTreeNode alloc] init];
    node->_key = key;
    node->_value = value;
    node->_depth = depth;
    return node;
}

- (TSTreeNode *)addChild:(TSTreeNode *)child {
    // 如果已经存在子节点，检查是否为占位点
    {
        TSTreeNode *existNode = _children.allValues.firstObject;
        if (existNode.isPlaceholder) {
            TSAssertion([child->_key isEqualToString:existNode->_key], @"Place holder can node must be only one");
        }

        if (child.isPlaceholder && existNode) {
            TSAssertion([child->_key isEqualToString:existNode->_key], @"Place holder can node must be only one");
        }
    }

    // 添加节点
    TSTreeNode *finalNode;

    TSTreeNode *existeNode = _children[child.key];

    if (existeNode) {
        if (child.isEndingNode) {
            TSAssertion(!existeNode.getValue, "Multiple end pattern: %@", existeNode.getPathToRoot);
            [existeNode setNodeValue:child.getValue];
        }
        finalNode = existeNode;
    } else {
        _children[child.key] = child;
        finalNode = child;
    }

    finalNode.parent = self;

    return finalNode;

}

- (void)setNodeValue:(id)value {
    _value = value;
}

- (id)getValue {
    return _value;
}

- (BOOL)isEndingNode {
    return _value != nil;
}

- (BOOL)isPlaceholder {
    return [_key hasPrefix:@":"];
}

- (BOOL)isRoot {
    return _parent == nil;
}

- (NSString *)realkey {
    return self.isPlaceholder ? [self.key substringFromIndex:1] : self.key;
}

- (NSArray<NSString *> *)getPathToRoot {
    NSMutableArray<NSString *> *arr = [NSMutableArray array];
    TSTreeNode *current = self;
    while (current.parent != nil) {
        [arr insertObject:current.key atIndex:0];
        current = current.parent;
    }
    return arr;
}

- (NSString *)description {
    NSMutableString *prefix = @"".mutableCopy;
    if (_depth > 0) {
        prefix = @"|".mutableCopy;
        for (int i = 0; i < _depth; i++) {
            [prefix appendString:@"---"];
        }
    }
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@[%@]", prefix, self.key];
    if (self.isEndingNode && !self.isRoot) {
        [string appendFormat:@" (%@)", self.getValue];
    }
    [_children enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TSTreeNode * _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"\n%@", obj];
    }];

    return string;
}

- (void)removeChildByKey:(NSString *)key {
    _children[key] = nil;
}

@end

#pragma mark - RITreeResult

@implementation TSTreeResult

+ (TSTreeResult *)resultWithParams:(NSDictionary<NSString *,NSString *> *)params node:(TSTreeNode *)node {
    TSTreeResult *result = [[TSTreeResult alloc] init];
    result->_params = params;
    result->_node = node;
    return result;
}

@end

#pragma mark - RITree

@implementation TSTree

- (instancetype)init {
    if (self = [super init]) {
        _root = [TSTreeNode nodeWithKey:@"Root of the tree" value:nil depth:0];
    }
    return self;
}

- (TSTreeResult *)findNodeWithPath:(NSArray<NSString *> *)path {
    __block TSTreeNode *currentNode = _root;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __block TSTreeNode *final;

    NSUInteger count = path.count;

    [path enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        TSTreeNode *existNode = currentNode.children[obj];

        if (existNode) {
            currentNode = existNode;
        }
        else if (currentNode.children.count > 0 && currentNode.children.allValues.firstObject.isPlaceholder) {
            currentNode = currentNode.children.allValues.firstObject;
            params[currentNode.realkey] = obj;
        }
        else {
            currentNode = nil;
            *stop = YES;
        }

        if (idx == count - 1) {
            final = currentNode.getValue ? currentNode : nil;
        }

    }];

    return final ? [TSTreeResult resultWithParams:params node:final] : nil;
}

- (void)buildTree:(TSNodePath *)nodePath {

    if (nodePath.path.count == 0) {
        return;
    }

    NSUInteger count = nodePath.path.count;

    __block TSTreeNode *current = _root;

    [nodePath.path enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TSTreeNode *node;
        if (idx == count - 1) {
            node = [TSTreeNode nodeWithKey:obj value:nodePath.value depth:idx];
        } else {
            node = [TSTreeNode nodeWithKey:obj value:nil depth:idx];
        }
        current = [current addChild:node];
    }];

}

- (void)removeNodeWithPath:(NSArray<NSString *> *)path {
    TSTreeResult *result = [self findNodeWithPath:path];
    if (!result) {
        return;
    }
    [self removeNode:result.node];
}

- (void)removeNode:(TSTreeNode *)node {

    [node setNodeValue:nil];

    if (node.children.count > 0) {
        return;
    }

    TSTreeNode *parent = node.parent;

    [parent removeChildByKey:node.key];

    if (parent.isEndingNode) {
        return;
    }

    [self removeNode:parent];

}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n%@", _root];
}


@end



#pragma mark - TSTree URL Support

@implementation TSTreeUrlComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        _params = [NSMutableDictionary new];
        _pathComponents = @[];
    }
    return self;
}

+ (TSTreeUrlComponent *)componentWithURL:(NSURL *)url value:(id)value {
    NSURLComponents *com = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    TSAssertion(com, "URL: %@; invalid", url);
    TSAssertion(value, "Value is nil");
    
    TSTreeUrlComponent *treeComp = [[TSTreeUrlComponent alloc] init];
    
    treeComp.value = value;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [com.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        params[obj.name] = obj.value;
    }];
    treeComp->_params = params;
    treeComp->_pathComponents = [self getFullPathFromPath:com.path] ?: @[];
    treeComp->_path = com.path;
    
    treeComp->_scheme = com.scheme;
    treeComp->_host = com.host;
    treeComp->_port = com.port;
    treeComp->_path = com.path;
    treeComp->_queryString = com.query;
    
    return treeComp;
}

+ (NSArray<NSString *> *)getFullPathFromPath:(NSString *)path {
    NSArray *pathes = [path componentsSeparatedByString:@"/"];
    return [pathes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.length > 0"]];
}

- (void)addParameters:(NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_params];
    [dict addEntriesFromDictionary:params];
    self->_params = dict;
}

@end

@implementation TSTree (URLSupport)

- (void)buildTreeWithURL:(NSURL *)url value:(id)value {
    TSTreeUrlComponent *comp = [TSTreeUrlComponent componentWithURL:url value:value];
    [self buildTreeByURLComponents:comp];
}

- (TSTreeUrlComponent *)findByURL:(NSURL *)url {
    TSTreeUrlComponent *comp = [TSTreeUrlComponent componentWithURL:url value:@"temp obj"];
    TSTreeResult *result = [self findNodeWithPath:comp.pathComponents];
    if (!result) {
        return nil;
    }
    comp.value = result.node.getValue;
    [comp addParameters:result.params];
    return comp;
}

- (void)buildTreeWithURLString:(NSString *)urlString value:(id)value {
    NSURL *url = [NSURL URLWithString:urlString];
    [self buildTreeWithURL:url value:value];
}

- (TSTreeUrlComponent *)findByURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    return [self findByURL:url];
}

#pragma mark - private

- (void)buildTreeByURLComponents:(TSTreeUrlComponent *)comp {
    TSNodePath *path = [TSNodePath nodePathWithPath:comp.pathComponents value:comp.value];
    [self buildTree:path];
}


@end


#pragma mark - TSSnycTree

@interface TSSyncTree ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation TSSyncTree

- (instancetype)init {
    if (self = [super init]) {
        _queue = [NSOperationQueue new];
        _queue.name = [NSString stringWithFormat:@"com.tetris.syncTree.queue.%@", self];
        _queue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)buildTree:(TSNodePath *)nodePath {
    [self addOperationWithBlock:^{
        [super buildTree:nodePath];
    } wait:NO];// async build
}

- (TSTreeResult *)findNodeWithPath:(NSArray<NSString *> *)path {
    __block TSTreeResult *result;
    [self addOperationWithBlock:^{
        result = [super findNodeWithPath:path];
    } wait:YES]; // sync find
    return result;
}

- (void)removeNodeWithPath:(NSArray<NSString *> *)path {
    [self addOperationWithBlock:^{
        [super removeNodeWithPath:path];
    } wait:NO];
}

- (void)addOperationWithBlock:(dispatch_block_t)block wait:(BOOL)wait {
    if ([_queue isEqual:[NSOperationQueue currentQueue]]) {
        block();
    } else {
        NSOperation *operation  = [NSBlockOperation blockOperationWithBlock:^{
            block();
        }];
        [_queue addOperation:operation];
        if (wait) {
            [operation waitUntilFinished];
        }
    }
}


@end
