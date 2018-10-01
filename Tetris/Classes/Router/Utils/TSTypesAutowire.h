//
//  TSTypesAutowire.h
//  RouteIntent
//
//  Created by 王俊仁 on 2017/10/18.
//

#import <Foundation/Foundation.h>

#define TSInjectString(name) @property (copy) NSString<TSString> *name;
#define TSInjectNumber(name) @property NSNumber<TSNumber> *name;

@protocol TSTypes
@end

@protocol TSString <TSTypes>
@end

@protocol TSNumber <TSTypes>
@end

@interface TSTypesAutowire : NSObject

@end

@interface NSObject (TSTypesAutowire)


/**
 Auto wire the dict values into the same key property;
 The property type should NSStTSng<TSStTSng>
 The property type should NSNumber<TSNumber>

 @param dict input datasource
 */
- (void)ts_autowireTSTypesWithDict:(NSDictionary *)dict NS_SWIFT_UNAVAILABLE("swift unusable");

@end
