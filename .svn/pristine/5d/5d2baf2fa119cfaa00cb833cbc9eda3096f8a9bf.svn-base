//
//  SVRootScrollView.h
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubShowTableView.h"
#import "PhotosUICollectionView.h"
#import <AVOSCloud/AVOSCloud.h>

@interface SVRootScrollView : UIScrollView <UIScrollViewDelegate,PubSHowTableViewDelegate,CommentViewDelegate>
{
    NSArray *viewNameArray;
    CGFloat userContentOffsetX;
    BOOL isLeftScroll;
    BOOL isVerticScroll;
}
@property (nonatomic, strong) NSArray *viewNameArray;



@property(nonatomic,strong)PhotosUICollectionView *hotCollectionView;

@property(nonatomic,strong)PubShowTableView *attetionTableView;

@property(nonatomic,strong)PubShowTableView *newlyTableView;



+ (SVRootScrollView *)shareInstance;

- (void)initWithViews;
/**
 *  加载主要内容
 */
- (void)loadData;

-(void)refresh;

@end
