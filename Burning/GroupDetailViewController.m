//
//  GroupDetailViewController.m
//  Burning
//
//  Created by Xiang Li on 15/6/20.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "GroupDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVGloble.h"
#import "UsersFollowedEachOtherViewController.h"
#import "GroupMembersViewController.h"
#import "LCDataHelper.h"
#import "PListFileHelper.h"
#import "CDMacros.h"
#import "GroupGeneralEditViewController.h"
#import "GroupBriefEditViewController.h"
#import "CDMessage.h"
#import "LCEChatListVC.h"
#import "RegionSelectorVC.h"
#import "LocationHelper.h"
#import <JZLocationConverter.h>
#import "PersonalInfoViewController.h"
#import "LayoutConst.h"



#define GROUP_DETAIL_TAG 100

typedef enum : NSUInteger {
    GroupMaster = 0,
    GroupGuest =1,
    GroupMember =2,
} GroupRole;

static NSInteger groupLimit = 50;

@interface GroupDetailViewController ()<CLLocationManagerDelegate, RegionSelectorVCDelegate>

@property NSString *groupAvatarPath;
@property BOOL isFullScreen;
@property NSInteger curUserRole;
@property CDIM *im;
@property NSArray *userArray;

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *curLocation;

@property (nonatomic)        float latitudeFromSeletor;
@property (nonatomic)        float longitudeFromSeletor;
@property (nonatomic,strong) NSString *nameFromSeletor;

@property (nonatomic,strong) UIImageView *avatarBackgroud;
@property (nonatomic,strong) UIImageView *avatarView;
@property (nonatomic,strong) UILabel *sequenceLabel;

@end

@implementation GroupDetailViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"群详情";
        _im = [CDIM sharedInstance];
        [self startLocations];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpManualLayout];
    
    self.memberNumber.tag = 11;
    NSString *curUserObjId = [self getCurrentUser].objectId;
    
    NSArray *memberArr = self.conversion.members;
    BOOL isAFullGroup = NO;
    if (memberArr.count == groupLimit || memberArr.count > groupLimit) {
        isAFullGroup = YES;
    }
    
    //群主
    if ([self.conversion.creator isEqualToString:curUserObjId]) {
        _curUserRole = GroupMaster;
        [self.exitGroupButton setHidden:YES];
        
        if (isAFullGroup) {
            [self.bottomView setHidden:YES];
        }else {
            [self.bottomView setHidden:NO];
            [self.bottomButton setTitle:@"邀请好友" forState:UIControlStateNormal];
        }
    } else {
        //不可编辑
        [self.avatarView setUserInteractionEnabled:NO];
        [self.editGroupName setUserInteractionEnabled:NO];
        [self.editGroupLoc setUserInteractionEnabled:NO];
        //[self.editGroupBrief setUserInteractionEnabled:NO];
        [self.editGroupBrief setHidden:YES];

        //群成员
        NSArray *members = self.conversion.members;
        if ([members containsObject:curUserObjId]) {
            _curUserRole = GroupMember;
            [self.dissmiss setHidden:YES];
            [self.bottomView setHidden:YES];
        
        //游客
        }else {
            _curUserRole = GroupGuest;
            [self.noDisturbLabel setHidden:YES];
            [self.switchButton setHidden:YES];

            [self.noAtLabel setHidden:YES];
            [self.noAtSwitch setHidden:YES];
            
            
            [self.cleanMemory setHidden:YES];
            [self.exitGroupButton setHidden:YES];
            [self.dissmiss setHidden:YES];
            
            if (isAFullGroup) {
                [self.bottomView setHidden:YES];
            }else {
                [self.bottomView setHidden:NO];
                [self.bottomButton setTitle:@"申请加入" forState:UIControlStateNormal];
            }
        }
    }
    
    //NSString *isOn = [PListFileHelper readObjectByKey:self.conversion.conversationId];
    NSMutableDictionary *muDict = [PListFileHelper readObjectByKey:self.conversion.conversationId];
    if (muDict) {
        NSString *isNoDisturbConv = [muDict objectForKey:@"NoDisturbConvKey"];
        NSString *isNoAt = [muDict objectForKey:@"NoAtKey"];
        
        if ([isNoDisturbConv isEqual:@"YES"]) {
            [self.switchButton setOn:YES];
        }else {
            [self.switchButton setOn:NO];
        };
        
        if ([isNoAt isEqual:@"YES"]) {
            [self.noAtSwitch setOn:YES];
        }else {
            [self.noAtSwitch setOn:NO];
        }
    }else {
        [self.switchButton setOn:NO];
        [self.noAtSwitch setOn:NO];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSDictionary *dict = self.conversion.attributes;
    NSArray *userIds = [self.conversion members];
    [self initAvatarViewWithAVUsers:userIds];
    
    NSString *editalbeSign = @"";
    if(_curUserRole == GroupMaster) {
        editalbeSign = @" >";
    }
    
    
    [self.groupName setTitle:[self.conversion.name stringByAppendingString:editalbeSign] forState:UIControlStateNormal];
    
    NSNumber *sequenceNum = [dict objectForKey:@"sequenceNum"];
    if (sequenceNum) {
        NSString *sequenceStr = [NSString stringWithFormat:@"%d",[sequenceNum intValue]];
        _sequenceLabel.text = sequenceStr;
    }
    
    [self.groupLocation setTitle:[[dict objectForKey:@"locationName"] stringByAppendingString:editalbeSign] forState:UIControlStateNormal];
    self.groupBrief.text = [dict objectForKey:@"groupBrief"];
    
    NSString *url = [dict objectForKey:@"groupAvatarPicUrl"];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"group_blank"]];
