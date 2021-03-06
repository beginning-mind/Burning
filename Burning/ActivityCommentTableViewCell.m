//
//  ActivityCommentTableViewCell.m
//  Burning
//
//  Created by wei_zhu on 15/7/8.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "ActivityCommentTableViewCell.h"
#import "LayoutConst.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <NSDate+DateTools.h>
#import "NSString+DynamicHeight.h"

@interface ActivityCommentTableViewCell()

@property (nonatomic,strong)UIImageView *avatarImageView;

@property (nonatomic,strong)UILabel *usernameLabel;

@property (nonatomic,strong)UILabel *timestampLabel;

@property (nonatomic,strong)UILabel *contentLabel;

@end

@implementation ActivityCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}

+(CGFloat)contentWidth{
    return CGRectGetWidth([[UIScreen mainScreen] bounds])-2*kCommonAvatarLeadingSpace-kCommonAvatarSize-kCommonTextToAvatarHorizalSpace;
}

+(CGFloat)calculateCellHeightWithLCComment:(LCActivityComment*)lcActivityComment{
    if(lcActivityComment==nil){
        return 0;
    }
    CGFloat richTextHeight=kCommonTextTopSpace;
    richTextHeight+=18;
    richTextHeight+=kSmallTextVerticSpace;
    richTextHeight+=[NSString getTextHeight:lcActivityComment.commentContent textFont:[UIFont systemFontOfSize:kCommonFontSize] width:[[self class] contentWidth]];
    richTextHeight+=kCommonTextTopSpace;
    
    CGFloat avatarSize = 2*kCommonSpace+kCommonAvatarSize;
    return richTextHeight>avatarSize? richTextHeight :avatarSize;
}

#pragma mark UI
-(UIImageView*)avatarImageView{
    if(_avatarImageView==nil){
        _avatarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(kCommonAvatarLeadingSpace,kSmallSpace, kCommonAvatarSize, kCommonAvatarSize)];
//        _avatarImageView.layer.masksToBounds =YES;
//        _avatarImageView.layer.cornerRadius =kCommonAvatarSize/2.0;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick:)];
        [_avatarImageView addGestureRecognizer:singleTap];
    }
    return _avatarImageView;
}

-(UILabel*)usernameLabel{
    if(_usernameLabel==nil){
        _usernameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImageView.frame)+kCommonTextToAvatarHorizalSpace, kCommonTextTopSpace,[[self class] contentWidth]-kPubShowTimeLableWidth , 18)];
        _usernameLabel.font = [UIFont systemFontOfSize:kCommonFontSize];
//        _usernameLabel.backgroundColor=[UIColor clearColor];
        _usernameLabel.textColor=RGB(0, 0, 0);
    }
    return _usernameLabel;
}

-(UILabel*)timestampLabel{
    if(_timestampLabel==nil){
        _timestampLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _timestampLabel.textAlignment = NSTextAlignmentRight;
        _timestampLabel.font=[UIFont systemFontOfSize:kSmallFontSize];
        _timestampLabel.textColor=RGB(133, 133, 133);
    }
    return _timestampLabel;
}

-(UILabel*)contentLabel{
    if(!_contentLabel){
        _contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_usernameLabel.frame), CGRectGetMaxY(_usernameLabel.frame)+kSmallTextVerticSpace, [[self class] contentWidth], 18)];
        _contentLabel.font=[UIFont systemFontOfSize:kCommonFontSize];
        _contentLabel.textColor = RGB(133, 133, 133);
        _contentLabel.numberOfLines=0;
    }
    return _contentLabel;
}

-(void)setComment:(LCActivityComment *)comment{
    _comment = comment;
    self.usernameLabel.text=self.commentUser.username;
    self.contentLabel.text=comment.commentContent;
    
    AVFile *avatarFile = [self.commentUser objectForKey:@"avatar"];
    [self.avatarImageView sd_cancelCurrentImageLoad];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarFile.url] placeholderImage:[UIImage imageNamed:@"blank_avatar.jpg"]];
    self.timestampLabel.text=comment.createdAt.timeAgoSinceNow;
    
    
    [self setNeedsLayout];
}

-(void)setup{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self addSubview:self.avatarImageView];
    [self addSubview:self.usernameLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timestampLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect contentFrame=_contentLabel.frame;
    contentFrame.size.height =[NSString getTextHeight:self.comment.commentContent textFont:[UIFont systemFontOfSize:kCommonFontSize] width:[[self class] contentWidth]];
    _contentLabel.frame=contentFrame;
    
    _timestampLabel.frame=CGRectMake(CGRectGetMaxX(_contentLabel.frame)-kPubShowTimeLableWidth, CGRectGetMinY(_usernameLabel.frame), kPubShowTimeLableWidth, CGRectGetHeight(_usernameLabel.frame));
    
    CGFloat maxY = CGRectGetMaxY(_contentLabel.frame);
    maxY+=kCommonTextTopSpace;
    CGFloat avatarSize = 2*kSmallSpace+kCommonAvatarSize;
    CGRect frame=self.frame;
    frame.size.height=maxY>avatarSize?maxY:avatarSize;
    self.frame=frame;
}

#pragma mark action
-(void)avatarClick:(UIGestureRecognizer*)gestureRecognizer{
    if ([_commentViewCellDelegate respondsToSelector:@selector(didAvatarImageViewClick:indexPath:)]) {
        [_commentViewCellDelegate didAvatarImageViewClick:gestureRecognizer indexPath:self.indexPath];
    }
}

@end
