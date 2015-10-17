//
//  OrderDetailViewController.m
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "DetailOrderTableViewCell.h"

@interface OrderDetailViewController ()

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *payViewBg;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI
-(void)initUI{

}

-(void)loadData{

}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lcOrder.shoppingCommodity.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //需动态获取高度
    return 140;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailOrderTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"detailOrderCell"];
    if(cell==nil){
        cell = [[DetailOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailOrderCell"];
    }
    cell.lcOrder=self.lcOrder;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //code
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return 5.0;
}

@end
