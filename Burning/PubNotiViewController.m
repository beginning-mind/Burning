//
//  PubNotiViewController.m
//  Burning
//
//  Created by wei_zhu on 15/8/5.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "PubNotiViewController.h"
#import "PubNotiTableViewCell.h"
#import "PersonalInfoViewController.h"
#import "ActivityDetailViewController.h"
#import "PhotoDetailViewController.h"

@interface PubNotiViewController ()

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation PubNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AVIMTypedMessage *message = self.avIMMessageArray[0];
    if ([message.conversationId isEqualToString:@"activity"]) {
        [self.navigationItem setTitle:@"活动通知"];
    }
    else if([message.conversationId isEqualToString:@"publish"]){
        [self.navigationItem setTitle:@"动态通知"];
    }
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
    return [PubNotiTableViewCell calculateCellHeightWithMessage:self.avIMMessageArray[indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PubNotiTableViewCell *puborAcCell= [tableView dequeueReusableCellWithIdentifier:@"pubCell"];
    if(puborAcCell==nil){
        puborAcCell=[[PubNotiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pubCell"];
        puborAcCell.pubNotiTableViewCellDelegate = self;
    }
    puborAcCell.message=self.avIMMessageArray[indexPath.row];
    return puborAcCell;
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

#pragma mark pubNotiTableViewCellDelegate
-(void)didAvatarClick:(NSString*)userID{
    PersonalInfoViewController *personalVC = [[PersonalInfoViewController alloc]init];
    personalVC.userId = userID;
    [self.navigationController pushViewController:personalVC animated:YES];
}

-(void)didContentImageClick:(NSString*)conID objID:(NSString*)objID{
    if ([conID isEqualToString:@"activity"]) {
        ActivityDetailViewController *activityDetailVC = [[ActivityDetailViewController alloc]init];
        activityDetailVC.lcActivityObjID = objID;
        
        [self.navigationController pushViewController:activityDetailVC animated:YES];
    }
    else if([conID isEqualToString:@"publish"]){
        PhotoDetailViewController *photoDetailVC = [[PhotoDetailViewController alloc]init];
        photoDetailVC.lcpublishID = objID;
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
}

@end
