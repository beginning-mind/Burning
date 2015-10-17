//
//  PersonNearbyViewController.m
//  Burning
//
//  Created by Xiang Li on 15/7/29.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "PersonNearbyViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CDIM.h"
#import <MJRefresh.h>
#import "PersonNearbyTableViewCell.h"
#import "PersonalInfoViewController.h"
#import <JZLocationConverter.h>
#import "SVGloble.h"

#define LOADCOUNT 10

//@implementation CLLocationManager (TemporaryHack)
//
////模拟器测试用
//- (void)hackLocationFix
//{
//    //CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
//    float latitude = 39.906811;
//    float longitude = 116.377586;  //这里可以是任意的经纬度值
//    CLLocation *location= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    //    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:nil];
//    [[self delegate] locationManager:self didUpdateLocations:[NSArray arrayWithObject:location]];
//}
//
//-(void)startUpdatingLocation
//{
//    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
//}
//
//@end

@interface PersonNearbyViewController ()<CLLocationManagerDelegate, UITableViewDataSource, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *curLocation;

@property (nonatomic,strong) NSMutableArray *avUsers;
@property (nonatomic,assign) NSInteger curLoadOldCount;
@property (nonatomic,strong) NSString *genderFilter;
@property (nonatomic, strong) CDIM *im;

@property(nonatomic,strong)UITableView *personNearbyTableView;

@property(nonatomic,strong)UILabel *unLocationPromtLable;

@end

@implementation PersonNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationBar];
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.personNearbyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kStatusBarHeight-kNavigationBarHeight)];
    [self.view addSubview:self.personNearbyTableView];
    self.personNearbyTableView.dataSource = self;
    self.personNearbyTableView.delegate = self;
    _im = [CDIM sharedInstance];
    
    //分割线从最左边画
    if ([self.personNearbyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.personNearbyTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.personNearbyTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.personNearbyTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.personNearbyTableView.separatorColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.90 alpha:1.0];
    
    //空余cell没有分割线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.personNearbyTableView setTableFooterView:view];
    
    _genderFilter = @"";
    [self.personNearbyTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadUserData)];
    [self.personNearbyTableView.header setTitle:@"加载中..." forState:MJRefreshHeaderStateRefreshing];
    [self.personNearbyTableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.personNearbyTableView.header setTitle:@"松开刷新数据" forState:MJRefreshHeaderStatePulling];
    self.personNearbyTableView.header.font = [UIFont systemFontOfSize:kCommonFontSize];
    self.personNearbyTableView.header.textColor = RGB(133, 133, 133);
    
    [self.personNearbyTableView.header setUpdatedTimeHidden:YES];
    //    [self.personNearbyTableView.header beginRefreshing];
    
    //footRefresh
    [self.personNearbyTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadOldUserData)];
    [self.personNearbyTableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [self.personNearbyTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [self.personNearbyTableView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
    self.personNearbyTableView.footer.font= [UIFont systemFontOfSize:kCommonFontSize];
    self.personNearbyTableView.footer.textColor = RGB(133, 133, 133);
    
    CLAuthorizationStatus status =  [CLLocationManager authorizationStatus];
    if (status ==2) {
        self.unLocationPromtLable.hidden = NO;
    }
    else{
        self.unLocationPromtLable.hidden = YES;
        
        //headRefresh
        [self startLocations];
    }
    
    
}

-(void)setNavgationBar {
    [self.navigationItem setTitle:@"附近的人"];
    
    UIImage *_filterIcon = [UIImage imageNamed:@"filter"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:_filterIcon style:UIBarButtonItemStyleDone target:self action:@selector(filterPerson:)];
    self.navigationItem.rightBarButtonItem =item;
}

-(void)filterPerson:(id)sender{
    UIActionSheet *sheet;
    sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"只看女生",@"只看男生",@"查看全部", nil];
    sheet.tag = 257;
    [sheet showInView:self.view];
}

-(UILabel*)unLocationPromtLable{
    
    if (_unLocationPromtLable==nil) {
        _unLocationPromtLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, [SVGloble shareInstance].globleWidth, 100)];
        _unLocationPromtLable.text = @"无法获取你的位置信息。\n请到手机系统的[设置]->[隐私]->[定\n位服务]中打开定位服务，并允许Burning\n使用定位服务";
        _unLocationPromtLable.textColor = [UIColor blackColor];
        _unLocationPromtLable.font = [UIFont systemFontOfSize:14];
        _unLocationPromtLable.textAlignment = NSTextAlignmentCenter;
        _unLocationPromtLable.numberOfLines = 0;
        [self.view addSubview:_unLocationPromtLable];
    }
    return _unLocationPromtLable;
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 257) {
        NSUInteger sourceType = 0;
        switch (buttonIndex) {
            case 0:
                return;
            case 1:
                _genderFilter = @"0";
                break;
            case 2:
                _genderFilter = @"1";
                break;
            case 3:
                _genderFilter = @"";
                break;
        }
        [self loadUserData];
    }
}


