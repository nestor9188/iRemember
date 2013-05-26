//
//  AppDelegate.m
//  iRemember
//
//  Created by nest0r on 13-4-2.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "AppDelegate.h"

#import "DDMenuController.h"
#import "MainViewController.h"
#import "OptionsViewController.h"
#import "Note.h"
#import "NoteDatabase.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 注册社交分享框架
    [ShareSDK registerApp:@"3e757671f64"];
    [self initializePlat];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MainViewController *mainController = [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navController];
    _menuController = rootController;
    
    OptionsViewController *rightController = [[OptionsViewController alloc] init];
    rightController.mainViewController = mainController;
    rootController.rightViewController = rightController;
    
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kNoteFontSize]) {
        // 如果没有设置字体大小，默认为16
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:16] forKey:kNoteFontSize];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kNoteFontColor]) {
        // 如果没有设置字体颜色，默认为黑色 0xFF000000
        [[NSUserDefaults standardUserDefaults] setObject:@"0xFF000000" forKey:kNoteFontColor];
    }
    
    // 检查是否设置密码
    if ([Utilities isEnablePasscode]) {
        PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
        passcodeViewController.delegate = self;
        passcodeViewController.hideCancelButton = YES;
        [self.menuController presentViewController:passcodeViewController animated:YES completion:nil];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UINavigationController *nav = (UINavigationController *)self.menuController.rootViewController;
    if ([[nav.visibleViewController class] isSubclassOfClass:[MainViewController class]]) {
        MainViewController *mainViewController = (MainViewController *)nav.visibleViewController;
        [mainViewController resetRemindFinishedNote];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 检查是否设置密码
    if ([Utilities isEnablePasscode]) {
        PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
        passcodeViewController.delegate = self;
        passcodeViewController.hideCancelButton = YES;
        [self.menuController presentViewController:passcodeViewController animated:YES completion:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (application.applicationIconBadgeNumber > 0) {
        UINavigationController *nav = (UINavigationController *)self.menuController.rootViewController;
        if ([[nav.visibleViewController class] isSubclassOfClass:[MainViewController class]]) {
            MainViewController *mainViewController = (MainViewController *)nav.visibleViewController;
            [mainViewController checkUnreadNote];
        }
    }
    if (application.applicationIconBadgeNumber > 0) application.applicationIconBadgeNumber--;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"收到本地通知 %@", notification.userInfo);
    NSInteger notificationCount = [application scheduledLocalNotifications].count;
    NSLog(@"application icon badge number: %d", application.applicationIconBadgeNumber);
    NSLog(@"notication count: %d" ,notificationCount);
}

- (void)initializePlat
{
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"3201194191"
                               appSecret:@"0334252914651e8f76bad63337b3b78f"
                             redirectUri:@"http://appgo.cn"];
    
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"];
    
    //添加网易微博应用
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
    
    //添加豆瓣应用
    [ShareSDK connectDoubanWithAppKey:@"07d08fbfc1210e931771af3f43632bb9"
                            appSecret:@"e32896161e72be91"
                          redirectUri:@"http://dev.kumoway.com/braininference/infos.php"];
    
    //添加人人网应用
    [ShareSDK connectRenRenWithAppKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                            appSecret:@"f29df781abdd4f49beca5a2194676ca4"];
    
    //添加开心网应用
    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
                            appSecret:@"da32179d859c016169f66d90b6db2a23"
                          redirectUri:@"http://www.sharesdk.cn/"];
    
    //添加Instapaper应用
    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
    
    //添加有道云笔记应用
    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
                                   redirectUri:@"http://www.sharesdk.cn/"];
    
    //添加Facebook应用
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    
    //添加Twitter应用
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                redirectUri:@"http://www.sharesdk.cn"];
}

#pragma mark - PasscodeViewControllerDelegate

- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
