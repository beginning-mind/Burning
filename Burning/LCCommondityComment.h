//
//  LCCommondityComment.h
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCCommodity.h"

@interface LCCommondityComment : AVObject<AVSubclassing>

@property(nonatomic,strong)LCCommodity *commodity;
@property(nonatomic,copy)NSString *commentContent;
@property(nonatomic,strong)AVUser *commentUser;
@property(nonatomic,strong)AVUser *toUser;

@end
