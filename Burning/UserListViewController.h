//
//  UserListViewController.h
//  Burning
//
//  Created by wei_zhu on 15/6/18.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"
#import "UserListTableViewCell.h"
#import "PersonalInfoViewController.h"

@interface UserListViewController : BaseViewController

@property(nonatomic,strong)UITableView *userListTableView;

//@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)NSMutableArray *users;

@end
