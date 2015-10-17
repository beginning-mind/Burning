//
//  CDChatListController.h
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/25/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "AVIMConversation+Custom.h"
#import "GroupSysMsgTableViewCell.h"
#import "CDStorage.h"

@class CDChatListVC;

@protocol CDChatListVCDelegate <NSObject>

- (void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount;
- (void)viewController:(UIViewController *)viewController didSelectRoom:(CDRoom *)cdroom;
//- (void)viewController:(UIViewController *)viewController didSelectSysConv:(AVIMConversation *)conv;

@end

@interface CDChatListVC : UITableViewController

@property (nonatomic, strong) id <CDChatListVCDelegate> chatListDelegate;

@property(nonatomic,assign)NSInteger totolUnReadCount;

@end
