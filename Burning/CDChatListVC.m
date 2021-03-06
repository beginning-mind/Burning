//
//  CDChatListController.m
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/25/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "CDChatListVC.h"
#import "LZStatusView.h"
#import "UIView+XHRemoteImage.h"
#import "CDChatListTableViewCell.h"
#import "CDIM.h"
#import "CDMacros.h"
#import "AVIMConversation+Custom.h"
#import "CDIMConfig.h"
#import "UIView+XHRemoteImage.h"
#import "CDEmotionUtils.h"
#import "CDNotify.h"
#import "GroupSysMsgTableViewCell.h"
#import "CDChatRoomVC.h"
#import "LCESysMsgVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <NSDate+DateTools.h>
#import <AFMInfoBanner.h>

@interface CDChatListVC ()

@property (nonatomic) LZStatusView *clientStatusView;

@property (nonatomic, strong) NSMutableArray *rooms;

@property (nonatomic, strong) CDNotify *notify;

@property (nonatomic, strong) CDIM *im;

@property (nonatomic, strong) CDStorage *storage;

@property (nonatomic, strong) CDIMConfig *imConfig;

@end

static NSMutableArray *cacheConvs;

@implementation CDChatListVC

static NSString *cellIdentifier = @"ContactCell";

- (instancetype)init {
    if ((self = [super init])) {
        _rooms = [[NSMutableArray alloc] init];
        _im = [CDIM sharedInstance];
        _storage = [CDStorage sharedInstance];
        _notify = [CDNotify sharedInstance];
        _imConfig = [CDIMConfig config];
        
        //设置线条顶格画
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        //设置不显示多余的白线
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [self.tableView setTableFooterView:view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [CDChatListTableViewCell registerCellToTableView:self.tableView];
    self.refreshControl = [self getRefreshControl];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf refresh:nil];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_notify removeMsgObserver:self];
    [_notify addMsgObserver:self selector:@selector(refresh)];
    [self.im addObserver:self forKeyPath:@"connect" options:NSKeyValueObservingOptionNew context:NULL];
    [self updateStatusView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_im removeObserver:self forKeyPath:@"connect"];
    //[_notify removeMsgObserver:self];
}

#pragma mark - Propertys

- (LZStatusView *)clientStatusView {
    if (_clientStatusView == nil) {
        _clientStatusView = [[LZStatusView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), kLZStatusViewHight)];
    }
    return _clientStatusView;
}

- (UIRefreshControl *)getRefreshControl {
    UIRefreshControl *refreshConrol;
    refreshConrol = [[UIRefreshControl alloc] init];
    [refreshConrol addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    return refreshConrol;
}

#pragma mark - notification

- (void)refresh {
    [self refresh:nil];
}

#pragma mark

- (void)stopRefreshControl:(UIRefreshControl *)refreshControl {
    if (refreshControl != nil && [[refreshControl class] isSubclassOfClass:[UIRefreshControl class]]) {
        [refreshControl endRefreshing];
    }
}

- (BOOL)filterError:(NSError *)error {
    if (error) {
        //        [[[UIAlertView alloc]
        //                  initWithTitle:nil message:[NSString stringWithFormat:@"%@", error] delegate:nil
        //                  cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        //                initWithTitle:nil message:[NSString stringWithFormat:@"%@", @"网络不太稳定嗳 :("] delegate:nil
        //                            cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        [AFMInfoBanner showAndHideWithText:@"网络有些不太对劲 :(" style:AFMInfoBannerStyleError];
        return NO;
    }
    return YES;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.im findRecentRoomsWithBlock:^(NSArray *objects, NSError *error) {
                                [self stopRefreshControl:refreshControl];
                                if([self filterError:error]) {
                                    _rooms = objects;
                                    //NSInteger totalUnreadCount = 0;
                                    self.totolUnReadCount = 0;
                                    for (CDRoom *room in _rooms) {
                                        self.totolUnReadCount += room.unreadCount;
                                    }
                                    [UIApplication sharedApplication].applicationIconBadgeNumber=self.totolUnReadCount;
                                    if([self.chatListDelegate respondsToSelector:@selector(setBadgeWithTotalUnreadCount:)]) {
                                        [self.chatListDelegate setBadgeWithTotalUnreadCount:self.totolUnReadCount];
                                    }
                                    [self.tableView reloadData];
                                }
        }];
}

#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_rooms count];
}

