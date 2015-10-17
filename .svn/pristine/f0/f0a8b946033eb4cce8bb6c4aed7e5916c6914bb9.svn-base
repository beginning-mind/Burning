//
//  DetailOrderTableViewCell.m
//  Burning
//
//  Created by wei_zhu on 15/9/2.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "DetailOrderTableViewCell.h"

@interface DetailOrderTableViewCell()

@property(nonatomic,strong)UIImageView *photoImageView;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLable;

@property(nonatomic,strong)UILabel *countLable;

@property(nonatomic,strong)UILabel *totolPriceLable;

@end

@implementation DetailOrderTableViewCell

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

}

-(UIImageView*)photoImageView{
    if (_photoImageView) {
        
    }
    return _photoImageView;
}

-(UILabel*)nameLabel{
    if (_nameLabel==nil) {

    }
    return _nameLabel;
}

-(UILabel*)priceLable{
    if (_priceLable==nil) {
        
    }
    return _priceLable;
}

-(UILabel*)countLable{
    if (_countLable==nil) {
        
    }
    return _countLable;
}

-(UILabel*)totolPriceLable{
    if (_totolPriceLable ==nil) {

    }
    return _totolPriceLable;
}

-(void)setLcOrder:(LCOrder *)lcOrder{
    _lcOrder = lcOrder;
    //给控件赋值
}

@end
