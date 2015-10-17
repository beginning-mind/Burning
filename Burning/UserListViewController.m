//
//  UserListViewController.m
//  Burning
//
//  Created by wei_zhu on 15/6/18.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "UserListViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"列表";
    self.showTabbar = NO;
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    self.userListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kStatusBarHeight-kNavigationBarHeight)];
    self.userListTableView.dataSource = self;
    self.userListTableView.delegate = self;
    
    //分割线从顶部开始画
    if ([self.userListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.userListTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.userListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.userListTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //隐藏多余的线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.userListTableView setTableFooterView:view];
    
    [self.view addSubview:self.userListTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDataSource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UserListTableViewCell calculateCellHeightWithUser:self.users[indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserListTableViewCell *userListCell= [tableView dequeueReusableCellWithIdentifier:@"userListCell"];
    if(userListCell==nil){
        userListCell=[[UserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userListCell"];
    }
    userListCell.user=self.users[indexPath.row];
    userListCell.indexPath = indexPath;
    userListCell.userListViewCellDelegate = self;
    return userListCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma userListViewDelegate Cell Delegate
-(void)didAvatarImageViewClick:(UIGestureRecognizer *)gestureRecognizer indexPath:(NSIndexPath *)indexPath{
    PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
    personalInfoVC.user = self.users[indexPath.row];
    
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

#pragma mark action

-(void)bakcClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
