//
//  PersonalInfoHeaderView.m
//  Burning
//
//  Created by wei_zhu on 15/6/15.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "PersonalInfoHeaderView.h"
#import "UserListViewController.h"
#import "LayoutConst.h"
#import "SVGloble.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MeDetailViewController.h"
#import "NSString+DynamicHeight.h"
#import "XHImageViewer.h"

@interface PersonalInfoHeaderView()

//@property(nonatomic,strong)UIImageView *backGroundView;

@property(nonatomic,strong)UIImageView *avatarView;

@property(nonatomic,strong)UILabel *userName;

@property(nonatomic,strong)UILabel *sequenceLable;

@property(nonatomic,strong)UILabel *signature;

@property(nonatomic,strong)UIButton *attentionBtn;

@property(nonatomic,strong)UIButton *attentionsBtn;

@property(nonatomic,strong)UIButton *fansBtn;

@property(nonatomic,strong)UIButton *freindsBtn;

@property(nonatomic,strong)UIButton *vipBtn; //会员

@property(nonatomic,strong)UIView *seperator;

@property(nonatomic,strong)NSMutableArray *followers; //AVUser arry

@property(nonatomic,strong)NSMutableArray *followees; //AVUser arry

@property(nonatomic,strong)NSMutableArray *friends; //AVUser arry

@property(nonatomic,strong)UIImageView *sexImageView;

@property(nonatomic,strong)UILabel *regionLabel;

@end

@implementation PersonalInfoHeaderView

+(CGFloat)calculateHeightWithSignature:(NSString*)sigNature{
    CGFloat height = kLargeAvatarLeadingSpace;
    height+=60;
    height+=12;
    height+=18;
    height+=6;
    height+=18;
    height+=6;
    height+=18;
    height+=6;
    if ([sigNature isEqualToString:@""] || sigNature==nil) {
        height+=18;
    }
    else{
        NSString *curSigNature = [NSString stringWithFormat:@"个人签名:%@",sigNature];
        CGFloat sigLabelHeight = [NSString getTextHeight:curSigNature textFont:[UIFont systemFontOfSize:kCommonFontSize] width:CGRectGetWidth([[UIScreen mainScreen] bounds])-2*kLargeAvatarLeadingSpace];

        height+=sigLabelHeight;
    }
    height+=18;
    height+=1;
    
    return height;
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

-(UIImageView *)avatarView{
    if (_avatarView==nil) {
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(kLargeAvatarLeadingSpace, kLargeAvatarLeadingSpace, kLagerAvatarSize, kLagerAvatarSize)];
        _avatarView.userInteractionEnabled = YES;
//        _avatarView.layer.masksToBounds =YES;
//        _avatarView.layer.cornerRadius =kLagerAvatarSize/2.0;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avtarClick:)];
        [_avatarView addGestureRecognizer:tapGes];
    }
    return _avatarView;
}

-(UILabel *)userName{
    if (_userName==nil) {
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.avatarView.frame), CGRectGetMaxY(self.avatarView.frame)+kSmallSpace, 180, 18)];
        _userName.font=[UIFont systemFontOfSize:kCommonFontSize];
        _userName.textColor = [UIColor blackColor];
    }
    
    return _userName;
}
-(UIImageView*)sexImageView{
    if (_sexImageView==nil) {
        _sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userName.frame)+6, CGRectGetMaxY(self.avatarView.frame)+kCommonSpace, 12, 12)];
    }
    
    return _sexImageView;
}

-(UILabel *)sequenceLable {
    if (_sequenceLable==nil) {
        _sequenceLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.userName.frame), CGRectGetMaxY(_userName.frame)+6, 100, 18)];
        _sequenceLable.font=[UIFont systemFontOfSize:kCommonFontSize];
        _sequenceLable.textColor = [UIColor lightGrayColor];
    }
    
    return _sequenceLable;
}

-(UILabel*)regionLabel{
    if (_regionLabel==nil) {
        _regionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.userName.frame), CGRectGetMaxY(self.sequenceLable.frame)+6, [SVGloble shareInstance].globleWidth-2*kLargeAvatarLeadingSpace, 18)];
        _regionLabel.font=[UIFont systemFontOfSize:kCommonFontSize];
        _regionLabel.textColor = [UIColor lightGrayColor];
    }
    return _regionLabel;
}

-(UILabel *)signature{
    if (_signature==nil) {
        _signature = [[UILabel alloc]initWithFrame:CGRectZero];
        _signature.font=[UIFont systemFontOfSize:kCommonFontSize];
        _signature.numberOfLines=0;
        _signature.textColor=RGB(133, 133, 133);
    }

    return _signature;
}

