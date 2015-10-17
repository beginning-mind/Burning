//
//  NSString+DynamicHeight.h
//  Burning
//
//  Created by wei_zhu on 15/8/28.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (DynamicHeight)

+ (CGFloat)getTextHeight:(NSString *)text textFont:(UIFont *)font width:(CGFloat)width;

+(CGFloat)getTextWidth:(NSString*)text textFont:(UIFont*)font maxWidth:(CGFloat)maxWidth;
@end
