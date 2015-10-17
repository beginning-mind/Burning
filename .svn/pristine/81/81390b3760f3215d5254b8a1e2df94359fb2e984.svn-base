//
//  LCESysMsgVC.h
//  Burning
//
//  Created by Xiang Li on 15/7/6.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BaseViewController.h"
#import "LeanChatLib.h"

@protocol LCESysMsgVCDelegate <NSObject>

@optional
-(void)startAConverstionWithConversation:(AVIMConversation *) conv;

@end


@interface LCESysMsgVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sysMsgTableView;
@property (strong, nonatomic) NSMutableArray *sysMsgs;
//@property(nonatomic, strong) AVIMConversation *conversion;
@property(nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) CDIM *im;
@property (nonatomic,strong)id<LCESysMsgVCDelegate> lceSysMsgVCDelegate;



@end
