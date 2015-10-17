//
//  PersonRegionVC.m
//  Burning
//
//  Created by Xiang Li on 15/8/19.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "PersonRegionVC.h"
#import "HZAreaPickerView.h"

@interface PersonRegionVC ()<UITextFieldDelegate, HZAreaPickerDelegate>

@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (strong, nonatomic) NSString *cityValue;
@property (strong, nonatomic) UILabel *hintLabel;

@end

@implementation PersonRegionVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区";
    
    self.personRegionTextField.text = self.content;
    self.personRegionTextField.delegate = self;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButton4BriefEidtClicked)];
    self.navigationItem.rightBarButtonItems = @[addItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)rightBarButton4BriefEidtClicked {
    if (self.personRegionTextField.text.length != 0) {
        WEAKSELF
        AVUser *avUser = [AVUser currentUser];
        [avUser setObject:self.personRegionTextField.text forKey:@"region"];
        [weakSelf showProgress];
        [avUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [weakSelf hideProgress];
            if (error) {
                [weakSelf alert:@"更新区域失败，请重试 :)"];
            }else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
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


-(UITextField*) personRegionTextField {
    UIImageView *leftView= [[UIImageView alloc]initWithFrame:CGRectMake(8, 4, 36, 36)];
    leftView.image = [UIImage imageNamed:@"ac_place_black"];
    _personRegionTextField.leftView = leftView;
    _personRegionTextField.leftViewMode = UITextFieldViewModeAlways;
    return _personRegionTextField;
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
        self.personRegionTextField.text = cityValue;
    }
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker {
    self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
}

-(void)cancelLocatePicker
{
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}

@end
