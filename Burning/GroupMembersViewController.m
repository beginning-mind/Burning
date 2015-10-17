//
//  GroupMembersViewController.m
//  Burning
//
//  Created by Xiang Li on 15/6/27.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "GroupMembersViewController.h"
#import "GroupMembersTableViewCell.h"
#import "CDIM.h"
#import "PersonalInfoViewController.h"
#import "CDMessage.h"

@interface GroupMembersViewController ()<AddUserTableViewCellDelegate>

@end

@implementation GroupMembersViewController

- (void)viewDidLoad {
    self.navigationController.navigationBarHidden =NO;
    [super viewDidLoad];
    self.title = @"群成员";
    
    self.groupMembersTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kStatusBarHeight-kNavigationBarHeight)];
    [self.groupMembersTableView setAllowsSelection:NO];
    //设置线条顶格画
    if ([self.groupMembersTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.groupMembersTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.groupMembersTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.groupMembersTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //设置不显示多余的白线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.groupMembersTableView setTableFooterView:view];
    
//    self.tempMembers = [[NSMutableArray alloc]init];
    self.groupMembersTableView.dataSource = self;
    self.groupMembersTableView.delegate = self;
    
    [self.view addSubview:self.groupMembersTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark TableViewDataSource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [GroupMembersTableViewCell calculateCellHeightWithUser:self.users[indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMembersTableViewCell *groupMembersTableViewCell= [tableView dequeueReusableCellWithIdentifier:@"groupMembersCell"];
    if(groupMembersTableViewCell==nil){
        groupMembersTableViewCell=[[GroupMembersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupMembersCell"];
    }
    groupMembersTableViewCell.user=self.users[indexPath.row];
    groupMembersTableViewCell.indexPath = indexPath;
    groupMembersTableViewCell.addUserTableViewCellDelegate = self;
    return groupMembersTableViewCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AVUser *currentUser = [self getCurrentUser];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showProgress];
        AVUser *avUser = [_users objectAtIndex:indexPath.row];
        NSArray *array = [[NSArray alloc]initWithObjects:avUser.objectId, nil];
        if ([currentUser isEqual:avUser]) {
            [self alert:@"不能移出自己"];
            [self hideProgress];
        } else {
            WEAKSELF
            [self.conversion removeMembersWithClientIds:array callback:^(BOOL succeeded, NSError *error) {
                [weakSelf hideProgress];
                if (error) {
                    [weakSelf alert:@"移出失败，请重试 T_T"];
                }else {
                    NSDictionary *convDict = self.conversion.attributes;
                    NSString *url = [convDict objectForKey:@"groupAvatarPicUrl"];
                    if (url == nil) url = @"";
                    [self kickMemberAndNotifyThemWithHint:@" 将你移出 " MsgType:MasterMoveOut AvatarUrl:url ObjectId:self.conversion.conversationId MemberId:avUser.objectId];
                    
                    [self.users removeObjectAtIndex:indexPath.row];
                    [self.groupMembersTableView reloadData];
                }
            }];
        }
    }
}

-(void) kickMemberAndNotifyThemWithHint:(NSString *)hint MsgType:(NSUInteger)msgType AvatarUrl:(NSString*)url ObjectId:(NSString *)objId MemberId:(NSString *)memberId{
    WEAKSELF
    //找到申请或者被邀请的对话
    CDIM *im = [CDIM sharedInstance];
    [im fetchSystemConvWithConvId:self.conversion.conversationId AndMemberId:memberId callback:^(NSArray *objects, NSError *error) {
        if (error) {
            [weakSelf alert:@""];
        }else {
            if (objects.count >0) {
                AVIMConversation *sendConv = [objects objectAtIndex:0];
                //初始化消息
                
                NSString *groupName = weakSelf.conversion.name;
                NSString *creator = [AVUser currentUser].username;
                //NSString *realConvid = sendConv.conversationId;
                
                NSString *txt = [creator stringByAppendingString:hint];
                txt = [txt stringByAppendingString:groupName];
                
                //                                                   NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,@"groupAvatarPicUrl",realConvid,@"realConvid", groupName, @"groupName", nil];
                
                NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,MSG_ATTR_URL, objId, MSG_ATTR_ID, [NSString stringWithFormat:@"%lu", (unsigned long)msgType], MSG_ATTR_TYPE,  nil];
                
                AVIMTextMessage *txtMsg = [AVIMTextMessage messageWithText:txt attributes:dict4msg];
                
                [sendConv sendMessage:txtMsg callback:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        [hint stringByAppendingString:@"失败"];
                        [weakSelf alert:hint];
                    } else {
                        //删除此对话
                        //[im deleteConvWithConvId:self.conversion.conversationId];
                    }
                }];
            }
        }
    }];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //判断是否是群主
    if ([self.conversion.creator isEqualToString:[self getCurrentUser].objectId]) {
       return true;
        
    } else {
        return false;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"移出群";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark adduserTableViewCellDelegate
-(void)didAvatarImageViewClick:(UIGestureRecognizer *)gestureRecognizer indexPath:(NSIndexPath *)indexPath{
    PersonalInfoViewController *personInfoVC = [[PersonalInfoViewController alloc]init];
    personInfoVC.user = self.users[indexPath.row];
    
    [self.navigationController pushViewController:personInfoVC animated:YES];
}

@end
