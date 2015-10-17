//
//  BaseViewController.h
//  Burning
//
//  Created by 李想 on 15/5/24.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "LayoutConst.h"
#import <AVUser.h>
#import "BurningNavControl.h"
#import "LCDataHelper.h"
@interface BaseViewController : UIViewController

@property(nonatomic,assign)BOOL showTabbar; 
@property(nonatomic,strong)BurningNavControl *customNavController;
@property(nonatomic,strong)LCDataHelper *lcDataHelper;



-(void)showNetworkIndicator;

-(void)hideNetworkIndicator;

-(void)showProgress;

-(void)hideProgress;

-(void)alert:(NSString*)msg;

-(void)showInfo:(NSString*)msg;

-(BOOL)alertError:(NSError*)error;

-(BOOL)filterError:(NSError*)error;

-(void)runInMainQueue:(void (^)())queue;

-(void)runInGlobalQueue:(void (^)())queue;

-(void)runAfterSecs:(float)secs block:(void (^)())block;

-(void)showHUDText:(NSString*)text;

-(AVUser*)getCurrentUser;

-(void)loadCustomNavControl;

-(void)PushNewsWithData:(NSDictionary*)data deviceToke:(NSString*)deviceToken Chanell:(NSString*)chanell;

@end
