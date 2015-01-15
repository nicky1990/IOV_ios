//
//  ShateDataSuper.m
//  ShareD
//
//  Created by newman on 15-1-10.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import "ShateDataSuper.h"

#import <objc/runtime.h>

@implementation ShateDataSuper

- (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}

- (NSDictionary *)convertDictionary{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *propertyList = [self propertyKeys];
    for (NSString *key in propertyList) {
        SEL selector = NSSelectorFromString(key);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id value = [self performSelector:selector];
#pragma clang diagnostic pop
        
        if (value == nil) {
            value = [NSNull null];
        }
        [dict setObject:value forKey:key];
    }
    return dict;
}

- (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource
{
    BOOL ret = NO;
    for (NSString *key in [self propertyKeys]) {
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        }
        else
        {
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        }
        if (ret) {
            id propertyValue = [dataSource valueForKey:key];
            //该值不为NSNULL，并且也不为nil
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                [self setValue:propertyValue forKey:key];
            }
        }
    }
    return ret;
}

@end
