//
//  SearchingVC.h
//  Burning
//
//  Created by Xiang Li on 15/8/15.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchingVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *searchingTextField;
- (IBAction)searchingAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *personAndGroupTableView;

@end
