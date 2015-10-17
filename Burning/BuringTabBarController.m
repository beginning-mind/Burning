//
//  BuringTabBarController.m
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "BuringTabBarController.h"
#import "DiscoverMainViewController.h"
#import "BodyBuildingMainViewController.h"
#import "SquareMainViewController.h"
#import "MessageMainViewController.h"
//#import "MeMainViewController.h"
#import "BurningNavControl.h"
#import "LCEChatListVC.h"
#import "PersonalInfoViewController.h"



@interface BuringTabBarController ()

-(void)loadViewControls;
-(void)loadCustomTabbar;

@property(nonatomic,strong) UILabel *messagebadgeLable;

@property(nonatomic,strong)UILabel *dailyNewsBadgeLable;

@property(nonatomic,strong)PersonalInfoViewController *personalInfoViewController;

@end

@implementation BuringTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.tabBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadViewControls];
    [self loadCustomTabbar];
    [self saveToken];
}

-(void)saveToken{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSLog(@"token:%@",token);
    if (token!=nil) {
        AVUser *currentUser = [AVUser currentUser];
        [currentUser setObject:token forKey:@"deviceToken"];
        [currentUser saveInBackground];
    }
}

-(void)setMessagebadgeValue:(NSString*)messagebadgeValue{

    if (messagebadgeValue ==nil) {
        self.messagebadgeLable.hidden = YES;
    }
    else{
        self.messagebadgeLable.hidden = NO;
        self.messagebadgeLable.text = messagebadgeValue;
    }
}

-(void)setDailyNewsbadgeValue:(NSString *)dailyNewsbadgeValue{
    if (dailyNewsbadgeValue ==nil) {
        self.dailyNewsBadgeLable.hidden = YES;
    }
    else{
        self.dailyNewsBadgeLable.hidden = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate

{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations

{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadViewControls{
    DiscoverMainViewController *discoverMainVC = [[DiscoverMainViewController alloc] init];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverMainVC];
    
    BodyBuildingMainViewController *bodyBuildingMainVC = [[BodyBuildingMainViewController alloc]init];
    UINavigationController *bodyBuildingNav = [[UINavigationController alloc] initWithRootViewController:bodyBuildingMainVC];
    
    SquareMainViewController *squareMainVC = [[SquareMainViewController alloc]init];
    UINavigationController *squareNav = [[UINavigationController alloc] initWithRootViewController:squareMainVC];
    
    LCEChatListVC *messageMainVC = [[LCEChatListVC alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageMainVC];
    
    _personalInfoViewController = [[PersonalInfoViewController alloc]init];
    _personalInfoViewController.showTabbar = YES;
    _personalInfoViewController.user = [AVUser currentUser];
    UINavigationController *meNav = [[UINavigationController alloc]initWithRootViewController:_personalInfoViewController];
    
    NSArray *viewControllers = @[bodyBuildingNav,discoverNav,squareNav,messageNav,meNav];
    [self setViewControllers:viewControllers animated:YES];
}

-(void)loadCustomTabbar{
    //initial background
    _rect = self.tabBar.frame;
    [self.tabBar removeFromSuperview];
    _tabBarBg = [[UIImageView alloc]initWithFrame:_rect];
    _tabBarBg.userInteractionEnabled = YES;
    _tabBarBg.backgroundColor = RGB(249, 249, 249);
    [self.view addSubview:_tabBarBg];
    
    //initial tabbarbuttonitem
    for (int i=0; i<5; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i+100 ;
        
        NSString *imageName = [NSString stringWithFormat:@"tab_btn%d_normal",i];
        NSString *selectedImageName = [NSString stringWithFormat:@"tab_btn%d_selected",i];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
        
        CGFloat x = i*_tabBarBg.frame.size.width/5;
        button.frame = CGRectMake(x,0,_tabBarBg.frame.size.width/5,_tabBarBg.frame.size.height);
        [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarBg addSubview:button];
        
        if (i==1) {
            self.dailyNewsBadgeLable = [[UILabel alloc]initWithFrame:CGRectMake(x+_tabBarBg.frame.size.width/5-30, 5, 10, 10)];
            self.dailyNewsBadgeLable.layer.masksToBounds = YES;
            self.dailyNewsBadgeLable.layer.cornerRadius = 10/2.0;
            self.dailyNewsBadgeLable.hidden = YES;
            self.dailyNewsBadgeLable.textAlignment = NSTextAlignmentCenter;
            self.dailyNewsBadgeLable.font = [UIFont systemFontOfSize:12];
            self.dailyNewsBadgeLable.textColor = [UIColor whiteColor];
            self.dailyNewsBadgeLable.backgroundColor = [UIColor redColor];
            [_tabBarBg addSubview:self.dailyNewsBadgeLable];
        }
        
        if(i==3){
            self.messagebadgeLable = [[UILabel alloc]initWithFrame:CGRectMake(x+_tabBarBg.frame.size.width/5-30, 5, 18, 18)];
            self.messagebadgeLable.layer.masksToBounds = YES;
            self.messagebadgeLable.layer.cornerRadius = 18/2.0;
            self.messagebadgeLable.hidden = YES;
            self.messagebadgeLable.textAlignment = NSTextAlignmentCenter;
            self.messagebadgeLable.font = [UIFont systemFontOfSize:12];
            self.messagebadgeLable.textColor = [UIColor whiteColor];
            self.messagebadgeLable.backgroundColor = [UIColor redColor];
            [_tabBarBg addSubview:self.messagebadgeLable];
        }
        
        if(0==i){
            button.selected = YES;
            _seletedBtn = button;
        }
    }
    
}

-(void)changeViewController:(UIButton *)button{
    _seletedBtn.selected = NO;
    button.selected = YES;
    _seletedBtn = button;
    self.selectedIndex = button.tag-100;
}

-(void)showTabbar{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.28];
    _tabBarBg.hidden = NO;
    _tabBarBg.frame = _rect;
    [UIView commitAnimations];
}
-(void)hiddenTabbar{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    _tabBarBg.frame = CGRectMake(0-_rect.size.width, _rect.origin.y, _rect.size.width, _rect.size.height);
    _tabBarBg.hidden = YES;
    [UIView commitAnimations];
}

-(void)reloadData{
    _personalInfoViewController.user = [AVUser currentUser];
    [self setTab:100];
}

-(void)unloadData{
    _personalInfoViewController.user = nil;
}

-(void)setTab:(NSInteger)buttonTag{

    UIButton *btn = [_tabBarBg viewWithTag:buttonTag];
    [self changeViewController:btn];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
