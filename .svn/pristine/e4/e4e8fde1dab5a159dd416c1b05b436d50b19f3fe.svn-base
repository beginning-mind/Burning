//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  PickerGroupTableViewCell.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-13.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "MLSelectPhotoPickerGroupTableViewCell.h"
#import "MLSelectPhotoPickerGroup.h"
#import "LayoutConst.h"

@interface MLSelectPhotoPickerGroupTableViewCell ()
@property (weak, nonatomic) UIImageView *groupImageView;
@property (weak, nonatomic) UILabel *groupNameLabel;
@property (weak, nonatomic) UILabel *groupPicCountLabel;
@end

@implementation MLSelectPhotoPickerGroupTableViewCell

- (UIImageView *)groupImageView{
    if (!_groupImageView) {
        UIImageView *groupImageView = [[UIImageView alloc] init];
        groupImageView.frame = CGRectMake(kSmallSpace, kSmallSpace, kLagerAvatarSize, kLagerAvatarSize);
        groupImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_groupImageView = groupImageView];
    }
    return _groupImageView;
}

- (UILabel *)groupNameLabel{
    if (!_groupNameLabel) {
        UILabel *groupNameLabel = [[UILabel alloc] init];
        groupNameLabel.frame = CGRectMake(CGRectGetMaxX(self.groupImageView.frame)+kCommonAvatarLeadingSpace, kSmallSpace, self.frame.size.width - 100, 18);
        groupNameLabel.font = [UIFont systemFontOfSize:kCommonFontSize];
        groupNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_groupNameLabel = groupNameLabel];
    }
    return _groupNameLabel;
}

- (UILabel *)groupPicCountLabel{
    if (!_groupPicCountLabel) {
        UILabel *groupPicCountLabel = [[UILabel alloc] init];
        groupPicCountLabel.font = [UIFont systemFontOfSize:kCommonFontSize];
        groupPicCountLabel.textColor = RGB(133, 133, 133);
        groupPicCountLabel.frame = CGRectMake(CGRectGetMinX(self.groupNameLabel.frame), CGRectGetMaxY(self.groupNameLabel.frame)+kSmallSpace, self.frame.size.width - 100, 18);
        [self.contentView addSubview:_groupPicCountLabel = groupPicCountLabel];
    }
    return _groupPicCountLabel;
}

- (void)setGroup:(MLSelectPhotoPickerGroup *)group{
    _group = group;
    
    self.groupNameLabel.text = group.groupName;
    self.groupImageView.image = group.thumbImage;
    self.groupPicCountLabel.text = [NSString stringWithFormat:@"(%ld)",group.assetsCount];
}


@end
