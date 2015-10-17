//
//  LCFeedback.h
//  Burning
//
//  Created by Xiang Li on 15/8/20.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "AVObject.h"

@interface LCFeedback : AVObject

@property(nonatomic, strong) NSString *userObjectId;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *mobilePhoneNum;
@property(nonatomic, strong) NSString *content;

@end
