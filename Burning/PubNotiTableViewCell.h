//
//  PubNotiTableViewCell.h
//  Burning
//
//  Created by wei_zhu on 15/8/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVIMTypedMessage.h>

@protocol PubNotiTableViewCellDelegate <NSObject>

-(void)didAvatarClick:(NSString*)userID;

-(void)didContentImageClick:(NSString*)conID objID:(NSString*)objID;

@end

@interface PubNotiTableViewCell : UITableViewCell

@property(nonatomic,strong)AVIMTypedMessage *message;

@property(nonatomic,strong)id<PubNotiTableViewCellDelegate> pubNotiTableViewCellDelegate;

+(CGFloat)calculateCellHeightWithMessage:(AVIMTypedMessage*)message;

@end
