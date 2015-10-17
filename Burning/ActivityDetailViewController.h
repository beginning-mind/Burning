//
//  ActivityDetailViewController.h
//  Burning
//
//  Created by wei_zhu on 15/6/23.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"
#import "LCActivity.h"
#import "ActivityDetailHeaderView.h"

@interface ActivityDetailViewController : BaseViewController

@property(nonatomic,assign) MemberType memberType;

@property(nonatomic,strong)LCActivity *lcActivity;

@property(nonatomic,strong)NSString *lcActivityObjID;

@end
