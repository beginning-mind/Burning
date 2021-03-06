//
//  BodyBuildingMainViewController.m
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BodyBuildingMainViewController.h"
#import "BurningNavControl.h"
#import "BodyBuildingGroupTableCell.h"
#import "LCBodyBuilding.h"
#import "SHBodyBuilding.h"
#import <MJRefresh.h>
#import "ModelTransfer.h"
#import "BodyBuildingViewController.h"
#import "SVGloble.h"

@interface BodyBuildingMainViewController ()

@property(nonatomic,strong)NSMutableArray *shBodyBuildingGroups;

@property(nonatomic,strong)NSMutableArray *lcBodyBuildings;

@property(nonatomic,strong)UIImageView *headerView;

@end

@implementation BodyBuildingMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showTabbar = YES;
        [self setTitle:@"课程"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;
    //和heightForHeaderInSection配合设置间隔
//    self.tableView.sectionFooterHeight=0;
    self.tableView.sectionHeaderHeight =0;
    
    //headRefresh
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //__weak typeof(self) weakSelf = self;
    [self.tableView.header setTitle:@"加载中..." forState:MJRefreshHeaderStateRefreshing];
    [self.tableView.header setUpdatedTimeHidden:YES];
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView*)headerView{

    if (_headerView ==nil) {
        UIImage *image = [UIImage imageNamed:@"slogan2"];
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

-(void)loadData{
    [self.lcDataHelper getBodyBuildingBlock: ^(NSArray *objects, NSError *error) {
        if (error) {
            [self.tableView.header endRefreshing];
            return ;
        }
        self.lcBodyBuildings = [objects mutableCopy];
        NSMutableArray *curBodyBuildingGroups = [NSMutableArray array];
        NSMutableArray *groupArry =[NSMutableArray array];
        for (LCBodyBuilding *lcBodyBuilding in objects) {
            NSString *curGroup = lcBodyBuilding.group;
            if (![groupArry containsObject:curGroup]) {
                [curBodyBuildingGroups addObject:[ModelTransfer lcBodyBuildingToSHBodyBuildingGroup:lcBodyBuilding]];
                [groupArry addObject:curGroup];
            }
        }
        self.shBodyBuildingGroups = curBodyBuildingGroups;
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.shBodyBuildingGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    SHBodyBuildingGroup *curShBodyBuilding =self.shBodyBuildingGroups[indexPath.section];
//    
//    AVFile *backFile = curShBodyBuilding.backFile;
//    NSString *sizestr = [backFile.metaData valueForKey:@"imgSize"];
//    NSArray *sizeArry = [sizestr componentsSeparatedByString:@","];
//    NSString *wStr = sizeArry[0];
//    CGFloat imgW  =wStr.floatValue;
//    NSString *hstr = sizeArry[1];
//    CGFloat imgH = hstr.floatValue;
//    CGFloat ration = imgW/imgH;
    CGFloat ration = 2.72;
    return [SVGloble shareInstance].globleWidth/ration;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BodyBuildingGroupTableCell *bodyBuildingCell= [tableView dequeueReusableCellWithIdentifier:@"bodyGroupCell"];
    if(bodyBuildingCell==nil){
        bodyBuildingCell = [[BodyBuildingGroupTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bodyGroupCell"];
    }
    bodyBuildingCell.shBodyBuildingGroup=self.shBodyBuildingGroups[indexPath.section];
    return bodyBuildingCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SHBodyBuildingGroup *curShBodyBuilding = self.shBodyBuildingGroups[indexPath.section];
    NSString *group = curShBodyBuilding.group;
    NSMutableArray *shBodyBuildings = [NSMutableArray array];
    for (LCBodyBuilding *curlcBodyBuilding in self.lcBodyBuildings) {
        NSString *curGroup = curlcBodyBuilding.group;
        if ([group isEqual:curGroup]) {
            [shBodyBuildings addObject:[ModelTransfer lcBodyBuildingToSHBodyBuilding:curlcBodyBuilding]];
        }
    }
    BodyBuildingViewController *bodyBuildingViewController = [[BodyBuildingViewController alloc]init];
    bodyBuildingViewController.shBodyBuildings = shBodyBuildings;
    [self.navigationController pushViewController:bodyBuildingViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return 5.0;
}

@end
