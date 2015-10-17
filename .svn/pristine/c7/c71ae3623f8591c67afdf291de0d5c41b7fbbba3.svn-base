//
//  LCPublish.h
//  Burning
//
//  Created by wei_zhu on 15/5/28.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>

#define KEY_CLS @"cls"
#define KEY_ALBUM_TYPE @"publishType"
#define KEY_ALBUM_CONTENT @"publishContent"
#define KEY_ALBUM_PHOTOS @"publishPhotos"
#define KEY_DIG_USERS @"digUsers"
#define KEY_COMMENTS @"comments"
#define KEY_COMMENTUSERS @"commentUsers"
#define KEY_IS_DEL @"isDel"
#define KEY_CREATOR @"creator"
#define KEY_CREATED_AT @"createdAt"
#define KEY_AVATAR @"avatar"
#define KEY_HOT_COUNT @"hotCount"

@interface LCPublish : AVObject<AVSubclassing>


@property (nonatomic,strong) AVUser* creator; // 创建者
@property (nonatomic,copy) NSString* publishContent; //分享内容
@property (nonatomic,assign) NSArray* publishPhotos;  //分享照片 _File Array
@property (nonatomic,assign) NSArray* digUsers; //赞过的人 AVUser Array
@property(nonatomic,strong)NSArray *commentUsers;//评论过的人 AVUserArry

@property (nonatomic,strong) NSArray* comments; // LCComment Array
@property (nonatomic,strong) NSNumber* isDel; //是否删除

@property(nonatomic,assign)NSInteger hotCount;

@end
