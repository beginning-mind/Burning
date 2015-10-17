//
//  LCDataHelper.h
//  Burning
//
//  Created by wei_zhu on 15/5/28.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCPublish.h"
#import "LCComment.h"
#import "LCObjectHeader.h"
#import "LCActivity.h"
#import "LCActivityComment.h"
#import "LCDailyNews.h"
#import "AVIMConversation+Custom.h"
#import "LCGroup.h"
#import "LCBodyBuilding.h"
#import "LCSequence.h"
#import "LCFeedback.h"
#import "LCReport.h"
#import "LCAddress.h"
#import "LCCommodity.h"
#import "LCShoppingCart.h"
#import "LCOrder.h"
#import "LCCommondityComment.h"

@interface LCDataHelper : NSObject


//publish

-(void)getPublishAttentiondWithlimit:(NSInteger*)limit skip:(NSInteger*)skip block:(AVArrayResultBlock)block;

-(void)getPublishWithObjectId:(NSString*)objId block:(AVArrayResultBlock)block;

//-(void)getPublishs:(AVArrayResultBlock)block;

-(void)getPublishsWithlimit:(NSInteger*)limit block:(AVArrayResultBlock)block;

-(void)getPublishsWithlimit:(NSInteger*)limit skip:(NSInteger*)skip block:(AVArrayResultBlock)block;

-(void)getPublishsWithUser:(AVUser*)user limit:(NSInteger*)limit skip:(NSInteger*)skip block:(AVArrayResultBlock)block;

-(void)getPublishsWithUserID:(NSString*)userID limit:(NSInteger*)limit skip:(NSInteger*)skip block:(AVArrayResultBlock)block;

-(void)digOrCancelDigOfPublish:(LCPublish*)lcPublish block:(AVBooleanResultBlock)block;

//-(void)getHotUserWithlimit:(NSInteger*)limit skip:(NSInteger*)skip block:(AVArrayResultBlock)block;

-(void)getHotPhotoWithlimit:(NSInteger*)limit block:(AVArrayResultBlock)block;

-(void)getHotPhotoWithlimit:(NSInteger*)limit skip:(NSInteger*)skip block:(AVArrayResultBlock)block;

-(void)publishWithContent:(NSString*)content images:(NSArray*)images error:(NSError**)error;

-(void)pubComment:(LCComment*)comment AtPublish:(LCPublish*)lcPublish  block:(AVBooleanResultBlock)block;

//-(void)attentionUser:(LCUser*)user;
//
//-(void)unAttentionUser:(LCUser*)user;

-(void)getUserWithPhoneNum:(NSString*)phoneNum block:(AVArrayResultBlock)block;

-(void)getUserWithUsername:(NSString *)username butNotObjId:(NSString*)objId block:(AVArrayResultBlock)block;

-(void)getUserWithUsername:(NSString *)username block:(AVArrayResultBlock)block;

-(void)getUsersFollowedEachOtherWithUser:(AVUser*)user block:(AVArrayResultBlock)block;

//Activity
-(void)getAcitivityWithObjectId:(NSString*)objId block:(AVArrayResultBlock)block;

-(void)getActivityWithlimit:(NSInteger*)limit skip:(NSInteger*)skip latitude:(double)latitude longitude:(double)longitude block:(AVArrayResultBlock)block;

-(void)createActivityWith:(NSString*)title date:(NSDate*)date place:(NSString*)place latitude:(double)latitude longitude:(double)longitude maxPersonCount:(NSString*)maxPersonCount coast:(NSString*)coast content:(NSString*)content backImage:(UIImage*)backImage error:(NSError**)error;

-(void)pubActivityComment:(LCActivityComment*)comment AtActivity:(LCActivity*)lcActivity block:(AVBooleanResultBlock)block;

-(void)attendActivity:(LCActivity*)lcActivity block:(AVBooleanResultBlock)block;

-(void)getUsersByUsernames:(NSMutableArray*)usernames block:(AVArrayResultBlock)block;

//DailyNews
-(void)getDailyNewsWithObjectID:(NSString*)objId block:(AVArrayResultBlock)block;

//Group
-(void)getGroupsWithLimit:(NSInteger)limit skip:(NSInteger)skip latitude:(double)latitude longitude:(double)longitude block:(AVArrayResultBlock)block;

-(void)deleteGeoGroupWithConversationId:(NSString*)convId;

//Person nearby
-(void)getPersonNearbyWithLimit:(NSInteger)limit skip:(NSInteger)skip latitude:(double)latitude longitude:(double)longitude  andGender:(NSString*)gender block:(AVArrayResultBlock)block;

-(void)saveAGroupWithConversation:(AVIMConversation *) conversion latitude:(double)latitude longitude:(double)longitude error:(NSError**)error;

//user
-(void)getUserWithObjectId:(NSString*)objId block:(AVArrayResultBlock)block;
-(void)getUserArrayWithObjectIdArray:(NSArray*)objIds block:(AVArrayResultBlock)block;

//bodybuildingVideo
-(void)getBodyBuildingBlock:(AVArrayResultBlock)block;

-(void)saveSequenceWithType:(NSInteger)type Block:(AVIntegerResultBlock)block;

//-(void) initSequenceWithType:(NSNumber *)type;

-(void)fetchPersonWithSequenceId:(NSInteger)sequenceNum Block:(AVArrayResultBlock)block;

-(void)saveFeedbackWithLCFeedback:(LCFeedback*)lcFeedback error:(NSError**)error;

#pragma mark LCReport
-(void)upLoadReport:(NSString*)reportUserID reportedUserID:(NSString*)reportedUserID publishID:(NSString*)publishID reportType:(NSInteger)reportType error:(NSError**)error;

-(void)saveAddressWithLCAddress:(LCAddress*) adderss error:(NSError**) error;
#pragma mark LCCommodity
-(void)getCommoditysWithlimit:(NSInteger*)limit skip:(NSInteger*)skip block:(AVArrayResultBlock)block;

#pragma mark LCShoppingCart
-(void)getShoppingCartsWithlimit:(NSInteger*)limit skip:(NSInteger*)skip block:(AVArrayResultBlock)block;

#pragma mark LCOrder
-(void)getOrdersWithlimit:(NSInteger*)limit skip:(NSInteger*)skip block:(AVArrayResultBlock)block;


@end
