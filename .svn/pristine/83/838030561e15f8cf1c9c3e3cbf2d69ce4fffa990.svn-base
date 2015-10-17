//
//  MeMainViewController.m
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "MeMainViewController.h"
#import "BurningNavControl.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"
#import <AVIMClient.h>
#import "CDIM.h"
#import "CDMacros.h"
#import "MessageMainViewController.h"

@interface MeMainViewController ()


@end

@implementation MeMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showTabbar = YES;
        [self setTitle:@"我"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavControl];
    AVUser *currentUser = [AVUser currentUser];
    self.currentUser.text = currentUser.username;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCustomNavControl{
    //set titile
    self.customNavController.title.text =@"我";
}

//- (IBAction)logout:(id)sender {
//    CDIM *im = [CDIM sharedInstance];
//    [im closeWithCallback:^(BOOL succeeded, NSError *error) {
//        if(error) {
//            [self alert:@"关闭IM客户端失败"];
//        }else {
//            NSLog(@"--- GoodBye and closing your IM client : %@",[self getCurrentUser].username);
//            [AVUser logOut];  //清除缓存用户对象
//            LoginViewController *loginViewController = [[LoginViewController alloc] init];
//            loginViewController.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:loginViewController animated:YES];
//        }
//    }];
//}
//
//- (IBAction)joinAGroup:(id)sender {
//    CDIM *im = [CDIM sharedInstance];
//    WEAKSELF
//    [im fecthConvWithId:@"5593b886e4b0001a928c7617" callback:^(AVIMConversation *conversation, NSError *error) {
//        if (error) {
//            
//        }else {
//           [conversation joinWithCallback:^(BOOL succeeded, NSError *error) {
//               if (error) {
//                   [weakSelf alert:@"加入失败"];
//               } else {
//                   MessageMainViewController *messageMainVC = [[MessageMainViewController alloc] init];
//                   [self.navigationController pushViewController:messageMainVC animated:YES];
//               }
//           }];
//        }
//    }];
//}
@end
