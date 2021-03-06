//
//  RegisterDetailViewController.m
//  Burning
//
//  Created by Xiang Li on 15/6/7.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "RegisterDetailViewController.h"
#import "BuringTabBarController.h"
#import "CDMacros.h"
#import "CDIM.h"

@interface RegisterDetailViewController ()

@property(nonatomic) BOOL isVerified;
@property(nonatomic) BOOL isOccupied;

@end

@implementation RegisterDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.showTabbar = NO;
    self.title = @"注册详情";
    
    [self startTime];
//    [self.customNavController.leftButton setImage:[UIImage imageNamed:@"homeBtn2"] forState:UIControlStateNormal];
//    [self.customNavController.leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)checkRepeat:(id)sender {
    //查重
    WEAKSELF
    [self.lcDataHelper getUserWithUsername:self.nickname.text block:^(NSArray *objects, NSError *error) {
        if (error) {
            [weakSelf alert:@"用户名查重失败 T_T"];
        } else {
            if (objects.count>0) {
                [weakSelf alert:@"此用户名已被使用，换个呗亲"];
            }
        }
    }];
}

- (IBAction)registerUser:(id)sender {
     WEAKSELF
    [AVUser verifyMobilePhone:self.sms4Register.text withBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            [weakSelf alert:@"验证码输入错误"];
        }else {
            if([self.sms4Register.text length] == 0) {
                [self alert:@"请填写验证码"];
                return;
            }
            //    if (!_isVerified) {
            //        [self alert:@"验证码错误"];
            //        return;
            //    }
            if([self.nickname.text length] == 0) {
                [self alert:@"起个炫酷的名字呗 :)"];
                return;
            }
            
            if ([self.nickname.text length] >10) {
                [self alert:@"昵称不能多于10个字符"];
                return;
            }
            
            if (_isOccupied) {
                [self alert:@"用户名被占用"];
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
            //NSLog(@"self.phoneNumber: %@", self.phoneNum);
            
            
            [self.lcDataHelper saveSequenceWithType:0 Block:^(NSInteger number, NSError *error) {
                if (error) {
                    [weakSelf alert:@"获取序列失败"];
                }else {
                    if (number>10000) {
                        AVUser *user = [AVUser currentUser];
                        NSLog(@"user.sessionToken: %@", user.sessionToken);
                        if (user != nil) {
                            [user setObject:self.nickname.text forKey:@"username"];
                            [user setObject:self.password.text forKey:@"password"];
                            [user setObject:@(number) forKey:@"sequenceNum"];
                            [user setObject:@(0) forKey:@"isDel"];
                            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (error) {
                                    if (error.code == 202) {
                                        [weakSelf alert:@"用户名已被占用 :("];
                                    }else{
                                        [weakSelf alert:@"注册失败"];
                                    }
                                }else {
                                    [AVUser logOut];
                                    [AVUser logInWithMobilePhoneNumberInBackground:self.phoneNum password:self.password.text block:^(AVUser *user2, NSError *error) {
                                        if (error) {
                                            [weakSelf alert:@"登录失败"];
                                        }else {
                                            //开启聊天客户端
                                            CDIM *im = [CDIM sharedInstance];
                                            [im openWithClientId:user2.objectId callback: ^(BOOL succeeded, NSError *error) {
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
                                        }
                                    }];
                                }
                            }];
                        }
                    }
                }
            }];
        }
    }];
}

//- (IBAction)validateSMS:(id)sender {
//    WEAKSELF
//    [AVUser verifyMobilePhone:self.sms4Register.text withBlock:^(BOOL succeeded, NSError *error) {
//        if(error) {
//            [weakSelf alert:@"验证码输入错误"];
//            _isVerified = NO;
//        }else {
//            _isVerified = YES;
//        }
//    }];
//}


- (IBAction)reFetchAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.reFetchButton setTitle:@"重新获取" forState:UIControlStateNormal];
//                [self.reFetchButton setTintColor:[UIColor blueColor] ];
                [self.reFetchButton setTitleColor:[UIColor colorWithRed:30.0/255 green:172.0/255 blue:199.0/255 alpha:1] forState:UIControlStateNormal];
                self.reFetchButton.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [self.reFetchButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                
                [self.reFetchButton setTitleColor:RGB(220,220,220) forState:UIControlStateNormal];
                self.reFetchButton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}


-(void)getRandomNumber{
//    int from = 10000;
//    int to = 9999999;
//    return (int)(from + (arc4random() % (to-from + 1)));
    
//    return [self.lcDataHelper saveRandomId];
}

@end