//    self.avatarView.layer.masksToBounds = YES;
//    self.avatarView.layer.cornerRadius = 60/2.0;
    NSString *limit = [NSString stringWithFormat:@"%ld", (long)groupLimit];
    NSString *groupLimitStr = [@"/" stringByAppendingString:limit];
    self.memberNumber.text = [[NSString stringWithFormat:@"%lu", (unsigned long)self.conversion.members.count]stringByAppendingString:groupLimitStr];
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

-(CLLocation *)constructWithCoordinate:(CLLocationCoordinate2D)coordinate {
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

-(NSArray*) pickMasterOutInArray:(NSArray*)array {
    NSMutableArray *mtArr = [array mutableCopy];
    NSInteger masterIdx;
    for (int i=0; i<mtArr.count; i++) {
        AVUser *user = [mtArr objectAtIndex:i];
        if ([user.objectId isEqualToString:self.conversion.creator]) {
            masterIdx = i;
            break;
        }
    }
    [mtArr exchangeObjectAtIndex:0 withObjectAtIndex:masterIdx];
    return [mtArr copy];
}

#pragma mark UI
-(void) setUpManualLayout {
    [self.picHolder addSubview:self.avatarBackgroud];
    [self.picHolder addSubview:self.avatarView];
    [self.picHolder addSubview:self.sequenceLabel];
}

-(UIImageView*)avatarBackgroud {
    if (_avatarBackgroud == nil) {
        //NSLog(@"[[UIScreen mainScreen] bounds].size.width:%f", [[UIScreen mainScreen] bounds].size.width);
        //NSLog(@"[[UIScreen mainScreen] bounds].size.height:%f", [[UIScreen mainScreen] bounds].size.height);
        
        _avatarBackgroud = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, kBackgroudViewHeight)];
        [_avatarBackgroud setImage:[UIImage imageNamed:@"AlbumHeaderBackgrounImage"]];
    }
    return _avatarBackgroud;
}

-(UIImageView*)avatarView {
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(kLargeAvatarLeadingSpace, kLargeAvatarLeadingSpace, kLagerAvatarSize, kLagerAvatarSize)];
        _avatarView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupAvatarClick:)];
        [_avatarView addGestureRecognizer:singleTap];
    }
    return _avatarView;
}

-(UILabel*)sequenceLabel {
    if (_sequenceLabel == nil) {
        _sequenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLargeAvatarLeadingSpace+kLagerAvatarSize+kSmallTextAvatarHorizalSpace, kLargeAvatarLeadingSpace+kLagerAvatarSize-kPubShowUsernameHeight, 100, kPubShowUsernameHeight)];
        
        _sequenceLabel.font = [UIFont systemFontOfSize:kCommonFontSize];
        _sequenceLabel.textColor = RGB(255, 255, 255);
    }
    return _sequenceLabel;
}

-(UIImageView*)newAImageViewWithURL:(NSString*)url userId:(NSString*)userId Placeholer:(NSString*) placeholder index:(NSUInteger)index count:(NSUInteger)count {
    
    NSLog(@"[SVGloble shareInstance].globleWidth:%f", [SVGloble shareInstance].globleWidth);
    CGFloat size = ([SVGloble shareInstance].globleWidth-2*10-5*(kGroupMemberAvatarRowCount-1))/kGroupMemberAvatarRowCount;//两边隔10,中间5
    CGFloat x = 0.0;
    x = 10+index*(size+5);
    UIImageView* avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x,0, size, size)];
    //    avatarImageView.layer.masksToBounds =YES;
    //    avatarImageView.layer.cornerRadius =size/2.0;
    avatarImageView.userInteractionEnabled = YES;
    
    
    //暂时没有头像
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholder]];
    
    if ([userId isEqualToString:@"-1"]) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMemberList:)];
        [avatarImageView addGestureRecognizer:singleTap];
    }
    else{
        int tag = GROUP_DETAIL_TAG + index;
        avatarImageView.tag = tag;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userClick:)];
        [avatarImageView addGestureRecognizer:singleTap];
    }
    return avatarImageView;
}