- (NSString *)getMessageTitle:(AVIMTypedMessage *)msg {
    NSString *title;
    AVIMLocationMessage *locationMsg;
    switch (msg.mediaType) {
        case kAVIMMessageMediaTypeText:
            title = [CDEmotionUtils emojiStringFromString:msg.text];
            break;
            
        case kAVIMMessageMediaTypeAudio:
            title = @"语音";
            break;
        case kAVIMMessageMediaTypeVideo:
            title = @"视频";
            break;
            
        case kAVIMMessageMediaTypeImage:
            title = @"图片";
            break;
            
        case kAVIMMessageMediaTypeLocation:
            locationMsg = (AVIMLocationMessage *)msg;
            title = locationMsg.text;
            break;
        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDChatListTableViewCell *cell = [CDChatListTableViewCell dequeueOrCreateCellByTableView:tableView];
    //    cell.avatarImageView.layer.masksToBounds = YES;
    //    cell.avatarImageView.layer.cornerRadius = 36/2.0;
    
    CDRoom *room = [_rooms objectAtIndex:indexPath.row];
    switch (room.type) {
        case CDConvTypeSingle://单聊
        {
            id <CDUserModel> user = [[CDIMConfig config].userDelegate getUserById:room.conv.otherId];
            cell.nameLabel.text = user.username;
            //[cell.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarUrl]];
            [cell.avatarImageView sd_cancelCurrentImageLoad];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"group_blank"]];
            cell.messageLabel.text = [self getMessageTitle:room.lastMsg];//最后一条消息
        }
            break;
        case CDConvTypeGroup://群聊
        {
            NSString *sUrl = [room.conv.attributes objectForKey:@"groupAvatarPicUrl"];
            //            [cell.avatarImageView setImageWithURL:[NSURL URLWithString:sUrl] placeholer:[UIImage imageNamed:@"group_blank"]];
            [cell.avatarImageView sd_cancelCurrentImageLoad];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:sUrl] placeholderImage:[UIImage imageNamed:@"group_blank"]];
            
            cell.nameLabel.text = room.conv.displayName;
            cell.messageLabel.text = [self getMessageTitle:room.lastMsg];//最后一条消息
        }
            break;
            
        case CDConvTypeSystem: {
            [cell.avatarImageView setImage:[UIImage imageNamed:@"sys-msg"]];
            cell.nameLabel.text = @"群系统消息";
            cell.messageLabel.text = room.lastMsg.text;
        }
            break;
            
        case CDConvTypeDynamics://动态通知
        {
            [cell.avatarImageView setImage:[UIImage imageNamed:@"ms_plnoti"]];
            cell.nameLabel.text = @"动态通知";
            cell.messageLabel.text =room.lastMsg.text;
        }
            break;
        case CDConvTypeActivity://活动通知
        {
            [cell.avatarImageView setImage:[UIImage imageNamed:@"ms_acnoti"]];
            cell.nameLabel.text = @"活动通知";
            cell.messageLabel.text =room.lastMsg.text;
        }
            break;
        case CDConvTypeAttention://关注通知
        {
            [cell.avatarImageView setImage:[UIImage imageNamed:@"follow"]];
            cell.nameLabel.text = @"关注通知";
            cell.messageLabel.text =room.lastMsg.text;
        }
            break;
        default:
            break;
    }
    
    if (room.lastMsg) {
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        //        NSString *timeString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:room.lastMsg.sendTimestamp / 1000]];
        //        cell.timestampLabel.text = timeString;
        
        NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:room.lastMsg.sendTimestamp / 1000];
        cell.timestampLabel.text = curDate.timeAgoSinceNow;
    }
    else {
        cell.timestampLabel.text = @"";
    }
    cell.unreadCount = room.unreadCount;
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        CDRoom *room = [_rooms objectAtIndex:indexPath.row];
//        [_storage deleteRoomByConvid:room.conv.conversationId];
//        [self refresh];
//    }
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CDRoom *room = [_rooms objectAtIndex:indexPath.row];
    CDChatListTableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    selectCell.unreadCount = 0;
    
    if ([self.chatListDelegate respondsToSelector:@selector(viewController:didSelectRoom:)]) {
        [self.chatListDelegate viewController:self didSelectRoom:room];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CDChatListTableViewCell heightOfCell];
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

#pragma mark - connect

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.im && [keyPath isEqualToString:@"status"]) {
        [self updateStatusView];
    }
}

- (void)updateStatusView {
    if (self.im.connect) {
        self.tableView.tableHeaderView = nil ;
    }else {
        //self.tableView.tableHeaderView = self.clientStatusView;
    }
}



@end
