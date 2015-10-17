//
//  UserListTableViewCell.h
//  Burning
//
//  Created by wei_zhu on 15/6/18.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@protocol UserListViewCellDelegate <NSObject>

@optional

-(void)didAvatarImageViewClick:(UIGestureRecognizer*)gestureRecognizer indexPath:(NSIndexPath*)indexPath;

@end

@interface UserListTableViewCell : UITableViewCell

@property(nonatomic,strong)AVUser *user;

@property(nonatomic,strong) id<UserListViewCellDelegate> userListViewCellDelegate;

@property (nonatomic,strong) NSIndexPath* indexPath;

+(CGFloat)calculateCellHeightWithUser:(AVUser*)user;

@end
