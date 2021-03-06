//
//  FollowNotiViewController.m
//  Burning
//
//  Created by wei_zhu on 15/8/5.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "FollowNotiViewController.h"
#import "FollowNotiTableViewCell.h"
#import "PersonalInfoViewController.h"

@interface FollowNotiViewController ()

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation FollowNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"关注提醒"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //分割线从顶部开始画
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //隐藏多余的线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    [self.tableView reloadData];
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
    return self.avIMMessageArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FollowNotiTableViewCell calculateCellHeightWithMessage:self.avIMMessageArray[indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FollowNotiTableViewCell *followCell= [tableView dequeueReusableCellWithIdentifier:@"followCell"];
    if(followCell==nil){
        followCell=[[FollowNotiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"followCell"];
        followCell.followNotiTableViewCellDelegate = self;
    }
    followCell.message=self.avIMMessageArray[indexPath.row];
    return followCell;
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

#pragma mark followNotiTableViewCellDelegate
-(void)didSendNoti:(AVUser*)toUser{
    NSString *deviceToken = [toUser objectForKey:@"deviceToken"];
    if (deviceToken!=nil) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:1],@"content-available",
                              @"4",@"type",
                              [AVUser currentUser].objectId,@"userId",
                              nil];
        [self PushNewsWithData:data deviceToke:deviceToken Chanell:@"SysNoti"];
    }
}

-(void)didAvatarClick:(NSString*)userID{
    PersonalInfoViewController *personalVC = [[PersonalInfoViewController alloc]init];
    personalVC.userId = userID;
    [self.navigationController pushViewController:personalVC animated:YES];
}


@end
