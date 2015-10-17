//
//  GroupTableViewCell.h
//  Burning
//
//  Created by Xiang Li on 15/7/17.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGroup.h"

@interface GroupTableViewCell : UITableViewCell

@property(nonatomic,strong) SHGroup *showGroup;

+(CGFloat)calculateCellHeightWithUser:(SHGroup*)shGroup;

@end
