//
//  ShoppingCartTableViewCell.h
//  Burning
//
//  Created by wei_zhu on 15/8/31.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCShoppingCart.h"

@protocol ShoppingCartTableViewCellDelegate <NSObject>

-(void)didSubtractionBtn;

-(void)didAddBtn;

-(void)didDeleBtn:(NSIndexPath*)indexPath;

@end

@interface ShoppingCartTableViewCell : UITableViewCell

@property(nonatomic,strong)LCShoppingCart *lcShoppingCart;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)id<ShoppingCartTableViewCellDelegate> shoppingCartTableViewCellDelegate;

@end
