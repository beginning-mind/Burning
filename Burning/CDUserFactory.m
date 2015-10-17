//
//  CDUserFactory.m
//  LeanChatExample
//
//  Created by lzw on 15/4/7.
//  Copyright (c) 2015年 avoscloud. All rights reserved.
//

#import "CDUserFactory.h"
#import "CDUser.h"
#import "LCDataHelper.h"

@implementation CDUserFactory

#pragma mark - CDUserDelegate
- (void)cacheUserByIds:(NSSet *)userIds block:(AVIMArrayResultBlock)block {
    
    
//    [self.lcDataHelper getUserArrayWithObjectIdArray:[userIds allObjects] block:^(NSArray *objects, NSError *error) {
//        if (error) {
//            block(nil, error);
//        }else {
//            block(objects, error);
//        }
//        
//    }];
    block(nil, nil);
}

- (id <CDUserModel> )getUserById:(NSString *)userId {

    CDUser *user = [[CDUser alloc] init];
    user.userId = userId;
    AVUser *currUser = [AVUser currentUser];
    if ([userId isEqualToString:currUser.objectId]) {
        user.username = currUser.username;
        AVFile *avFile = [currUser objectForKey:@"avatar"];
        user.avatarUrl = avFile.url;
    }else {
        CDIM *im = [CDIM sharedInstance];
        if ([im lookupUserById:userId]) {
            user.username = [[im lookupUserById:userId] objectForKey:@"username"];
            AVFile *avFile = [[im lookupUserById:userId] objectForKey:@"avatar"];
            user.avatarUrl = avFile.url;
        } else {
            AVQuery *q = [AVUser query];
            AVObject *obj = [q getObjectWithId:userId];
            user.username = [obj objectForKey:@"username"];
            AVFile *avFile = [obj objectForKey:@"avatar"];
            user.avatarUrl = avFile.url;
            
            [im registerUser:obj];
        }
    }

    return user;
}

@end
