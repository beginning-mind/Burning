//
//  DailyNewsTableViewCell.h
//  Burning
//
//  Created by wei_zhu on 15/7/3.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHDailyNews.h"

@interface DailyNewsTableViewCell : UITableViewCell

@property(nonatomic,strong)SHDailyNews *shDailyNews;

@property(nonatomic,strong)NSIndexPath *indexPath;

+(CGFloat)calculateCellHeightWithSHDailyNews:(SHDailyNews*)shDialyNews;

@end
