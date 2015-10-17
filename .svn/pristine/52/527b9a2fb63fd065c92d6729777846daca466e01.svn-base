//
//  RegionSelectorVC.m
//  Burning
//
//  Created by Xiang Li on 15/7/30.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "RegionSelectorVC.h"
#import "RegionTableViewController.h"

@interface RegionSelectorVC()<RegionTableVCDelegate>

@end


@implementation RegionSelectorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"na_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem= backItem;
    
    RegionTableViewController *allTableVC = [[RegionTableViewController alloc]initWithType:0];
    allTableVC.regionTableVCDelegate = self;
    allTableVC.curLocation = self.curLocation;
    allTableVC.view.frame = self.view.frame;
    
    RegionTableViewController *communityTableVC = [[RegionTableViewController alloc]initWithType:1];
    communityTableVC.regionTableVCDelegate = self;
    communityTableVC.curLocation = self.curLocation;
    communityTableVC.view.frame = self.view.frame;
    
    RegionTableViewController *busnessTableVC = [[RegionTableViewController alloc]initWithType:2];
    busnessTableVC.regionTableVCDelegate = self;
    busnessTableVC.curLocation = self.curLocation;
    busnessTableVC.view.frame = self.view.frame;
    
    [self setViewControllers:@[allTableVC,communityTableVC,busnessTableVC]];
}

-(void)back:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma RegionTableVC Delegate
- (void)setPLaceTextFieldWithName:(NSString*)placeName latitude:(float)latitude longitude:(float)longitude {
    if ([self.regionSelectorVCDelegate respondsToSelector:@selector(setPLaceTextFieldWithName:latitude:longitude:)]) {
        [self.regionSelectorVCDelegate setPLaceTextFieldWithName:placeName latitude:latitude longitude:longitude];
    }
    
}


@end
