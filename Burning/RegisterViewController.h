//
//  RegisterViewController.h
//  Burning
//
//  Created by Xiang Li on 15/6/7.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"
#import "LCDataHelper.h"


/*@protocol RegisterViewControllerDelegate

@optional
-(void)passPhoneNum:(NSString *)phoneNum;

@end*/


@interface RegisterViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property(strong, nonatomic) NSString *sourcePageFlag;//1 注册，2找回密码
- (IBAction)validateUserBySMS:(id)sender;


@end
