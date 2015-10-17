//
//  PhotoDetailViewController.m
//  Burning
//
//  Created by wei_zhu on 15/6/12.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "PersonalInfoViewController.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态详情";
    
    self.photoDetailTableView = [[PubShowTableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-kNavigationBarHeight-kStatusBarHeight)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.photoDetailTableView];
    
    if (self.lcPublishs ==nil) {
        [self.lcDataHelper getPublishWithObjectId:self.lcpublishID block:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count==0) {
                    [self alert:@"该条记录已被用户删除 :)"];
                }
                else{
                    self.lcPublishs = [NSMutableArray array];
                    [self.lcPublishs addObjectsFromArray:objects];
                    self.photoDetailTableView.lcPublishs  = self.lcPublishs;
                    self.photoDetailTableView.pubShowTableViewDelegate = self;
                    [self.photoDetailTableView reloadData];
                }
            }
            else{
                [self alert:@"获取数据失败, 请重试 :)"];
            }
        }];
    }
    else{
        self.photoDetailTableView.lcPublishs  = self.lcPublishs;
        self.photoDetailTableView.pubShowTableViewDelegate = self;
        [self.photoDetailTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backClick:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark pubShowTableViewDelegate

-(void)didAvatarImageViewClickUser:(AVUser *)user{
    PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
    personalInfoVC.user = user;
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

-(void)didDigUserImageViewClickUser:(AVUser *)user{
    PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
    personalInfoVC.user = user;
    
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

-(void)didCommentButtonClick:(NSIndexPath *)indexPath commentUserIndex:(NSInteger)commentUserIndex{
    CommentViewController *commentViewController = [[CommentViewController alloc]init];
    commentViewController.commentViewDelegate = self;
    commentViewController.indexPath = indexPath;
    commentViewController.publish = self.lcPublishs[indexPath.row];
    commentViewController.commentUserIndex = commentUserIndex;
    [self.navigationController pushViewController:commentViewController animated:YES];
}

-(void)didLikeButtonClick:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
        self.photoDetailTableView.selectedIndexPath = indexPath;
    [self.photoDetailTableView addLike];
}

-(void)didDeletePubButtonClickindexPath:(NSIndexPath *)indexPath{
    [self.photoDetailTableView.lcPublishs removeObjectAtIndex:indexPath.row];
    [self.photoDetailTableView reloadData];
}

#pragma mark commentViewDelegat
-(void)ReloadTableViewCellForIndex:(NSIndexPath *)indexPath{
    [self.photoDetailTableView reloadLCPublish:self.photoDetailTableView.lcPublishs[indexPath.row] AtIndexPath:indexPath];
}

@end
