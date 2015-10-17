//
//  FollowNotiTableViewCell.h
//  Burning
//
//  Created by wei_zhu on 15/8/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVIMTypedMessage.h>

@protocol FollowNotiTableViewCellDelegate <NSObject>

-(void)didSendNoti:(AVUser*)toUser;

-(void)didAvatarClick:(NSString*)userID;

@end

@interface FollowNotiTableViewCell : UITableViewCell

@property(nonatomic,strong)AVIMTypedMessage *message;

+(CGFloat)calculateCellHeightWithMessage:(AVIMTypedMessage*)message;

@property(nonatomic,strong)id<FollowNotiTableViewCellDelegate>followNotiTableViewCellDelegate;

@end
