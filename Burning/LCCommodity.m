//
//  LCCommodity.m
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "LCCommodity.h"

@implementation LCCommodity

@dynamic name;
@dynamic price;
@dynamic vipPrice;
@dynamic photos;
@dynamic detailPhoto;
@dynamic comments;
@dynamic shortPhoto;

+(NSString*)parseClassName{
    return @"Commondity";
}

@end
