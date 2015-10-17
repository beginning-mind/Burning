//
//  PesonalInfoViewController.m
//  Burning
//
//  Created by wei_zhu on 15/6/15.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "ModelTransfer.h"
#import <MJRefresh.h>
#import "LCDataHelper.h"
#import "CommentViewController.h"
#import "PersonalInfoHeaderView.h"
#import "SettingsViewController.h"

#define LOADCOUNT 10

@interface PersonalInfoViewController ()<PubSHowTableViewDelegate>

@property(nonatomic,strong)PersonalInfoHeaderView *personalInfoHeaderView;

@end

@implementation PersonalInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.showTabbar) {
        self.personalInfolTableView = [[PubShowTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kTabBarHeight-kNavigationBarHeight-kStatusBarHeight)];
    }
    else{
        self.personalInfolTableView = [[PubShowTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kNavigationBarHeight-kStatusBarHeight)];
    }

    self.personalInfoHeaderView.backgroundColor = [UIColor whiteColor];
//    self.personalInfolTableView.tableHeaderView = self.personalInfoHeaderView;
    //self.personalInfoHeaderView.user = self.user;
    self.personalInfolTableView.pubShowTableViewDelegate = self;
    [self.view addSubview:self.personalInfolTableView];

    //headRefresh
    [self.personalInfolTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //__weak typeof(self) weakSelf = self;
    [self.personalInfolTableView.header setTitle:@"加载中..." forState:MJRefreshHeaderStateRefreshing];
    [self.personalInfolTableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.personalInfolTableView.header setTitle:@"松开刷新数据" forState:MJRefreshHeaderStatePulling];
    self.personalInfolTableView.header.font = [UIFont systemFontOfSize:kCommonFontSize];
    self.personalInfolTableView.header.textColor = RGB(133, 133, 133);
    [self.personalInfolTableView.header setUpdatedTimeHidden:YES];
    [self.personalInfolTableView.header beginRefreshing];
    
    //footRefresh
    [self.personalInfolTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.personalInfolTableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [self.personalInfolTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [self.personalInfolTableView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
    self.personalInfolTableView.footer.font= [UIFont systemFontOfSize:kCommonFontSize];
    self.personalInfolTableView.footer.textColor = RGB(133, 133, 133);
    [self setNavgationBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.user==nil) {
        NSError *err;
        AVQuery *q = [AVUser query];
        [q setCachePolicy:kAVCachePolicyNetworkElseCache];
        if(self.userId==nil){
            [q whereKey:@"username" equalTo:self.userName];
            NSArray *arry = [q findObjects:&err];
            if (arry.count>0) {
                self.user = arry[0];
            }
            else{
                [self alert:@"获取数据失败, 请重试 :)"];
                return;
            }
        }
        else{
            self.user = [q getObjectWithId:self.userId error:&err];
        }
        if (err) {
            [self alert:@"获取数据失败, 请重试 :)"];
            return;
        }
    }
    self.personalInfoHeaderView.user = self.user;
    [self.personalInfolTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PersonalInfoHeaderView*)personalInfoHeaderView{
    if (self.user==nil) {
        NSError *err;
        AVQuery *q = [AVUser query];
        [q setCachePolicy:kAVCachePolicyNetworkElseCache];
        if(self.userId==nil){
            [q whereKey:@"username" equalTo:self.userName];
            NSArray *arry = [q findObjects:&err];
            if (arry.count>0) {
                self.user = arry[0];
            }
            else{
                [self alert:@"获取数据失败, 请重试 :)"];
            }
        }
        else{
            self.user = [q getObjectWithId:self.userId error:&err];
        }
        if (err) {
            [self alert:@"获取数据失败, 请重试 :)"];
        }
    }
    NSString *signature = [self.user objectForKey:@"signature"];
    CGFloat height = [PersonalInfoHeaderView calculateHeightWithSignature:signature];
    if (_personalInfoHeaderView ==nil) {
        _personalInfoHeaderView = [[PersonalInfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
    }
    else{
        _personalInfoHeaderView.frame =CGRectMake(0, 0, self.view.bounds.size.width, height);
    }
    [self.personalInfolTableView beginUpdates];
    self.personalInfolTableView.tableHeaderView = _personalInfoHeaderView;
    [self.personalInfolTableView endUpdates];
    return  _personalInfoHeaderView;
}

-(void)setNavgationBar{
    NSString *curUserId;
    if (self.user==nil) {
        curUserId = self.userId;
    }
    else{
        curUserId = self.user.objectId;
    }
    if ([curUserId isEqualToString:[AVUser currentUser].objectId] || [self.userName isEqual:[AVUser currentUser].username]) {
        [self.navigationItem setTitle:@"我"];
        UIImage *_settingsIcon = [UIImage imageNamed:@"settings"];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:_settingsIcon style:UIBarButtonItemStyleDone target:self action:@selector(goSetting:)];
        self.navigationItem.rightBarButtonItem =item;
        
//        self.personalInfolTableView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height);
        
    }else {
        [self.navigationItem setTitle:@"个人动态"];
        
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"举报" style:UIBarButtonItemStylePlain target:self action:@selector(reportBtn:)];
        rightBarItem.tintColor = RGB(199, 199, 199);
        self.navigationItem.rightBarButtonItem = rightBarItem;
//        self.personalInfolTableView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    }
}

-(void)goSetting:(id)sender {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc]init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

-(void)loadData{
    [self.personalInfolTableView.footer endRefreshing];
    self.personalInfolTableView.footer.state = MJRefreshFooterStateNoMoreData;
    if (self.user==nil) {
        NSError *err;
        AVQuery *q = [AVUser query];
        [q setCachePolicy:kAVCachePolicyNetworkElseCache];
        if(self.userId==nil){
            [q whereKey:@"username" equalTo:self.userName];
            NSArray *arry = [q findObjects:&err];
            if (arry.count>0) {
                self.user = arry[0];
            }
            else{
                [self alert:@"获取数据失败, 请重试 :)"];
                return;
            }
        }
        else{
            self.user = [q getObjectWithId:self.userId error:&err];
        }
        
        if (err) {
            [self alert:@"获取数据失败, 请重试 :)"];
            return;
        }
    }
    [self.lcDataHelper getPublishsWithUser:self.user limit:LOADCOUNT skip:0 block:^(NSArray *objects, NSError *error) {
        if (error) {
            [self.personalInfolTableView.header endRefreshing];
            [self alert:@"获取数据失败, 请重试 :)"];
            return ;
        }
        self.personalInfolTableView.lcPublishs = [objects mutableCopy];
        self.personalInfolTableView.curLoadMoreCount =1;
        [self.personalInfolTableView reloadData];
        [self.personalInfolTableView.header endRefreshing];
        if (objects.count<LOADCOUNT) {
            self.personalInfolTableView.footer.state = MJRefreshFooterStateNoMoreData;
        }
        else{
            self.personalInfolTableView.footer.state = MJRefreshFooterStateIdle;
        }
    }];
}

-(void)loadMoreData{
    if (self.user==nil) {
        NSError *err;
        AVQuery *q = [AVUser query];
        [q setCachePolicy:kAVCachePolicyNetworkElseCache];
        if(self.userId==nil){
            [q whereKey:@"username" equalTo:self.userName];
            NSArray *arry = [q findObjects:&err];
            if (arry.count>0) {
                self.user = arry[0];
            }
            else{
                [self alert:@"获取数据失败, 请重试 :)"];
                return;
            }
        }
        else{
            self.user = [q getObjectWithId:self.userId error:&err];
        }
        if (err) {
            [self alert:@"获取数据失败, 请重试 :)"];
            return;
        }
    }
    [self.lcDataHelper getPublishsWithUser:self.user limit:LOADCOUNT skip:LOADCOUNT*self.personalInfolTableView.curLoadMoreCount block:^(NSArray *objects, NSError *error) {
        if (error) {
            [self.personalInfolTableView.footer endRefreshing];
            [self alert:@"获取数据失败, 请重试 :)"];
            return ;
        }
        if (objects.count==0) {
            self.personalInfolTableView.footer.state = MJRefreshFooterStateNoMoreData;
        }
        else{
            if(self.personalInfolTableView.lcPublishs ==nil){
                self.personalInfolTableView.lcPublishs = [NSMutableArray array];
            }
            for(LCPublish *lcPublish in objects){
                [self.personalInfolTableView.lcPublishs addObject:lcPublish];
            }
            self.personalInfolTableView.curLoadMoreCount++;
            [self.personalInfolTableView reloadData];
            [self.personalInfolTableView.footer endRefreshing];
        }
    }];
}

#pragma mark action
-(void)reportBtn:(UIButton*)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"举报" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"色情相关",@"违法违规",@"垃圾广告", nil];
    [sheet showInView:self.view];
}

#pragma mark PubShowTableView Delegate
-(void)didDigUserImageViewClickUser:(AVUser *)user{
    PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
    personalInfoVC.user = user;
    
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

-(void)didCommentButtonClick:(NSIndexPath *)indexPath commentUserIndex:(NSInteger)commentUserIndex{
    CommentViewController *commentViewController = [[CommentViewController alloc]init];
    commentViewController.commentViewDelegate = self;
    commentViewController.indexPath = indexPath;
    commentViewController.publish = self.personalInfolTableView.lcPublishs[indexPath.row];
    commentViewController.commentUserIndex = commentUserIndex;
    [self.navigationController pushViewController:commentViewController animated:YES];
}

-(void)didLikeButtonClick:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    self.personalInfolTableView.selectedIndexPath = indexPath;
    [self.personalInfolTableView addLike];
}

-(void)didDeletePubButtonClickindexPath:(NSIndexPath *)indexPath{
    [self.personalInfolTableView.lcPublishs removeObjectAtIndex:indexPath.row];
    [self.personalInfolTableView reloadData];
}

#pragma mark commentViewDelegat
-(void)ReloadTableViewCellForIndex:(NSIndexPath *)indexPath{
    [self.personalInfolTableView reloadLCPublish:self.personalInfolTableView.lcPublishs[indexPath.row] AtIndexPath:indexPath];
}

#pragma mark actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *reportUserId = [AVUser currentUser].objectId;
    NSString *reportedUserId = self.user.objectId;
    NSString *publishId = @"0";
    NSInteger reportType;
    switch (buttonIndex) {
        case 0:
            // 取消
            return;
        case 1:
            // 色情相关
            reportType = 0;
            break;
        case 2:
            // 违法违规
            reportType = 1;
            break;
        case 3:
            //垃圾广告
            reportType = 2;
            break;
    }
    NSError* error;
    LCDataHelper *lcDataHelper = [[LCDataHelper alloc]init];
    [lcDataHelper upLoadReport:reportUserId reportedUserID:reportedUserId publishID:publishId reportType:reportType error:&error];
    if (error==nil) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:@"举报成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerView show];
    }
    else{
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:nil message:@"举报失败,请检查网络!" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alerView show];
    }
}

@end
