//
//  MCAlbumPhotoCollectionViewCell.m
//  ClassNet
//
//  Created by lzw on 15/3/27.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "PubShowPhotoCollectionViewCell.h"

@implementation PubShowPhotoCollectionViewCell

-(UIImageView*)photoImageView{
    if(_photoImageView==nil){
        _photoImageView=[[UIImageView alloc] initWithFrame:self.bounds];
        _photoImageView.contentMode=UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds=YES;
    }
    return _photoImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoImageView];
    }
    return self;
}

@end
