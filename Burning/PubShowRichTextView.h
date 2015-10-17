//
//  MCAlbumRichTextView.h
//  ClassNet
//
//  Created by lzw on 15/3/25.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPublish.h"

@protocol PubShowRichTextViewDelegate <NSObject>

-(void)didCommentButtonClick:(NSInteger)commentUserIndex;

-(void)didLikeButtonClick:(UIButton*)button;

-(void)didAvatarImageViewClick:(UIGestureRecognizer*)gestureRecognizer;

-(void)didDigUserImageViewClick:(NSInteger)digUserindex;

-(void)didDeletePubButtonClick;

@end

@interface PubShowRichTextView : UIView

@property (nonatomic,strong) LCPublish  *publish;

@property (nonatomic,strong) id<PubShowRichTextViewDelegate> richTextViewDelegate;

+(CGFloat)calculateRichTextHeightWithSHPublish:(LCPublish*)publish;

@end