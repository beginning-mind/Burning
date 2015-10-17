//
//  CDChatListTableViewCell.h
//  Burning
//
//  Created by Xiang Li on 15/8/17.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDChatListTableViewCell : UITableViewCell

+ (CGFloat)heightOfCell;

+ (CDChatListTableViewCell *)dequeueOrCreateCellByTableView :(UITableView *)tableView;

+ (void)registerCellToTableView: (UITableView *)tableView ;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, strong) UILabel *timestampLabel;

@end
