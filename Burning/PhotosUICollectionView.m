//
//  PhotosUICollectionView.m
//  Burning
//
//  Created by wei_zhu on 15/6/13.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "PhotosUICollectionView.h"

#define HOTPHOTOLOADCOUNT 15
static NSString *collectionCellIdentifer = @"collectioncell1";

@implementation PhotosUICollectionView


-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    self.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate = self;
    
    [self registerClass:[PubShowPhotoCollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifer];
    return  self;
}

- (UIViewController*)getSuperViewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

-(void)loadData{
    [self.lcDataHelper getHotPhotoWithlimit:(NSInteger*)HOTPHOTOLOADCOUNT block:^(NSArray *objects, NSError *error) {
        if (error) {
            return ;
        }
        _lcPublishs = [objects mutableCopy];
        _curLoadMoreCount =1;
        [self reloadData];
        [self.header endRefreshing];
        if (objects.count<HOTPHOTOLOADCOUNT) {
            self.footer.state = MJRefreshFooterStateNoMoreData;
        }
        else{
            self.footer.state = MJRefreshFooterStateIdle;
        }
    }];
}

-(void)loadMoreData{
    [self.lcDataHelper getHotPhotoWithlimit:HOTPHOTOLOADCOUNT skip:HOTPHOTOLOADCOUNT*_curLoadMoreCount block:^(NSArray *objects, NSError *error) {
        if (error) {
            return;
        }
        if (objects.count==0) {
            self.footer.state = MJRefreshFooterStateNoMoreData;
        }
        else{
            if(self.lcPublishs ==nil){
                self.lcPublishs = [NSMutableArray array];
            }
            [self.lcPublishs addObjectsFromArray:objects];
            _curLoadMoreCount++;
            [self reloadData];
            [self.footer endRefreshing];
        }

    }];
}

#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.lcPublishs.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PubShowPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifer forIndexPath:indexPath];
    
    CGFloat cellSize = (CGRectGetWidth([[UIScreen mainScreen] bounds])-2*kPubShowPhotoInset)/3;
    if(cell==nil){
        cell=[[PubShowPhotoCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, cellSize, cellSize)];
    }
    LCPublish *curLCPublis =  self.lcPublishs[indexPath.row];
    AVFile *photo = curLCPublis.publishPhotos[0];
    [cell.photoImageView sd_cancelCurrentImageLoad];
//    NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.url]];
//    NSLog(@"-----data.size:%lu",(unsigned long)data.length);
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:photo.url]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BaseViewController *superViewController = (BaseViewController*)[self getSuperViewController];
    PhotoDetailViewController *photoDetailVC = [[PhotoDetailViewController alloc]init];
    
    NSMutableArray *lcPublishs = [NSMutableArray array];
    [lcPublishs addObject:self.lcPublishs[indexPath.row]];
    photoDetailVC.lcPublishs = lcPublishs;
    
    [superViewController.navigationController pushViewController:photoDetailVC animated:YES];
}

#pragma mark -FlowLayout Delegate
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize finalSize = CGSizeMake(([SVGloble shareInstance].globleWidth-2.0)/3.0, ([SVGloble shareInstance].globleWidth-2.0)/3.0);
    return finalSize;
}

#pragma mar - Data Propertys
-(LCDataHelper*)lcDataHelper{
    if (_lcDataHelper==nil) {
        _lcDataHelper = [[LCDataHelper alloc]init];
    }
    return _lcDataHelper;
}


@end