-(void)initAvatarViewWithAVUsers:(NSArray*) userIds {
//    NSArray *subViews = [self.avatarViewContainer subviews];
//    for(UIView *uiView in subViews){
//        if (uiView.tag == 11) {
//            continue;
//        }
//        [uiView removeFromSuperview];
//    }
    WEAKSELF
    [weakSelf showProgress];
    [self.lcDataHelper getUserArrayWithObjectIdArray:userIds block:^(NSArray *objects, NSError *error) {
        [weakSelf hideProgress];
        if (error) {
            [self alert:@"获取群成员列表失败，请重试 :)"];
        } else {
            if (objects>0) {
                NSArray *orderedArr = [self pickMasterOutInArray:objects];
                _userArray = orderedArr;
                
                //                //***边界测试
                //                NSMutableArray *mtArr = [[NSMutableArray alloc]init];
                //                NSMutableArray *avUserArr = [[NSMutableArray alloc] init];
                //                for(int i=0; i<5;i++) {
                //                    [avUserArr addObjectsFromArray:orderedArr];
                //                }
                
                //NSLog(@"aa %@",[NSString stringWithFormat:@"%lu", (unsigned long)mtArr.count]);
                
                NSUInteger z = 0;//最多显示8个
                
                for (AVUser *avUser in orderedArr) {
                    if (z>7) {
                        break;
                    }
                    if (z > orderedArr.count-1 || orderedArr.count ==0) {
                        break;
                    }
                    
                    AVUser *tmpUser = [orderedArr objectAtIndex:z];
//                    BOOL isMaster;
//                    if([tmpUser.objectId isEqual:self.conversion.creator]) {
//                        isMaster = YES;
//                    }else {
//                        isMaster = NO;
//                    }
                    
                    
                    AVFile *avFile = [tmpUser objectForKey:@"avatar"];
                    UIImageView *avatarView =[self newAImageViewWithURL:avFile.url userId:tmpUser.objectId Placeholer:@"blank_avatar.jpg" index:z count:orderedArr.count];
                    [self.avatarViewContainer addSubview:avatarView];
                    if (z == 0) {
                        UIImageView *tagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(avatarView.frame)-9, CGRectGetMaxY(avatarView.frame)-8, 14, 10)];
                        tagImageView.image = [UIImage imageNamed:@"co_master"];
                        [self.avatarViewContainer addSubview:tagImageView];
                    }
                    z++;
                }
                
                [self.avatarViewContainer addSubview:[self newAImageViewWithURL:@"" userId:@"-1" Placeholer:@"btn_more_normal" index:z count:orderedArr.count]];
            }
        }
    }];
    
}

-(void)saveAndUpdateAvatarWithImage:(UIImage*) image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    AVFile *imageFile = [AVFile fileWithName:self.conversion.conversationId data:imageData];
    
    WEAKSELF
    [weakSelf showProgress];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [weakSelf hideProgress];
        if(error) {
            [weakSelf alert:@"上传头像失败，请重试 :)"];
        }else {
            //更新本对话里的头像
            AVIMConversationUpdateBuilder *builder = [weakSelf.conversion newUpdateBuilder];
            [self.conversion.attributes setValue:imageFile.url forKey:@"groupAvatarPicUrl"];
            builder.attributes = [[NSDictionary alloc]initWithDictionary:self.conversion.attributes];
            NSDictionary *changedDict = [builder dictionary];
            [weakSelf.conversion update:changedDict callback:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [weakSelf alert:@"更新对话失败，请重试 :)"];
                }else {
                    [weakSelf viewWillAppear:YES];
                }
            }];
        }
    }];
}

