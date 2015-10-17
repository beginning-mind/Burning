//
//  CommentViewController.h
//  Burning
//
//  Created by wei_zhu on 15/6/11.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"
#import "LCPublish.h"
#import "CommentsTableViewCell.h"


@protocol CommentViewDelegate <NSObject>

-(void)ReloadTableViewCellForIndex:(NSIndexPath*)indexPath;

@end

@interface CommentViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *replyCommentText;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

- (IBAction)sendBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *replyInputBgView;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)LCPublish *publish;

@property(nonatomic,assign)NSInteger commentUserIndex;

@property(nonatomic,strong)id<CommentViewDelegate> commentViewDelegate;

@end
