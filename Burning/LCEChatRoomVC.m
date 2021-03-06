//
//  LCEChatRoomVC.m
//  LeanChatExample
//
//  Created by lzw on 15/4/7.
//  Copyright (c) 2015年 avoscloud. All rights reserved.
//

#import "LCEChatRoomVC.h"
#import "BuringTabBarController.h"
#import "GroupDetailViewController.h"

@interface LCEChatRoomVC ()

@end

@implementation LCEChatRoomVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //    UIImage *_peopleImage = [UIImage imageNamed:@"chat_menu_people"];
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:_peopleImage style:UIBarButtonItemStyleDone target:self action:@selector(goChatGroupDetail:)];
    //    self.navigationItem.rightBarButtonItem = item;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"na_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem= backItem;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStyleBordered target:self action:@selector(goChatGroupDetail:)];
    self.navigationItem.rightBarButtonItems = @[addItem];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    BuringTabBarController *tabBarController = (BuringTabBarController*)self.tabBarController;
    [tabBarController hiddenTabbar];
}

- (void)goChatGroupDetail:(id)sender {
    //DLog(@"conversionId:%@", self.conversion.conversationId);
    
    GroupDetailViewController *groupDetailViewController = [[GroupDetailViewController alloc]init];
    
    
    groupDetailViewController.conversion = self.conv;
    [self.navigationController pushViewController:groupDetailViewController animated:YES];
    
//    CDIM *im = [CDIM sharedInstance];
//    NSMutableSet *convidSet = [[NSMutableSet alloc] init];
//    [convidSet addObject:self.conversion.conversationId];
//    [im fetchConvsWithConvids:convidSet callback:^(NSArray *objects, NSError *error) {
//        if (error) {
//            NSLog(@"获取群组详细失败");
//        }else {
//            if (objects>0) {
//                
//            }
//        }
//    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)back:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
