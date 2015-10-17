//
//  FollowNotiTableViewCell.m
//  Burning
//
//  Created by wei_zhu on 15/8/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "FollowNotiTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LayoutConst.h"
#import "LCDataHelper.h"
#import <NSDate+DateTools.h>
#import "NSString+DynamicHeight.h"

@interface FollowNotiTableViewCell()

@property(nonatomic,assign)BOOL isAttention;

@property(nonatomic,copy)NSString *userID;

@property(nonatomic,strong)AVUser *curUser;

@property(nonatomic,strong)UIImageView *avatarImageView;

@property(nonatomic,strong)UILabel *contenetLabe;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIButton *attentionBtn;

@end

@implementation FollowNotiTableViewCell

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
    richtextHeight2+=[NSString getTextHeight:message.text textFont:[UIFont systemFontOfSize:kCommonFontSize] width:[UIScreen mainScreen].bounds.size.width-192];

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
        _contenetLabe =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+kSmallTextAvatarHorizalSpace, kSmallSpace, CGRectGetMinX(self.timeLabel.frame)-CGRectGetMaxX(self.avatarImageView.frame)-kSmallTextAvatarHorizalSpace, 18)];
        _contenetLabe.font=[UIFont systemFontOfSize:kCommonFontSize];
        _contenetLabe.textColor = RGB(0, 0, 0);
        _contenetLabe.numberOfLines=0;
    }
    return  _contenetLabe;
}

-(UILabel*)timeLabel{
    if (_timeLabel ==nil) {
        _timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.attentionBtn.frame)-kCommonAvatarLeadingSpace-60,kSmallSpace, 60, 18)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font=[UIFont systemFontOfSize:kCommonFontSize];
        _timeLabel.textColor=RGB(133, 133, 133);
    }
    return  _timeLabel;
}

-(UIButton*)attentionBtn{
    if (_attentionBtn ==nil) {
        _attentionBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-60-kCommonAvatarLeadingSpace, kSmallSpace, 60, 30)];
        _attentionBtn.titleLabel.font =[UIFont systemFontOfSize: 14.0];
        [_attentionBtn setTitleColor:RGB(30, 172, 199) forState:UIControlStateNormal];
        [_attentionBtn.layer setMasksToBounds:YES];
        [_attentionBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        [_attentionBtn.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 30/255.0, 172/255.0, 199/255.0, 1 });
        [_attentionBtn.layer setBorderColor:colorref];
        _attentionBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [_attentionBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _attentionBtn;
}

-(void)setMessage:(AVIMTypedMessage *)message{
    _message = message;
    NSDictionary *dic  = message.attributes;
    self.userID = [dic objectForKey:@"userId"];
    NSString *avatarUrl = [dic objectForKey:@"avatarUrl"];
    NSString *content = message.text;

    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp / 1000];
    [self.avatarImageView sd_cancelCurrentImageLoad];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"blank_avatar.jpg"]];
    self.contenetLabe.text = content;
    self.timeLabel.text = curDate.timeAgoSinceNow;

    LCDataHelper *lcDataHelper = [[LCDataHelper alloc]init];
    [lcDataHelper getUserWithObjectId:self.userID block:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count>0) {
                self.curUser = objects[0];
                AVQuery *query = [AVUser followeeQuery:[AVUser currentUser].objectId];
                [query whereKey:@"followee" equalTo:self.curUser];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (error) {
                        NSLog(@"err:%@",error);
                    }
                    else{
                        if (objects.count>0) {
                            [self.attentionBtn setTitle:@"√已关注" forState:UIControlStateNormal];
                            [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [self.attentionBtn setBackgroundColor:RGB(30, 172, 199)];
                            self.isAttention = YES;
                        }
                        else{
                            [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
                            [self.attentionBtn setTitleColor:RGB(30, 172, 199) forState:UIControlStateNormal];
                            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 30/255.0, 172/255.0, 199/255.0, 1 });
                            [self.attentionBtn.layer setBorderColor:colorref];
                            [self.attentionBtn setBackgroundColor:[UIColor whiteColor]];
                            self.isAttention = NO;
                        }
                    }
                }];
            }
        }
    }];
    [self setNeedsLayout];
}

-(void)setup{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self addSubview:self.avatarImageView];
    [self addSubview:self.contenetLabe];
    [self addSubview:self.attentionBtn];
    [self addSubview:self.timeLabel];
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

#pragma  mark action
-(void)followBtnClick:(UIButton*)button{
    AVUser *currentUser = [AVUser currentUser];
    if (!self.isAttention) {
        [currentUser follow:self.userID andCallback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.attentionBtn setTitle:@"√已关注" forState:UIControlStateNormal];
                [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.attentionBtn setBackgroundColor:RGB(30, 172, 199)];
                self.attentionBtn.transform = CGAffineTransformMakeScale(0.9, 0.9);
                [UIButton animateWithDuration:0.2 animations:^{
                    self.attentionBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
                } completion:^(BOOL finished) {
                    [UIButton animateWithDuration:0.2 animations:^{
                        self.attentionBtn.transform = CGAffineTransformMakeScale(1, 1);
                    } completion:^(BOOL finished) {
                    }];
                }];
                self.isAttention = YES;
                
                //发送通知
                if ([self.followNotiTableViewCellDelegate respondsToSelector:@selector(didSendNoti:)]) {
                    [self.followNotiTableViewCellDelegate didSendNoti:self.curUser];
                }
            }
        }];
    }
    else{
        [currentUser unfollow:self.userID andCallback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
                [self.attentionBtn setTitleColor:RGB(30, 172, 199) forState:UIControlStateNormal];
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 30/255.0, 172/255.0, 199/255.0, 1 });
                [self.attentionBtn.layer setBorderColor:colorref];
                [self.attentionBtn setBackgroundColor:[UIColor whiteColor]];
                self.isAttention = NO;
            }
        }];
    }
}

-(void)avatarClick:(UIGestureRecognizer*)gestureRecognizer{
    if ([self.followNotiTableViewCellDelegate respondsToSelector:@selector(didAvatarClick:)]) {
        [self.followNotiTableViewCellDelegate didAvatarClick:self.userID];
    }
}

@end