-(UIButton *)attentionBtn{
    if (_attentionBtn ==nil) {
        _attentionBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.attentionsBtn.frame),CGRectGetMaxY(self.attentionsBtn.frame)+6 , 200, 24)];
        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [_attentionBtn setTitleColor:RGB(30, 172, 199) forState:UIControlStateNormal];

        [_attentionBtn.layer setMasksToBounds:YES];
        [_attentionBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        [_attentionBtn.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 30/255.0, 172/255.0, 199/255.0, 1 });
        [_attentionBtn.layer setBorderColor:colorref];
        
        _attentionBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [_attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

-(UIButton *)attentionsBtn{
    if (_attentionsBtn==nil) {
        _attentionsBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.freindsBtn.frame)-60-kCommonAvatarLeadingSpace,CGRectGetMinY(self.avatarView.frame), 60, 30)];
        _attentionsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _attentionsBtn.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
        [_attentionsBtn setTitleColor:RGB(133, 133, 133) forState:UIControlStateNormal];
        [_attentionsBtn addTarget:self action:@selector(attentionsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionsBtn;
}

-(UIButton *)fansBtn{
    if (_fansBtn==nil) {
        _fansBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-kLargeAvatarLeadingSpace-60, CGRectGetMinY(self.avatarView.frame), 60, 30)];
        _fansBtn.titleLabel.font =[UIFont systemFontOfSize: 12.0];
        _fansBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _fansBtn.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
        [_fansBtn setTitleColor:RGB(133, 133, 133) forState:UIControlStateNormal];
        [_fansBtn addTarget:self action:@selector(fansBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fansBtn;
}

-(UIButton*)freindsBtn{
    if (_freindsBtn==nil) {
         _freindsBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.fansBtn.frame)-kCommonAvatarLeadingSpace-60, CGRectGetMinY(self.avatarView.frame), 60, 30)];
        _freindsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _freindsBtn.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
        _freindsBtn.titleLabel.font =[UIFont systemFontOfSize: 12.0];
        [_freindsBtn setTitleColor:RGB(133, 133, 133) forState:UIControlStateNormal];
        [_freindsBtn addTarget:self action:@selector(freindsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _freindsBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _freindsBtn;
}

-(UIView*)seperator{

    if (_seperator==nil) {
        _seperator = [[UIView alloc]initWithFrame:CGRectZero];
        _seperator.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    }
    return _seperator;
}

-(UIButton*)vipBtn{

    return _vipBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    [self addSubview:self.avatarView];
    [self addSubview:self.userName];
    [self addSubview:self.sequenceLable];
    [self addSubview:self.regionLabel];
    [self addSubview:self.sexImageView];
    [self addSubview:self.signature];
    [self addSubview:self.attentionBtn];
    [self addSubview:self.attentionsBtn];
    [self addSubview:self.fansBtn];
    [self addSubview:self.freindsBtn];
    [self addSubview:self.attentionBtn];
    [self addSubview:self.seperator];
}

-(void)setUser:(AVUser *)user{
    _user = user;
    AVUser *curUser = [AVUser currentUser];
    _isMe = [user.objectId isEqualToString:[AVUser currentUser].objectId];
    if (_isMe) {
        [self.attentionBtn setTitle:@"编辑个人资料" forState:UIControlStateNormal];
    }
    else{
        
        AVQuery *query = [AVUser followeeQuery:[AVUser currentUser].objectId];
        [query whereKey:@"followee" equalTo:user];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"err:%@",error);
            }
            else{
                if (objects.count>0) {
                    [self.attentionBtn setTitle:@"√ 已关注" forState:UIControlStateNormal];
                    [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_attentionBtn setBackgroundColor:RGB(30, 172, 199)];
                    
                    _isAttetion = YES;
                }
                else{
                    [self.attentionBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
                    [_attentionBtn setTitleColor:RGB(30, 172, 199) forState:UIControlStateNormal];
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 30.0/255.0, 172.0/255.0, 199.0/255.0, 1 });
                    [_attentionBtn.layer setBorderColor:colorref];
                    [_attentionBtn setBackgroundColor:[UIColor whiteColor]];
                    _isAttetion = NO;
                }
            }
        }];
    }
    
    AVFile *avFile = [user objectForKey:@"avatar"];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avFile.url] placeholderImage:[UIImage imageNamed:@"blank_avatar.jpg"]];
    
    self.userName.text = user.username;
    
    NSString *gender = [user objectForKey:@"gender"];
    //男
    if ([gender isEqualToString:@"1"]) {
        self.sexImageView.image = [UIImage imageNamed:@"ic_male"];
    }
    //女
    else if([gender isEqualToString:@"0"] ){
        self.sexImageView.image = [UIImage imageNamed:@"ic_female"];
    }
    

        NSNumber *sequenceNum = [user objectForKey:@"sequenceNum"];
        if (sequenceNum) {
            NSString *sequenceStr = [NSString stringWithFormat:@"%d",[sequenceNum intValue]];
            self.sequenceLable.text =[NSString stringWithFormat:@"ID:%@",sequenceStr];
        }
 
        NSString *region = [user objectForKey:@"region"];
        if (region ==nil || [region isEqualToString:@""]) {
            region =@"开普勒 452b";
        }
        if (region) {
            self.regionLabel.text =[NSString stringWithFormat:@"地区:%@",region];
        }
    
    
    NSString *signature = [user objectForKey:@"signature"];
    if (signature==nil || [signature isEqual:@""]) {
        self.signature.text = @"个人签名:ta只要人鱼线，不要签名";
    }
    else{
        self.signature.text =[NSString stringWithFormat:@"个人签名:%@",signature];
    }
    
    //粉丝
    [user getFollowersAndFollowees:^(NSDictionary *dict, NSError *error) {
        if (!error) {
            self.followers = dict[@"followers"];
            
            self.followees = dict[@"followees"];
            
            [self updateFansBtn];
            [self updateAttentionsBtn];
          
        }
    }];
    
    //互相关注列表
    [self updateFreindsBtn];

    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = [NSString getTextWidth:self.userName.text textFont:[UIFont systemFontOfSize:kCommonFontSize] maxWidth:180];

    
    CGRect fram = self.userName.frame;
    fram.size.width = width;
    self.userName.frame = fram;
    
    CGRect sexImageViewFram = self.sexImageView.frame;
    sexImageViewFram.origin.x = CGRectGetMaxX(fram)+6;
    self.sexImageView.frame = sexImageViewFram;
    
    NSString *sigNature =[NSString stringWithFormat:@"个人签名:%@",[self.user objectForKey:@"signature"]];
    CGFloat height;
    if(sigNature==nil || [sigNature isEqualToString:@""]){
        height = 18;
    }
    else
    {
        height = [NSString getTextHeight:sigNature textFont:[UIFont systemFontOfSize:kCommonFontSize] width:CGRectGetWidth([[UIScreen mainScreen] bounds])-2*kLargeAvatarLeadingSpace];
        
        
    }
     _signature.frame = CGRectMake(CGRectGetMinX(self.userName.frame), CGRectGetMaxY(self.regionLabel.frame)+6, CGRectGetWidth([[UIScreen mainScreen] bounds])-2*kLargeAvatarLeadingSpace, height);
    
    _seperator.frame = CGRectMake(0, CGRectGetMaxY(self.signature.frame)+kLargeAvatarLeadingSpace, CGRectGetWidth([[UIScreen mainScreen] bounds]), 1);
    
    CGFloat maxy = CGRectGetMaxY(_seperator.frame);
    CGRect frame=self.frame;
    frame.size.height=maxy;
    self.frame=frame;
}

