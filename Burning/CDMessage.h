//
//  CDMessage.h
//  Burning
//
//  Created by Xiang Li on 15/8/7.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MSG_ATTR_ID @"msgAttrId"//主体ID
#define MSG_ATTR_NAME @"msgAttrName"

#define MSG_ATTR_TYPE @"msgAttrType"
#define MSG_ATTR_URL @"msgAttrUrl"
#define MSG_ATTR_REAL_CONVID @"msgAttrRealConvId"

typedef enum : NSUInteger {
    MasterInvite =0,
    FriendAccept =1,
    
    VisitorApply = 2,
    MasterAccept = 3,
    
    MemberQuit = 4,
    MasterDismiss = 5,
    
    MasterMoveOut = 6
} CDMessageType;

@interface CDMessage : NSObject

@end
