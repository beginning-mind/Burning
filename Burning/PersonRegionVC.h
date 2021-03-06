//
//  PersonRegionVC.h
//  Burning
//
//  Created by Xiang Li on 15/8/19.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonRegionVC : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *personRegionTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailAddressTextView;
@property (nonatomic, strong) NSString *content;

@end
