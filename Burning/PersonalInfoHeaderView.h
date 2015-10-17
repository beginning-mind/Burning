//
//  PersonalInfoHeaderView.h
//  Burning
//
//  Created by wei_zhu on 15/6/15.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>


@interface PersonalInfoHeaderView : UIView
{
    @private
    BOOL _isAttetion;
    BOOL _isMe;
}

@property(nonatomic,strong)AVUser *user;

+(CGFloat)calculateHeightWithSignature:(NSString*)sigNature;

@end
