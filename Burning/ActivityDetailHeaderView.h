//
//  ActivityDetailHeaderView.h
//  Burning
//
//  Created by wei_zhu on 15/6/23.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCActivity.h"

@protocol ActivityDetailHeaderViewDelegate<NSObject>

-(void)didCommentButtonClick:(NSInteger)commentUserIndex;

-(void)didAttendedUserImageViewClick:(NSInteger)attendUserindex;

@end

@interface ActivityDetailHeaderView : UIScrollView

typedef enum{
    
    MemberTypeCreator = 0,
    MemberTypeAttended,
    MemberTypeUnAttend
} MemberType;

@property(nonatomic,strong)LCActivity *lcActivity;

@property MemberType memberType;

@property(nonatomic,strong)id<ActivityDetailHeaderViewDelegate> activityDetailHeaderViewDelegate;

@end