#pragma  mark action
-(void)attentionBtnClick:(UIButton*)button{
    AVUser *loginUser = [AVUser currentUser];
    NSString *objectId = self.user.objectId;
    if([loginUser.objectId isEqualToString:self.user.objectId]){
        MeDetailViewController *meDetailViewController = [[MeDetailViewController alloc]init];
//        meDetailViewController.avUser = self.user;
        BaseViewController *baseVC = [self getSuperViewController];
        [baseVC.navigationController pushViewController:meDetailViewController animated:YES];
    }
    else{
        if (!_isAttetion) {
            [loginUser follow:objectId andCallback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    //改变按钮的状态
                    [self.attentionBtn setTitle:@"√ 已关注" forState:UIControlStateNormal];
                    [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_attentionBtn setBackgroundColor:RGB(30, 172, 199)];
                    _attentionBtn.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    [UIButton animateWithDuration:0.2 animations:^{
                        _attentionBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
                    } completion:^(BOOL finished) {
                        [UIButton animateWithDuration:0.2 animations:^{
                            _attentionBtn.transform = CGAffineTransformMakeScale(1, 1);
                        } completion:^(BOOL finished) {
                        }];
                    }];
                    
                    //改变粉丝列表
                    [self.followers addObject:loginUser];
                    [self updateFansBtn];
                    
                    //改变互相关注列表
                    [self updateFreindsBtn];

                    //发送通知
                    BaseViewController *baseVC = [self getSuperViewController];
                    AVUser *toUser =self.user;
                    NSString *deviceToken = [toUser objectForKey:@"deviceToken"];
                    if (deviceToken!=nil) {
                        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:1],@"content-available",
                                              @"4",@"type",
                                              loginUser.objectId,@"userId",
                                              //                                  @"Increment", @"badge",
//                                              @"cheering.caf", @"sound",
                                              nil];
                        [baseVC PushNewsWithData:data deviceToke:deviceToken Chanell:@"SysNoti"];
                    }                    
                    _isAttetion = YES;
                }
            }];
        }
        else{
            [loginUser unfollow:objectId andCallback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    //改变按钮状态
                    [self.attentionBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
                    [_attentionBtn setTitleColor:RGB(30, 172, 199) forState:UIControlStateNormal];
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 30/255.0, 172/255.0, 199/255.0, 1 });
                    [_attentionBtn.layer setBorderColor:colorref];
                    [_attentionBtn setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //粉丝
                    [self.followers removeObject:loginUser];
                    [self updateFansBtn];
                    
                    //互相关注列表
                    [self updateFreindsBtn];
                    _isAttetion = NO;
                }
            }];
        }
    }
}

