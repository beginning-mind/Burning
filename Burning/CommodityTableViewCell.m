//
//  CommodityTableViewCell.m
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "CommodityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LayoutConst.h"

@interface CommodityTableViewCell()

@property(nonatomic,strong)UIImageView *backImageView;

@end

@implementation CommodityTableViewCell

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

-(void)setCommodity:(LCCommodity *)commodity{
    _commodity = commodity;
    [self setNeedsDisplay];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSString *url = self.commodity.photos[0];
    CGFloat ration = kcommodityImgRation;
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
