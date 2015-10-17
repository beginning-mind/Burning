//
//  ActivityCommentTableViewCell.h
//  Burning
//
//  Created by wei_zhu on 15/7/8.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCActivityComment.h"
#import "LCActivity.h"

@protocol ActitivityCommentViewCellDelegate <NSObject>

@optional

-(void)didAvatarImageViewClick:(UIGestureRecognizer*)gestureRecognizer indexPath:(NSIndexPath*)indexPath;

@end

@interface ActivityCommentTableViewCell : UITableViewCell

@property (nonatomic,strong) LCActivityComment *comment;

@property(nonatomic,strong)AVUser *commentUser;

@property (nonatomic,strong) NSIndexPath* indexPath;



@property(nonatomic,strong) id<ActitivityCommentViewCellDelegate>commentViewCellDelegate;

+(CGFloat)calculateCellHeightWithLCComment:(LCActivityComment*)lcActivityComment;

@end
