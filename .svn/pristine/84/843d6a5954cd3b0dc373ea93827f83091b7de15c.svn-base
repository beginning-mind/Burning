//
//  PListFileHelper.m
//  Burning
//
//  Created by Xiang Li on 15/6/29.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "PListFileHelper.h"

@implementation PListFileHelper

+(NSObject*)readObjectByKey:(NSString *)key {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename =[plistPath1 stringByAppendingPathComponent:@"local.plist"];
    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    return [data1 objectForKey:key];
}

+(void)write2PlistWithKey:(NSString *)key AndValue:(NSMutableDictionary*)value{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"local" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    [data setObject:value forKey:key];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename = [plistPath1 stringByAppendingPathComponent:@"local.plist"];
    
    [data writeToFile:filename atomically:YES];
}

@end
