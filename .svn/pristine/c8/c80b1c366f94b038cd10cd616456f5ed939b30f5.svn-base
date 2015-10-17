//
//  RegionSelectorVC.h
//  Burning
//
//  Created by Xiang Li on 15/7/30.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentedViewController.h"
#import <CoreLocation/CoreLocation.h>


@protocol RegionSelectorVCDelegate <NSObject>

- (void)setPLaceTextFieldWithName:(NSString*)placeName latitude:(float)latitude longitude:(float)longitude;

@end


@interface RegionSelectorVC :SegmentedViewController

@property(nonatomic,strong)CLLocation *curLocation;
//@property(nonatomic)CLLocationCoordinate2D *curCoordinate2D;
@property (nonatomic,strong) id<RegionSelectorVCDelegate> regionSelectorVCDelegate;

@end
