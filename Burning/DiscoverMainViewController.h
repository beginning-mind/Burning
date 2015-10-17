//
//  DiscoverMainViewController.h
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DiscoverMainViewController : BaseViewController
- (IBAction)nearlyActivityBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *scrollView;

- (IBAction)openWeb:(id)sender;
- (IBAction)subscribe:(id)sender;
- (IBAction)unSubscribe:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)scrollViewBtn:(id)sender;


@end
