//
//  SHDailyNews.h
//  Burning
//
//  Created by wei_zhu on 15/7/3.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDailyNews : NSObject

@property (nonatomic,copy) NSString* title;

@property(nonatomic,copy)NSString *abstract;

@property (nonatomic,copy) NSString* coverUrl;

@property(nonatomic,copy)NSString *contentUrl;

@property(nonatomic,strong)NSString *time;

@end
