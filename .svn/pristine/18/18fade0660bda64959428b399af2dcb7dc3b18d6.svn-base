//
//  MCAlbumCollectionFlowLayout.m
//  ClassNet
//
//  Created by lzw on 15/3/27.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import "PubShowCollectionFlowLayout.h"
#include "LayoutConst.h"


@implementation PubShowCollectionFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat cellSize = (CGRectGetWidth([[UIScreen mainScreen] bounds])-2*kCommonAvatarLeadingSpace-2*kPubShowPhotoInset)/3;
        self.itemSize=CGSizeMake(cellSize, cellSize);
        self.minimumInteritemSpacing=kPubShowPhotoInset;
        self.minimumLineSpacing=kPubShowPhotoInset;
    }
    return self;
}

@end
