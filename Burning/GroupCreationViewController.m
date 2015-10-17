//
//  GroupCreationViewController.m
//  Burning
//
//  Created by Xiang Li on 15/6/18.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "GroupCreationViewController.h"
#import <AVIMClient.h>
#import "GroupDetailViewController.h"
#import "CDStorage.h"
#import "CDIM.h"
#import "CDMacros.h"
#import "RegionSelectorVC.h"
#import "BuringTabBarController.h"
#import "SVGloble.h"
#import "LocationHelper.h"
#import <JZLocationConverter.h>

//@implementation CLLocationManager (TemporaryHack)
//
////模拟器测试用
//- (void)hackLocationFix
//{
//    //CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
//    float latitude = 39.906811;
//    float longitude = 116.377586;  //这里可以是任意的经纬度值
//    CLLocation *location= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    //    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:nil];
//    [[self delegate] locationManager:self didUpdateLocations:[NSArray arrayWithObject:location]];
//}
//
//-(void)startUpdatingLocation
//{
//    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
//}
//
//@end


@interface GroupCreationViewController ()<CLLocationManagerDelegate, RegionSelectorVCDelegate>

@property (nonatomic, strong) CDStorage *storage;
@property BOOL isFullScreen;
@property NSString *groupAvatarPath;

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *curLocation;
@property (nonatomic)        float latitudeFromSeletor;
@property (nonatomic)        float longitudeFromSeletor;
@property (nonatomic,strong) NSString *nameFromSeletor;

@property (nonatomic,strong) UIImageView *avatarBackgroud;
@property (nonatomic,strong) UIImageView *avatarView;

@property(nonatomic) BOOL defaultScorll;

@property(nonatomic) BOOL avatarChanged;

@property(nonatomic,assign)CGFloat orignaloffesetY;

@property(nonatomic,assign)CGFloat keyBoardHeight;

@property(nonatomic,assign)CGFloat orignalfocusedControlMaxY;

@property(nonatomic,assign)CGFloat newoffesetY;

@property(nonatomic,assign)CGFloat orignalContesizeHeight;

@end

@implementation GroupCreationViewController

//bool _defaultScorll = NO;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"新建群";
        _defaultScorll = NO;
        _avatarChanged = NO;
        _storage = [CDStorage sharedInstance];
        
        //        LocationHelper *locationHelper = [[LocationHelper alloc]init];
        //        _curLocation = locationHelper.curLocation;

        [self startLocations];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BuringTabBarController * buringTabBarController  = (BuringTabBarController*)self.tabBarController;
    [buringTabBarController hiddenTabbar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setUp];
}

-(void)setUp {
    self.groupName.delegate = self;
    self.groupLocation.delegate = self;
    self.groupBrief.delegate = self;
    self.groupName.returnKeyType = UIReturnKeyDone;
    self.groupBrief.returnKeyType = UIReturnKeyDone;
    
    //[self initAvatarImageView];
    //    self.avatarImgView.layer.masksToBounds = YES;
    //    self.avatarImgView.layer.cornerRadius = 60/2.0;
    
    self.groupBrief.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.groupBrief.layer.borderWidth = 0.6f;
    self.groupBrief.layer.cornerRadius = 6.0f;
    
    CGFloat maxy = CGRectGetMaxY(self.creationButton.frame);
    if (maxy+15>[[UIScreen mainScreen] bounds].size.height) {
        self.creationScrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, maxy+15);
        _defaultScorll = YES;
        self.orignalContesizeHeight = maxy+15;
    }
    else{
        self.creationScrollView.contentSize = CGSizeZero;
        _defaultScorll = NO;
        self.orignalContesizeHeight = 0;
    }
    
    [self.picHolderView addSubview:self.avatarBackgroud];
    [self.picHolderView addSubview:self.avatarView];
}

-(UIImageView*)avatarBackgroud {
    if (_avatarBackgroud == nil) {
            _avatarBackgroud = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, kBackgroudViewHeight)];
        [_avatarBackgroud setImage:[UIImage imageNamed:@"AlbumHeaderBackgrounImage"]];
    }
    return _avatarBackgroud;
}

-(UIImageView*)avatarView {
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(kLargeAvatarLeadingSpace, kLargeAvatarLeadingSpace, kLagerAvatarSize, kLagerAvatarSize)];
        _avatarView.userInteractionEnabled = YES;
        
        [_avatarView setImage:[UIImage imageNamed:@"group_blank"]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAvatar:)];
        [_avatarView addGestureRecognizer:singleTap];
    }
    return _avatarView;
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

