//
//  UsersFollowedEachOtherViewController.m
//  Burning
//
//  Created by Xiang Li on 15/6/24.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "UsersFollowedEachOtherViewController.h"
#import "AddUserTableViewCell.h"
#import "CDMacros.h"
#import <AVIMClient.h>
#import "CDIM.h"
#import "AVIMConversation+Custom.h"
#import "CDMessage.h"

@interface UsersFollowedEachOtherViewController ()<AddUserTableViewCellDelegate>

@property (nonatomic, strong) CDIM *im;
@end

@implementation UsersFollowedEachOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _im = [CDIM sharedInstance];
    
    self.navigationController.navigationBarHidden =NO;
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStyleBordered target:self action:@selector(sendInvitation2Users)];
    self.navigationItem.rightBarButtonItems = @[addItem];
    self.title = @"互关好友";
    
    self.userListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kStatusBarHeight-kNavigationBarHeight)];
    self.userListTableView.allowsSelection = NO;
    //设置线条顶格画
    if ([self.userListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.userListTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.userListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.userListTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //设置不显示多余的白线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.userListTableView setTableFooterView:view];

    
    self.tempMembers = [[NSMutableArray alloc]init];
    
    self.userListTableView.dataSource = self;
    self.userListTableView.delegate = self;
    
    [self.view addSubview:self.userListTableView];
}


//邀请好友入群
-(void)sendInvitation2Users {
    WEAKSELF
    if (self.tempMembers.count >0) {
        for (AVUser *user in self.tempMembers) {
            [self checkOutIfAreadyInvitedWithUserId:user.objectId];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }else {
        [weakSelf alert:@"至少选择一个互关好友"];
    }
}


-(void)checkOutIfAreadyInvitedWithUserId:(NSString *)userObjId {
    WEAKSELF
    [_im fetchConvsWithConvName:self.conversion.conversationId AndCreator:[AVUser currentUser].objectId callback:^(NSArray *objects, NSError *error) {
        if (error) {
            [weakSelf alert:@"检查是否发送过邀请失败"];
        } else {
            if (objects.count > 0) {
                AVIMConversation *tempConv = nil;
                for (AVIMConversation *conv in objects) {
                    NSArray *memberArr = conv.members;
                    NSDictionary *dict = conv.attributes;
                    NSNumber *convType = [dict objectForKey:@"type"];
                    
                    NSString *memberStr = [memberArr componentsJoinedByString:@","];
                    NSRange range = [memberStr rangeOfString:userObjId];
                    
                    if (range.length != 0 && convType.intValue == 2) {
                        tempConv = conv;
                        break;
                    }
                }
                if (tempConv) {
                    //已存在获取使用
                    [self useExsitConverstionWithId:userObjId conversion:tempConv];
                }else {
                    //创建新对话
                    [self createNewConversationWithId:userObjId];
                }
            } else {
                //创建新对话
                [self createNewConversationWithId:userObjId];
            }
        }
    }];
}

-(void) useExsitConverstionWithId:(NSString *)objectId conversion:(AVIMConversation*) conv{
    WEAKSELF
    NSDictionary *dict = self.conversion.attributes;
    NSString *url = [dict objectForKey:@"groupAvatarPicUrl"];
    if (url == nil) url = @"";
    
    NSString *groupName = weakSelf.conversion.name;
    //NSString *realConvid = conv.conversationId;
    NSString *creator = [AVUser currentUser].username;
    NSString *txt = [creator stringByAppendingString:@" 邀请你加入群 "];
    txt = [txt stringByAppendingString:groupName];
    //NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,@"groupAvatarPicUrl",realConvid,@"realConvid", groupName, @"groupName", nil];
    NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,MSG_ATTR_URL, self.conversion.conversationId, MSG_ATTR_ID, [NSString stringWithFormat:@"%lu", (unsigned long)MasterInvite], MSG_ATTR_TYPE,  nil];
    AVIMTextMessage *txtMsg = [AVIMTextMessage messageWithText:txt attributes:dict4msg];
    
    [conv sendMessage:txtMsg callback:^(BOOL succeeded, NSError *error) {
        if (error) {
            [weakSelf alert:@"发送邀请失败，请重试 :)"];
        } else {
            [weakSelf showInfo:@"已邀请，请等待"];
        }
    }];
}

-(void) createNewConversationWithId:(NSString *) objectId {
    AVUser *currentUser = [self getCurrentUser];
    NSArray *clientIdArr = @[currentUser.objectId, objectId];
    
    WEAKSELF
    [_im.imClient
     createConversationWithName:self.conversion.conversationId clientIds:clientIdArr
                     attributes:@{@"type":[NSNumber numberWithInt:CDConvTypeSystem]}
                        options:AVIMConversationOptionNone
                       callback:^(AVIMConversation *conv, NSError *error) {
        if (error) {
            [weakSelf alert:@"创建邀请对话失败，请重试 :)"];
        } else {
            //头像url 群名称 创建者
            //NSLog(@"covn:%@", self.conversion);
            NSDictionary *dict = self.conversion.attributes;
            NSString *url = [dict objectForKey:@"groupAvatarPicUrl"];
            if (url == nil) url = @"";
            
            NSString *groupName = weakSelf.conversion.name;
            //NSString *realConvid = conv.conversationId;
            NSString *creator = [AVUser currentUser].username;
            NSString *txt = [creator stringByAppendingString:@" 邀请你加入群 "];
            txt = [txt stringByAppendingString:groupName];
            
            //NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,@"groupAvatarPicUrl",realConvid,@"realConvid", groupName, @"groupName", nil];
            
            NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,MSG_ATTR_URL, self.conversion.conversationId, MSG_ATTR_ID, [NSString stringWithFormat:@"%lu", (unsigned long)MasterInvite], MSG_ATTR_TYPE,  nil];
            
            AVIMTextMessage *txtMsg = [AVIMTextMessage messageWithText:txt attributes:dict4msg];
            [conv sendMessage:txtMsg callback:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [weakSelf alert:@"邀请互关失败，请重试 :)"];
                } else {
                    [weakSelf showInfo:@"已邀请，请等待"];
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableViewDataSource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AddUserTableViewCell calculateCellHeightWithUser:self.users[indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddUserTableViewCell *userListCell= [tableView dequeueReusableCellWithIdentifier:@"addUserListCell"];
    if(userListCell==nil){
        userListCell=[[AddUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addUserListCell"];
    }
    userListCell.user=self.users[indexPath.row];
    userListCell.indexPath = indexPath;
    userListCell.addUserTableViewCellDelegate = self;
    return userListCell;
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


#pragma userListViewDelegate Cell Delegate
-(void)didAvatarImageViewClick:(UIGestureRecognizer *)gestureRecognizer indexPath:(NSIndexPath *)indexPath{
//    PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
//    personalInfoVC.user = self.users[indexPath.row];
//    
//    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

#pragma AddUserTableViewCell Delegate
-(void) addOrDeleteAUserWithFlag:(bool)isAdd avUser:(AVUser *)user indexPath:(NSIndexPath *)indexPath{
    if (isAdd) {
        [self.tempMembers addObject:user];
    } else {
        [self.tempMembers removeObject:user];
    }
}

@end
