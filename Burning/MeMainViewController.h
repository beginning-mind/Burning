//
//  MeMainViewController.h
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MeMainViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *currentUser;
- (IBAction)logout:(id)sender;
- (IBAction)joinAGroup:(id)sender;

@end
