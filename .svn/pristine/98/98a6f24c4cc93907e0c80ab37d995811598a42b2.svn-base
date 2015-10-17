//
//  LoginViewController.m
//  Burning
//
//  Created by Xiang Li on 15/6/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "LoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "BuringTabBarController.h"
#import "RegisterViewController.h"
#import "BurningNavControl.h"
#import "TakeBackPasswordViewController.h"
#import "CDMacros.h"
#import "CDIM.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    
    [self exitFullScreen];
    [self name];
    [self password];

    self.title =@"登录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark UI
-(void)exitFullScreen {
    self.navigationController.navigationBar.translucent =NO;
    self.wantsFullScreenLayout = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(UITextField*)name {
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 4, 36, 36)];
    leftView.image = [UIImage imageNamed:@"ic_call_cyan"];
    _name.leftView = leftView;
    _name.leftViewMode = UITextFieldViewModeAlways;
    return _name;
}

-(UITextField*)password {
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 4, 36, 36)];
    leftView.image = [UIImage imageNamed:@"ic_lock_cyan"];
    _password.leftView = leftView;
    _password.leftViewMode = UITextFieldViewModeAlways;
    return _password;
}

#pragma  mark action
- (IBAction)login:(id)sender {
    NSString *name = self.name.text;
    NSString *password = self.password.text;
    if(name.length != 0 && password.length !=0) {
        [self showProgress];
        WEAKSELF
        [AVUser logInWithMobilePhoneNumberInBackground:name password:password block:^(AVUser *user, NSError *error) {
            [weakSelf hideProgress];
            if(user != nil) {
                if (user.mobilePhoneVerified) {
                    //开启聊天客户端
                    CDIM *im = [CDIM sharedInstance];
                    [im openWithClientId:user.objectId callback: ^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"开启聊天客户端异常");
                        }
                    }];
                    
                    UIViewController *rootVC =[UIApplication sharedApplication].keyWindow.rootViewController;
                    if ([rootVC isKindOfClass:[BuringTabBarController class]]) {
                        
                        BuringTabBarController *mainVC = rootVC;
                        [mainVC reloadData];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else{
                        BuringTabBarController *buringTabBarController = [[BuringTabBarController alloc]init];
                        [UIApplication sharedApplication].keyWindow.rootViewController = buringTabBarController;
                    }
                }else {
                    [weakSelf alert:@"手机号未验证，请继续注册"];
                }
            }else {
                [weakSelf alert:@"手机号和密码不匹配"];
            }
        }];
    }else {
        [self alert:@"请填写手机号和密码"];
    }
}

- (IBAction)forget:(id)sender {
    
}

- (IBAction)takeBackPassword:(id)sender {
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
        registerViewController.sourcePageFlag = @"2";
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
}

@end
