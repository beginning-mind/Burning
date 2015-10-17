//
//  AddUserTableViewCell.h
//  Burning
//
//  Created by Xiang Li on 15/6/24.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@protocol AddUserTableViewCellDelegate <NSObject>
@optional

-(void)didAvatarImageViewClick:(UIGestureRecognizer*)gestureRecognizer indexPath:(NSIndexPath*)indexPath;
-(void)addOrDeleteAUserWithFlag:(bool)isAdd avUser:(AVUser*)user indexPath:(NSIndexPath*)indexPath;//add YES,del NO

@end


@interface AddUserTableViewCell : UITableViewCell

@property(nonatomic,strong)AVUser *user;
@property(nonatomic,strong) id<AddUserTableViewCellDelegate> addUserTableViewCellDelegate;
@property (nonatomic,strong) NSIndexPath* indexPath;

+(CGFloat)calculateCellHeightWithUser:(AVUser*)user;


@end