-(void)attentionsBtnClick:(UIButton*)button{
    if (self.followees.count>0) {
        BaseViewController *superViewController = (BaseViewController*)[self getSuperViewController];
        UserListViewController *userListViewController = [[UserListViewController alloc]init];
        userListViewController.users = self.followees;

        [superViewController.navigationController pushViewController:userListViewController animated:YES];
    }
}

-(void)fansBtnClick:(UIButton*)button{
    if (self.followers.count>0) {
        BaseViewController *superViewController = (BaseViewController*)[self getSuperViewController];
        UserListViewController *userListViewController = [[UserListViewController alloc]init];
        userListViewController.users = self.followers;
        
        [superViewController.navigationController pushViewController:userListViewController animated:YES];
    }
}

-(void)freindsBtnClick:(UIButton*)button{
    if (self.friends.count>0) {
        BaseViewController *superViewController = (BaseViewController*)[self getSuperViewController];
        UserListViewController *userListViewController = [[UserListViewController alloc]init];
        userListViewController.users = self.friends;
        
        [superViewController.navigationController pushViewController:userListViewController animated:YES];
    }
}

-(void)updateFansBtn{
    NSString *fansText = [NSString stringWithFormat:@"%ld\n粉丝",(unsigned long)_followers.count];
    NSMutableAttributedString *strfans = [[NSMutableAttributedString alloc] initWithString:fansText];
    [strfans addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,fansText.length-2)];
    [strfans addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,fansText.length-2)];
    [strfans addAttribute:NSForegroundColorAttributeName value:RGB(133, 133, 133) range:NSMakeRange(fansText.length-2,2)];
    [strfans addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(fansText.length-2,2)];
    [self.fansBtn setAttributedTitle:strfans forState:UIControlStateNormal];
}

-(void)updateAttentionsBtn{
    NSString *attentionsText =[NSString stringWithFormat:@"%ld\n关注",(unsigned long)_followees.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attentionsText];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,attentionsText.length-2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,attentionsText.length-2)];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(133, 133, 133) range:NSMakeRange(attentionsText.length-2,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(attentionsText.length-2,2)];
    [self.attentionsBtn setAttributedTitle:str forState:UIControlStateNormal];
}

-(void)updateFreindsBtn{
    LCDataHelper *lcDataHelper = [[LCDataHelper alloc]init];
    [lcDataHelper getUsersFollowedEachOtherWithUser:_user block:^(NSArray *objects, NSError *error) {
        if (error) {
            return ;
        }
        _friends = [objects copy];
        NSString *friendsBtnText =[NSString stringWithFormat:@"%ld\n互相关注",(unsigned long)_friends.count];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:friendsBtnText];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,friendsBtnText.length-4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,friendsBtnText.length-4)];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(133, 133, 133) range:NSMakeRange(friendsBtnText.length-4,4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(friendsBtnText.length-4,4)];
        [self.freindsBtn setAttributedTitle:str forState:UIControlStateNormal];
    }];
}

-(void)avtarClick:(UITapGestureRecognizer*)gestureRecognizer{
    UIImageView *sharImgView = (UIImageView*)gestureRecognizer.view;
    if (sharImgView!=nil) {
        XHImageViewer *imageViewr = [[XHImageViewer alloc] init];
        NSMutableArray *views = [NSMutableArray array];
        [views addObject:sharImgView];
        [imageViewr showWithImageViews:views selectedView:sharImgView];
    }
}

@end
