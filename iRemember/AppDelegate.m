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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MainViewController *mainController = [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navController];
    _menuController = rootController;
    
    OptionsViewController *rightController = [[OptionsViewController alloc] init];
    rootController.rightViewController = rightController;
    
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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

@end
