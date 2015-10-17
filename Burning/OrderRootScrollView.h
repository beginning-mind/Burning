//
//  OrderRootScrollView.h
//  Burning
//
//  Created by wei_zhu on 15/9/1.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderRootScrollView : UIScrollView
{
    NSArray *viewNameArray;
    CGFloat userContentOffsetX;
    BOOL isLeftScroll;
    BOOL isVerticScroll;
}

@property (nonatomic, strong) NSArray *viewNameArray;




+ (OrderRootScrollView *)shareInstance;

- (void)initWithViews;

/**
 *  加载主要内容
 */
- (void)loadData;

-(void)refresh;

@end
