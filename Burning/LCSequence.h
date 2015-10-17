//
//  LCSequence.h
//  Burning
//
//  Created by Xiang Li on 15/8/13.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface LCSequence : AVObject<AVSubclassing>

@property(nonatomic, strong) NSNumber *sequenceNum;
@property(nonatomic, strong) NSNumber *type;

@end
