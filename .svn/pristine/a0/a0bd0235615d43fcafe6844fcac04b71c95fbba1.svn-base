//
//  ShoppingCartViewController.m
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "LCShoppingCart.h"
#import "SVGloble.h"
#import <MJRefresh.h>
#import "ShoppingCartTableViewCell.h"

@interface ShoppingCartViewController ()

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *payBg;

@property(nonatomic,strong)NSMutableArray *lcShoppingCarts;

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark UI
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [SVGloble shareInstance].globleWidth,[SVGloble shareInstance].globleAllHeight-kStatusBarHeight-kNavigationBarHeight-53) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    
    //配合heightForFooter设置间隔
    self.tableView.sectionHeaderHeight=0;
    
    //headRefresh
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //__weak typeof(self) weakSelf = self;
    [self.tableView.header setTitle:@"加载中..." forState:MJRefreshHeaderStateRefreshing];
    [self.tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"松开刷新数据" forState:MJRefreshHeaderStatePulling];
    self.tableView.header.font = [UIFont systemFontOfSize:kCommonFontSize];
    self.tableView.header.textColor = RGB(133, 133, 133);
    [self.tableView.header setUpdatedTimeHidden:YES];
    [self.tableView.header beginRefreshing];
    
    //payBgView
    self.payBg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), [SVGloble shareInstance].globleWidth, 53)];
    //添加总计lable和结算button
    
}

-(void)loadData{
   [self.lcDataHelper getShoppingCartsWithlimit:0 skip:0 block:^(NSArray *objects, NSError *error) {
       if (error) {
           [self alert:@"获取数据失败"];
           return ;
       }
       self.lcShoppingCarts = [objects mutableCopy];
       [self.tableView reloadData];
       [self.tableView.header endRefreshing];
   }];
}

#pragma mark UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lcShoppingCarts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //需动态获取高度
    return 140;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCartTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"shoppingCartCell"];
    if(cell==nil){
        cell = [[ShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shoppingCartCell"];
    }
    cell.shoppingCartTableViewCellDelegate = self;
    cell.lcShoppingCart=self.lcShoppingCarts[indexPath.row];
    cell.indexPath = indexPath;
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

#pragma mark action
-(void)payBtnClick:(UIButton*)button{

}

#pragma mark shoppingCartTableViewCellDelegate
-(void)didSubtractionBtn{

}

-(void)didAddBtn{

}

-(void)didDeleBtn{

}


@end
