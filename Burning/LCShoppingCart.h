//
//  LCShoppingCart.h
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#define KEY_SHOPPINGCART_COMMODITY @"commodity"
#define KEY_SHOPPINGCART_STATE @"state"

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
#import "LCCommodity.h"

@interface LCShoppingCart : AVObject<AVSubclassing>

@property(nonatomic,strong)LCCommodity *commodity;

@property(nonatomic,assign)NSNumber *shoppingcount;

@property(nonatomic,assign)NSNumber *state;

@end
