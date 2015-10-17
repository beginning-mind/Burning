//
//  LCFeedback.m
//  Burning
//
//  Created by Xiang Li on 15/8/20.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "LCFeedback.h"

@implementation LCFeedback
@dynamic userObjectId;
@dynamic username;
@dynamic mobilePhoneNum;
@dynamic content;

+(NSString *)parseClassName {
    return @"Feedback";
}

@end