#pragma  mark action
-(void)groupAvatarClick:(UIGestureRecognizer*)gestureRecognizer {
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

- (IBAction)dissmissGroup:(id)sender {
    WEAKSELF
    NSString *hint = @"真的要解散 ";
    hint = [hint stringByAppendingString:self.conversion.name];
    hint = [hint stringByAppendingString:@" ?"];
    self.dissmissDialog = [[STAlertView alloc] initWithTitle:@""
                                                     message:hint
                                               textFieldHint:@"登录密码"
                                              textFieldValue:nil
                                           cancelButtonTitle:@"取消"
                                            otherButtonTitle:@"解散"
                                           cancelButtonBlock:^{
                                               
                                           } otherButtonBlock:^(NSString * result) {
                                               //[weakSelf alert:result];
                                               AVUser *user = [weakSelf getCurrentUser];
                                               NSError *loginError;
                                               [AVUser logInWithUsername:user.username password:result error:&loginError];
                                               NSLog(@"loginError:%@",loginError);
                                               if (!loginError) {
                                                   [self setConversionDelFlagWithConv:weakSelf.conversion];
                                                   
                                                   NSArray *members = weakSelf.conversion.members;
                                                   AVUser *avUser = [AVUser currentUser];
                                                   AVFile *avFile = [avUser objectForKey:@"avatar"];
                                                   NSString *url = @"";
                                                   if (avFile.url) {
                                                       url = avFile.url;
                                                   }
                                                   
                                                   
                                                   [weakSelf.conversion removeMembersWithClientIds:members callback:^(BOOL succeeded, NSError *error) {//删除所有成员，包括自己
                                                       if (error) {
                                                           
                                                       } else {
                                                           
                                                           for (NSString *memberId in members) {
                                                               if (![memberId isEqualToString:user.objectId]) {
                                                                   [self kickMemberAndNotifyThemWithHint:@" 解散了群 " MsgType:MasterDismiss AvatarUrl:url ObjectId:avUser.objectId MemberId:memberId];
                                                               }
                                                           }
                                                           [_im deleteConvWithConvId:self.conversion.conversationId];
                                                           [self back2List];
                                                       }
                                                   }];
                                               }else {
                                                   [weakSelf alert:@"密码错误"];
                                               }
                                           }];
    [self.dissmissDialog show];
}

- (IBAction)exitGroupButtonAction:(id)sender {
    
    NSString *hint = [@"确定要退出 " stringByAppendingString:self.conversion.name];
    hint = [hint stringByAppendingString:@" ?"];
    
    self.dissmissDialog = [[STAlertView alloc] initWithTitle:@""
                                     message:hint
                           cancelButtonTitle:@"取消"
                            otherButtonTitle:@"仍要退出"
                           cancelButtonBlock:^{
                           } otherButtonBlock:^{
                               NSArray *clientIdArr = [[NSArray alloc]initWithObjects:[AVUser currentUser].objectId, nil];
                               [self.conversion removeMembersWithClientIds:clientIdArr callback:^(BOOL succeeded, NSError *error) {
                                   if (error) {
                                       
                                   }else {
                                       NSLog(@"self.conversion.conversationId: %@", self.conversion.conversationId);
                                       AVUser *avUser = [AVUser currentUser];
                                       AVFile *avFile = [avUser objectForKey:@"avatar"];
                                       NSString *url = @"";
                                       if (avFile.url) {
                                           url = avFile.url;
                                       }
                                       
                                       [self kickMemberAndNotifyThemWithHint:@" 退出群 " MsgType:MemberQuit AvatarUrl:url ObjectId:avUser.objectId MemberId:[AVUser currentUser].objectId];
                                       
                                       [_im deleteConvWithConvId:self.conversion.conversationId];
                                       [self back2List];
                                   }
                               }];
                           }];
    [self.dissmissDialog show];
    
}

- (IBAction)bottomButtonAction:(id)sender {
    switch (_curUserRole) {
        case GroupGuest:
            [self sendApply2GroupMaster];
            break;
        case GroupMaster:
            [self addClick];
            break;
        default:
            break;
    }
}

- (IBAction)cleanMemoryAction:(id)sender {
    self.dissmissDialog = [[STAlertView alloc] initWithTitle:@""
                               message:@"将清空此群所有聊天记录!"
                     cancelButtonTitle:@"取消"
                      otherButtonTitle:@"仍要清理"
                     cancelButtonBlock:^{
                    } otherButtonBlock:^{
                        [_im deleteMsgWithConvid:self.conversion.conversationId];
                        [self showInfo:@"清理完毕"];
                    }];
    [self.dissmissDialog show];
}

- (IBAction)noAtSwitchAction:(id)sender {
    UISwitch *noAtSwitchButton = (UISwitch*)sender;
    BOOL isNoAtOn = [noAtSwitchButton isOn];
    BOOL isButtonOn = [self.switchButton isOn];
    
    NSMutableDictionary *mtDict = [[NSMutableDictionary alloc]init];
    //设置免打扰
    if (isButtonOn) {
        [mtDict setValue:@"YES" forKey:@"NoDisturbConvKey"];
    } else {
        [mtDict setValue:@"NO" forKey:@"NoDisturbConvKey"];
    }
    
    if (isNoAtOn) {
        [mtDict setValue:@"YES" forKey:@"NoAtKey"];
        [PListFileHelper write2PlistWithKey:self.conversion.conversationId  AndValue:mtDict];
        [self setConversionMuteAtSetWithConv:self.conversion userObjectId:[AVUser currentUser].objectId isAdd:YES];
    }else {
        [mtDict setValue:@"NO" forKey:@"NoAtKey"];
        [PListFileHelper write2PlistWithKey:self.conversion.conversationId  AndValue:mtDict];
        [self setConversionMuteAtSetWithConv:self.conversion userObjectId:[AVUser currentUser].objectId isAdd:NO];
    }
}

- (IBAction)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    BOOL isNoAtOn = [self.noAtSwitch isOn];
    
    //[self showProgress];
    
    NSMutableDictionary *mtDict = [[NSMutableDictionary alloc]init];
    //先设置免@
    if (isNoAtOn) {
        [mtDict setValue:@"YES" forKey:@"NoAtKey"];
    } else {
        [mtDict setValue:@"NO" forKey:@"NoAtKey"];
    }

    if (isButtonOn) {
        [mtDict setValue:@"YES" forKey:@"NoDisturbConvKey"];
        //        [PListFileHelper write2PlistWithKey:self.conversion.conversationId  AndValue:@"YES"];
        [PListFileHelper write2PlistWithKey:self.conversion.conversationId  AndValue:mtDict];
        [self.conversion muteWithCallback:^(BOOL succeeded, NSError *error) {
            //[self hideProgress];
            if (error) {
                [self alert:@"开启免打扰失败，请重试 :)"];
            }
        }];
    } else {
        [mtDict setValue:@"NO" forKey:@"NoDisturbConvKey"];
        [PListFileHelper write2PlistWithKey:self.conversion.conversationId  AndValue:mtDict];
        [self.conversion unmuteWithCallback:^(BOOL succeeded, NSError *error) {
            //[self hideProgress];
            if (error) {
                [self alert:@"关闭免打扰失败，请重试 :)"];
            }
        }];
    }
}

