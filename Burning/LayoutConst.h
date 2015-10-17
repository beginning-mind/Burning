//
//  LayoutConst.h
//  Burning
//
//  Created by wei_zhu on 15/6/8.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#ifndef Burning_LayoutConst_h
#define Burning_LayoutConst_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define WEAKSELF  typeof(self) __weak weakSelf=self;

#define RGB(R,G,B) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]
#define RGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)/255]

static const CGFloat kNavigationBarHeight = 44;
static const CGFloat kStatusBarHeight =20;
static const CGFloat kTabBarHeight = 49;

//hot attention,newlyst layout const
static const CGFloat kHoriztalScorllBarHeight = 44;

static const CGFloat kHotUsernameHeight=18.0f;
static const CGFloat kHotDigUserButtonWidth=30.0f;
static const CGFloat kHotDigUserButtonHeight=30.0f;
static const CGFloat kHotPhotHeight=100.0f;
static const CGFloat kHotPhotInset=5.0f;
static const CGFloat kHotAvatarSpacing=15.0f;
static const CGFloat kHottimeLineFont=12.0f;
static const CGFloat kHotPhotoSpacing = 15.0f;


static const CGFloat kPubShowContentLineSpacing=4.0f;
static const CGFloat kPubShowCommentButtonWidth=30.0f;
static const CGFloat kPubShowTimeLableWidth = 80.0f;
static const CGFloat kPubShowCommentButtonHeight=30.0f;

static const CGFloat kPubShowAvatarSpacing=15.0f;
static const CGFloat kPubShowAvatarImageSize=45.0f;

static const CGFloat kPubShowPhotoInset=1;

static const CGFloat kPubShowFontSize=15;

static const CGFloat kShowLikeUserCount = 9;
static const CGFloat kLikeUserAvataSpcing=10;

static const CGFloat kMoreCommentButtonHeight = 16;
static const CGFloat kMoreCommentButtonWidth = 105;

static const CGFloat kPersonalResumeBgHeight = 200;
static const CGFloat kPersonalAvatarSize = 70;

//消息模块，群详情
static const CGFloat kGroupMemberAvatarRowCount = 9;

//DailyNews
static const CGFloat kDailyNewsImageSize = 200;

//新布局

//间距
static const CGFloat kCommonSpace = 15.0f;
static const CGFloat kSmallSpace  =12.0f;

static const CGFloat kCommonTextToAvatarHorizalSpace = 9.0f;
static const CGFloat kSmallTextAvatarHorizalSpace = 5.0f;

static const CGFloat kLargestTextTopSpace = 30.0f;
static const CGFloat kCommonTextTopSpace = 14.0f;
static const CGFloat kLargeTextTopSpace = 19.0f;

static const CGFloat kSmallTextVerticSpace = 6.0f;


//背景
static const CGFloat kBackgroudViewHeight = 94;

//文本框
static const CGFloat kTextHeight = 41;
static const CGFloat kTextViewHeight = 64;


//头像
static const CGFloat kLagerAvatarSize = 60.0f;
static const CGFloat kCommonAvatarSize = 43.0f;
static const CGFloat kSmallAvatarSize = 24.0f;

static const CGFloat kLargeAvatarLeadingSpace = 18.0f;
static const CGFloat kLargeAvatarTopSpace = 64.0f;
static const CGFloat kCommonAvatarLeadingSpace = 10.0f;
static const CGFloat kSmallAvatarLeadingSpace = 6.0f;

static const CGFloat kSmallAvatarTopSpace = 8.0f;

//头像间距
static const CGFloat kCommonAvatarHorizalSpace= 7.0f;
static const CGFloat kSmallAvatarHorizalSpace = 5.0f;

//长按钮
static const CGFloat kLargeBtnLeadingSpace = 17.0f;
static const CGFloat kLargeBtnTopSpace = 13.0f;
static const CGFloat kLargeBtnHeight = 32.0f;

//字体
static const CGFloat kLargeFontSize = 16.0f;
static const CGFloat kCommonFontSize = 14.0f;
static const CGFloat kSmallFontSize = 12.0f;
static const CGFloat kSmallestFontSize = 11.0f;
static const CGFloat kNavigationTitleFontSize = 17.0f;

//labelheight
static const CGFloat kLargeLabelHeight=21.0f;
static const CGFloat kPubShowUsernameHeight=18.0f;
static const CGFloat kUserListLabeSpading = 4.0f;

//图片
static const CGFloat kPubShowPhotoSize=65;
//字体颜色 浅色:（133，133，133）,蓝色:(0,108,255),系统蓝（30, 172, 199）

//shopping
static const CGFloat kcommodityImgRation = 2.72;
static const CGFloat kcommodityDetaiImgRation = 2.72;
static const CGFloat kcommodityShortImgRation = 1;

//个人设置头像
static const CGFloat kSettingAvatarRightSpace=25.0f;
static const CGFloat kSettingAvatarSize=36.0f;

//消息窗口title
static const CGFloat kMsgTitleTopSpace=11.0f;
static const CGFloat kMsgIndicatorSize=20.0f;
static const CGFloat kMsgTitleAndIndicatorWidth=200.0f;
static const CGFloat kMsgTitleWidth=160.0f;



#endif
