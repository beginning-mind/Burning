//
//  DiscoverMainViewController.m
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "DiscoverMainViewController.h"
#import "NearlyManViewController.h"
#import "BurningNavControl.h"
#import "BuringTabBarController.h"
#import "NearlyGroupViewController.h"
#import "MoviePlayerViewController.h"
#import "NearlyActivityViewController.h"
#import "DailyNewsViewController.h"
#import "PersonNearbyViewController.h"
#import "SVGloble.h"
#import <sys/sysctl.h>
#import "CDNotify.h"
#import "REMenu.h"
#import "SearchingVC.h"
#import "AddressDetailVC.h"


@interface DiscoverMainViewController ()

@property(nonatomic,strong)UIScrollView *contentscrollView;

@property(nonatomic,strong)UIImageView *headerView;

@property(nonatomic,strong)UIImageView *nearlyPersonalImageView;

@property(nonatomic,strong)UIImageView *nearlyGroupImageView;

@property(nonatomic,strong)UIImageView *nearlyActivityImageView;

@property(nonatomic,strong)UIImageView *shareImageView;

@property(nonatomic,strong)UIButton *listAddressBtn;
@property(nonatomic,strong)UIButton *insertAddressBtn;

@property(nonatomic,strong)NSString *devModel;

@property (nonatomic, strong) CDNotify *notify;

@property (strong, readwrite, nonatomic) REMenu *menu;

@end

@implementation DiscoverMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _notify = [CDNotify sharedInstance];
        self.showTabbar = YES;
        [self setTitle:@"发现"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UIImage *searchIcon = [UIImage imageNamed:@"searching"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:searchIcon style:UIBarButtonItemStyleDone target:self action:@selector(searchingButtonClicked:)];
    self.navigationItem.rightBarButtonItem =item;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setup];
}

- (void)searchingButtonClicked:(id)sender {
    SearchingVC *searchingVC = [[SearchingVC alloc]init];
    [self.navigationController pushViewController:searchingVC animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [_notify removeDailyNewsObserver:self];
    [_notify addDailyNewsObserver:self selector:@selector(updateBadge)];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateBadge{
    BuringTabBarController *tabBarController = (BuringTabBarController*)self.tabBarController;
    tabBarController.dailyNewsbadgeValue =@"1";
}

-(void)hiddenBadge{
    BuringTabBarController *tabBarController = (BuringTabBarController*)self.tabBarController;
    tabBarController.dailyNewsbadgeValue =nil;
}

-(void)setup{
    
    [self.view addSubview:self.contentscrollView];

    [self.contentscrollView addSubview:self.headerView];
    [self.contentscrollView addSubview:self.nearlyPersonalImageView];
    [self.contentscrollView addSubview:self.nearlyGroupImageView];
    [self.contentscrollView addSubview:self.nearlyActivityImageView];
    [self.contentscrollView addSubview:self.shareImageView];
    
//    [self.contentscrollView addSubview:self.listAddressBtn];
//    [self.contentscrollView addSubview:self.insertAddressBtn];
    
    self.contentscrollView.contentSize = CGSizeMake([SVGloble shareInstance].globleWidth, CGRectGetMaxY(self.shareImageView.frame));
//    self.contentscrollView.contentSize = CGSizeMake([SVGloble shareInstance].globleWidth, CGRectGetMaxY(self.insertAddressBtn.frame));
}

#pragma mark UI
-(UIScrollView*)contentscrollView{
    if (_contentscrollView ==nil) {
        _contentscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [SVGloble shareInstance].globleWidth, [SVGloble shareInstance].globleAllHeight-kNavigationBarHeight-kStatusBarHeight-kTabBarHeight)];
        self.contentscrollView.delegate = self;
    }
    
    return _contentscrollView;
}

-(UIImageView*)headerView{
    if (_headerView==nil) {
        UIImage *image = [UIImage imageNamed:@"slogan1"];
        CGFloat imgW= image.size.width;
        CGFloat imgH = image.size.height;
        CGFloat ration = imgW/imgH;
        CGFloat w = [SVGloble shareInstance].globleWidth;
        CGFloat h = w/ration;
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
        _headerView.image = image;
    }
    return _headerView;
}

-(UIImageView*)nearlyPersonalImageView{
    if (_nearlyPersonalImageView==nil) {
        UIImage *image = [UIImage imageNamed:@"ds_nearlyP_4s.jpg"];
        CGFloat imgW= image.size.width;
        CGFloat imgH = image.size.height;
        CGFloat ration = imgW/imgH;
        CGFloat w = [SVGloble shareInstance].globleWidth;
        CGFloat h = w/ration;
        _nearlyPersonalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), w, h)];
        _nearlyPersonalImageView.image = image;
        _nearlyPersonalImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nearlyPersonClick:)];
        [_nearlyPersonalImageView addGestureRecognizer:singleTap];
    }
    
    return _nearlyPersonalImageView;
}

