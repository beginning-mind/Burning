//
//  CommodityDetailViewController.m
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "CommodityDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailCommodityRichView.h"
#import "SVGloble.h"
#import "ShoppingCartViewController.h"

@interface CommodityDetailViewController ()

@property(nonatomic,strong)DetailCommodityRichView *detailRichView;

@property(nonatomic,strong)UIView *addShoppingBg;

@end

@implementation CommodityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailRichView.lcCommodity = self.lcCommodity;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI
-(void)initUI{
   //detailRichView;
    self.detailRichView  = [[DetailCommodityRichView alloc]initWithFrame:CGRectMake(0, 0, [SVGloble shareInstance].globleWidth,[SVGloble shareInstance].globleAllHeight-kStatusBarHeight-kNavigationBarHeight-53)];
    self.detailRichView.lcCommodity = self.lcCommodity;
    self.detailRichView.detailCommodityDelegate = self;
    

    //addshoppingBg;
    self.addShoppingBg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.detailRichView.frame), [SVGloble shareInstance].globleWidth, 53)];
    //购物车按钮
    UIButton *shoppingCartBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSmallSpace, (53.0-kLargeBtnHeight)/2.0,46, kLargeBtnHeight)];
    [shoppingCartBtn setImage:@"" forState:UIControlStateNormal];
    [shoppingCartBtn addTarget:self action:@selector(shoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [self.addShoppingBg addSubview:shoppingCartBtn];
    
    //加入购物车按钮
    UIButton *addShpCartBtn = [[UIButton alloc]initWithFrame:CGRectMake([SVGloble shareInstance].globleWidth-60, (53.0-kLargeBtnHeight)/2.0, 60, kLargeBtnHeight)];
    [addShpCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    addShpCartBtn.titleLabel.font = [UIFont systemFontOfSize:kLargeFontSize];
    [addShpCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addShpCartBtn setBackgroundImage:[UIImage imageNamed:@"co_bottomBtn_bg"] forState:UIControlStateNormal];
    [self.addShoppingBg addSubview:addShpCartBtn];
}

#pragma mark DetailCommodityDelegate
-(void)didComemntButtonClick{

}

#pragma mark action
-(void)shoppingCart:(UIButton*)button{
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

-(void)addShoppingCart:(UIButton*)button{

}

@end
