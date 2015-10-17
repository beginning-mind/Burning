//
//  BodyBuildingTableCell.m
//  Burning
//
//  Created by wei_zhu on 15/8/20.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BodyBuildingTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BodyBuildingTableCell()

@property(nonatomic,strong)UIImageView *backImageView;

@end

@implementation BodyBuildingTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}

#pragma mark UI
-(void)setup{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self addSubview:self.backImageView];
}

-(UIImageView*)backImageView{
    if (_backImageView==nil) {
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, 100)];
    }
    return _backImageView;
}

-(void)setShBodyBuilding:(SHBodyBuilding *)shBodyBuilding{
    _shBodyBuilding = shBodyBuilding;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    AVFile *backFile = self.shBodyBuilding.backFile;
    CGFloat ration = 400.0/110.0;
    CGFloat W = self.frame.size.width;
    CGFloat H = W/ration;
    self.backImageView.frame = CGRectMake(0, 0, W, H);
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:backFile.url]];
}

@end