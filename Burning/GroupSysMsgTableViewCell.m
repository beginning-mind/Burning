//
//  GroupSysMsgTableViewCell.m
//  Burning
//
//  Created by Xiang Li on 15/7/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "GroupSysMsgTableViewCell.h"
#import "LayoutConst.h"
#import "SVGloble.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CDChatRoomVC.h"
#import "CDMessage.h"
#import "LCDataHelper.h"
#import "PersonalInfoViewController.h"
#import "GroupDetailViewController.h"
#import <NSDate+DateTools.h>
#import "NSString+DynamicHeight.h"

@interface GroupSysMsgTableViewCell()

@property (nonatomic,strong)UIImageView *avatarImageView;
@property (nonatomic,strong)UILabel *sigNatureLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@property (nonatomic)BOOL isOn;
@property (nonatomic,strong)NSString *realConvid;


@end

@implementation GroupSysMsgTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//+(CGFloat)calculateCellHeight{
//    CGFloat richTextHeight=kPubShowAvatarSpacing;
//    richTextHeight+=kPubShowUsernameHeight;
//    richTextHeight+=kPubShowContentLineSpacing;
//    NSString *signature;
//    richTextHeight+=[[self class] getContentLabelHeightWithText:signature];
//    richTextHeight+=kPubShowAvatarSpacing;
//    
//    CGFloat avatarSize = 2*kPubShowAvatarSpacing+kPubShowAvatarImageSize;
//    return richTextHeight>avatarSize? richTextHeight :avatarSize;
//}

+(CGFloat)contentWidth{
    return CGRectGetWidth([[UIScreen mainScreen] bounds])-3*kPubShowAvatarSpacing-kPubShowAvatarImageSize;
}

-(UIImageView*)avatarImageView{
    
    if(_avatarImageView==nil){
        _avatarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(kCommonAvatarLeadingSpace,kSmallSpace, kCommonAvatarSize, kCommonAvatarSize)];
//        _avatarImageView.layer.masksToBounds =YES;
//        _avatarImageView.layer.cornerRadius = kCommonAvatarSize/2.0;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sysMsgAvatarClick:)];
        [_avatarImageView addGestureRecognizer:singleTap];
    }
    return _avatarImageView;
}

-(void)sysMsgAvatarClick:(UITapGestureRecognizer*) gestureRecognizer{
    NSDictionary *dict = self.avIMTypedMessage.attributes;
    NSNumber *msgType = [dict objectForKey:MSG_ATTR_TYPE];
    NSString *attrId = [dict objectForKey:MSG_ATTR_ID];
    
    switch (msgType.intValue) {
        case MasterInvite:
            [self skip2ConversationWithConvId:attrId];
            break;
        
        case FriendAccept:
            [self skip2UserWithUserObjId:attrId];
            break;
            
        case VisitorApply:
            //[self skip2ConversationWithConvId:attrId];
            [self skip2UserWithUserObjId:attrId];
            break;
            
        case MasterAccept:
            [self skip2ConversationWithConvId:attrId];
            break;
        
        case MasterDismiss:
            [self skip2ConversationWithConvId:attrId];
            break;
            
        case MemberQuit:
            [self skip2UserWithUserObjId:attrId];
            break;
            
        case MasterMoveOut:
            [self skip2ConversationWithConvId:attrId];
            break;
            
        default:
            break;
    }
    
}

-(void) skip2ConversationWithConvId:(NSString *)convId {
    GroupDetailViewController *groupDetailViewController = [[GroupDetailViewController alloc]init];
    CDIM *im = [CDIM sharedInstance];
    [im fecthConvWithId:convId callback:^(AVIMConversation *conversation, NSError *error) {
        if (error) {
            NSLog(@"获取对话失败 T_T");
        } else {
            groupDetailViewController.conversion = conversation;
            BaseViewController *baseVC = [self getSuperViewController];
            [baseVC.navigationController pushViewController:groupDetailViewController animated:YES];
        }
        
    }];
}

-(void) skip2UserWithUserObjId:(NSString *)objId {
    LCDataHelper *lcDataHelper = [[LCDataHelper alloc]init];
    [lcDataHelper getUserWithObjectId:objId block:^(NSArray *objects, NSError *error) {
        if (error) {
           NSLog(@"获取用户失败 T_T");
        }else {
            if (objects.count>0) {
                AVUser *user = objects[0];
                PersonalInfoViewController *personalVC = [[PersonalInfoViewController alloc]init];
                personalVC.user = user;
                
                BaseViewController *baseVC = [self getSuperViewController];
                [baseVC.navigationController pushViewController:personalVC animated:YES];
            }
        }
    }];
    
}



- (UIViewController*)getSuperViewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

//-(UILabel*)usernameLabel{
//    if(_usernameLabel==nil){
//        _usernameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImageView.frame)+kPubShowAvatarSpacing, kPubShowAvatarSpacing,[[self class] contentWidth] , kPubShowUsernameHeight)];
//        _usernameLabel.backgroundColor=[UIColor clearColor];
//        _usernameLabel.textColor=RGB(52, 164, 254);
//        _usernameLabel.font =[UIFont systemFontOfSize:kPubShowFontSize];
//    }
//    return _usernameLabel;
//}

