//
//  TSLine.h
//  Tetris
//
//  Created by Junren Wong on 2018/11/15.
//

#import <Foundation/Foundation.h>
#import "TSTree.h"
#import "TSRouterProtocols.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Line)
@interface TSLine : NSObject

@property (nonatomic, strong) id<TSURLPresentable> url;
@property (nonatomic, copy  ) NSString *desc;

@property (nonatomic, strong) Class<TSIntentable> intentableClass;

- (instancetype)initWithUrl:(id<TSURLPresentable>)url desc:(NSString *)desc class:(Class<TSIntentable>)aClass;

@end

NS_ASSUME_NONNULL_END
