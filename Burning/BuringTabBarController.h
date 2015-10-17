//
//  BuringTabBarController.h
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BuringTabBarController : UITabBarController
{
    @private
    UIImageView *_selectedView;
    UIView *_tabBarBg;
    UIButton *_seletedBtn;
    CGRect _rect;
}

-(void)showTabbar;
-(void)hiddenTabbar;
-(void)reloadData;
-(void)unloadData;
@property(nonatomic,strong) NSString *messagebadgeValue;

@property(nonatomic,strong) NSString *dailyNewsbadgeValue;

@end
