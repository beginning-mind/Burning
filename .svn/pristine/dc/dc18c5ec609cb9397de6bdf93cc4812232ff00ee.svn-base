//
//  DetailCommodityRichView.m
//  Burning
//
//  Created by wei_zhu on 15/9/1.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "DetailCommodityRichView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HDScrollview.h"
#import "SVGloble.h"
#import "LayoutConst.h"

@interface DetailCommodityRichView()

@property(nonatomic,strong)HDScrollview *titlePhotoView;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLable;

@property(nonatomic,strong)UIView *commentViewBg;
@property(nonatomic,strong)UILabel *commentLabel;
@property(nonatomic,strong)UIButton *commentAccessBtn;

@property(nonatomic,strong)UIScrollView *detailScrollView;

@end

@implementation DetailCommodityRichView


-(void)setLcCommodity:(LCCommodity *)lcCommodity{
    _lcCommodity = lcCommodity;
    
    //给控件赋值
    //code
    
    [self setNeedsLayout];
}

#pragma mark UI
-(void)setup{
//    [self addSubview:self.titlePhotoView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.priceLable];
    [self addSubview:self.commentViewBg];
    [self addSubview:self.detailScrollView];
}

//-(HDScrollview*)titlePhotoView{
//    if (_titlePhotoView == nil) {
//        _titlePhotoView = [[HDScrollview alloc]initWithFrame:CGRectMake(0, 0, [SVGloble shareInstance].globleWidth, 150)];
//    }
//    return _titlePhotoView;
//}

-(UILabel*)nameLabel{
    if (_nameLabel ==nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 152, [SVGloble shareInstance].globleWidth, 18)];
        _nameLabel.font = [UIFont systemFontOfSize:kCommonFontSize];
        _nameLabel.textColor = [UIColor blackColor];
    }
    
    return _nameLabel;
}

-(UILabel*)priceLable{
    if (_priceLable ==nil) {
        _priceLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame)+1, [SVGloble shareInstance].globleWidth, 18)];
        _priceLable.font = [UIFont systemFontOfSize:kCommonFontSize];
        _priceLable.textColor = [UIColor blackColor];
    }
    return _priceLable;
}

-(UIView*)commentViewBg{
    if (_commentViewBg ==nil) {
        _commentViewBg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLable.frame)+1, [SVGloble shareInstance].globleWidth, 18)];
        _commentViewBg.backgroundColor = [UIColor whiteColor];
        
        _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 18)];
        [_commentViewBg addSubview:_commentLabel];
        
        _commentAccessBtn = [[UIButton alloc]initWithFrame:CGRectMake([SVGloble shareInstance].globleWidth-30-kSmallSpace, 0, 30, 18)];
        [_commentAccessBtn setTitle:@">" forState:UIControlStateNormal];
        _commentAccessBtn.titleLabel.font =[UIFont systemFontOfSize:kCommonFontSize];
        [_commentAccessBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_commentViewBg addSubview:_commentAccessBtn];
    }
    return _commentViewBg;
}

-(UIScrollView*)detailScrollView{
    if (_detailScrollView==nil) {
        
    }
    return _detailScrollView;
}

-(void)loadHDScorllView{
    NSMutableArray *imageViewArry;
    for (AVFile *photoFile in self.lcCommodity.photos) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *url = photoFile.url;
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        [imageViewArry addObject:imageView];
    }
    _titlePhotoView = [[HDScrollview alloc]initLoopScrollWithFrame:CGRectMake(0, 0, [SVGloble shareInstance].globleWidth, 150) withImageView:imageViewArry];
    _titlePhotoView.delegate = self;
    _titlePhotoView.HDdelegate = self;
    [self addSubview:_titlePhotoView];
    _titlePhotoView.pagecontrol.frame =CGRectMake(0, _titlePhotoView.pagecontrol.frame.origin.y+_titlePhotoView.frame.size.height-10, [SVGloble shareInstance].globleWidth, 10);
    _titlePhotoView.pagecontrol.currentPage=0;
    [self addSubview:_titlePhotoView.pagecontrol];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //重新布局代码
}

#pragma mark action
-(void)commentAccessBtnClick:(UIButton*)button{
    if ([_detailCommodityDelegate respondsToSelector:@selector(didCommentButtonClick)]) {
        [_detailCommodityDelegate didCommentButtonClick];
    }
}

@end
