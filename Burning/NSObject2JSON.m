//
//  NSObject2JSON.m
//  Burning
//
//  Created by Xiang Li on 15/7/16.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "NSObject2JSON.h"
#import <objc/runtime.h>
#import "JSONKit.h"


@implementation NSObject2JSON

+ (NSString *) getDicFromNormalClass:(id) classInstance
{
    
    Class clazz = [classInstance class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        id value =  [classInstance performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
        if(value ==nil)
            [valueArray addObject:@""];
        else {
            [valueArray addObject:value];
        }
    }
    free(properties);
    NSDictionary* dtoDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    NSString *returnJson = [dtoDic JSONString];
    NSLog(@"%@", returnJson);
    return returnJson;
}

@end
