//
//  LocationHelper.m
//  Burning
//
//  Created by Xiang Li on 15/8/12.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "LocationHelper.h"

//@implementation CLLocationManager (TemporaryHack)
//
////模拟器测试用
//- (void)hackLocationFix
//{
//    //CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
//    float latitude = 39.906811;
//    float longitude = 116.377586;  //这里可以是任意的经纬度值
//    CLLocation *location= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    //    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:nil];
//    [[self delegate] locationManager:self didUpdateLocations:[NSArray arrayWithObject:location]];
//}
//
//-(void)startUpdatingLocation
//{
//    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
//}
//
//@end



@interface LocationHelper()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@end


@implementation LocationHelper

-(instancetype)init {
    self = [super init];
    if (self) {
        [self startLocations];
    }
    return self;
}

-(void)startLocations {
    self.locationManager = [[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization]; // 永久授权
            [self.locationManager requestWhenInUseAuthorization]; //使用中授权
        }
        
        [self.locationManager startUpdatingLocation];
    }
    else {
        NSLog( @"Cannot Starting CLLocationManager" );
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
}


#pragma mark CLLocationManager Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.curLocation = [locations lastObject];
    [manager stopUpdatingLocation];
}

@end