-(UILabel*)sigNatureLabel{
    if (_sigNatureLabel ==nil) {
        _sigNatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+kHotPhotInset, kSmallSpace, [UIScreen mainScreen].bounds.size.width-192, 18)];
        _sigNatureLabel.font = [UIFont systemFontOfSize:kCommonFontSize];
        _sigNatureLabel.textColor = RGB(0, 0, 0);
        _sigNatureLabel.numberOfLines=0;
    }
    return  _sigNatureLabel;
}

-(UILabel*)timeLabel{
    if (_timeLabel ==nil) {
        _timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.selectedButton.frame)-kCommonAvatarLeadingSpace-60,kSmallSpace, 60, 18)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font=[UIFont systemFontOfSize:kCommonFontSize];
        _timeLabel.textColor=RGB(133, 133, 133);
    }
    return  _timeLabel;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentFrame=_sigNatureLabel.frame;
    contentFrame.size.height = [NSString getTextHeight:self.avIMTypedMessage.text textFont:[UIFont systemFontOfSize:kCommonFontSize] width:CGRectGetWidth(self.sigNatureLabel.frame)];

    _sigNatureLabel.frame = contentFrame;
    
    CGFloat maxYAvatar = CGRectGetMaxY(self.avatarImageView.frame);
    CGFloat maxYContent = CGRectGetMaxY(self.sigNatureLabel.frame);
    
    CGFloat maxY = maxYAvatar>maxYContent?maxYAvatar:maxYContent;
    maxY+=kSmallSpace;
    CGRect frame=self.frame;
    frame.size.height = maxY;
    self.frame = frame;
}

+(CGFloat)calculateCellHeightWithMessage:(AVIMTypedMessage*)message{
    if(message==nil){
        return 0;
    }
    CGFloat richTextHeight=kSmallSpace;
    richTextHeight+=kCommonAvatarSize;
    richTextHeight +=kSmallSpace;
    
    CGFloat richtextHeight2 = 19;
    richtextHeight2+=[NSString getTextHeight:message.text textFont:[UIFont systemFontOfSize:kCommonFontSize] width:[UIScreen mainScreen].bounds.size.width-168];

    richtextHeight2+=kSmallSpace;
    
    return richTextHeight>richtextHeight2? richTextHeight :richtextHeight2;
}

-(UIButton*)selectedButton{
    if (_selectedButton==nil) {
        
        
         _selectedButton=[[UIButton alloc]initWithFrame:CGRectMake([SVGloble shareInstance].globleWidth-60-kCommonAvatarLeadingSpace, kSmallSpace, 60, 30)];
//        _selectedButton=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-60-kCommonAvatarLeadingSpace, kSmallSpace, 60, 30)];
        
        _selectedButton.titleLabel.font =[UIFont systemFontOfSize: 14.0];
        [_selectedButton setTitleColor:RGB(30, 172, 199) forState:UIControlStateNormal];
        [_selectedButton.layer setMasksToBounds:YES];
        [_selectedButton.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        [_selectedButton.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 30/255.0, 172/255.0, 199/255.0, 1 });
        [_selectedButton.layer setBorderColor:colorref];
        _selectedButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [_selectedButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedButton setTitle:@"同意" forState:UIControlStateNormal];
        
        
    }
    return  _selectedButton;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    _isOn = NO;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}



-(void)setup{
    [self addSubview:self.avatarImageView];
    [self addSubview:self.sigNatureLabel];
    [self addSubview:self.selectedButton];
    [self addSubview:self.timeLabel];
}

-(void)setAvIMTypedMessage:(AVIMTypedMessage *)avIMTypedMessage{
    _avIMTypedMessage = avIMTypedMessage;
    NSDictionary *msgDict =avIMTypedMessage.attributes;
    NSString *sUrl = [msgDict objectForKey:MSG_ATTR_URL];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    [self.avatarImageView sd_cancelCurrentImageLoad];
    [self.avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"group_blank"]];
    
    if (avIMTypedMessage.content.length>0) {
        self.sigNatureLabel.text = avIMTypedMessage.text;
    }
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:avIMTypedMessage.sendTimestamp / 1000];
    self.timeLabel.text = curDate.timeAgoSinceNow;
    
    _realConvid = [msgDict objectForKey:MSG_ATTR_REAL_CONVID];
    [self setNeedsLayout];
}

#pragma mark action
-(void)confirmButtonClick:(UIButton*)button {
    NSDictionary *dict = self.avIMTypedMessage.attributes;
    NSString *isConfirmed = [dict objectForKey:@"isConfirmed"];
    
    if ([isConfirmed isEqualToString:@"1"]) {//开始对话
        if([_groupSysMsgTableViewCellDelegate respondsToSelector:@selector(startAConverstionWithConversationId:)]) {
            [_groupSysMsgTableViewCellDelegate startAConverstionWithConversationId:_realConvid];
        }
    }else {
        //[_selectedButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        if([_groupSysMsgTableViewCellDelegate respondsToSelector:@selector(confirmJoinAGroupWithRealConvid:AVMsg:AndGroupName:indexPath:)]) {
            [_groupSysMsgTableViewCellDelegate confirmJoinAGroupWithRealConvid:_realConvid AVMsg:self.avIMTypedMessage AndGroupName:@"" indexPath:self.indexPath];
        }
    }
}

@end
