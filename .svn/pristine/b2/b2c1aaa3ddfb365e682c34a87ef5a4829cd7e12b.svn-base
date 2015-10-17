//
//  ShoppingCartTableViewCell.m
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"

@interface ShoppingCartTableViewCell()

@property(nonatomic,strong)UIImageView *commodityImageView;

@property(nonatomic,strong)UILabel *nameLable;

@property(nonatomic,strong)UILabel *priceLable;

@property(nonatomic,strong)UILabel *countPreLable;

@property(nonatomic,strong)UILabel *countLable;

@property(nonatomic,strong)UIButton *subtractionBtn;

@property(nonatomic,strong)UIButton *addBtn;

@property(nonatomic,strong)UIButton *deleteBtn;

@end

@implementation ShoppingCartTableViewCell

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

#pragma mark UI
-(void)setup{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self addSubview:self.commodityImageView];
    [self addSubview:self.nameLable];
    [self addSubview:self.priceLable];
    [self addSubview:self.countPreLable];
    [self addSubview:self.subtractionBtn];
    [self addSubview:self.countLable];
    [self addSubview:self.addBtn];
    [self addSubview:self.deleteBtn];
}

-(UIImageView*)commodityImageView{
    if (_commodityImageView==nil) {
        
    }
    
    return _commodityImageView;
}

-(UILabel*)nameLable{
    if (_nameLable ==nil) {
        
    }
    return _nameLable;
}

-(UILabel*)priceLable{
    if (_priceLable ==nil) {
        
    }
    
    return _priceLable;
}

-(UILabel*)countPreLable{
    if (_countPreLable ==nil) {
        
    }
    
    return _countPreLable;
}

-(UIButton*)subtractionBtn{
    if (_subtractionBtn ==nil) {
        
    }
    return _subtractionBtn;
}

-(UILabel*)countLable{
    if (_countLable ==nil) {
        
    }
    return _countLable;
}

-(UIButton*)addBtn{
    if (_addBtn ==nil) {
        
    }
    return _addBtn;
}

-(UIButton*)deleteBtn{
    if (_deleteBtn ==nil) {
        
    }
    return _deleteBtn;
}

-(void)setLcShoppingCart:(LCShoppingCart *)lcShoppingCart{
    _lcShoppingCart = lcShoppingCart;
    
    //给控件赋值
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //重新布局
}

#pragma mark action
-(void)subtractionBtnClick:(UIButton*)button{
    if ([_shoppingCartTableViewCellDelegate respondsToSelector:@selector(didSubtractionBtn)]) {
        [_shoppingCartTableViewCellDelegate didSubtractionBtn];
    }
}

-(void)addBtnClick:(UIButton*)button{
    if ([_shoppingCartTableViewCellDelegate respondsToSelector:@selector(didAddBtn)]) {
        [_shoppingCartTableViewCellDelegate didAddBtn];
    }
}

-(void)deleteBtnClick:(UIButton*)button{
    if ([_shoppingCartTableViewCellDelegate respondsToSelector:@selector(didDeleBtn:)]) {
        [_shoppingCartTableViewCellDelegate didDeleBtn:_indexPath];
    }
}

@end
