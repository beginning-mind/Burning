//
//  ActivityCommentViewController.h
//  Burning
//
//  Created by wei_zhu on 15/7/8.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"
#import "LCActivity.h"

@protocol ActivityCommentViewDelegate <NSObject>

-(void)ReloadActivity;

@end


@interface ActivityCommentViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *replyCommentText;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UIView *replyInputBgView;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

- (IBAction)sendBtnClick:(id)sender;

//@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)LCActivity *lcActivity;

@property(nonatomic,assign)NSInteger commentUserIndex;

@property(nonatomic,strong)id<ActivityCommentViewDelegate> commentViewDelegate;

@end