-(void) doAfterSaveAvatarWith:(AVIMConversation*)conversation groupAvatarUrl:(NSString*)groupAvatarUrl Sequence:(NSInteger)number {
    
    CLLocationCoordinate2D selectLocation = CLLocationCoordinate2DMake(self.latitudeFromSeletor, self.longitudeFromSeletor);
    CLLocationCoordinate2D wgsSelectLocation = [JZLocationConverter bd09ToWgs84:selectLocation];
    WEAKSELF
    //插入Group表，用于定位
    [weakSelf runInGlobalQueue:^{
        NSError *error2;
        
        [weakSelf.lcDataHelper saveAGroupWithConversation:conversation latitude:wgsSelectLocation.latitude longitude:wgsSelectLocation.longitude error:&error2];
        [weakSelf runInMainQueue:^{
            if (error2 == nil) {
                
            }else {
                [weakSelf alert:@"定位失败，请开启 T_T"];
            }
        }];
    }];
    
    //更新attributes信息
    AVIMConversationUpdateBuilder *builder = [conversation newUpdateBuilder];
    if (self.nameFromSeletor == nil) {
        self.nameFromSeletor = @"";
    }

    NSString *location = [[NSString stringWithFormat:@"%f", wgsSelectLocation.latitude] stringByAppendingString:@","];
    location = [location stringByAppendingString:[NSString stringWithFormat:@"%f", wgsSelectLocation.longitude]];
    
    //NSLog(@"geoPointJSON, %@", location);
    builder.attributes = @{@"type":[NSNumber numberWithInt:1],
                           //@"groupLocation":self.groupLocation.text,
                           @"sequenceNum":[NSNumber numberWithInt:number],
                           @"groupBrief":self.groupBrief.text,
                           @"groupAvatarPicUrl":groupAvatarUrl,
                           @"location":location,
                           @"locationName":self.nameFromSeletor,
                           @"isDel":@(0)
                           };
    
    NSDictionary *changedDict = [builder dictionary];
    [conversation update:changedDict callback:^(BOOL succeeded, NSError *error) {
        [weakSelf hideProgress];
        if (error) {
            [weakSelf alert:@"更新对话失败，请重试 :)"];
        }else {
            //插入本地库并返回消息页
            [_storage insertRoomWithConvid:conversation.conversationId AndType:CDConvTypeGroup];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)hiddenTextPicker{
    [self.groupName resignFirstResponder];
    [self.groupLocation resignFirstResponder];
    [self.groupBrief resignFirstResponder];
}

#pragma mark UI
//-(UIImageView*)avatarImgView {
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAvatar:)];
//    [_avatarImgView addGestureRecognizer:singleTap];
//    return _avatarImgView;
//}
//-(void)initAvatarImageView{
//    _avatarImgView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAvatar:)];
//    [_avatarImgView addGestureRecognizer:singleTap];
//}

-(UITextField*)groupName {
    UIImageView *leftView= [[UIImageView alloc]initWithFrame:CGRectMake(8, 4, 36, 36)];
    leftView.image = [UIImage imageNamed:@"ac_maxPerson"];
    _groupName.leftView = leftView;
    _groupName.leftViewMode = UITextFieldViewModeAlways;
    return _groupName;
}

-(UITextField*)groupLocation {
    _groupLocation.tag = 1001;
    UIImageView *leftView= [[UIImageView alloc]initWithFrame:CGRectMake(8, 4, 36, 36)];
    leftView.image = [UIImage imageNamed:@"ac_place"];
    _groupLocation.leftView = leftView;
    _groupLocation.leftViewMode = UITextFieldViewModeAlways;
    return _groupLocation;
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    _groupAvatarPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:_groupAvatarPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self saveImage:image withName:@"group_avatar_creation.jpg"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:_groupAvatarPath];
    _isFullScreen = NO;

    _avatarView.image = savedImage;
    _avatarChanged = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
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
//    NSLog(@"%f", _curLocation.coordinate.latitude);
    [manager stopUpdatingLocation];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hiddenTextPicker];
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.orignaloffesetY = self.creationScrollView.contentOffset.y;
    self.orignalfocusedControlMaxY = CGRectGetMaxY(textField.frame);
    if(textField.tag == 1001){
        
        RegionSelectorVC *regionSelectorVC = [[RegionSelectorVC alloc]init];
        NSLog(@"%f", _curLocation.coordinate.latitude);
        regionSelectorVC.regionSelectorVCDelegate =self;
        
        CLLocationCoordinate2D baiduCoordinate2D = [JZLocationConverter wgs84ToBd09:_curLocation.coordinate];
        
        regionSelectorVC.curLocation = [self constructWithCoordinate:baiduCoordinate2D];
        [self.navigationController pushViewController:regionSelectorVC animated:YES];
        
        return NO;
    }
    return YES;
}

