//
//  TakePhotoViewController.h
//  Burning
//
//  Created by wei_zhu on 15/6/3.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"
#import "LCDataHelper.h"
#import "SVGloble.h"

@protocol TakePhotoViewControllerDelegate <NSObject>

-(void)refresh;

@end

@interface TakePhotoViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextView *texViewComment;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;

@property (nonatomic,strong) NSMutableArray* selectPhotos;

@property(nonatomic,strong)id<TakePhotoViewControllerDelegate> takePhotoViewControllerDelegate;

@end