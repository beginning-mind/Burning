//
//  AppDelegate.m
//  Burning
//
//  Created by wei_zhu on 15/5/24.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "AppDelegate.h"
#import "BuringTabBarController.h"
#import "SVGloble.h"
#import "LCPublish.h"
#import "LCComment.h"
#import "LoginViewController.h"
#import "LCActivity.h"
#import "LCActivityComment.h"
#import "LCDailyNews.h"
#import "LCDataHelper.h"
#import "CDMacros.h"
#import "CDIM.h"
#import <FMDB/FMDB.h>
#import "CDStorage.h"
#import "CDNotify.h"
#import "LCBodyBuilding.h"
#import "StartPageViewController.h"
#import "GuideViewController.h"
#import "LCSequence.h"
#import "LCReport.h"
#import "LCAddress.h"

@interface AppDelegate ()

typedef enum {
    DailyNews = 0,
    Dig,
    UnDig,
    Comment,
    Attention,
    Unattention,
    JoninAcitivty,
    QuitActivity,
    CommentActivity,
    Avisit,
    SysMsg,
    ReplyComment,
    ReplyActivityComment,
    At2GroupMember
} RemoteNotificationType;

@property FMDatabaseQueue *dbQueue;

@property(nonatomic,strong) LCDataHelper* lcDataHelper;

@property(nonatomic,assign)BOOL isOut;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LCPublish registerSubclass];
    [LCComment registerSubclass];
    [LCActivity registerSubclass];
    [LCActivityComment registerSubclass];
    [LCDailyNews registerSubclass];
    [LCGroup registerSubclass];
    [LCSequence registerSubclass];
    [LCBodyBuilding registerSubclass];
    [LCReport registerSubclass];
    [LCAddress registerSubclass];
    
    [NSThread sleepForTimeInterval:2.0];
    [_window makeKeyAndVisible];

    
    [[UIApplication sharedApplication]setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
#if defined(DEBUG) || defined(_DEBUG)
    //测试库 lxsbox@hotmail.com
    [AVOSCloud setApplicationId:@"em0v41nujd419purfz826vnwvqg053a2isxptpgi0k83ju4q"
        clientKey:@"k5w8vpnqjf5lh8ggvabujh1a2a1r84jxywbwqfw2jjtxmb11"];
    //测试库 312111673@qq.com
//    [AVOSCloud setApplicationId:@"kJr5DBvPrghm6Qda0rJR5gKM"
//                      clientKey:@"fgdL4aUSHo6ioaGtOsnYuRUq"];
    
    //[AVOSCloud setAllLogsEnabled:YES];
#else
    //生产库
    [AVOSCloud setApplicationId:@"jqy6y0n4i6tyeo4c0djyxfin"
                      clientKey:@"617ka5tkjzaat2zg0z3f5k09"];
#endif
    
    //获取推送权限 for ios8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 code
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                | UIUserNotificationTypeBadge
                                                | UIUserNotificationTypeSound
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }

    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"DailyNews"];
    FMDatabase *db = [FMDatabase databaseWithPath:databaseFilePath];
    NSLog(@"文件路径:%@",databaseFilePath);
    if (![db open]) {
        
        NSLog(@"db open failed");
    }
    BOOL createTableSucess = [db executeUpdate:@"create table IF NOT EXISTS DailyNews(objectId VARCHAR(63),title text,abstract text,coverUrl VARCHAR(200),contentUrl VARCHAR(200),time date_time)"];
    if (!createTableSucess) {
        NSLog(@"create table failed");
    }
    [db close];
    [db closeOpenResultSets];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [SVGloble shareInstance].globleWidth = screenRect.size.width; //屏幕宽度
    [SVGloble shareInstance].globleHeight = screenRect.size.height-20;  //屏幕高度（无顶栏）
    [SVGloble shareInstance].globleAllHeight = screenRect.size.height;  //屏幕高度（有顶栏
    
    [self.window makeKeyAndVisible];
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunchedtest"]){
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        NSLog(@"第一次启动");
//        GuideViewController *guiedVC = [[GuideViewController alloc]init];
//        self.window.rootViewController = guiedVC;
//    }
//    else{
    [[AVUser currentUser]refresh];
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil && currentUser.mobilePhoneVerified) {
//        if (currentUser != nil) {
            BuringTabBarController *mainViewController = [[BuringTabBarController alloc]init];
//            [mainViewController setUp];
        self.window.rootViewController =mainViewController;
        application.applicationIconBadgeNumber = 0;
            //开启聊天客户端
        CDIM *im = [CDIM sharedInstance];
        [im openWithClientId:currentUser.objectId callback: ^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"开启聊天客户端异常");
                }
        }];
        } else {
            StartPageViewController *startPageViewController = [[StartPageViewController alloc]init];
            UINavigationController *startPageVCNav = [[UINavigationController alloc] initWithRootViewController:startPageViewController];
            self.window.rootViewController =startPageVCNav;
        }
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    }
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation addUniqueObject:@"SysNoti" forKey:@"channels"];
    [currentInstallation saveInBackground];
    
    //    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token substringWithRange:NSMakeRange(1, 71)];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed to get token, error: %@", error);
}