- (IBAction)editGroupNameAction:(id)sender {
    GroupGeneralEditViewController *groupGeneralEditViewController = [[GroupGeneralEditViewController alloc] init];
    groupGeneralEditViewController.editType = 0;
    groupGeneralEditViewController.conversion = self.conversion;
    [self.navigationController pushViewController:groupGeneralEditViewController animated:YES];
}

- (IBAction)editGroupLocAction:(id)sender {
    RegionSelectorVC *regionSelectorVC = [[RegionSelectorVC alloc]init];
    NSLog(@"%f", _curLocation.coordinate.latitude);
    regionSelectorVC.regionSelectorVCDelegate =self;
    
    CLLocationCoordinate2D baiduCoordinate2D = [JZLocationConverter wgs84ToBd09:_curLocation.coordinate];
    
    regionSelectorVC.curLocation = [self constructWithCoordinate:baiduCoordinate2D];
    [self.navigationController pushViewController:regionSelectorVC animated:YES];
}

- (IBAction)editGroupBriefAction:(id)sender {
    GroupBriefEditViewController *groupBriefEditViewController = [[GroupBriefEditViewController alloc]init];
    groupBriefEditViewController.conversion = self.conversion;
    groupBriefEditViewController.editType = 0;
    [self.navigationController pushViewController:groupBriefEditViewController animated:YES];
}

-(void)addClick{
    WEAKSELF
    [_im fecthConvWithId:self.conversion.conversationId callback:^(AVIMConversation *conv, NSError *error) {
        if (error) {
            [weakSelf alert:@"查询群上限失败 T_T"];
        }else {
            NSArray *memberArr = conv.members;
            if (memberArr.count == groupLimit || memberArr.count > groupLimit) {
                [self alert:@"群人数已达上限了嗳"];
                return;
            }
            
            UsersFollowedEachOtherViewController *usersFollowedEachOtherViewController = [[UsersFollowedEachOtherViewController alloc] init];
            [self.lcDataHelper getUsersFollowedEachOtherWithUser:self.getCurrentUser block:^(NSArray *objects, NSError *error) {
                if (error) {
                    [self alert:@"获取互相关注用户失败,请重试 :)"];
                } else {
                    //去除已经在群中
                    NSArray *existUsers = [self.conversion members];
                    NSMutableArray * mObjects = [objects mutableCopy];
                    for (AVUser *u in objects) {
                        if ([existUsers containsObject:u.username]) {
                            [mObjects removeObject:u];
                        }
                    }
                    
                    usersFollowedEachOtherViewController.users = mObjects;
                    usersFollowedEachOtherViewController.conversion = self.conversion;
                    [self.navigationController pushViewController:usersFollowedEachOtherViewController animated:YES];
                }
            }];
        }
    }];
}

