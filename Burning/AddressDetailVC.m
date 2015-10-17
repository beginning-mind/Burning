//
//  addressDetailVC.m
//  Burning
//
//  Created by Xiang Li on 15/9/1.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "addressDetailVC.h"
#import "HZAreaPickerView.h"

@interface AddressDetailVC ()<UITextFieldDelegate, HZAreaPickerDelegate, UITextViewDelegate>

@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (strong, nonatomic) NSString *cityValue;
@property (strong, nonatomic) UILabel *hintLabel;

@end

@implementation AddressDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增地址";
    [self.detailAddressTextView setHidden:NO];
    [self setHint];
    
    self.regionTextField.text = self.content;
    self.regionTextField.delegate = self;
    self.detailAddressTextView.delegate = self;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButton4BriefEidtClicked)];
    self.navigationItem.rightBarButtonItems = @[addItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)rightBarButton4BriefEidtClicked {
    if (self.detailAddressTextView.text.length ==0) {
        [self alert:@"详细地址不能为空"];
        return;
    }
    LCAddress *lcAddress = [LCAddress object];
    lcAddress.userObjectId = [AVUser currentUser].objectId;
    
    WEAKSELF
    [self showProgress];
    [weakSelf runInGlobalQueue:^{
        NSError *error2;
        [weakSelf.lcDataHelper saveAddressWithLCAddress:lcAddress error:&error2];
        [weakSelf runInMainQueue:^{
            [weakSelf hideProgress];
            if (error2) {
                [weakSelf alert:@"提交地址失败, 请重试 :)"];
            }else {
                //[weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}


-(UITextField*) regionTextField {
    UIImageView *leftView= [[UIImageView alloc]initWithFrame:CGRectMake(8, 4, 36, 36)];
    leftView.image = [UIImage imageNamed:@"ac_place_black"];
    _regionTextField.leftView = leftView;
    _regionTextField.leftViewMode = UITextFieldViewModeAlways;
    return _regionTextField;
}

-(UITextView*)detailAddressTextView {
    _detailAddressTextView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    _detailAddressTextView.layer.borderWidth = 0.6f;
    _detailAddressTextView.layer.cornerRadius = 6.0f;
    
    return _detailAddressTextView;
}

-(void)setCityValue:(NSString *)cityValue
{
    if (![_cityValue isEqualToString:cityValue]) {
        self.regionTextField.text = cityValue;
    }
}

-(void)setHint{
    _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,7,200,18)];
    _hintLabel.font = [UIFont systemFontOfSize:14.0f];
    _hintLabel.text = @"详细地址";
    _hintLabel.enabled = YES;
    _hintLabel.textColor =[UIColor lightGrayColor];
    //_hintLabel.backgroundColor = [UIColor blueColor];
    [self.detailAddressTextView addSubview:_hintLabel];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker {
    self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
}
-(void)cancelLocatePicker {
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self cancelLocatePicker];
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
    [self.locatePicker showInView:self.view];
    return NO;
}

#pragma UITextView Delegate
-(void)textViewDidChange:(UITextView*) textView {
    if (textView.text.length ==0) {
        _hintLabel.text = @"详细地址";
    }else {
        _hintLabel.text = @"";
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self cancelLocatePicker];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}


@end