//在当前app时，收到推送执行该方法
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    if (application.applicationIconBadgeNumber<0) {
        application.applicationIconBadgeNumber=0;
    }
    NSString *type = [userInfo objectForKey:@"type"];
    NSString *objId = [userInfo objectForKey:@"objId"];
    switch (type.intValue) {
        case DailyNews:
        {
            [self HandleDailyNewsNoti:objId];
        }
            break;
        case Dig:
        {
            NSString *userId = [userInfo objectForKey:@"userId"];
            NSString *commentIndex = @"-1";
            [self HandleCommentOrDigNoiti:objId UserId:userId notiType:1 commentIndex:commentIndex];
        }
            break;
        case UnDig:
            NSLog(@"Undig");
            break;
        case Comment:
        {
            NSString *userId = [userInfo objectForKey:@"userId"];
            NSString *commentIndex =[userInfo objectForKey:@"comIdx"];
            [self HandleCommentOrDigNoiti:objId UserId:userId notiType:3 commentIndex:commentIndex];
        }
            break;
        case ReplyComment:{
            NSString *userId = [userInfo objectForKey:@"userId"];
            NSString *commentIndex =[userInfo objectForKey:@"comIdx"];
            [self HandleCommentOrDigNoiti:objId UserId:userId notiType:11 commentIndex:commentIndex];
        }
            break;
        case Attention:
        {
            NSString *userId = [userInfo objectForKey:@"userId"];
            [self HandleAttentionOrUnNotiUserId:userId notiType:4];
            
        }
            break;
        case Unattention:
            NSLog(@"Unattention");
            break;
        case JoninAcitivty:
        {
            NSString *userId = [userInfo objectForKey:@"userId"];
            NSString *comentIndex = @"-1";
            [self HandleActivityNoti:objId UserId:userId notiType:6 commentIndex:comentIndex];
        }
            break;
        case QuitActivity:
        {
            NSString *userId = [userInfo objectForKey:@"userId"];
            NSString *comentIndex = @"-1";
            [self HandleActivityNoti:objId UserId:userId notiType:7 commentIndex:comentIndex];
        }
            break;
        case CommentActivity:
        {
            NSString *userId = [userInfo objectForKey:@"userId"];
            NSString *commentIndex =[userInfo objectForKey:@"comIdx"];
            [self HandleActivityNoti:objId UserId:userId notiType:8 commentIndex:commentIndex];
        }
            break;
        case ReplyActivityComment:
        {
            NSString *userId = [userInfo objectForKey:@"userId"];
            NSString *commentIndex =[userInfo objectForKey:@"comIdx"];
            [self HandleActivityNoti:objId UserId:userId notiType:12 commentIndex:commentIndex];
        }
            break;
        case Avisit:
            NSLog(@"Avisit");
            break;
        case SysMsg:
            application.applicationIconBadgeNumber+=1;
            break;
        //        case At2GroupMember:
        //            application.applicationIconBadgeNumber+=1;
        //            break;
        default:
            break;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark handle notification
-(void)HandleDailyNewsNoti:(NSString*)objectId{
    [self.lcDataHelper getDailyNewsWithObjectID:objectId block:^(NSArray *objects, NSError *error) {
        if (error) {
            return;
        }
        for (LCDailyNews *lcDailyNews in objects) {
            NSString *title = lcDailyNews.title;
            NSString *abstract = lcDailyNews.abstract;
            NSString *coverUrl = lcDailyNews.coverUrl;
            NSString *contentUrl = lcDailyNews.contentUrl;
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/dd hh:mm"];
            
            NSString *dateStr = [formatter stringFromDate:currentDate];
            
            NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                        , NSUserDomainMask
                                                                        , YES);
            NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"DailyNews"];
            
            
            
            FMDatabase *db = [FMDatabase databaseWithPath:databaseFilePath];
            if (![db open]) {
                NSLog(@"db open failed");
                [db close];
                return;
            }
            
            NSString *selectSql =[NSString stringWithFormat:@"select * from DailyNews where objectId='%@'",objectId];
            FMResultSet *rs = [db executeQuery:selectSql];
            int rowCount = 0;
            while ([rs next]) {
                rowCount ++;
                break;
            }
            //不存在该记录,插入数据
            if(rowCount==0)
            {
                NSString *inserSql = [NSString stringWithFormat:@"insert into DailyNews(objectId,title,abstract,coverUrl,contentUrl,time)values('%@','%@','%@','%@','%@','%@')",objectId,title,abstract,coverUrl,contentUrl,dateStr];
                if (![db executeUpdate:inserSql]) {
                    NSLog(@"插入数据不成功:%@",inserSql);
                }
            }
            [db close];
            [db closeOpenResultSets];
            [[CDNotify sharedInstance] postDailyNewsNotify];
        }
    }];
    
}

