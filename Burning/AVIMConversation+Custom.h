//
//  AVIMConversation+CustomAttributes.h
//  LeanChatLib
//
//  Created by lzw on 15/4/8.
//  Copyright (c) 2015年 avoscloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "CDIMConfig.h"

#define CONV_TYPE @"type"
#define CONV_GEO_POINT @"location"
#define CONV_MEMBERS_KEY @"m"
#define CONV_CLIENT_KEY @"c"
#define CONV_NAME @"name"
typedef void (^AVIMConversationsResultBlock)(NSMutableArray *conversations, NSError *error);

typedef enum : NSUInteger {
    CDConvTypeSingle = 0,
    CDConvTypeGroup =1,
    CDConvTypeSystem =2,//系统消息对话
    //CDConvTypeSystemGuest2Master =21,//游客发起加群
    CDConvTypeDynamics =3,//动态通知对话
    CDConvTypeActivity =4, //活动通知对话
    CDConvTypeAttention=5,//关注
} CDConvType;

@interface AVIMConversation (Custom)

- (CDConvType)type;

- (NSString *)otherId;

- (NSString *)displayName;

+ (NSString *)nameOfUserIds:(NSArray *)userIds;

- (NSString *)title;

- (UIImage *)icon;


@end
