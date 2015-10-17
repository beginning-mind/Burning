//
//  LCActivity.h
//  Burning
//
//  Created by wei_zhu on 15/5/28.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>

#define KEY_ATTEND_USERS  @"attendUsers"

@interface LCActivity : AVObject<AVSubclassing>

@property (nonatomic,strong) AVUser *creator; // 创建者
@property (nonatomic,copy) NSString *title; //活动主题
@property(nonatomic,strong)NSDate *activityDate;//活动时间
@property(nonatomic,copy)NSString *maxPersonCount; //活动人数；
@property(nonatomic,copy)NSString *place;
@property(nonatomic,copy)NSString* coast;//活动费用
@property(nonatomic,copy)NSString *content;//活动说明
@property(nonatomic,strong)AVFile *backGroundFile;//背景图片
@property (nonatomic,strong) NSArray* attendUsers; //参加的人 _User Array
@property(nonatomic,strong)NSArray *commentUsers; //评论的人
@property (nonatomic,strong) NSArray* comments; // LCActivityComment Array
@property (nonatomic,assign) NSNumber* isDel; //是否删除

@end