-(void)HandleCommentOrDigNoiti:(NSString*)objectId UserId:(NSString*)userId notiType:(RemoteNotificationType)notiType commentIndex:(NSString*)commentIndex {
    [self.lcDataHelper getPublishWithObjectId:objectId block:^(NSArray *objects, NSError *error) {
        if (error) {
            return;
        }
        if (objects.count==0) {
            return;
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber+=1;
        LCPublish *curLcpublish = objects[0];
        NSString *imageUrl;
        if (curLcpublish !=nil) {
            if (curLcpublish.publishPhotos.count>0) {
                AVFile *imageFile  = curLcpublish.publishPhotos[0];
                imageUrl = imageFile.url;
            }
            else{
                imageUrl = @"";
            }

            
            int comIndex = commentIndex.intValue;
            
            [self.lcDataHelper getUserWithObjectId:userId block:^(NSArray *objects, NSError *error) {
                if (error) {
                    return ;
                }
                AVUser *commentOrDigUser =objects[0];
                if (commentOrDigUser !=nil) {
                    NSString *userName = commentOrDigUser.username;
                    AVFile *avtarFile = [commentOrDigUser objectForKey:@"avatar"];
                    NSString *avatarUrl = avtarFile.url==nil?@"":avtarFile.url;
                    NSString *messge = @"";
                    if (notiType ==1) {
                        messge = [NSString stringWithFormat:@"%@ 赞了你的动态",userName];
                    }
                    else if(notiType==3) {
                        LCActivityComment *curLcComment = curLcpublish.comments[comIndex];
                        NSString *commentStr = curLcComment.commentContent;
                        messge = [NSString stringWithFormat:@"%@ 评论了你的动态:%@",userName,commentStr];
                    }
                    else if(notiType==11){
                        LCActivityComment *curLcComment = curLcpublish.comments[comIndex];
                        NSString *commentStr = curLcComment.commentContent;

                        NSError *error = NULL;
                        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"回复\\s(\\S+?)\\s" options:NSRegularExpressionCaseInsensitive error:&error];
                        NSTextCheckingResult *result = [regex firstMatchInString:commentStr options:0 range:NSMakeRange(0, [commentStr length])];
                        if (result) {
                            commentStr = [commentStr stringByReplacingCharactersInRange:result.range withString:@""];
                        }
                        

                        messge = [NSString stringWithFormat:@"%@ 回复了你的评论:%@",userName,commentStr];
                    }

                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",avatarUrl,@"avatarUrl",userId,@"userId",imageUrl,@"contentImageUrl",objectId,@"contentObjId", nil];
                    
                    AVIMTypedMessage *avIMMessage = [AVIMTextMessage messageWithText:messge attributes:dic];
                
                    NSString *convId = @"publish";
                    avIMMessage.conversationId =convId;
                    avIMMessage.sendTimestamp = [[NSDate date] timeIntervalSince1970]*1000;
                    avIMMessage.messageId =[self createUnique];
                   
                    CDStorage *storage = [CDStorage sharedInstance];
                    [storage insertRoomWithConvid:convId AndType:3];
                    [storage insertMsg:avIMMessage AndType:3];
                    [storage incrementUnreadWithConvid:convId AndType:3];
                    [[CDNotify sharedInstance] postMsgNotify:avIMMessage];
                }
            }];
        }
    }];
}

