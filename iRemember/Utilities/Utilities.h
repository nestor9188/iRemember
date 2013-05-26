//
//  Utilities.h
//  iRemember
//
//  Created by nest0r on 13-4-10.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "HTLocationManager.h"
#import <ShareSDK/ShareSDK.h>
#import "PAPasscodeViewController.h"

#define kDefaultDateFormatter           @"yyyy-MM-dd HH:mm"

#define IPHONE_WIDTH    [UIScreen mainScreen].bounds.size.width
#define IPHONE_HEIGHT   [UIScreen mainScreen].bounds.size.height

enum NotificationMode {
    NotificationModeDate = 1,
    NotificationModeLocation = 2
};
typedef NSInteger NotificationMode;

@interface Utilities : NSObject

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)customDateString:(NSString *)dateString;
+ (void)removeNotificationWithNoteID:(NSInteger)noteID withMode:(NSInteger)mode;
+ (BOOL)isEnablePasscode;

@end
