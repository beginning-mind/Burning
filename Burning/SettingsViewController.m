//
//  SettingsViewController.m
//  Burning
//
//  Created by Xiang Li on 15/7/28.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "SettingsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CDIM.h"
#import "StartPageViewController.h"
#import "GroupGeneralEditViewController.h"
#import "BuringTabBarController.h"
#import "GroupBriefEditViewController.h"
#import <StoreKit/StoreKit.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    //[self showCacheSize];
    
    NSString *currentUsername = [AVUser currentUser].username;
    NSString *buttonTitle = @"退出";
    buttonTitle = [buttonTitle stringByAppendingString:@" "];
    buttonTitle = [buttonTitle stringByAppendingString:currentUsername];
    [self.exitCurrentAccountButton setTitle:buttonTitle forState:UIControlStateNormal];
    
}

-(void)showCacheSize {
//    int cacheSizeByte = [[SDImageCache sharedImageCache] getSize];
//    cacheSizeByte = cacheSizeByte/1024.0/1024.0;
//    NSString *strSize = [NSString stringWithFormat:@"%d", cacheSizeByte];
//    strSize = [strSize stringByAppendingString:@"MB >"];
//    [self.cleanCacheButton setTitle:strSize forState:UIControlStateNormal];
//[self.cleanCacheButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction) feedbackAction:(id)sender {
    GroupBriefEditViewController *groupBriefEditViewController = [[GroupBriefEditViewController alloc] init];
    groupBriefEditViewController.editType = 2;
    [self.navigationController pushViewController:groupBriefEditViewController animated:YES];
}

- (IBAction)changePasswordAction:(id)sender {
    WEAKSELF
    self.dissmissDialog = [[STAlertView alloc] initWithTitle:@""
                                                     message:@"先输入旧密码"
                                               textFieldHint:@""
                                              textFieldValue:nil
                                           cancelButtonTitle:@"取消"
                                            otherButtonTitle:@"确定"
                                           cancelButtonBlock:^{
                                               
                                           } otherButtonBlock:^(NSString * result) {
                                               AVUser *user = [AVUser currentUser];
                                               
                                               [weakSelf showProgress];
                                               [AVUser logInWithUsernameInBackground:user.username password:result block:^(AVUser *user, NSError *error) {
                                                   [weakSelf hideProgress];
                                                   if (error) {
                                                       [weakSelf alert:@"旧密码错误"];
                                                   }else {
                                                       GroupGeneralEditViewController *groupGeneralEditViewController = [[GroupGeneralEditViewController alloc]init];
                                                       groupGeneralEditViewController.editType = 3;
                                                       [self.navigationController pushViewController:groupGeneralEditViewController animated:YES];
                                                   }
                                               }];
                                           }];
    [self.dissmissDialog show];
}

- (IBAction)cleanCacheAction:(id)sender {
    [self showProgress];
    NSUInteger cacheSizeByte = [[SDImageCache sharedImageCache] getSize];
    cacheSizeByte = cacheSizeByte/1024.0/1024.0;
    NSString *strHint = @"已清理";
    NSString *strSize = [NSString stringWithFormat:@"%lu", (unsigned long)cacheSizeByte];
    strSize = [strSize stringByAppendingString:@"MB"];
    strHint = [strHint stringByAppendingString:strSize];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [self hideProgress];
    
    [self showInfo:strHint];
}

- (IBAction)exitCurrentAcountAction:(id)sender {
    self.dissmissDialog = [[STAlertView alloc] initWithTitle:@""
                 message:@"确定要退出账户?"
        cancelButtonTitle:@"取消"
        otherButtonTitle:@"仍要退出"
        cancelButtonBlock:^{
        } otherButtonBlock:^{
           CDIM *im = [CDIM sharedInstance];
           WEAKSELF
            [weakSelf showProgress];
           [im closeWithCallback:^(BOOL succeeded, NSError *error) {
               [weakSelf hideProgress];
               if(error) {
                   [self alert:@"关闭IM客户端失败"];
               }else {
                   NSLog(@"--- GoodBye and closing your IM client : %@",[self getCurrentUser].username);
                   [AVUser logOut];  //清除缓存用户
                   StartPageViewController *startPageViewController = [[StartPageViewController alloc]init];
                   BuringTabBarController *mainVC =  self.tabBarController;
                   [mainVC unloadData];
                   [self.navigationController pushViewController:startPageViewController animated:YES];
               }
           }];
        }];
        [self.dissmissDialog show];
}

- (IBAction)goAppStoreBtn:(id)sender {
    NSString *str = [NSString stringWithFormat: @"https://itunes.apple.com/us/app/burning/id1034129880?l=zh&ls=1&mt=8"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
//    [self showProgress];
//    NSString *m_appleID = @"1034129880";
//    SKStoreProductViewController *storeProductViewContorller =[[SKStoreProductViewController alloc] init];
//    //设置代理请求为当前控制器本身
//    storeProductViewContorller.delegate = self;
//    //加载一个新的视图展示
//    [storeProductViewContorller loadProductWithParameters:
//     @{SKStoreProductParameterITunesItemIdentifier:m_appleID}//appId唯一的
//                                          completionBlock:^(BOOL result, NSError *error) {
//                                              //block回调
//                                              [self hideProgress];
//                                              if(error){
//                                                  NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
//                                              }else{
//                                                  //模态弹出appstore
//                                                  [self presentViewController:storeProductViewContorller animated:YES completion:^{}];
//                                              }
//                                          }
//     ];
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController{
    [viewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
