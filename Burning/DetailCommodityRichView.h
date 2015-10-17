//
//  DetailCommodityRichView.h
//  Burning
//
//  Created by wei_zhu on 15/9/1.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCommodity.h"

@protocol DetailCommodityDelegate <NSObject>

-(void)didCommentButtonClick;

@end

@interface DetailCommodityRichView : UIView

@property(nonatomic,strong)LCCommodity *lcCommodity;

@property(nonatomic,strong) id<DetailCommodityDelegate> detailCommodityDelegate;

@end
