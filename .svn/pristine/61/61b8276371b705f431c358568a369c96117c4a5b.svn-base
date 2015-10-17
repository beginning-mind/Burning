//
//  NSString+DynamicHeight.m
//  Burning
//
//  Created by wei_zhu on 15/8/28.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "NSString+DynamicHeight.h"

@implementation NSString (DynamicHeight)

+ (CGFloat)getTextHeight:(NSString *)text textFont:(UIFont *)font width:(CGFloat)width
{
    return [text boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
}

+(CGFloat)getTextWidth:(NSString*)text textFont:(UIFont*)font maxWidth:(CGFloat)maxWidth{
    return [text boundingRectWithSize:CGSizeMake(maxWidth,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
}

@end
