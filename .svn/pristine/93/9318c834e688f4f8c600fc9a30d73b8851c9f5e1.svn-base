//
//  GroupSysMsgTableViewCell.h
//  Burning
//
//  Created by Xiang Li on 15/7/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVIMTypedMessage.h>

@protocol GroupSysMsgTableViewCellDelegate <NSObject>
@optional

-(void)didAvatarImageViewClick:(UIGestureRecognizer*)gestureRecognizer indexPath:(NSIndexPath*)indexPath;

//-(void)confirmJoinAGroupWithRealConvid:(NSString *)realConvid Msgid:(NSString*)msgid AndGroupName:(NSString*) groupname indexPath:(NSIndexPath*)indexPath;
-(void)confirmJoinAGroupWithRealConvid:(NSString *)realConvid AVMsg:(AVIMTypedMessage *)avMsg AndGroupName:(NSString *)groupname indexPath:(NSIndexPath *)indexPath;

-(void)startAConverstionWithConversationId:(NSString *) convid;

@end

@interface GroupSysMsgTableViewCell : UITableViewCell

@property (nonatomic,strong) AVIMTypedMessage *avIMTypedMessage;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,strong) id<GroupSysMsgTableViewCellDelegate> groupSysMsgTableViewCellDelegate;
@property (nonatomic,strong) NSString* isFromMember;
@property (nonatomic,strong)UIButton *selectedButton;
//+(CGFloat)calculateCellHeight;
+(CGFloat)calculateCellHeightWithMessage:(AVIMTypedMessage*)message;

@end
