//
//  GroupGeneralEditViewController.m
//  Burning
//
//  Created by Xiang Li on 15/7/1.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "GroupGeneralEditViewController.h"
#import "CDMacros.h"

@interface GroupGeneralEditViewController ()

@end

@implementation GroupGeneralEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden =NO;
    [super viewDidLoad];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButton4EidtClicked)];
    self.navigationItem.rightBarButtonItems = @[addItem];
    NSDictionary *dict = self.conversion.attributes;
    
    switch (self.editType) {
        case 0:
            self.title = @"群名称";
            self.textField.text = self.conversion.name;
            break;
        case 1:
            self.title = @"群位置";
            self.textField.text = [dict objectForKey:@"groupLocation"];
            break;
        case 2:
            self.title = @"昵称";
            self.textField.text = [AVUser currentUser].username;
            break;
        case 3:
            self.title = @"修改密码";
            self.textField.secureTextEntry = YES;
            self.passwordTxtField.secureTextEntry = YES;
            [self.passwordTxtField setHidden:NO];
            self.textField.placeholder = @"新密码";
            self.passwordTxtField.placeholder = @"再输入一次";
            break;
        default:
            break;
    }
}

-(void)rightBarButton4EidtClicked{
    
    if (self.textField.text.length != 0) {
        AVIMConversationUpdateBuilder *builder = [self.conversion newUpdateBuilder];
        WEAKSELF
        [weakSelf showProgress];
        switch (self.editType) {
            case 0:{
                builder.name = self.textField.text;
                NSDictionary *changedDict = [builder dictionary];
                [self.conversion update:changedDict callback:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        [weakSelf alert:@"更新群名称失败，请重试 :)"];
                    } else {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
            break;
            case 1:{
                [self.conversion.attributes setValue:self.textField.text forKey:@"groupLocation"];
                builder.attributes = [[NSDictionary alloc]initWithDictionary:self.conversion.attributes];
                NSDictionary *changedDict2 = [builder dictionary];
                [self.conversion update:changedDict2 callback:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        [weakSelf alert:@"更新群位置失败，请重试 :)"];
                    } else {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
            break;
            case 2:{
                if (self.textField.text.length >10) {
                    [self alert:@"昵称不能多于10个字"];
                    [weakSelf hideProgress];
                    return;
                }
                
                AVUser *avUser = [AVUser currentUser];
                avUser.username = self.textField.text;
                //查重
                [self.lcDataHelper getUserWithUsername:self.textField.text butNotObjId:avUser.objectId block:^(NSArray *objects, NSError *error) {
                    if (error) {
                        
                    } else {
                        if (objects.count>0) {
                            [weakSelf alert:@"此昵称已被使用，换个呗 :)"];
                        }else {
                            [avUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (error) {
                                    
                                }else {
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                        }
                    }
                }];
            }
            break;
            case 3:{
                if ([self.textField.text isEqualToString:self.passwordTxtField.text]) {
                    [weakSelf showProgress];
                    AVUser *currentUser = [AVUser currentUser];
                    [currentUser updatePassword:currentUser.password newPassword:self.passwordTxtField.text block:^(id object, NSError *error) {
                        [weakSelf hideProgress];
                        if (error) {
                            [weakSelf alert:@"修改密码失败，请重试 :)"];
                        }else {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }else {
                    [self alert:@"真调皮，两次输的不一样 :("];
                }
            }
            break;
            default:
                break;
        }
        [weakSelf hideProgress];
    } else {
        [self alert:@"内容不能为空"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
