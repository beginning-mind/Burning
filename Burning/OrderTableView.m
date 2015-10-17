//
//  OrderTableView.m
//  Burning
//
//  Created by wei_zhu on 15/9/1.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "OrderTableView.h"
#import "LCOrder.h"
#import "OrderTableViewCell.h"

@interface OrderTableView()

@property(nonatomic,strong)NSMutableArray *lcOrders;

@end

@implementation OrderTableView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    self.delegate = self;
    self.dataSource = self;
    
    self.sectionHeaderHeight =0;
    
    return  self;
}


#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lcOrders.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //动态改变
    return 140;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if(cell==nil){
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
    }
    
    cell.lcOrder=self.lcOrders[indexPath.section];
    cell.orderState = self.orderState;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return 5.0;
}

@end
