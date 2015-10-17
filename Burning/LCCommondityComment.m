//
//  LCCommondityComment.m
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "LCCommondityComment.h"

@implementation LCCommondityComment

@dynamic commodity;
@dynamic commentContent;
@dynamic commentUser;
@dynamic toUser;

+(NSString*)parseClassName{
    return @"CommondityComment";
}

@end