-(void)startLocations{
    self.locationManager = [[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization]; // 永久授权
            [self.locationManager requestWhenInUseAuthorization]; //使用中授权
        }
        
        [self.locationManager startUpdatingLocation];
    }
    else {
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
}

-(void)writeLocation {
    CLLocationCoordinate2D baiduCoordinate2D = [JZLocationConverter wgs84ToBd09:_curLocation.coordinate];
    
    double latitude = baiduCoordinate2D.latitude;
    double longitude = baiduCoordinate2D.longitude;
    
    AVGeoPoint *point =  [AVGeoPoint geoPointWithLatitude:latitude longitude:longitude];
    if (point) {
        AVUser *currUser = [AVUser currentUser];
        [currUser setObject:point forKey:@"location"];
        WEAKSELF
        [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [self alert:@"写入地理位置失败"];
                [weakSelf.personNearbyTableView.header endRefreshing];
            }
        }];
    }
}

-(CLLocation *)constructWithCoordinate:(CLLocationCoordinate2D)coordinate {
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadUserData{
    WEAKSELF
    CLAuthorizationStatus status =  [CLLocationManager authorizationStatus];
    if (status ==2) {
        self.unLocationPromtLable.hidden = NO;
        weakSelf.avUsers = nil;
        [weakSelf.personNearbyTableView.header endRefreshing];
        [weakSelf.personNearbyTableView reloadData];
        return;
    }
    self.unLocationPromtLable.hidden = YES;
    [self.lcDataHelper getPersonNearbyWithLimit:LOADCOUNT skip:0 latitude:_curLocation.coordinate.latitude longitude:_curLocation.coordinate.longitude andGender:_genderFilter block:^(NSArray *objects, NSError *error) {//0女，1男，“”全部
        if (error) {
            [weakSelf alert:@"获取附近的人失败"];
            [weakSelf.personNearbyTableView.header endRefreshing];
        } else {
            _avUsers = [objects mutableCopy];
            
            weakSelf.curLoadOldCount  = 1;
            [weakSelf.personNearbyTableView reloadData];
            [weakSelf.personNearbyTableView.header endRefreshing];
            if (objects.count<LOADCOUNT) {
                weakSelf.personNearbyTableView.footer.state = MJRefreshFooterStateNoMoreData;
            }
            else{
                weakSelf.personNearbyTableView.footer.state = MJRefreshFooterStateIdle;
            }
        }
    }];
}

-(void)loadOldUserData {
    WEAKSELF
    CLAuthorizationStatus status =  [CLLocationManager authorizationStatus];
    if (status ==2) {
        self.unLocationPromtLable.hidden = NO;
        weakSelf.avUsers = nil;
        [weakSelf.personNearbyTableView.footer endRefreshing];
        [weakSelf.personNearbyTableView reloadData];
        return;
    }
    self.unLocationPromtLable.hidden = YES;
    [self.lcDataHelper getPersonNearbyWithLimit:LOADCOUNT skip:LOADCOUNT*self.curLoadOldCount latitude:_curLocation.coordinate.latitude longitude:_curLocation.coordinate.longitude andGender:@"" block:^(NSArray *objects, NSError *error) {//0女，1男，“”全部
        if (error) {
            [weakSelf alert:@"获取附近的人失败"];
        } else {
            if (objects.count==0) {
                [weakSelf.personNearbyTableView.footer setHidden:YES];
                weakSelf.personNearbyTableView.footer.state = MJRefreshFooterStateNoMoreData;
            }else {
                if (weakSelf.avUsers == nil) {
                    weakSelf.avUsers = [NSMutableArray array];
                }
                [_avUsers addObjectsFromArray:objects];
                weakSelf.curLoadOldCount++;
                [weakSelf.personNearbyTableView reloadData];
                [weakSelf.personNearbyTableView.footer endRefreshing];
            }
        }
    }];
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _curLocation = [locations lastObject];
    [manager stopUpdatingLocation];
    [self writeLocation];
    [self loadUserData];
}

#pragma mark TableViewDataSource delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _avUsers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PersonNearbyTableViewCell calculateCellHeightWithUser:self.avUsers[indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonNearbyTableViewCell *personNearbyTableViewCell= [tableView dequeueReusableCellWithIdentifier:@"personNearbyTableViewCell"];
    if(personNearbyTableViewCell==nil){
        personNearbyTableViewCell = [[PersonNearbyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personNearbyTableViewCell"];
    }
    personNearbyTableViewCell.avUser=self.avUsers[indexPath.row];
    personNearbyTableViewCell.currentLocation = _curLocation;
    return personNearbyTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalInfoViewController *personalInfoViewController = [[PersonalInfoViewController alloc]init];
    personalInfoViewController.user = self.avUsers[indexPath.row];
    [self.navigationController pushViewController:personalInfoViewController animated:YES];
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



@end
