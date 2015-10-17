//
//  CDChatRoomController.h
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/28/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "XHMessageTableViewController.h"
#import "CDIM.h"

@protocol CDChatRoomVCDelegate <NSObject>

/**
 *  长按消息发送者的头像回调方法
 *
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didLongPressAvatorOnMessage:(NSString*)username;

@end



@interface CDChatRoomVC : XHMessageTableViewController

@property (nonatomic, strong) AVIMConversation *conv;

@property (nonatomic, strong) NSMutableArray *msgs;

@property (nonatomic, strong) CDIM *im;

@property (nonatomic, weak) id<CDChatRoomVCDelegate> cdChatRoomVCDelegate;

- (instancetype)initWithConv:(AVIMConversation *)conv;

+(NSString*) getConvidInChatRoom;

@end
