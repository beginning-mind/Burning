//
//  CDConvsVC.m
//  LeanChat
//
//  Created by lzw on 15/4/10.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import "LCEChatListVC.h"
#import "LCEChatRoomVC.h"
#import "BuringTabBarController.h"
#import "GroupCreationViewController.h"
#import "LCESysMsgVC.h"
#import "CDUserFactory.h"
#import "FollowNotiViewController.h"
#import "CDStorage.h"
#import "PubNotiViewController.h"

@interface LCEChatListVC () <CDChatListVCDelegate, LCESysMsgVCDelegate>

@end

@implementation LCEChatListVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"消息";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_chat_active"];
        self.chatListDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CDIMConfig config].userDelegate = [[CDUserFactory alloc] init];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden =NO;
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"新建群" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClicked:)];
    self.navigationItem.rightBarButtonItems = @[addItem];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.barTintColor =RGB(59, 59, 73);
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//按钮颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    BuringTabBarController *tabBarController = (BuringTabBarController*)self.tabBarController;
    [tabBarController showTabbar];
}


- (void)logout:(id)sender {
    [[CDIM sharedInstance] closeWithCallback: ^(BOOL succeeded, NSError *error) {
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        [self performSelector:@selector(exitApp:) withObject:nil afterDelay:0.5];
    }];
}

- (void)exitApp:(id)sender {
    exit(0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- CDChatListVC Delegate
- (void)viewController:(UIViewController *)viewController didSelectRoom:(CDRoom *)cdroom {
    AVIMConversation *conv = cdroom.conv;
    //NSDictionary *dict =conv.attributes;
    
    self.totolUnReadCount -=cdroom.unreadCount;
//    NSLog(@"-------unreadCount:%ld",(long)cdroom.unreadCount);
//    NSLog(@"--------dakaizhiqian:%ld",[UIApplication sharedApplication].applicationIconBadgeNumber);
    [UIApplication sharedApplication].applicationIconBadgeNumber-=cdroom.unreadCount;
//    NSLog(@"--------dakaizhihou:%ld",[UIApplication sharedApplication].applicationIconBadgeNumber);
    if ([UIApplication sharedApplication].applicationIconBadgeNumber<0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    }
    [self setBadgeWithTotalUnreadCount:self.totolUnReadCount];
//    if (self.totolUnReadCount<=0) {
//        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
//    }
    [[CDStorage sharedInstance] clearUnreadWithConvid:cdroom.convid];
    switch (cdroom.type) {
        case CDConvTypeSystem:
        {
            LCESysMsgVC *lceSysMsgVC = [[LCESysMsgVC alloc] init];
            lceSysMsgVC.hidesBottomBarWhenPushed = YES;
            //lceSysMsgVC.conversion = conv;
            lceSysMsgVC.conversationId = cdroom.convid;
            CDIM *im = [CDIM sharedInstance];
            lceSysMsgVC.sysMsgs = [[im querySystemMsgs] mutableCopy];
            lceSysMsgVC.lceSysMsgVCDelegate = self;
            [self.navigationController pushViewController:lceSysMsgVC animated:YES];
        }
            break;
        case CDConvTypeGroup:{
            LCEChatRoomVC *chatRoomVC = [[LCEChatRoomVC alloc] initWithConv:conv];
            [chatRoomVC setBackgroundColor:[UIColor whiteColor]];
            chatRoomVC.hidesBottomBarWhenPushed = YES;
            chatRoomVC.conversion = conv;
            [self.navigationController pushViewController:chatRoomVC animated:YES];

        }
            break;
        case CDConvTypeDynamics:
        {
            cdroom.unreadCount = 0;
            PubNotiViewController *pubNotiVC = [[PubNotiViewController alloc]init];
            NSArray *messageArry =[[CDStorage sharedInstance] getMsgsWithConvid:@"publish"];
            pubNotiVC.avIMMessageArray = messageArry;
            [self.navigationController pushViewController:pubNotiVC animated:YES];
        }
            break;
        case CDConvTypeActivity:{
            cdroom.unreadCount = 0;
            PubNotiViewController *pubNotiVC = [[PubNotiViewController alloc]init];
            NSArray *messageArry =[[CDStorage sharedInstance] getMsgsWithConvid:@"activity"];
            pubNotiVC.avIMMessageArray = messageArry;
            [self.navigationController pushViewController:pubNotiVC animated:YES];
        }
            break;
        case CDConvTypeAttention:{
            cdroom.unreadCount = 0;
            FollowNotiViewController *follwVC = [[FollowNotiViewController alloc]init];
            NSArray *messageArry =[[CDStorage sharedInstance] getMsgsWithConvid:@"attention"];
            follwVC.avIMMessageArray = messageArry;
            [self.navigationController pushViewController:follwVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount {

    BuringTabBarController *tabBarController = (BuringTabBarController*)self.tabBarController;
    if (totalUnreadCount > 0) {
        tabBarController.messagebadgeValue = [NSString stringWithFormat:@"%ld", totalUnreadCount];
    }
    else {
        tabBarController.messagebadgeValue =nil;
    }
}

- (void)rightBarButtonClicked:(id)sender {
    GroupCreationViewController *groupCreationViewController = [[GroupCreationViewController alloc] init];
    [self.navigationController pushViewController:groupCreationViewController animated:YES];
}

#pragma LCESysMsgVC Delegate
-(void)startAConverstionWithConversation:(AVIMConversation *) conv{
    
    CDChatRoomVC * cDChatRoomVC = [[CDChatRoomVC alloc] initWithConv:conv];
    cDChatRoomVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cDChatRoomVC animated:YES];

}


@end
