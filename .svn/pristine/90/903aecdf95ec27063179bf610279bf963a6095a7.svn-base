//
//  OrderTableViewCell.m
//  Burning
//
//  Created by wei_zhu on 15/9/1.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell()

@property(nonatomic,strong)UILabel *orderNOLable;

@property(nonatomic,strong)UILabel *totalCashLable;

@property(nonatomic,strong)UILabel *orderDateLable;

@property(nonatomic,strong)UIView *shoppingPhotoView;

@property(nonatomic,strong)UILabel *orderStableLabel;

@property(nonatomic,strong)UIButton *payButton;

@end

@implementation OrderTableViewCell

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

-(UILabel*)orderNOLable{
    if (_orderNOLable ==nil) {
        
    }
    return _orderNOLable;
}

-(UILabel*)totalCashLable{
    if (_totalCashLable==nil) {
        
    }
    return _totalCashLable;
}

-(UILabel*)orderDateLable{
    if (_orderDateLable ==nil) {
        
    }
    return _orderDateLable;
}

-(UIView*)shoppingPhotoView{
    if (_shoppingPhotoView==nil) {

    }
    return _shoppingPhotoView;
}

-(UILabel*)orderStableLabel{
    if (_orderStableLabel ==nil) {

    }
    return _orderStableLabel;
}

-(UIButton*)payButton{
    if (_payButton ==nil) {
        
    }
    return _payButton;
}

-(void)setLcOrder:(LCOrder *)lcOrder{
    _lcOrder = lcOrder;
    //给控件赋值
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //重新布局
}

#pragma mark action
-(void)payButtonClick:(UIButton*)button{

}

-(void)shoppingPhotoViewClick:(UIGestureRecognizer*)gestureRecognizer{

}

@end