-(CLLocation *)constructWithCoordinate:(CLLocationCoordinate2D)coordinate {
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma mark -textView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.orignaloffesetY = self.creationScrollView.contentOffset.y;
    self.orignalfocusedControlMaxY = CGRectGetMaxY(textView.frame);
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    //    self.explainTextView.text =  textView.text;
    //    if (self.explainTextView.text.length == 0) {
    //        self.placeText.text = @"无";
    //        self.placHolderLabel.textColor = [UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1.0];
    //        self.placHolderLabel.font = [UIFont systemFontOfSize:14.0];
    //    }else{
    //        self.placHolderLabel.text = @"";
    //    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        
        [self hiddenTextPicker];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark - RegionSelectorVC Delegate
-(void)setPLaceTextFieldWithName:(NSString *)placeName latitude:(float)latitude longitude:(float)longitude {
    self.groupLocation.text = placeName;
    self.latitudeFromSeletor = latitude;
    self.longitudeFromSeletor = longitude;
    self.nameFromSeletor = placeName;
}

#pragma mark action
- (void)addAvatar:(UIGestureRecognizer*)gestureRecognizer {
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}

- (IBAction)creationOKButton:(id)sender {
    NSString *groupName = self.groupName.text;
    if(groupName.length != 0) {
        if (groupName.length > 10) {
            [self alert:@"群名不能超过10个字"];
            return;
        }
        CDIM *im = [CDIM sharedInstance];
        AVUser *currentUser = self.getCurrentUser;
        NSArray *clientIds = @[currentUser.objectId];
        
        [self showProgress];
        WEAKSELF
        //获取群组序列
        [self.lcDataHelper saveSequenceWithType:1 Block:^(NSInteger number, NSError *error) {
            if (error) {
                [weakSelf hideProgress];
                [weakSelf alert:@"生成用户ID失败 T_T"];
            }else {
                [im.imClient createConversationWithName:groupName clientIds:clientIds attributes:@{@"type":[NSNumber numberWithInt:CDConvTypeGroup]} options:AVIMConversationOptionNone callback:^(AVIMConversation *conversation, NSError *error) {
                    if(error) {
                        [weakSelf alert:@"创建群组失败，请重试 :)"];
                        [weakSelf hideProgress];
                    }else {
                        UIImage *image = [[UIImage alloc] initWithContentsOfFile:_groupAvatarPath];
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                        AVFile *imageFile = [AVFile fileWithName:conversation.conversationId data:imageData];
                        
                        //保存头像
                        if (_avatarChanged) {
                            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if(error) {
                                    [weakSelf alert:@"上传头像失败，请重试 :)"];
                                    [weakSelf hideProgress];
                                }else {
                                    [weakSelf doAfterSaveAvatarWith:conversation groupAvatarUrl:imageFile.url Sequence:number];
                                }
                            }];
                        }else {
                            [weakSelf doAfterSaveAvatarWith:conversation groupAvatarUrl:@"" Sequence:number];
                        }
                    }
                }];
            }
        }];
    } else {
        [self alert:@"群需要个霸气的名号"];
    }
}

#pragma mark keyboard delegate
-(void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keyBoardHeight = kbSize.height;
    CGFloat contentHeight = self.orignalContesizeHeight;
    if (self.defaultScorll) {
        contentHeight+=self.keyBoardHeight;
    }
    else{
        contentHeight+=self.creationScrollView.frame.size.height;
        contentHeight+=self.keyBoardHeight;
    }
    
    self.creationScrollView.contentSize =CGSizeMake([[UIScreen mainScreen] bounds].size.width, contentHeight);
    
    self.newoffesetY = self.orignalfocusedControlMaxY+self.keyBoardHeight+kStatusBarHeight+kNavigationBarHeight- [SVGloble shareInstance].globleAllHeight-self.orignaloffesetY;
    if(self.newoffesetY>0){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        self.creationScrollView.contentOffset = CGPointMake(0,self.newoffesetY+self.orignaloffesetY+5);
        [UIView commitAnimations];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
    if (self.defaultScorll) {
        self.creationScrollView.contentSize =CGSizeMake([[UIScreen mainScreen] bounds].size.width, self.orignalContesizeHeight);
    }
    else{
        self.creationScrollView.contentSize =CGSizeZero;
    }
}
@end
