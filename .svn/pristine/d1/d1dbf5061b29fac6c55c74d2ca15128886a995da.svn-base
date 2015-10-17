//
//  PubShowTableView.h
//  Burning
//
//  Created by wei_zhu on 15/6/12.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LCPublish.h"



@protocol PubSHowTableViewDelegate <NSObject>

@optional

-(void)didAvatarImageViewClickUser:(AVUser*)user;

-(void)didDigUserImageViewClickUser:(AVUser*)user;

-(void)didCommentButtonClick:(NSIndexPath *)indexPath commentUserIndex:(NSInteger)commentUserIndex;

-(void)didLikeButtonClick:(UIButton *)button indexPath:(NSIndexPath *)indexPath;

-(void)didDeletePubButtonClickindexPath:(NSIndexPath*)indexPath;

@end


@interface PubShowTableView : UITableView

@property(nonatomic,strong)NSMutableArray *lcPublishs;

@property(nonatomic,strong)NSIndexPath *selectedIndexPath;

@property(nonatomic,assign)NSInteger curLoadMoreCount;

@property(nonatomic,strong)id<PubSHowTableViewDelegate> pubShowTableViewDelegate;

-(void)addLike;

-(void)reloadLCPublish:(LCPublish*)lcPublish AtIndexPath:(NSIndexPath*)indexPath;


@end
