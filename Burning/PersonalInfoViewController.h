//
//  PesonalInfoViewController.h
//  Burning
//
//  Created by wei_zhu on 15/6/15.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"
#import "PubShowTableView.h"


@interface PersonalInfoViewController : BaseViewController

@property(nonatomic,strong)PubShowTableView *personalInfolTableView;

@property(nonatomic,strong)AVUser *user;

@property(nonatomic,strong)NSString *userId;

@property(nonatomic,strong)NSString *userName;

@end
