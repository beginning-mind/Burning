//
//  CommodityListViewController.m
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "CommodityListViewController.h"
#import "CommodityTableViewCell.h"
#import "SVGloble.h"
#import <MJRefresh.h>
#import "LayoutConst.h"
#import "CommodityDetailViewController.h"
#import "ShoppingCartViewController.h"
#import "OrderListViewController.h"

#define LOADCOUNT 10

@interface CommodityListViewController ()

@property(nonatomic,strong)UITableView *commodityTableView;

@property(nonatomic,strong)UIView *orderBgView;

@property(nonatomic,strong)NSMutableArray *lcCommoditys;

@property(nonatomic,assign)NSInteger curLoadMoreCount;

@end

@implementation CommodityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.commodityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [SVGloble shareInstance].globleWidth,[SVGloble shareInstance].globleAllHeight-kStatusBarHeight-kNavigationBarHeight-53) style:UITableViewStyleGrouped];
    [self.view addSubview:self.commodityTableView];
    self.commodityTableView.delegate = self;
    self.commodityTableView.dataSource =self;
    
    //配合heightForFooter设置间隔
    self.commodityTableView.sectionHeaderHeight=0;
    
    //headRefresh
    [self.commodityTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //__weak typeof(self) weakSelf = self;
    [self.commodityTableView.header setTitle:@"加载中..." forState:MJRefreshHeaderStateRefreshing];
    [self.commodityTableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.commodityTableView.header setTitle:@"松开刷新数据" forState:MJRefreshHeaderStatePulling];
    self.commodityTableView.header.font = [UIFont systemFontOfSize:kCommonFontSize];
    self.commodityTableView.header.textColor = RGB(133, 133, 133);
    [self.commodityTableView.header setUpdatedTimeHidden:YES];
    [self.commodityTableView.header beginRefreshing];
    
    //footRefresh
    [self.commodityTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.commodityTableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [self.commodityTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [self.commodityTableView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
    self.commodityTableView.footer.font= [UIFont systemFontOfSize:kCommonFontSize];
    self.commodityTableView.footer.textColor = RGB(133, 133, 133);
    
    //orderBgView
    self.orderBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.commodityTableView.frame), [SVGloble shareInstance].globleWidth, 53)];
    
    //order button
    UIButton *orderBtn = [[UIButton alloc]initWithFrame:CGRectMake(([SVGloble shareInstance].globleWidth/2.0-46.0)/2.0, (53.0-kLargeBtnHeight)/2.0, 46, kLargeBtnHeight)];
    [orderBtn setTitle:@"订单" forState:UIControlStateNormal];
    [orderBtn setTintColor:RGB(30, 172, 199)];
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSize];
    [orderBtn addTarget:self action:@selector(orbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderBgView addSubview:orderBtn];
    
    //shopping button
    UIButton *shoppingCartBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderBtn.frame) +([SVGloble shareInstance].globleWidth/2.0-46.0)/2.0, (53.0-kLargeBtnHeight)/2.0, 46, kLargeBtnHeight)];
    [shoppingCartBtn setTitle:@"购物车" forState:UIControlStateNormal];
    [shoppingCartBtn setTintColor:RGB(30, 172, 199)];
    shoppingCartBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSize];
    [shoppingCartBtn addTarget:self action:@selector(shoppingCartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderBgView addSubview:shoppingCartBtn];
}

-(void)loadData{
[self.lcDataHelper getCommoditysWithlimit:LOADCOUNT skip:0 block:^(NSArray *objects, NSError *error) {
    if (error) {
        [self alert:@"获取数据失败"];
        return ;
    }
    self.lcCommoditys = [objects mutableCopy];
    self.curLoadMoreCount  = 1;
    [self.commodityTableView reloadData];
    [self.commodityTableView.header endRefreshing];
    if (objects.count<LOADCOUNT) {
        self.commodityTableView.footer.state = MJRefreshFooterStateNoMoreData;
    }
    else{
        self.commodityTableView.footer.state = MJRefreshFooterStateIdle;
    }
}];
}

-(void)loadMoreData{
    [self.lcDataHelper getCommoditysWithlimit:LOADCOUNT skip:self.curLoadMoreCount block:^(NSArray *objects, NSError *error) {
        if (error) {
            [self alert:@"获取数据失败"];
            return ;
        }
        if (objects.count==0) {
            self.commodityTableView.footer.state = MJRefreshFooterStateNoMoreData;
        }
        else{
            if(self.lcCommoditys ==nil){
                self.lcCommoditys = [NSMutableArray array];
            }
            [self.lcCommoditys addObjectsFromArray:objects];
            self.curLoadMoreCount++;
            [self.commodityTableView reloadData];
            [self.commodityTableView.footer endRefreshing];
        }
    }];
}  

#pragma mark UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lcCommoditys.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //需动态获取高度
    CGFloat ration = kcommodityImgRation;
    return [SVGloble shareInstance].globleWidth/ration;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommodityTableViewCell *commodityCell= [tableView dequeueReusableCellWithIdentifier:@"commodityCell"];
    if(commodityCell==nil){
        commodityCell = [[CommodityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commodityCell"];
    }
    commodityCell.commodity=self.lcCommoditys[indexPath.row];
    return commodityCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommodityDetailViewController *commodityDetailVC = [[CommodityDetailViewController alloc]init];
    commodityDetailVC.lcCommodity = self.lcCommoditys[indexPath.row];
    
    [self.navigationController pushViewController:commodityDetailVC animated:YES];
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
-(void)orbtnClick:(UIButton*)button{
    OrderListViewController *orderListVC = [[OrderListViewController alloc]init];
    [self.navigationController pushViewController:orderListVC animated:YES];
}

-(void)shoppingCartBtnClick:(UIButton*)button{
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
    
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

@end
