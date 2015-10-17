//
//  PhotosUICollectionView.h
//  Burning
//
//  Created by wei_zhu on 15/6/13.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPublish.h"
#import "LCDataHelper.h"
#import "ModelTransfer.h"
#import <MJRefresh.h>
#import "LayoutConst.h"
#import "PubShowPhotoCollectionViewCell.h"
#import "SVGloble.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BaseViewController.h"
#import "PhotoDetailViewController.h"

@interface PhotosUICollectionView : UICollectionView
{
@private
    int _curLoadMoreCount;

}

@property(nonatomic,strong) LCDataHelper* lcDataHelper;

@property(nonatomic,strong)NSMutableArray *lcPublishs;

//@property(nonatomic,strong)NSMutableArray *shPublishs;

-(void)loadData;

-(void)loadMoreData;

@end
