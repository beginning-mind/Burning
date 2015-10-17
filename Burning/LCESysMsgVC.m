//
//  LCESysMsgVC.m
//  Burning
//
//  Created by Xiang Li on 15/7/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "LCESysMsgVC.h"
#import "GroupSysMsgTableViewCell.h"
#import "CDStorage.h"
#import "CDIM.h"
#import "CDMessage.h"

static NSInteger groupLimit = 50;

@interface LCESysMsgVC ()<GroupSysMsgTableViewCellDelegate>

@property (nonatomic, strong) CDStorage *storage;

@end

@implementation LCESysMsgVC

- (instancetype)init {
    self = [super init];
    if (self) {
        _im = [CDIM sharedInstance];
        _storage = [CDStorage sharedInstance];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    self.sysMsgTableView.dataSource = self;
    self.sysMsgTableView.delegate = self;
    
    //设置不显示多余的白线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.sysMsgTableView setTableFooterView:view];
}

-(void)viewDidAppear:(BOOL)animated {
//    [_storage clearUnreadWithConvid:self.conversion.conversationId];
}

-(void)viewDidDisappear:(BOOL)animated {
    [_storage clearUnreadWithConvid:self.conversationId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark TableViewDataSource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sysMsgs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [GroupSysMsgTableViewCell calculateCellHeightWithMessage:self.sysMsgs[indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupSysMsgTableViewCell *groupSysMsgTableViewCell= [tableView dequeueReusableCellWithIdentifier:@"groupSysMsgTableViewCell"];
    if(groupSysMsgTableViewCell==nil){
        groupSysMsgTableViewCell=[[GroupSysMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupSysMsgTableViewCell"];
    }
    
    groupSysMsgTableViewCell.avIMTypedMessage = self.sysMsgs[indexPath.row];
    AVIMTypedMessage *msg = self.sysMsgs[indexPath.row];
    
    NSDictionary *msgDict = msg.attributes;
    NSString *typeStr = [msgDict objectForKey:MSG_ATTR_TYPE];
    int type = [typeStr intValue];
    
    switch (type) {
        case MasterInvite: {
                NSString *isConfirmed = [msgDict objectForKey:@"isConfirmed"];
                if ([isConfirmed isEqualToString:@"1"]) {
                    [groupSysMsgTableViewCell.selectedButton setTitle:@"聊天" forState:UIControlStateNormal];
                }
            }
            break;
            
        case FriendAccept:
            groupSysMsgTableViewCell.selectedButton.hidden = YES;
            break;
            
        case VisitorApply: {
                NSString *isConfirmed = [msgDict objectForKey:@"isConfirmed"];
                if ([isConfirmed isEqualToString:@"1"]) {
                    [groupSysMsgTableViewCell.selectedButton setTitle:@"聊天" forState:UIControlStateNormal];
                                    //[groupSysMsgTableViewCell.selectedButton setBackgroundColor:RGB(30, 172, 199)];
                                    
                    //                    groupSysMsgTableViewCell.selectedButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    //                    [UIButton animateWithDuration:0.2 animations:^{
                    //                        groupSysMsgTableViewCell.selectedButton.transform = CGAffineTransformMakeScale(1.1, 1.1);
                    //                    } completion:^(BOOL finished) {
                    //                        [UIButton animateWithDuration:0.2 animations:^{
                    //                            groupSysMsgTableViewCell.selectedButton.transform = CGAffineTransformMakeScale(1, 1);
                    //                        } completion:^(BOOL finished) {
                    //                        }];
                    //                    }];
                }
            }
            break;
            
        case MasterAccept:
            groupSysMsgTableViewCell.selectedButton.hidden = YES;
            break;
            
        case MemberQuit:
            groupSysMsgTableViewCell.selectedButton.hidden = YES;
            break;
            
        case MasterDismiss:
            groupSysMsgTableViewCell.selectedButton.hidden = YES;
            break;
            
        case MasterMoveOut:
            groupSysMsgTableViewCell.selectedButton.hidden = YES;
            break;
            
        default:
            break;
    }
    
    groupSysMsgTableViewCell.indexPath = indexPath;
    groupSysMsgTableViewCell.groupSysMsgTableViewCellDelegate = self;
    return groupSysMsgTableViewCell;
}



#pragma GroupSysMsgTableViewCell Delegate

-(void)confirmJoinAGroupWithRealConvid:(NSString *)realConvid AVMsg:(AVIMTypedMessage *)avMsg AndGroupName:(NSString *)groupname indexPath:(NSIndexPath *)indexPath {
    AVIMConversation *sysConv = [self.im lookupConvById:realConvid];
    
    //拿到群对话
    [self.im fecthConvWithId:sysConv.name callback:^(AVIMConversation *conversation, NSError *error) {
        __block AVIMConversation *weakConv = conversation;
        if (error) {
            [self alert:@"同意加入群后，获取对话异常"];
        }else {
            NSDictionary *convDict = sysConv.attributes;
            NSNumber *convType = [convDict objectForKey:@"type"];
            NSArray *cliends;
            
            NSDictionary *msgDict = avMsg.attributes;
            NSString *typeStr = [msgDict objectForKey:MSG_ATTR_TYPE];
            int msgType = [typeStr intValue];
            
            switch (msgType) {
                case MasterInvite:
                    cliends = [[NSArray alloc] initWithObjects:[self getCurrentUser].objectId, nil];
                    break;
                case FriendAccept:
                    
                    break;
                case VisitorApply:
                    cliends = [[NSArray alloc] initWithObjects:sysConv.creator, nil];
                    break;
                case MasterAccept:
                    
                    break;
                case MemberQuit:
                    
                    break;
                case MasterDismiss:
                    break;
                    
                default:
                    break;
            }
            
            NSArray *memberArr = conversation.members;
            if (memberArr.count < groupLimit) {
                [conversation addMembersWithClientIds:cliends callback:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        [self alert:@"添加群成员异常"];
                    } else {
                        [self.im updateMsgConfirmStatusByMsgId:avMsg.messageId];
                        
                        //同意添加后修改按钮值
                        AVIMTypedMessage *msg = [self.sysMsgs objectAtIndex:indexPath.row];
                        NSDictionary *tempDict = msg.attributes;
                        NSMutableDictionary *newDict = [[NSMutableDictionary alloc]init];
                        for (NSString *key in tempDict) {
                            if ([key isEqualToString:@"isConfirmed"]) {
                                [newDict setObject:@"1" forKey:key];
                            }else {
                                [newDict setObject:[tempDict objectForKey:key] forKey:key];
                            }
                        }
                        msg.attributes = [newDict copy];
                        [self.sysMsgs replaceObjectAtIndex:indexPath.row withObject:msg];
                        [self.sysMsgTableView reloadRowsAtIndexPaths:[[NSArray alloc]initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                        NSString *txt = @"";
                        NSDictionary *dict4msg;
                        NSString *msgAttUrl = @"";
                        AVFile *avFile = [[AVUser currentUser] objectForKey:@"avatar"];
                        if (avFile.url) {
                            msgAttUrl = avFile.url;
                        }
                        
                        switch (msgType) {
                            case MasterInvite:{
                                NSString *msgAttId = [AVUser currentUser].objectId;
                                
                                txt = [[self getCurrentUser].username stringByAppendingString:@" 同意加入群 "];
                                txt = [txt stringByAppendingString:conversation.name];
                                
                                dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:msgAttUrl,MSG_ATTR_URL, msgAttId, MSG_ATTR_ID, [NSString stringWithFormat:@"%lu", (unsigned long)FriendAccept], MSG_ATTR_TYPE,  nil];
                            }
                                break;
                                
                            case FriendAccept:
                                break;
                                
                            case VisitorApply: {
                                NSString *msgAttId = weakConv.conversationId;
                                NSLog(@"msgAttId: %@", msgAttId);
                                
                                txt = [[self getCurrentUser].username stringByAppendingString:@" 同意加入群 "];
                                txt = [txt stringByAppendingString:conversation.name];
                                
                                dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:msgAttUrl,MSG_ATTR_URL, msgAttId, MSG_ATTR_ID, [NSString stringWithFormat:@"%lu", (unsigned long)MasterAccept], MSG_ATTR_TYPE,  nil];
                            }
                                break;
                                
                            case MasterAccept:
                                break;
                                
                            case MemberQuit:
                                break;
                            case MasterDismiss:
                                break;
                                
                            default:
                                break;
                        }
                        
                        AVIMTextMessage *txtMsg = [AVIMTextMessage messageWithText:txt attributes:dict4msg];
                        [sysConv sendMessage:txtMsg callback:^(BOOL succeeded, NSError *error) {
                            if (error) {
                                [self alert:@"同意加入群后，返回消息异常"];
                            }
                        }];
                    }
                }];
            }else {
                [self alert:@"此群人数已达上限!"];
            }
        }
    }];
}

#pragma GroupSysMsgTableViewCell Delegate
-(void)startAConverstionWithConversationId:(NSString *) convid {
    if ([_lceSysMsgVCDelegate respondsToSelector:@selector(startAConverstionWithConversation:)]) {
        
        if ([self.im lookupConvById:convid]) {//消息的对话的id找消息对话
            AVIMConversation *sysConv = [self.im lookupConvById:convid];
            
            if ([self.im lookupConvById:sysConv.name]) {//消息对话的名字关联群对话
                AVIMConversation *grouConv =[self.im lookupConvById:sysConv.name];
                [_lceSysMsgVCDelegate startAConverstionWithConversation:grouConv];
            }else {
                [self.im fecthConvWithId:sysConv.name callback:^(AVIMConversation *conversation, NSError *error) {
                    if (error) {
                    }else {
                        [_lceSysMsgVCDelegate startAConverstionWithConversation:conversation];
                    }
                }];
            }
        }
    }
}


@end
