//
//  LCPublish.m
//  Burning
//
//  Created by wei_zhu on 15/5/28.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "LCPublish.h"

@implementation LCPublish


@dynamic creator;
@dynamic publishContent;
@dynamic publishPhotos;
@dynamic comments;
@dynamic digUsers;
@dynamic commentUsers;
@dynamic isDel;
@dynamic hotCount;

+(NSString*)parseClassName{
    return @"Publish";
}

@end