-(void)HandleActivityNoti:(NSString*)objectId UserId:(NSString*)userId notiType:(RemoteNotificationType)notiType commentIndex:(NSString*)commentIndex {
    [self.lcDataHelper getAcitivityWithObjectId:objectId block:^(NSArray *objects, NSError *error) {
        if (error) {
            return ;
        }
        if (objects.count ==0) {
            return;
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber+=1;
        LCActivity *curLcacitivity = objects[0];
        if (curLcacitivity !=nil) {
            AVFile *imageFile  = curLcacitivity.backGroundFile;
            NSString *activityUrl = imageFile.url==nil?@"":imageFile.url;
            NSString *activityTitle = curLcacitivity.title;
            int comIndex = commentIndex.intValue;
            
            [self.lcDataHelper getUserWithObjectId:userId block:^(NSArray *objects, NSError *error) {
                if (error) {
                    return ;
                }
                AVUser *opertatorUser =objects[0];
                if (opertatorUser !=nil) {
                    NSString *userName = opertatorUser.username;
                    AVFile *avtarFile = [opertatorUser objectForKey:@"avatar"];
                    NSString *avatarUrl = avtarFile.url==nil?@"":avtarFile.url;
                    NSString *messge = @"";
                    if (notiType ==6) {
                        messge = [NSString stringWithFormat:@"%@ 加入了你的活动 %@",userName,activityTitle];
                    }
                    else if(notiType==7) {
                        messge = [NSString stringWithFormat:@"%@ 退出了你的活动 %@",userName,activityTitle];
                    }
                    else if(notiType ==8){
                        LCActivityComment *curLcAcComment  = curLcacitivity.comments[comIndex];
                        NSString *commentStr = curLcAcComment.commentContent;
                        messge = [NSString stringWithFormat:@"%@ 评论了你的活动 %@:%@",userName,activityTitle,commentStr];
                    }
                    else if(notiType ==12){
                        LCActivityComment *curLcAcComment  = curLcacitivity.comments[comIndex];
                        NSString *commentStr = curLcAcComment.commentContent;
                        
                        NSError *error = NULL;
                        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"回复\\s(\\S+?)\\s" options:NSRegularExpressionCaseInsensitive error:&error];
                        NSTextCheckingResult *result = [regex firstMatchInString:commentStr options:0 range:NSMakeRange(0, [commentStr length])];
                        if (result) {
                            commentStr = [commentStr stringByReplacingCharactersInRange:result.range withString:@""];
                        }
                        
                        messge = [NSString stringWithFormat:@"%@ 回复了你的 %@ 评论:%@",userName,activityTitle,commentStr];
                    }
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",avatarUrl,@"avatarUrl",activityUrl,@"contentImageUrl",objectId,@"contentObjId",userId,@"userId", nil];
                    NSString *convId = @"activity";
                    AVIMTypedMessage *avIMMessage =[AVIMTextMessage messageWithText:messge attributes:dic];
                    avIMMessage.conversationId =convId;
                    avIMMessage.sendTimestamp = [[NSDate date] timeIntervalSince1970]*1000;
                    avIMMessage.messageId =[self createUnique];
                    
                    CDStorage *storage = [CDStorage sharedInstance];
                    [storage insertRoomWithConvid:convId AndType:4];
                    [storage insertMsg:avIMMessage AndType:4];
                    [storage incrementUnreadWithConvid:convId AndType:4];
                    [[CDNotify sharedInstance] postMsgNotify:avIMMessage];
                }
            }];
        }
    }];
}

-(void)HandleAttentionOrUnNotiUserId:(NSString*)userId notiType:(RemoteNotificationType)notiType{
    [self.lcDataHelper getUserWithObjectId:userId block:^(NSArray *objects, NSError *error) {
        if (error) {
            return ;
        }
        if (objects.count==0) {
            return;
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber+=1;
        AVUser *opertatorUser =objects[0];
        if (opertatorUser !=nil) {
            NSString *userName = opertatorUser.username;
            AVFile *avtarFile = [opertatorUser objectForKey:@"avatar"];
            NSString *avatarUrl = avtarFile.url==nil?@"":avtarFile.url;
            NSString *messge = @"";
            if (notiType ==4) {
                messge = [NSString stringWithFormat:@"%@ 关注了你",userName];
            }
            else if(notiType==5) {
                messge = [NSString stringWithFormat:@"%@ 取消关注了你",userName];
            }
            

            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",avatarUrl,@"avatarUrl",userId,@"userId", nil];
            NSString *convId = @"attention";
            AVIMTypedMessage *avIMMessage = [AVIMTextMessage messageWithText:messge attributes:dic];
            avIMMessage.conversationId =convId;
            avIMMessage.sendTimestamp = [[NSDate date] timeIntervalSince1970]*1000;
            avIMMessage.messageId =[self createUnique];
            
            CDStorage *storage = [CDStorage sharedInstance];
            [storage insertRoomWithConvid:convId AndType:5];
            [storage insertMsg:avIMMessage AndType:5];
            [storage incrementUnreadWithConvid:convId AndType:5];
            [[CDNotify sharedInstance] postMsgNotify:avIMMessage];
        }
    }];
}


#pragma mark Propertys
-(LCDataHelper*)lcDataHelper{
    if (_lcDataHelper==nil) {
        _lcDataHelper = [[LCDataHelper alloc]init];
    }
    return _lcDataHelper;
}

-(NSString*)createUnique{

    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}

@end
 