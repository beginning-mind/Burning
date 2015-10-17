//
//  TakeBackPasswordViewController.m
//  Burning
//
//  Created by Xiang Li on 15/6/8.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "TakeBackPasswordViewController.h"
#import "BuringTabBarController.h"

@interface TakeBackPasswordViewController ()

@end

@implementation TakeBackPasswordViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.showTabbar = NO;
    self.title = @"新密码";
    [self.customNavController.leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)submitPasswordReset:(id)sender {
    if([self.sms4Register.text length] == 0) {
        [self alert:@"请填写验证码"];
        return;
    }
    if([self.password.text length] == 0) {
        [self alert:@"密码不能为空"];
        return;
    }
    if(![self.password.text isEqualToString:self.password4Check.text]) {
        [self alert:@"两次输入密码不一致"];
        return;
    }
    NSLog(@"self.sms4Register.text:%@" , self.sms4Register.text);
    NSLog(@"self.password.text%@" , self.password.text);
//    [AVUser verifyMobilePhone:self.sms4Register.text withBlock:^(BOOL succeeded, NSError *error){
//        if(succeeded) {
//        }
//    }];
//    AVUser *avUser = [AVUser currentUser];
    WEAKSELF
    [AVUser resetPasswordWithSmsCode:self.sms4Register.text newPassword:self.password.text block:^(BOOL succeeded, NSError *error) {
                if (error) {
                    switch (error.code) {
                        case 603:
                            [weakSelf showInfo:@"无效的验证码"];
                            break;
                            
                        default:
                            [weakSelf showInfo:@"重置失败"];
                            break;
                    }
                } else {
                    [weakSelf showInfo:@"重置密码成功"];
                    
                    [AVUser logInWithMobilePhoneNumberInBackground:self.phoneNum password:self.password.text block:^(AVUser *user, NSError *error) {
                        if (error) {
                            [weakSelf alert:@"登录失败"];
                        }else {
                            BuringTabBarController *buringTabBarController = [[BuringTabBarController alloc]init];
                            [self presentViewController:buringTabBarController animated:YES  completion:nil];
                        }
                    }];
                    
                }
    }];
}

- (IBAction)validateSMS:(id)sender {
//    NSLog(@"self.sms4Register.text:%@", self.sms4Register.text);
//    [AVUser verifyMobilePhone:self.sms4Register.text withBlock:^(BOOL succeeded, NSError *error) {
//        if(succeeded) {
//            
//        }else {
//            [self alert:@"验证码输入错误"];
//        }
//    }];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
