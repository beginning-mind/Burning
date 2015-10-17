//
//  ModelTransfer.h
//  Burning
//
//  Created by wei_zhu on 15/6/11.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCPublish.h"
//#import "SHPublish.h"
#import "LCComment.h"
#import "LCActivity.h"
//#import "SHActivity.h"
#import "LCActivityComment.h"
#import "SHGroup.h"
#import "AVIMConversation+Custom.h"
#import "LCBodyBuilding.h"
#import "SHBodyBuilding.h"

@interface ModelTransfer : NSObject

//+(SHPublish*)lcPublishToSHPublish:(LCPublish*)lcPublish;

//+(SHPubComment*)lcCommentToSHPubComment:(LCComment*)lcComment;

//+(SHActivity*)lcActivityToSHActivity:(LCActivity*)lcActivity;

//+(SHActivityComment*)lcActivityCommentToSHActivityComment:(LCActivityComment*)lcActivityComment;

+(SHGroup *)coversation2SHGroup:(AVIMConversation *)conversation AndCurlocation:(CLLocation*)curLocation;

+(SHBodyBuildingGroup*)lcBodyBuildingToSHBodyBuildingGroup:(LCBodyBuilding*)lcBodyBuilding;

+(SHBodyBuilding*)lcBodyBuildingToSHBodyBuilding:(LCBodyBuilding*)lcBodyBuilding;
@end
