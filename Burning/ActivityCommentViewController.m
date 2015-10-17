//
//  ActivityCommentViewController.m
//  Burning
//
//  Created by wei_zhu on 15/7/8.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "ActivityCommentViewController.h"
#import "ActivityCommentTableViewCell.h"
#import "PersonalInfoViewController.h"

@interface ActivityCommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)NSString *replyPrefix;

//@property(nonatomic,assign)CGFloat keyBordHeight;

@end

@implementation ActivityCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationBar];
    [self setPlaceHolder];
    
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([self.commentTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.commentTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.commentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.commentTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //隐藏多余的线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.commentTableView setTableFooterView:view];
    
    self.replyCommentText.delegate = self;
    self.replyCommentText.returnKeyType = UIReturnKeyDone;
    self.showTabbar = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPlaceHolder{
    if (self.commentUserIndex>=0) {
        AVUser *replyCommentUser = self.lcActivity.commentUsers[self.commentUserIndex];
        NSString *repyCommentUserName = replyCommentUser.username;
        self.replyPrefix= [NSString stringWithFormat:@"回复 %@ ",repyCommentUserName];
        self.replyCommentText.placeholder = self.replyPrefix;
    }
}

-(void)setValueAfterSended{
    [self.replyCommentText resignFirstResponder];
    self.commentUserIndex  = -1;
    self.replyPrefix = @"";
    self.replyCommentText.text = nil;
    self.replyCommentText.placeholder = nil;
}

-(void)setNavgationBar{
    [self.navigationItem setTitle:@"评论"];
}

#pragma mark TableViewDataSource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lcActivity.comments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ActivityCommentTableViewCell calculateCellHeightWithLCComment:self.lcActivity.comments[indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityCommentTableViewCell *commentsTableViewCell= [tableView dequeueReusableCellWithIdentifier:@"acCommentsCell"];
    if(commentsTableViewCell==nil){
        commentsTableViewCell=[[ActivityCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"acCommentsCell"];
    }
    commentsTableViewCell.commentUser = self.lcActivity.commentUsers[indexPath.row];
    commentsTableViewCell.comment=self.lcActivity.comments[indexPath.row];
    commentsTableViewCell.indexPath = indexPath;
    commentsTableViewCell.commentViewCellDelegate= self;
    return commentsTableViewCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.commentUserIndex = indexPath.row;
    [self setPlaceHolder];
    [self.replyCommentText becomeFirstResponder];
}

#pragma CommentView Cell Delegate
-(void)didAvatarImageViewClick:(UIGestureRecognizer *)gestureRecognizer indexPath:(NSIndexPath *)indexPath{
    LCActivityComment *lcComment = self.lcActivity.comments[indexPath.row];
    PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
    personalInfoVC.user = lcComment.commentUser;
    
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

#pragma mark action
- (IBAction)sendBtnClick:(id)sender {
    if (self.replyCommentText.text==nil || [self.replyCommentText.text isEqual:@""] ) {
        return;
    }
    else{
        AVUser *toUser=self.lcActivity.creator;
        LCActivityComment* comment=[LCActivityComment object];
        if (self.commentUserIndex>=0) {
            comment.commentContent=[NSString stringWithFormat:@"%@%@",self.replyPrefix,self.replyCommentText.text];
        }
        else{
            comment.commentContent=self.replyCommentText.text;
        }
        AVUser* user=[AVUser currentUser];
        comment.commentUser=user;
        comment.lcActivity=self.lcActivity;
        comment.toUser=toUser;
        
        [self.lcDataHelper pubActivityComment:comment AtActivity:_lcActivity block:^(BOOL succeeded, NSError *error) {
            if (error) {
                [self alert:@"发送失败, 请重试 :)"];
                [self setValueAfterSended];
                return;
            }
            
            [self.replyCommentText resignFirstResponder];
            [self.commentTableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.lcActivity.comments.count-1 inSection:0];
            [self.commentTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:NO];
            [self.commentTableView endUpdates];
            [self.commentTableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionBottom animated:YES];
            
            if ([_commentViewDelegate respondsToSelector:@selector(ReloadActivity)]) {
                [_commentViewDelegate ReloadActivity];
            }
            self.replyCommentText.text = @"";
            //推送通知
            NSString *objId = self.lcActivity.objectId;
            NSString *commentIndex = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            AVUser *toPushUser;
            NSString *deviceToken;
            NSString *notiType;
            if (self.commentUserIndex>=0) {
                toPushUser = self.lcActivity.commentUsers[self.commentUserIndex];
                if([toPushUser.objectId isEqualToString:[AVUser currentUser].objectId]){
                    [self setValueAfterSended];
                    return ;
                }
                deviceToken = [toPushUser objectForKey:@"deviceToken"];
                notiType = @"12";
            }
            else{
                toPushUser =self.lcActivity.creator;
                if([toPushUser.objectId isEqualToString:[AVUser currentUser].objectId]){
                    [self setValueAfterSended];
                    return ;
                }
                deviceToken = [toPushUser objectForKey:@"deviceToken"];
                notiType = @"8";
            }
            
            deviceToken = [toPushUser objectForKey:@"deviceToken"];
            if (deviceToken !=nil) {
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:1],@"content-available",
                                      notiType,@"type",
                                      objId,@"objId",
                                      commentIndex,@"comIdx",
                                      [AVUser currentUser].objectId,@"userId",
                                      //                                  @"Increment", @"badge",
//                                      @"cheering.caf", @"sound",
                                      nil];
                [self PushNewsWithData:data deviceToke:deviceToken Chanell:@"SysNoti"];
            }
            [self setValueAfterSended];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.replyCommentText resignFirstResponder];
}

#pragma mark textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSArray *arry = self.view.constraints;
    for (NSLayoutConstraint *constraint in arry) {
        if (constraint.firstAttribute ==4) {
            if ([constraint.firstItem isKindOfClass:[UITableView class]] || [constraint.secondItem isKindOfClass:[UITableView class]]) {
                continue;
            }
            else{
                constraint.constant = 216+36;
                [UIView animateWithDuration:0.3 animations:^{
                    [self.view layoutIfNeeded];
                }];
                break;
            }
            
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    NSArray *arry = self.view.constraints;
    for (NSLayoutConstraint *constraint in arry) {
        if (constraint.firstAttribute ==4) {
            if ([constraint.firstItem isKindOfClass:[UITableView class]] || [constraint.secondItem isKindOfClass:[UITableView class]]) {
                continue;
            }
            else{
                constraint.constant = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    [self.view layoutIfNeeded];
                }];
                break;
            }
            
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.replyCommentText resignFirstResponder];
    return NO;
}

@end
