//
//  TSTypesAutowire.m
//  RouteIntent
//
//  Created by 王俊仁 on 2017/10/18.
//

#import "TSTypesAutowire.h"

#import <objc/runtime.h>

@implementation TSTypesAutowire

@end


@implementation NSObject (TSTypesAutowire)

- (void)ts_autowireTSTypesWithDict:(NSDictionary *)dict {
    unsigned int count = 0;
    objc_property_t *list = class_copyPropertyList([self class], &count);

    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    format.numberStyle = NSNumberFormatterDecimalStyle;

    for (int i = 0; i < count; i++) {
        objc_property_t prop = list[i];
        char *type = property_copyAttributeValue(prop, "T");
        NSString *objcType = [NSString stringWithUTF8String:type];
        free(type);
        NSString *name = [NSString stringWithUTF8String:property_getName(prop)];
        @try {
            if ([objcType containsString:@"NSString<TSString>"]) {
                // 注入stTSng
                [self setValue:[dict[name] description] forKey:name];
            } else if ([objcType containsString:@"NSNumber<TSNumber>"]) {
                // 注入number
                id obj = dict[name];
                if ([obj isKindOfClass:[NSNumber class]]) {
                    [self setValue:obj forKey:name];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    NSNumber *number = [format numberFromString:obj];
                    [self setValue:number forKey:name];
                }
            }
        } @catch (NSException *exception) {

        }
    }
    free(list);
}
@end
