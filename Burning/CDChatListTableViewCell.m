//
//  CDChatListTableViewCell.m
//  Burning
//
//  Created by Xiang Li on 15/8/17.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "CDChatListTableViewCell.h"
#import "CDBadgeView.h"


static CGFloat kLZImageSize = 43;
static CGFloat kLZVerticalSpacing = 15;
static CGFloat kLZHorizontalSpacing = 9;
static CGFloat KLZTimestampeRightHorizontalSpacing = 10;
static CGFloat ImageHorizontalSpacing = 10;
static CGFloat kLZTimestampeLabelWidth = 100;

static CGFloat kLZNameLabelHeightProportion = 3.0 / 6;
static CGFloat kLZNameLabelHeight;
static CGFloat kLZMessageLabelHeight;

@interface CDChatListTableViewCell ()

@property (nonatomic, strong) CDBadgeView *badgeView;

@end


@implementation CDChatListTableViewCell

+ (CDChatListTableViewCell *)dequeueOrCreateCellByTableView :(UITableView *)tableView {
    CDChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CDChatListTableViewCell identifier]];
    if (cell == nil) {
        cell = [[CDChatListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] identifier]];
    }
    return cell;
}

+ (void)registerCellToTableView: (UITableView *)tableView {
    [tableView registerClass:[CDChatListTableViewCell class] forCellReuseIdentifier:[[self class] identifier]];
}

+ (NSString *)identifier {
    return NSStringFromClass([CDChatListTableViewCell class]);
}

+ (CGFloat)heightOfCell {
    return kLZImageSize + kLZVerticalSpacing * 2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    kLZNameLabelHeight = kLZImageSize * kLZNameLabelHeightProportion;
    kLZMessageLabelHeight = kLZImageSize - kLZNameLabelHeight;
    
    [self addSubview:self.avatarImageView];
    [self addSubview:self.timestampLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.messageLabel];
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ImageHorizontalSpacing, kLZVerticalSpacing, kLZImageSize, kLZImageSize)];
    }
    return _avatarImageView;
}

- (UILabel *)timestampLabel {
    if (_timestampLabel == nil) {
        
        _timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - KLZTimestampeRightHorizontalSpacing - kLZTimestampeLabelWidth, CGRectGetMinY(_avatarImageView.frame), kLZTimestampeLabelWidth, kLZNameLabelHeight)];
        _timestampLabel.font = [UIFont systemFontOfSize:12];
        _timestampLabel.textAlignment = NSTextAlignmentRight;
        _timestampLabel.textColor = [UIColor grayColor];
    }
    return _timestampLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + kLZHorizontalSpacing, CGRectGetMinY(_avatarImageView.frame), CGRectGetMinX(_timestampLabel.frame) - kLZHorizontalSpacing * 3 - kLZImageSize, kLZNameLabelHeight)];
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), CGRectGetWidth([UIScreen mainScreen].bounds)- 3 * kLZHorizontalSpacing - kLZImageSize- kLZTimestampeLabelWidth/3, kLZMessageLabelHeight)];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = [UIColor grayColor];
    }
    return _messageLabel;
}

- (CDBadgeView *)badgeView {
    if (_badgeView == nil) {
//        _badgeView = [[CDBadgeView alloc] initWithParentView:_avatarImageView alignment:JSBadgeViewAlignmentTopRight];
        
        _badgeView = [[CDBadgeView alloc] initWithParentView:_timestampLabel alignment:JSBadgeViewAlignmentBottomRight];
    }
    return _badgeView;
}

- (void)setUnreadCount:(NSInteger)unreadCount {
    if (unreadCount > 0) {
        if (unreadCount<100) {
            self.badgeView.badgeText = [NSString stringWithFormat:@"%ld", (long)unreadCount];
        }else {
            self.badgeView.badgeText = @"99+";
        }
    }
    else {
        self.badgeView.badgeText = nil;
    }
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
