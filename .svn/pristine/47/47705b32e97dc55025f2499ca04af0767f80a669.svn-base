//
//  CDIMClient.h
//  LeanChat
//
//  Created by lzw on 15/1/21.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDAVOSHeaders.h"
#import "CDUserModel.h"
#import "AVIMConversation+Custom.h"

@interface CDIM : NSObject

@property AVIMClient *imClient;

@property (nonatomic, strong, readonly) NSString *selfId;

@property (nonatomic, strong) id <CDUserModel> selfUser;

@property (nonatomic, assign) BOOL connect;

+ (instancetype)sharedInstance;

- (void)openWithClientId:(NSString *)clientId callback:(AVIMBooleanResultBlock)callback;

- (void)closeWithCallback:(AVBooleanResultBlock)callback;

- (void)fecthConvWithId:(NSString *)convid callback:(AVIMConversationResultBlock)callback;

- (void)fetchConvWithOtherId:(NSString *)otherId callback:(AVIMConversationResultBlock)callback;

- (void)fetchConvWithMembers:(NSArray *)members callback:(AVIMConversationResultBlock)callback;

- (void)fetchGroupConvsWithClientId:(NSString *)clientId callback:(AVIMConversationsResultBlock)callback;

- (void)fetchConvsWithConvids:(NSSet *)convids callback:(AVIMArrayResultBlock)callback;

- (void)fetchConvsWithArrayConvids:(NSArray *)convids
                          callback:(AVIMArrayResultBlock)callback;

- (void)fetchConvsWithConvName:(NSString *)convName AndCreator:(NSString *)creator callback:(AVIMArrayResultBlock)callback;

- (void)fetchSystemConvWithConvId:(NSString *)convId AndMemberId:(NSString *)memberId callback:(AVIMArrayResultBlock)callback;

- (void)fetchConvsWithLimit:(NSInteger)limit skip:(NSInteger)skip latitude:(double)latitude longitude:(double)longitude callback:(AVIMArrayResultBlock)callback;

-(void)fetchConvsWithSequenceNum:(NSInteger)sequenceNum callback:(AVIMArrayResultBlock)callback;


- (void)createConvWithMembers:(NSArray *)members type:(CDConvType)type callback:(AVIMConversationResultBlock)callback;

- (void)updateConv:(AVIMConversation *)conv name:(NSString *)name attrs:(NSDictionary *)attrs callback:(AVIMBooleanResultBlock)callback;

- (void)deleteConvWithConvId:(NSString *)convId ;

- (BOOL)updateMsgConfirmStatusByMsgId:(NSString *)msgId;

- (void)findGroupedConvsWithBlock:(AVIMArrayResultBlock)block;

- (NSArray *)queryMsgsWithConv:(AVIMConversation *)conv msgId:(NSString *)msgId maxTime:(int64_t)time limit:(int)limit error:(NSError **)theError;

-(NSArray *)queryMsgsWithConvType:(NSInteger) convType;
-(NSArray *)querySystemMsgs;

-(void) deleteMsgWithConvid:(NSString *)convid;

- (void)findRecentRoomsWithBlock:(AVArrayResultBlock)block;

- (AVIMConversation *)lookupConvById:(NSString *)convid;

- (AVUser *)lookupUserById:(NSString *)objectId;

- (void)registerUser:(AVUser *)user;

#pragma mark - path utils

- (NSString *)getPathByObjectId:(NSString *)objectId;

- (NSString *)tmpPath;

#pragma mark - conv utils

- (NSString *)uuid;

@end