-(void)userClick:(UIGestureRecognizer*)gestureRecognizer{
    NSInteger tag = gestureRecognizer.view.tag;
    
    PersonalInfoViewController *personalInfoViewController = [[PersonalInfoViewController alloc]init];
    personalInfoViewController.user = [_userArray objectAtIndex:tag-GROUP_DETAIL_TAG];
    [self.navigationController pushViewController:personalInfoViewController animated:YES];
}

-(void) back2List {
    //返回列表
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LCEChatListVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)showMemberList:(UIGestureRecognizer*)gestureRecognizer {
    GroupMembersViewController *groupMembersViewController = [[GroupMembersViewController alloc] init];
    groupMembersViewController.users = [_userArray mutableCopy];
    groupMembersViewController.conversion = self.conversion;
    [self.navigationController pushViewController:groupMembersViewController animated:YES];
}

#pragma mark 群操作逻辑
-(void) kickMemberAndNotifyThemWithHint:(NSString *)hint MsgType:(NSUInteger)msgType AvatarUrl:(NSString*)url ObjectId:(NSString *)objId MemberId:(NSString *)memberId{
    WEAKSELF
    //找到申请或者被邀请的对话
    [_im fetchSystemConvWithConvId:self.conversion.conversationId AndMemberId:memberId callback:^(NSArray *objects, NSError *error) {
        if (error) {
            [weakSelf alert:@""];
        }else {
            if (objects.count >0) {
                AVIMConversation *sendConv = [objects objectAtIndex:0];
                //初始化消息
                
                NSString *groupName = weakSelf.conversion.name;
                NSString *creator = [AVUser currentUser].username;
                //NSString *realConvid = sendConv.conversationId;
                
                NSString *txt = [creator stringByAppendingString:hint];
                txt = [txt stringByAppendingString:groupName];
                
                //                                                   NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,@"groupAvatarPicUrl",realConvid,@"realConvid", groupName, @"groupName", nil];
                
                NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,MSG_ATTR_URL, objId, MSG_ATTR_ID, [NSString stringWithFormat:@"%lu", (unsigned long)msgType], MSG_ATTR_TYPE,  nil];
                
                AVIMTextMessage *txtMsg = [AVIMTextMessage messageWithText:txt attributes:dict4msg];
                
                [sendConv sendMessage:txtMsg callback:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        [hint stringByAppendingString:@"失败，请重试 T_T"];
                        [weakSelf alert:hint];
                    } else {
                        //删除此对话
                        //[_im deleteConvWithConvId:self.conversion.conversationId];
                    }
                }];
            }
        }
    }];
}

-(void)setConversionDelFlagWithConv:(AVIMConversation *)conv {
    WEAKSELF
    NSDictionary *dict = conv.attributes;
    
    AVIMConversationUpdateBuilder *builder = [conv newUpdateBuilder];
    builder.attributes = @{@"type":[NSNumber numberWithInt:1],
                           @"sequenceNum":[dict objectForKey:@"sequenceNum"],
                           @"groupBrief":[dict objectForKey:@"groupBrief"],
                           @"groupAvatarPicUrl":[dict objectForKey:@"groupAvatarPicUrl"],
                           @"location":[dict objectForKey:@"location"],
                           @"locationName":[dict objectForKey:@"locationName"],
                           @"isDel":@(1)
                           };
    
    NSDictionary *changedDict = [builder dictionary];
    [conv update:changedDict callback:^(BOOL succeeded, NSError *error) {
        if (error) {
            [weakSelf alert:@"设置删除标志失败 T_T"];
        }
    }];
    
    [self.lcDataHelper deleteGeoGroupWithConversationId:conv.conversationId];
}

