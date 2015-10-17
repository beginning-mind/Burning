//
//  CommentViewController.m
//  Burning
//
//  Created by wei_zhu on 15/6/11.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "CommentViewController.h"
#import "LCDataHelper.h"
#import "PersonalInfoViewController.h"

@interface CommentViewController ()

@property(nonatomic,strong)NSString *replyPrefix;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationBar];
    [self setPlaceHolder];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    //滚动条可以滚动底部
    self.automaticallyAdjustsScrollViewInsets = NO;
    //分割线从顶部开始画
    if ([self.commentTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.commentTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.commentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.commentTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //隐藏多余的线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blueColor];
    [self.commentTableView setTableFooterView:view];
    
    self.replyCommentText.delegate = self;
    self.replyCommentText.returnKeyType = UIReturnKeyDone;
//    [self.replyCommentText becomeFirstResponder];
    
    self.showTabbar = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPlaceHolder{
    if (self.commentUserIndex>=0) {
        AVUser *replyCommentUser = self.publish.commentUsers[self.commentUserIndex];
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
    self.sendBtn.enabled = true;
}

-(void)setNavgationBar{
    [self.navigationItem setTitle:@"评论"];
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createActivity:)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
}

#pragma mark TableViewDataSource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.publish.comments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CommentsTableViewCell calculateCellHeightWithLCComment:self.publish.comments[indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsTableViewCell *commentsTableViewCell= [tableView dequeueReusableCellWithIdentifier:@"commentsCell"];
    if(commentsTableViewCell==nil){
        commentsTableViewCell=[[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentsCell"];
    }
    AVUser *commentUser;
    @try {
        commentUser = _publish.commentUsers[indexPath.row];
    }
    @catch (NSException *exception) {
        commentUser = nil;
    }
    commentsTableViewCell.commentUser = commentUser;
    commentsTableViewCell.comment=self.publish.comments[indexPath.row];
    commentsTableViewCell.indexPath = indexPath;
    commentsTableViewCell.commentViewCellDelegate = self;
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
    LCComment *lcComment = self.publish.comments[indexPath.row];
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
        self.sendBtn.enabled = false;
        AVUser *toUser=self.publish.creator;
        LCComment* comment=[LCComment object];
        if (self.commentUserIndex>=0) {
            comment.commentContent=[NSString stringWithFormat:@"%@%@",self.replyPrefix,self.replyCommentText.text];
        }
        else{
            comment.commentContent=self.replyCommentText.text;
        }
        AVUser* user=[AVUser currentUser];
        comment.commentUser=user;
        comment.lcPublish=self.publish;
        comment.toUser=toUser;
//        comment.commentUsername=user.username;
        
//        //test
//        NSError *err;
//        for (NSInteger i = 0;i<10000;i++) {
//            comment.commentContent = [NSString stringWithFormat:@"commnet%ld",(long)i];
//            [comment save:&err];
//            [_publish addObject:comment forKey:KEY_COMMENTS];
//            [_publish addObject:comment.commentUser forKey:KEY_COMMENTUSERS];
//            [_publish incrementKey:KEY_HOT_COUNT];
//            [_publish save];
//        }
//        [self setValueAfterSended];
        
        [self.lcDataHelper pubComment:comment AtPublish:_publish block:^(BOOL succeeded, NSError *error) {
            if (error) {
                [self alert:@"发送失败，请重试 :)"];
                [self setValueAfterSended];
                return;
            }
            
            [self.commentTableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.publish.comments.count-1 inSection:0];
            [self.commentTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:NO];
            [self.commentTableView endUpdates];
            [self.commentTableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionNone animated:YES];
            
            if ([_commentViewDelegate respondsToSelector:@selector(ReloadTableViewCellForIndex:)]) {
                [_commentViewDelegate ReloadTableViewCellForIndex:self.indexPath];
            }
            //推送通知
            NSString *objId = self.publish.objectId;
            NSString *commentIndex = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            AVUser *toPushUser;
            NSString *deviceToken;
            NSString *notiType;
            if (self.commentUserIndex>=0) {
                toPushUser = self.publish.commentUsers[self.commentUserIndex];
                if([toPushUser.objectId isEqualToString:[AVUser currentUser].objectId]){
                    [self setValueAfterSended];
                    return ;
                }
                deviceToken = [toPushUser objectForKey:@"deviceToken"];
                notiType = @"11";
            }
            else{
                toPushUser =self.publish.creator;
                if([toPushUser.objectId isEqualToString:[AVUser currentUser].objectId]){
                    [self setValueAfterSended];
                    return ;
                }
                deviceToken = [toPushUser objectForKey:@"deviceToken"];
                notiType = @"3";
            }
            
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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
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

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSArray *arry = self.view.constraints;
    for (NSLayoutConstraint *constraint in arry) {
        NSLog(@"attr:%ld",(long)constraint.firstAttribute);
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
