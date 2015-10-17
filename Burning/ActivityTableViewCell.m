//
//  ActivityTableViewCell.m
//  Burning
//
//  Created by wei_zhu on 15/6/23.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVOSCloud/AVOSCloud.h>

@interface ActivityTableViewCell()

@property(nonatomic,strong) UIImageView *backImageView;

@end

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLcActivity:(LCActivity *)lcActivity{
    _lcActivity = lcActivity;
    self.titleLabel.text = lcActivity.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    self.timeLabel.text = [formatter stringFromDate:lcActivity.activityDate];
    self.placeLabel.text = lcActivity.place;
    self.attentionPesonLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)lcActivity.attendUsers.count-1,lcActivity.maxPersonCount];
    self.coastLabel.text = lcActivity.coast;
    
    for (UIView *subView in self.backView.subviews) {
        [subView removeFromSuperview];
    }
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height)];
    [self.backView addSubview:self.backImageView];
    [self.backImageView sd_cancelCurrentImageLoad];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:lcActivity.backGroundFile.url] placeholderImage:[UIImage imageNamed:@"group_blank"]];
}

@end