//设置免@
-(void)setConversionMuteAtSetWithConv:(AVIMConversation *)conv userObjectId:(NSString*)userObjectId isAdd:(BOOL) isAdd{
    WEAKSELF
    NSDictionary *dict = conv.attributes;
    NSMutableArray *noAtArr = [dict objectForKey:@"noAt"];
    if (!noAtArr) noAtArr = [[NSMutableArray alloc] init];
    if (isAdd) {
        if ([noAtArr containsObject:userObjectId]) {
            [noAtArr removeObject:userObjectId];
        }
        [noAtArr addObject:userObjectId];
    }else {
        if ([noAtArr containsObject:userObjectId]) {
            [noAtArr removeObject:userObjectId];
        }
    }
    
    AVIMConversationUpdateBuilder *builder = [conv newUpdateBuilder];
    builder.attributes = @{@"type":[NSNumber numberWithInt:1],
                           @"sequenceNum":[dict objectForKey:@"sequenceNum"],
                           @"groupBrief":[dict objectForKey:@"groupBrief"],
                           @"groupAvatarPicUrl":[dict objectForKey:@"groupAvatarPicUrl"],
                           @"location":[dict objectForKey:@"location"],
                           @"locationName":[dict objectForKey:@"locationName"],
                           @"isDel":@(0),
                           @"noAt":noAtArr
                           };
    
    NSDictionary *changedDict = [builder dictionary];
    [weakSelf showProgress];
    [conv update:changedDict callback:^(BOOL succeeded, NSError *error) {
        [weakSelf hideProgress];
        if (error) {
            [weakSelf alert:@"设置免@失败 T_T"];
        }
    }];
}

//申请入群
-(void)sendApply2GroupMaster {
    WEAKSELF
    [_im fecthConvWithId:self.conversion.conversationId callback:^(AVIMConversation *conv, NSError *error) {
        if (error) {
            [weakSelf alert:@"查询群上限失败 T_T"];
        }else {
            NSArray *memberArr = conv.members;
            if (memberArr.count == groupLimit || memberArr.count > groupLimit) {
                [self alert:@"群人数已达上限"];
                return;
            }
            [self checkOutIfAreadyAppliedWithUserId:self.conversion.creator];
        }
    }];
}

-(void)checkOutIfAreadyAppliedWithUserId:(NSString *)conversationCreator {
    //查找ConvID 是当前对话，创建者是本人的对话
    [_im fetchConvsWithConvName:self.conversion.conversationId AndCreator:[AVUser currentUser].objectId callback:^(NSArray *objects, NSError *error) {
        if (error) {
            
        }else {
            if (objects.count > 0) {
                AVIMConversation *tempConv = nil;
                for (AVIMConversation *conv in objects) {
                    NSDictionary *dict = conv.attributes;
                    NSNumber *convType = [dict objectForKey:@"type"];
                    
                    NSArray *memberArr = conv.members;
                    NSString *memberStr = [memberArr componentsJoinedByString:@","];
                    NSRange range = [memberStr rangeOfString:conversationCreator];
                    
                    if (range.length != 0 && convType.intValue == 2) {
                        tempConv = conv;
                        break;
                    }
                }
                if (tempConv) {
                    //已存在获取使用
                    [self useExsitConverstionWithConversion:tempConv];
                }else {
                    //创建新对话
                    [self createNewConversation];
                }
            }else {
                //创建新对话
                [self createNewConversation];
            }
        }
    }];
    
}

//我是游客
-(void) useExsitConverstionWithConversion:(AVIMConversation*) conv{
    WEAKSELF
    //NSDictionary *dict = self.conversion.attributes;
    //NSString *url = [dict objectForKey:@"groupAvatarPicUrl"];
    AVUser *avUser = [AVUser currentUser];
    AVFile *avFile = [avUser objectForKey:@"avatar"];
    NSString *url = avFile.url;
    if (url == nil) url = @"";
    
    NSString *groupName = weakSelf.conversion.name;
    //NSString *realConvid = conv.conversationId;
    NSString *creator = [AVUser currentUser].username;
    NSString *txt = [creator stringByAppendingString:@" 申请加入群 "];
    txt = [txt stringByAppendingString:groupName];
    //NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,@"groupAvatarPicUrl",realConvid,@"realConvid", groupName, @"groupName", nil];
    NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,MSG_ATTR_URL, avUser.objectId, MSG_ATTR_ID, [NSString stringWithFormat:@"%lu", (unsigned long)VisitorApply], MSG_ATTR_TYPE,  nil];
    AVIMTextMessage *txtMsg = [AVIMTextMessage messageWithText:txt attributes:dict4msg];
    
    [self.bottomButton setEnabled:NO];
    [conv sendMessage:txtMsg callback:^(BOOL succeeded, NSError *error) {
        if (error) {
            [weakSelf alert:@"发送申请加入消息失败，请重试 :)"];
        } else {
            [self.bottomButton setEnabled:YES];
            [weakSelf showInfo:@"已申请，请等待"];
        }
    }];
}

