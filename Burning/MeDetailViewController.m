//
//  MeDetailViewController.m
//  Burning
//
//  Created by Xiang Li on 15/7/26.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "MeDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RadioListViewController.h"
#import "GroupGeneralEditViewController.h"
#import "GroupBriefEditViewController.h"
#import <JZLocationConverter.h>
#import "PersonRegionVC.h"

@interface MeDetailViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) UIImageView *avatarImageView;

@property NSString *userAvatarPath;
@property BOOL isFullScreen;

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *curLocation;

@end

@implementation MeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self setUpManualLayout];
    
    [self startLocations];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    AVFile *avFile = [[AVUser currentUser] objectForKey:@"avatar"];
    NSString *url = @"";
    if (avFile.url) {
        url = avFile.url;
    }
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"blank_avatar.jpg"]];
    //    self.avartarImgView.layer.masksToBounds = YES;
    //    self.avartarImgView.layer.cornerRadius = 36/2.0;
    
    [self.nickNameButton setTitle:[[AVUser currentUser].username stringByAppendingString:@" >"] forState:UIControlStateNormal];
    
    NSString *gender = [[AVUser currentUser] objectForKey:@"gender"];
    if (gender == nil || [gender isEqualToString:@""]) {
        gender = @"去选择";
    }else if([gender isEqualToString:@"1"]){
        gender = @"男";
    }else {
        gender = @"女";
    }
    
    [self.genderButton setTitle:[gender stringByAppendingString:@" >"] forState:UIControlStateNormal];
    
    NSString *region = [[AVUser currentUser] objectForKey:@"region"];
    if (region) {
        [self.geoLocButton setTitle:[region stringByAppendingString:@" >"] forState:UIControlStateNormal];
    }else {
        [self.geoLocButton setTitle:@" >" forState:UIControlStateNormal];
    }
    
    
    NSString *signature = [[AVUser currentUser] objectForKey:@"signature"];
    if(signature == nil) {
        signature = @"";
    }
    [self.signatureButton setTitle:[signature stringByAppendingString:@" >"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)startLocations{
    self.locationManager = [[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization]; // 永久授权
            [self.locationManager requestWhenInUseAuthorization]; //使用中授权
        }
        
        [self.locationManager startUpdatingLocation];
    }
    else {
        NSLog( @"Cannot Starting CLLocationManager" );
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
}

-(void)setUpManualLayout {
    [self.picHolderView addSubview:self.avatarImageView];
}

-(UIImageView*)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSettingAvatarSize, kSettingAvatarSize)];
        
        //[_avatarImageView setImage:[UIImage imageNamed:@"group_blank"]];
        
        _avatarImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userAvatarClick:)];
        [_avatarImageView addGestureRecognizer:singleTap];
    }
    return _avatarImageView;
}

//-(UIImageView*)avartarImgView{
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userAvatarClick:)];
//    [_avartarImgView addGestureRecognizer:singleTap];
//    return _avartarImgView;
//}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    _userAvatarPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:_userAvatarPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self saveImage:image withName:@"user_avatar_detail.jpg"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:_userAvatarPath];
    _isFullScreen = NO;
    
    [self saveAndUpdateAvatarWithImage:savedImage];
}

-(void)saveAndUpdateAvatarWithImage:(UIImage*) image{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSUInteger imageLen = imageData.length;
    //NSLog(@"imageData len 1 :%d", imageData.length);
    
    if(imageLen > 1024*1024) {
        imageData = UIImageJPEGRepresentation(image, 0.2);
    }else if(imageLen > 512*1024 && imageLen < 1024*1024) {
        imageData = UIImageJPEGRepresentation(image, 0.4);
    }else if(imageLen > 256*1024 && imageLen < 512*1024) {
        imageData = UIImageJPEGRepresentation(image, 0.6);
    }else {
        imageData = UIImageJPEGRepresentation(image, 0.8);
    }
    //NSLog(@"imageData len 2 :%d", imageData.length);
    
    
    AVFile *oldFile = [[AVFile alloc] init];
    oldFile = [[AVUser currentUser] objectForKey:@"avatar"];
    
    //新的文件
    AVFile *imageFile = [AVFile fileWithName:[AVUser currentUser].objectId data:imageData];
    
    WEAKSELF
    [weakSelf showProgress];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [weakSelf hideProgress];
        if(error) {
            [weakSelf alert:@"上传头像失败, 请重试 :)"];
        }else {
            [[AVUser currentUser] setObject:imageFile forKey:@"avatar"];
            [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [weakSelf alert:@"更新头像失败, 请重试 :)"];
                } else {
                    NSLog(@"oldFile.objectId: %@", oldFile.objectId);
                    NSLog(@"imageFile.objectId: %@", imageFile.objectId);
                    
                    //系统自带不可删除
                    /*if (oldFile) {
                        [oldFile deleteInBackground];
                    }*/
                    
                    [weakSelf viewWillAppear:YES];
                }
            }];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 256) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark CLLocationManager Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _curLocation = [locations lastObject];
    [manager stopUpdatingLocation];
    
    
}

-(CLLocation *)constructWithCoordinate:(CLLocationCoordinate2D)coordinate {
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma mark action
- (IBAction)nicknameClick:(id)sender {
    GroupGeneralEditViewController *groupGeneralEditViewController = [[GroupGeneralEditViewController alloc]init];
    groupGeneralEditViewController.editType = 2;
    [self.navigationController pushViewController:groupGeneralEditViewController animated:YES];
    
}

- (IBAction)genderClick:(id)sender {
    RadioListViewController *radioListViewController = [[RadioListViewController alloc]init];
    radioListViewController.gender = [[AVUser currentUser] objectForKey:@"gender"];
    [self.navigationController pushViewController:radioListViewController animated:YES];
}

- (IBAction)geoLocClick:(id)sender {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    CLLocationCoordinate2D baiduCoordinate2D = [JZLocationConverter wgs84ToBd09:_curLocation.coordinate];
    
    [geoCoder reverseGeocodeLocation:[self constructWithCoordinate:baiduCoordinate2D] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks) {
            for (CLPlacemark * placemark in placemarks) {
                NSDictionary *test = [placemark addressDictionary];
                
                //NSLog(@"%@", [test objectForKey:@"State"]);
                //NSLog(@"%@", [test objectForKey:@"SubLocality"]);
                
                NSString *state = [test objectForKey:@"State"];
                NSString *subLocality = [test objectForKey:@"SubLocality"];
                NSString *regionStr = [state stringByAppendingString:@" "];
                regionStr = [regionStr stringByAppendingString:subLocality];
                
                PersonRegionVC *personRegionVC = [[PersonRegionVC alloc] init];
                personRegionVC.content = regionStr;
                [self.navigationController pushViewController:personRegionVC animated:YES];
            }
        }else {
            [self alert:@"请在'设置'开启定位"];
        }
    }];
}

- (IBAction)signatureClick:(id)sender {
    GroupBriefEditViewController *groupBriefEditViewController = [[GroupBriefEditViewController alloc]init];
    groupBriefEditViewController.editType =1;
    [self.navigationController pushViewController:groupBriefEditViewController animated:YES];
}

-(void)userAvatarClick:(UIGestureRecognizer*)gestureRecognizer {
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 256;
    [sheet showInView:self.view];
    
}

@end
