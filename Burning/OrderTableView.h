//
//  OrderTableView.h
//  Burning
//
//  Created by wei_zhu on 15/9/1.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableView : UITableView

@property(nonatomic,strong)NSString *orderState; //0:待付款 1:已付款 2 已发货

@end
