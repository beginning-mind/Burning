//
//  RegionTableViewController.h
//  Burning
//
//  Created by Xiang Li on 15/8/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol RegionTableVCDelegate <NSObject>

- (void)setPLaceTextFieldWithName:(NSString*)placeName latitude:(float)latitude longitude:(float)longitude;

@end

@interface RegionTableViewController : UITableViewController

- (instancetype)initWithType:(int)type;
@property (nonatomic,strong) CLLocation *curLocation;
@property (nonatomic,strong) id<RegionTableVCDelegate> regionTableVCDelegate;

@end
