	//
//  SquareMainViewController.m
//  Burning
//
//  Created by 李想 on 15/5/22.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//



#import "SquareMainViewController.h"

@interface SquareMainViewController ()


@property(nonatomic,strong)NSLayoutConstraint *headerConstraint;

@end

@implementation SquareMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showTabbar = YES;
        [self setTitle:@"广场"];
    }
    return self;
}

- (void)viewDidLoad{
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    [self setNavgationBar];
    
    self.svTopScrollView = [SVTopScrollView shareInstance];
    self.svTopScrollView.backgroundColor = RGB(249, 249, 249);
    self.svRootScrollView = [SVRootScrollView shareInstance];
    self.svTopScrollView.nameArray = @[@"热门", @"关注", @"最新"];
    self.svRootScrollView.viewNameArray = @[@"热门", @"关注", @"最新"];
    
    [self.view addSubview:self.svTopScrollView];
    [self.view addSubview:self.svRootScrollView];
    
    [self.svTopScrollView initWithNameButtons];
    [self.svRootScrollView initWithViews];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavgationBar{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"photo"] style:UIBarButtonItemStylePlain target:self action:@selector(takePhotoClick:)];

        self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)takePhotoClick:(UIButton*)button{
    TakePhotoViewController *takePhotoViewController = [[TakePhotoViewController alloc]init];
    takePhotoViewController.takePhotoViewControllerDelegate = self;
    [self.navigationController pushViewController:takePhotoViewController animated:YES];
}


#pragma mark TakePhotoViewControllerDelegate
-(void)refresh{
    [self.svRootScrollView refresh];
    [self.svTopScrollView setNewlyButton];
}

@end
