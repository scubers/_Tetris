//
//  RITree.h
//  RouteIntent
//
//  Created by 王俊仁 on 2018/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TSURLPresentable

@protocol TSURLPresentable

- (NSURL *)ts_url;

@end


#pragma mark - RINodePath

/**
 Tree节点路径描述对象
 */
NS_SWIFT_NAME(TreePath)
@interface TSNodePath : NSObject

@property (nonatomic, copy, readonly) NSArray<NSString *> *path;

@property (nonatomic, strong, nullable) id value;

+ (TSNodePath *)nodePathWithPath:(NSArray<NSString *> *)path value:(nullable id)value;

@end


#pragma mark - RITreeNode

/**
 Tree 节点对象
 */
NS_SWIFT_NAME(TreeNode)
@interface TSTreeNode : NSObject

+ (TSTreeNode *)nodeWithKey:(NSString *)key value:(nullable id)value depth:(NSInteger)depth;

@property (nonatomic, assign, readonly) NSInteger depth;

@property (nonatomic, strong, readonly, nullable) NSMutableDictionary<NSString *, TSTreeNode *> *children;

@property (nonatomic, assign, readonly) BOOL isEndingNode;
@property (nonatomic, assign, readonly) BOOL isPlaceholder;
@property (nonatomic, assign, readonly) NSString *realkey;
@property (nonatomic, assign, readonly) BOOL isRoot;

- (void)setNodeValue:(nullable id)value;

- (nullable id)getValue;

- (TSTreeNode *)addChild:(TSTreeNode *)child;

- (NSArray<NSString *> *)getPathToRoot;

@end

#pragma mark - RITreeResult

/**
 Tree查找结果对象
 */
NS_SWIFT_NAME(TreeResult)
@interface TSTreeResult : NSObject

@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *params;

@property (nonatomic, strong, readonly) TSTreeNode *node;

+ (TSTreeResult *)resultWithParams:(NSDictionary<NSString *, NSString *> *)params node:(TSTreeNode *)node;

@end

#pragma mark - RITree


/**
 Tree
 */
NS_SWIFT_NAME(Tree)
@interface TSTree : NSObject

@property (nonatomic, strong) TSTreeNode *root;

- (void)buildTree:(TSNodePath *)nodePath;

- (void)removeNodeWithPath:(NSArray<NSString *> *)path;

- (nullable TSTreeResult *)findNodeWithPath:(NSArray<NSString *> *)path;

- (void)enumerateEndNode:(void (^)(TSNodePath *path))block;

@end


#pragma mark - TSTree URL Support


/**
 Tree Url support component
 */
NS_SWIFT_NAME(TreeUrlComponent)
@interface TSTreeUrlComponent : NSObject

@property (nonatomic, strong, nullable) id value;

@property (nonatomic, strong, readonly) NSURL *url;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSString *> *params;
@property (nonatomic, strong, readonly) NSArray<NSString *> *pathComponents;

@property (nonatomic, copy, readonly, nullable) NSString *fragment;
@property (nonatomic, copy, readonly, nullable) NSString *scheme;
@property (nonatomic, copy, readonly, nullable) NSString *host;
@property (nonatomic, strong, readonly, nullable) NSNumber *port;
@property (nonatomic, copy, readonly, nullable) NSString *path;
@property (nonatomic, copy, readonly, nullable) NSString *queryString;



+ (TSTreeUrlComponent *)componentWithURL:(NSURL *)url value:(nullable id)value;

@end

@interface TSTree (URLSupport)

- (void)buildWithURL:(id<TSURLPresentable>)url value:(id)value;

- (TSTreeUrlComponent *)findByURL:(id<TSURLPresentable>)url;


@end

#pragma mark - TSSnycTree

/**
 async build, remove (do not block current queue)
 sync find (block current quene)
 */
@interface TSSyncTree : TSTree
@end


#pragma mark - Extension

@interface NSString (TSURLPresentable) <TSURLPresentable>
@end

@interface NSURL (TSURLPresentable) <TSURLPresentable>
@end

NS_ASSUME_NONNULL_END
