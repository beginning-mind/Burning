//
//  BodyBuildingGroupTableCell.m
//  Burning
//
//  Created by wei_zhu on 15/8/20.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BodyBuildingGroupTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BodyBuildingGroupTableCell()

@property(nonatomic,strong)UIImageView *backImageView;

@end

@implementation BodyBuildingGroupTableCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma  mark UI
-(void)setup{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self addSubview:self.backImageView];
}

-(UIImageView*)backImageView{
    if (_backImageView==nil) {
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _backImageView;
}

-(void)setShBodyBuildingGroup:(SHBodyBuildingGroup *)shBodyBuildingGroup{
    _shBodyBuildingGroup = shBodyBuildingGroup;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    NSString *url = self.shBodyBuildingGroup.backFile;
    CGFloat ration = 2.72;
    CGFloat W = self.frame.size.width;
    CGFloat H = W/ration;
    self.backImageView.frame = CGRectMake(0, 0, W, H);
    [self.backImageView sd_cancelCurrentImageLoad];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    CGRect frame=self.frame;
    frame.size.height=H;
    self.frame=frame;
}


@end
