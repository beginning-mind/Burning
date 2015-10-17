//
//  OrderRootScrollView.m
//  Burning
//
//  Created by wei_zhu on 15/9/1.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "OrderRootScrollView.h"
#import "SVGloble.h"
#import "LayoutConst.h"
#import "SVTopScrollView.h"


#define POSITIONID (int)(scrollView.contentOffset.x/[SVGloble shareInstance].globleWidth)

#define BASETAG 200

#define LOADCOUNT 4


@interface OrderRootScrollView()

@property(nonatomic,assign)BOOL isFirstTopDrag;
@property(nonatomic,assign)BOOL isFirstBottomDrag;

@end

@implementation OrderRootScrollView

@synthesize viewNameArray;

+ (OrderRootScrollView *)shareInstance{
    static OrderRootScrollView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] initWithFrame:CGRectMake(0, 44, [SVGloble shareInstance].globleWidth, [SVGloble shareInstance].globleAllHeight-kStatusBarHeight-kNavigationBarHeight-44-kTabBarHeight)];
        
    });
    return _instance;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.isFirstTopDrag = YES;
        self.isFirstBottomDrag = YES;
        
        userContentOffsetX = 0;
    }
    return self;
}

- (void)initWithViews{

}

- (void)loadData{

}

-(void)refresh{

}


#pragma mark alter topScrolView
//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView{
    [[SVTopScrollView shareInstance] setButtonUnSelect];
    if (!isVerticScroll) {
        [SVTopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    }
    [[SVTopScrollView shareInstance] setButtonSelect];
}

#pragma mark --ScrowView Delegat

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
        isVerticScroll = NO;
    }
    else if(userContentOffsetX>scrollView.contentOffset.x) {
        isLeftScroll = NO;
        isVerticScroll = NO;
    }
    else{
        isVerticScroll = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
    [self loadData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self loadData];
}

@end
