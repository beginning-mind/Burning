//
//  PubNotiTableViewCell.m
//  Burning
//
//  Created by wei_zhu on 15/8/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "PubNotiTableViewCell.h"
#import "LayoutConst.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCDataHelper.h"
#import <NSDate+DateTools.h>
#import "NSString+DynamicHeight.h"

@interface PubNotiTableViewCell()

@property(nonatomic,copy)NSString *userID;

@property(nonatomic,copy)NSString *contentObjID;

@property(nonatomic,strong)UIImageView *avatarImageView;

@property(nonatomic,strong)UILabel *contenetLabe;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIImageView *contentImageView;

@end

@implementation PubNotiTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)calculateCellHeightWithMessage:(AVIMTypedMessage*)message{
    if(message==nil){
        return 0;
    }
    CGFloat richTextHeight=kSmallSpace;
    richTextHeight+=kCommonAvatarSize;
    richTextHeight +=kSmallSpace;
    
    CGFloat richtextHeight2 = 19;
    richtextHeight2+= [NSString getTextHeight:message.text textFont:[UIFont systemFontOfSize:kCommonFontSize] width:[UIScreen mainScreen].bounds.size.width-168];

    richtextHeight2+=kSmallSpace;
    
    return richTextHeight>richtextHeight2? richTextHeight :richtextHeight2;
}

#pragma mark UI
-(UIImageView*)avatarImageView{
    if (_avatarImageView ==nil) {
        _avatarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(kCommonAvatarLeadingSpace,kSmallSpace, kCommonAvatarSize, kCommonAvatarSize)];
//        _avatarImageView.layer.masksToBounds =YES;
//        _avatarImageView.layer.cornerRadius =kCommonAvatarSize/2.0;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick:)];
        [_avatarImageView addGestureRecognizer:singleTap];
    }
    
    return _avatarImageView;
}

-(UILabel*)contenetLabe{
    if (_contenetLabe ==nil) {
        _contenetLabe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+kSmallTextAvatarHorizalSpace, kSmallSpace, CGRectGetMinX(self.timeLabel.frame)-CGRectGetMaxX(self.avatarImageView.frame)-kSmallTextAvatarHorizalSpace, 18)];
        _contenetLabe.font = [UIFont systemFontOfSize:kCommonFontSize];
        _contenetLabe.textColor = RGB(0, 0, 0);
        _contenetLabe.numberOfLines=0;
    }
    return  _contenetLabe;
}

-(UILabel*)timeLabel{
    if (_timeLabel ==nil) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.contentImageView.frame)-kSmallTextAvatarHorizalSpace-60, kSmallSpace, 60, 18)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font=[UIFont systemFontOfSize:kCommonFontSize];
        _timeLabel.textColor=RGB(133, 133, 133);
    }
    return  _timeLabel;
}

-(UIImageView*)contentImageView{
    if (_contentImageView==nil) {
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kCommonAvatarSize-kCommonAvatarLeadingSpace, kSmallSpace, kCommonAvatarSize, kCommonAvatarSize)];
        _contentImageView.userInteractionEnabled = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activityImageClick:)];
        [_contentImageView addGestureRecognizer:singleTap];
    }
    return _contentImageView;
}

-(void)setup{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self addSubview:self.avatarImageView];
    [self addSubview:self.contenetLabe];
    [self addSubview:self.timeLabel];
    [self addSubview:self.contentImageView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect contentFrame=_contenetLabe.frame;
    contentFrame.size.height=[NSString getTextHeight:self.message.text textFont:[UIFont systemFontOfSize:kCommonFontSize] width:CGRectGetWidth(self.contenetLabe.frame)];
    _contenetLabe.frame=contentFrame;
    
    CGFloat maxYAvatar = CGRectGetMaxY(self.avatarImageView.frame);
    CGFloat maxYContent = CGRectGetMaxY(self.contenetLabe.frame);
    
    CGFloat maxY = maxYAvatar>maxYContent?maxYAvatar:maxYContent;
    maxY+=kSmallSpace;
    CGRect frame=self.frame;
    frame.size.height = maxY;
    self.frame = frame;
}

-(void)setMessage:(AVIMTypedMessage *)message{
    _message = message;
    NSDictionary *dic  = message.attributes;
    self.userID = [dic objectForKey:@"userId"];
    self.contentObjID =[dic objectForKey:@"contentObjId"];
    NSString *avatarUrl = [dic objectForKey:@"avatarUrl"];
    NSString *activityImageUrl =[dic objectForKey:@"contentImageUrl"];
    NSString *content = message.text;
    NSDate *curDate =[NSDate dateWithTimeIntervalSince1970:message.sendTimestamp / 1000];
    [self.avatarImageView sd_cancelCurrentImageLoad];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"blank_avatar.jpg"]];
    
    self.contenetLabe.text = content;
    
    self.timeLabel.text = curDate.timeAgoSinceNow;
    
    NSString *conID = self.message.conversationId;
    NSString *defalutImg;
    if ([conID isEqualToString:@"activity"]) {
        defalutImg = @"group_blank";
    }
    else if([conID isEqualToString:@"publish"]){
        defalutImg = @"group_blank";
    }
    
    [self.contentImageView sd_cancelCurrentImageLoad];
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:activityImageUrl] placeholderImage:[UIImage imageNamed:defalutImg]];
    
    [self setNeedsLayout];
}

#pragma  mark action
-(void)avatarClick:(UIGestureRecognizer*)gestureRecognizer{
    if ([self.pubNotiTableViewCellDelegate respondsToSelector:@selector(didAvatarClick:)]) {
        [self.pubNotiTableViewCellDelegate didAvatarClick:self.userID];
    }
}

-(void)activityImageClick:(UIGestureRecognizer*)gestureRecognizer{
    if ([self.pubNotiTableViewCellDelegate respondsToSelector:@selector(didContentImageClick:objID:)]) {
        [self.pubNotiTableViewCellDelegate didContentImageClick:self.message.conversationId objID:self.contentObjID];
    }
}

@end
