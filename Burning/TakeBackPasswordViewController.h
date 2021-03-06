//
//  TakeBackPasswordViewController.h
//  Burning
//
//  Created by Xiang Li on 15/6/8.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"

@interface TakeBackPasswordViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *sms4Register;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password4Check;

@property (nonatomic, strong) NSString *phoneNum;

- (IBAction)submitPasswordReset:(id)sender;

- (IBAction)validateSMS:(id)sender;

@end