-(UIImageView*)nearlyGroupImageView{
    if (_nearlyGroupImageView==nil) {
        UIImage *image = [UIImage imageNamed:@"ds_nearlyG_4s.jpg"];
        CGFloat imgW= image.size.width;
        CGFloat imgH = image.size.height;
        CGFloat ration = imgW/imgH;
        CGFloat w = [SVGloble shareInstance].globleWidth;
        CGFloat h = w/ration;
        _nearlyGroupImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nearlyPersonalImageView.frame)+5, w, h)];
        _nearlyGroupImageView.image = image;
        _nearlyGroupImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nearlyGroupClick:)];
        [_nearlyGroupImageView addGestureRecognizer:singleTap];
    }
    
    return _nearlyGroupImageView;
}

-(UIImageView*)nearlyActivityImageView{
    if (_nearlyActivityImageView ==nil) {
        UIImage *image = [UIImage imageNamed:@"ds_nearlyA_4s.jpg"];
        CGFloat imgW= image.size.width;
        CGFloat imgH = image.size.height;
        CGFloat ration = imgW/imgH;
        CGFloat w = [SVGloble shareInstance].globleWidth;
        CGFloat h = w/ration;
        _nearlyActivityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nearlyGroupImageView.frame)+5, w, h)];
        _nearlyActivityImageView.image = image;
        _nearlyActivityImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nearlyActivityClick:)];
        [_nearlyActivityImageView addGestureRecognizer:singleTap];
    }
    
    return _nearlyActivityImageView;
}

-(UIImageView*)shareImageView{
    if (_shareImageView==nil) {
        UIImage *image = [UIImage imageNamed:@"ds_share_4s.jpg"];
        CGFloat imgW= image.size.width;
        CGFloat imgH = image.size.height;
        CGFloat ration = imgW/imgH;
        CGFloat w = [SVGloble shareInstance].globleWidth;
        CGFloat h = w/ration;
        _shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nearlyActivityImageView.frame)+5, w, h)];
        _shareImageView.image = image;
        _shareImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareClick:)];
        [_shareImageView addGestureRecognizer:singleTap];
    }
    return _shareImageView;
}

-(UIButton*)listAddressBtn{
    if (_listAddressBtn==nil) {
        _listAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shareImageView.frame)+5, 200, 100)];
        //_testAddressBtn.image = image;
        _listAddressBtn.userInteractionEnabled = YES;
        [_listAddressBtn setTitle:@"收货人地址列表" forState:UIControlStateNormal];
        [_listAddressBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listUserAddress:)];
        [_listAddressBtn addGestureRecognizer:singleTap];
    }
    return _listAddressBtn;
}


-(UIButton*)insertAddressBtn{
    if (_insertAddressBtn==nil) {
        _insertAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shareImageView.frame)+80, 200, 100)];
        //_testAddressBtn.image = image;
        _insertAddressBtn.userInteractionEnabled = YES;
        [_insertAddressBtn setTitle:@"添加收货人地址" forState:UIControlStateNormal];
        [_insertAddressBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addUserAddress:)];
        [_insertAddressBtn addGestureRecognizer:singleTap];
    }
    return _insertAddressBtn;
}

#pragma mark action
-(void)nearlyPersonClick:(UIGestureRecognizer*)gestureRecognizer{
    PersonNearbyViewController *personNearbyViewController = [[PersonNearbyViewController alloc]init];
    [self.navigationController pushViewController:personNearbyViewController animated:YES];
}

-(void)nearlyGroupClick:(UIGestureRecognizer*)gestureRecognizer{
    NearlyGroupViewController *nearlyGroupViewController = [[NearlyGroupViewController alloc]init];
    [self.navigationController pushViewController:nearlyGroupViewController animated:YES];
}

-(void)nearlyActivityClick:(UIGestureRecognizer*)gestureRecognizer{
    NearlyActivityViewController *nearlyActivityVC =[[NearlyActivityViewController alloc]init];
    [self.navigationController pushViewController:nearlyActivityVC animated:YES];
}

-(void)shareClick:(UIGestureRecognizer*)gestureRecognizer{
    [self hiddenBadge];
    DailyNewsViewController *dailyNewsVC = [[DailyNewsViewController alloc]init];
    [self.navigationController pushViewController:dailyNewsVC animated:YES];
}

-(void)listUserAddress:(UIGestureRecognizer*)gestureRecognizer {
    
}

-(void)addUserAddress:(UIGestureRecognizer*)gestureRecognizer {
    AddressDetailVC *addressDetailVC = [[AddressDetailVC alloc]init];
    addressDetailVC.content = @"";
    [self.navigationController pushViewController:addressDetailVC animated:YES];
}

@end