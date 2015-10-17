//
//  RegisterViewController.m
//  Burning
//
//  Created by Xiang Li on 15/6/7.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "RegisterViewController.h"
#import "BurningNavControl.h"
#import "RegisterDetailViewController.h"
#import "TakeBackPasswordViewController.h"
#import "CDMacros.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if([self.sourcePageFlag isEqualToString:@"1"]) {
        self.title =@"注册";
    }
    else {
        self.title =@"密码重置";
    }
    
    [self exitFullScreen];
    
    [self.customNavController.leftButton setImage:[UIImage imageNamed:@"homeBtn2"] forState:UIControlStateNormal];
    [self.customNavController.leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)exitFullScreen {
    self.navigationController.navigationBar.translucent =NO;
    self.wantsFullScreenLayout = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)validateUserBySMS:(id)sender {
    if([self.sourcePageFlag isEqualToString:@"1"]) {
        if ([self.phoneNumber.text length] == 0) {
            [self alert:@"手机号不能为空"];
            return;
        }
        //用户名和密码暂时是手机号，获取后再更新
        //        AVUser *user = [AVUser currentUser];
        AVUser *user = [AVUser user];
        user.username = self.phoneNumber.text;
        user.password = self.phoneNumber.text;
        user.mobilePhoneNumber = self.phoneNumber.text;
        NSError *error = nil;
        [self showProgress];
        
        if([user signUp:&error]) {//存入LeanCloud
            //        if(YES){
            AVUser *user = [AVUser currentUser];
            [self getIntoDetail];
        }else {
            switch (error.code) {
                case 214:{
                        WEAKSELF
                        [self.lcDataHelper getUserWithPhoneNum:self.phoneNumber.text block:^(NSArray *objects2, NSError *error) {
                            if (error) {
                                [self alert:@"登陆失败"];
                                return ;
                            }
                            AVUser *u = (AVUser*)[objects2 objectAtIndex:0];
                            
                            if(u.mobilePhoneVerified) {
                                [weakSelf alert:@"这个手机已经被注册过了嗳 :("];
                            }else {//已注册未验证
                                [AVUser requestMobilePhoneVerify:self.phoneNumber.text withBlock:^(BOOL succeeded, NSError *error) {
                                    if(succeeded) {
                                        [weakSelf getIntoDetail];
                                    }else {
                                        if(error.code == 601) {
                                            [weakSelf showInfo:@"上一次验证码依然有效"];
                                            [weakSelf getIntoDetail];
                                        }else {
                                            [weakSelf alert:@"获取验证码失败"];
                                        }
                                        
                                    }
                                }];
                            }
                        }];
                    }
                    break;
                default:{
                    [self alert:@"注册失败，请重试 :)"];
                    }
                    break;
            }
        }
        [self hideProgress];
    }else {
        WEAKSELF
        NSLog(@"self.phoneNumber.text:%@", self.phoneNumber.text);
        if (self.phoneNumber.text.length > 0 ) {
            [AVUser requestPasswordResetWithPhoneNumber:self.phoneNumber.text block:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    TakeBackPasswordViewController *takeBackPasswordViewController = [[TakeBackPasswordViewController alloc]init];
                    takeBackPasswordViewController.phoneNum = self.phoneNumber.text;
                    [weakSelf.navigationController pushViewController:takeBackPasswordViewController animated:YES];
                    
                } else if(error.code == 601) {
                    [weakSelf showInfo:@"请使用刚发送过的验证码"];
                    TakeBackPasswordViewController *takeBackPasswordViewController = [[TakeBackPasswordViewController alloc]init];
                    takeBackPasswordViewController.phoneNum = self.phoneNumber.text;
                    [weakSelf.navigationController pushViewController:takeBackPasswordViewController animated:YES];
                } else {
                    [self alert:@"获取验证码失败"];
                }
            }];
        } else {
            [weakSelf alert:@"请输入手机号"];
        }
    }
    
}

-(void)getIntoDetail {
    RegisterDetailViewController *registerDetailViewController = [[RegisterDetailViewController alloc]init];
    //NSLog(@"self.phoneNumber.text: %@", self.phoneNumber.text);
    registerDetailViewController.phoneNum= self.phoneNumber.text;
    [self.navigationController pushViewController:registerDetailViewController animated:YES];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