//游客创建
-(void) createNewConversation {
    AVUser *currentUser = [self getCurrentUser];
    WEAKSELF
    NSArray *clientIds = @[currentUser.objectId, self.conversion.creator];
    //群对话ID作name
    [_im.imClient createConversationWithName:self.conversion.conversationId clientIds:clientIds
                                  attributes:@{@"type":[NSNumber numberWithInt:CDConvTypeSystem]}
                                     options:AVIMConversationOptionNone
                                    callback:^(AVIMConversation *conv, NSError *error) {
                                        if (error) {
                                            
                                        } else {
                                            //头像url 群名称 创建者
                                            //NSDictionary *dict = weakSelf.conversion.attributes;
                                            
                                            //自己头像
                                            AVUser *avUser = [AVUser currentUser];
                                            AVFile *avFile = [avUser objectForKey:@"avatar"];
                                            NSString *url = avFile.url;
                                            if (url == nil) url = @"";
                                            
                                            NSString *groupName = weakSelf.conversion.name;
                                            //NSString *realConvid = conv.conversationId;
                                            
                                            NSString *creator = currentUser.username;
                                            NSString *txt = [creator stringByAppendingString:@" 申请加入群 "];
                                            txt = [txt stringByAppendingString:groupName];
                                            
                                            //                                            NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,@"groupAvatarPicUrl",realConvid,@"realConvid", groupName, @"groupName", nil];
                                            NSDictionary *dict4msg = [[NSDictionary alloc]initWithObjectsAndKeys:url,MSG_ATTR_URL, avUser.objectId, MSG_ATTR_ID, [NSString stringWithFormat:@"%lu", (unsigned long)VisitorApply], MSG_ATTR_TYPE,  nil];
                                            
                                            
                                            AVIMTextMessage *txtMsg = [AVIMTextMessage messageWithText:txt attributes:dict4msg];
                                            
                                            [self.bottomButton setEnabled:NO];
                                            [conv sendMessage:txtMsg callback:^(BOOL succeeded, NSError *error) {
                                                if (error) {
                                                    
                                                }else {
                                                    [self.bottomButton setEnabled:YES];
                                                    [weakSelf showInfo:@"已申请加入，请等待"];
                                                }
                                            }];
                                        }
                                    }];
    [weakSelf.navigationController popViewControllerAnimated:YES];
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
    [self saveImage:image withName:@"group_avatar_detail.jpg"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:_groupAvatarPath];
    _isFullScreen = NO;
    
    [self saveAndUpdateAvatarWithImage:savedImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
    NSLog(@"%f", _curLocation.coordinate.latitude);
    [manager stopUpdatingLocation];
}

#pragma mark - RegionSelectorVC Delegate
-(void)setPLaceTextFieldWithName:(NSString *)placeName latitude:(float)latitude longitude:(float)longitude {
    //    self.groupLocation.text = placeName;
    //[self.groupLocation setTitle:placeName forState:UIControlStateNormal];
    self.latitudeFromSeletor = latitude;
    self.longitudeFromSeletor = longitude;
    self.nameFromSeletor = placeName;
    
    
    //更新Group表，用于定位
    WEAKSELF
    [weakSelf runInGlobalQueue:^{
        NSError *error2;
        //        [weakSelf.lcDataHelper addAGroupWithConversation:self.conversion latitude:self.latitudeFromSeletor longitude:self.longitudeFromSeletor error:&error2];
        [weakSelf.lcDataHelper saveAGroupWithConversation:self.conversion latitude:self.latitudeFromSeletor longitude:self.longitudeFromSeletor error:&error2];
        [weakSelf runInMainQueue:^{
            if (error2 == nil) {
                
            }else {
                [weakSelf alert:@"定位失败，请开启 :)"];
            }
        }];
    }];
    
    //更新群信息
    [self.conversion.attributes setValue:placeName forKey:@"locationName"];
    
    NSString *location = [[NSString stringWithFormat:@"%f", self.latitudeFromSeletor] stringByAppendingString:@","];
    location = [location stringByAppendingString:[NSString stringWithFormat:@"%f", self.longitudeFromSeletor]];
    [self.conversion.attributes setValue:location forKey:@"location"];
    
    AVIMConversationUpdateBuilder *builder = [self.conversion newUpdateBuilder];
    builder.attributes = [[NSDictionary alloc]initWithDictionary:self.conversion.attributes];
    NSDictionary *changedDict2 = [builder dictionary];
    //[weakSelf showProgress];
    [self.conversion update:changedDict2 callback:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            [weakSelf alert:@"更新群位置失败 T_T"];
        } else {
            //[weakSelf.navigationController popViewControllerAnimated:YES];
        }
        //[weakSelf hideProgress];
    }];
    
    
}
@end
