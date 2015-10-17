//
//  DailyNewsDetailViewController.m
//  Burning
//
//  Created by wei_zhu on 15/7/7.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "DailyNewsDetailViewController.h"

@interface DailyNewsDetailViewController ()

@end

@implementation DailyNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgationBar];
    self.webView.scalesPageToFit =YES;
    self.webView.delegate =self;
    NSURL *curNSUrl = [NSURL URLWithString:self.url];
    NSData *data =[NSData dataWithContentsOfURL:curNSUrl];
    [self.webView loadData:data MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:curNSUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavgationBar{
    self.title = @"详情";
}

-(void)backClick:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
