//
//  CommentsTableViewCell.h
//  Burning
//
//  Created by wei_zhu on 15/6/11.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCComment.h"

@protocol CommentViewCellDelegate <NSObject>

@optional

-(void)didAvatarImageViewClick:(UIGestureRecognizer*)gestureRecognizer indexPath:(NSIndexPath*)indexPath;

@end

@interface CommentsTableViewCell : UITableViewCell

@property (nonatomic,strong) LCComment *comment;

@property(nonatomic,strong)AVUser *commentUser;

@property (nonatomic,strong) NSIndexPath* indexPath;



@property(nonatomic,strong) id<CommentViewCellDelegate>commentViewCellDelegate;

+(CGFloat)calculateCellHeightWithLCComment:(LCComment*)lccommet;

@end
