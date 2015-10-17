//
//  LCCommodity.h
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#define KEY_DERAIL_PHOTO @"detailPhoto"
#define KEY_COMMODITY_PHOTOS @"photos"
#define KEY_COMMODITY_COMMENT @"comments"

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>

@interface LCCommodity : AVObject<AVSubclassing>

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *price;

@property(nonatomic,copy)NSString *vipPrice;

@property(nonatomic,strong)AVFile *detailPhoto;

@property(nonatomic,strong)NSArray *photos;

@property(nonatomic,strong)AVFile *shortPhoto;

@property(nonatomic,strong)NSArray *comments;

@end
