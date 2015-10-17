//
//  XHDisplayTextViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDisplayTextViewController.h"

@interface XHDisplayTextViewController ()

@property (nonatomic, weak) UITextView *displayTextView;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation XHDisplayTextViewController

- (UITextView *)displayTextView {
    if (!_displayTextView) {
        UITextView *displayTextView = [[UITextView alloc] initWithFrame:self.view.frame];
        displayTextView.font = [UIFont systemFontOfSize:16.0f];
        displayTextView.textColor = [UIColor blackColor];
        displayTextView.userInteractionEnabled = YES;
        displayTextView.editable = NO;
        displayTextView.backgroundColor = [UIColor clearColor];
        displayTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.view addSubview:displayTextView];
        _displayTextView = displayTextView;
    }
    return _displayTextView;
}

//- (void)setMessage:(id<XHMessageModel>)message {
//    _message = message;
//    self.displayTextView.text = [message text];
//}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"na_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem= backItem;
    
    NSString *reg = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSString *searchText = self.message.text;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    if (result) {
        self.title = @"外部网页";
        CGRect rx = [ UIScreen mainScreen ].bounds;
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.message.text]];
        [self.view addSubview: _webView];
        [_webView loadRequest:request];
    }else {
        self.title = @"文本消息";
        self.displayTextView.text = self.message.text;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.displayTextView = nil;
}

-(void)back:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
