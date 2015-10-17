//
//  MessageMainViewController.m
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "MessageMainViewController.h"
#import "BurningNavControl.h"
#import "LCEChatListVC.h"
#import "CDUserFactory.h"
#import "CDMacros.h"


@interface MessageMainViewController ()


@end

@implementation MessageMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showTabbar = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [CDIMConfig config].userDelegate = [[CDUserFactory alloc] init];
    
    LCEChatListVC *chatListVC = [[LCEChatListVC alloc] init];
    [self.navigationController pushViewController:chatListVC animated:NO];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
