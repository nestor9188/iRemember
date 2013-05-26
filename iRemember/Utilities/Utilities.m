//
//  Utilities.m
//  iRemember
//
//  Created by nest0r on 13-4-10.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDefaultDateFormatter];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)customDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    date = [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
    
    NSDate *currentDate = [NSDate date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:currentDate]];
    
    NSTimeInterval interval = [date timeIntervalSinceDate:currentDate];

    NSString *customedDate;
    if (interval < 60 * 60 * 24 && interval >= 0) {
        // 今天
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        customedDate = [NSString stringWithFormat:@"今天 %@", [df stringFromDate:date]];
    } else if (interval >= -60 * 60 * 24 && interval < 0  ) {
        // 昨天
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        customedDate = [NSString stringWithFormat:@"昨天 %@", [df stringFromDate:date]];
    } else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd HH:mm"];
        customedDate = [df stringFromDate:date];
    }
    return customedDate;
}

+ (void)removeNotificationWithNoteID:(NSInteger)noteID withMode:(NSInteger)mode {
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *preNotifications = [application scheduledLocalNotifications];
    for (UILocalNotification *notification in preNotifications) {
        if ([[notification.userInfo objectForKey:@"noteID"] integerValue] == noteID &&
            [[notification.userInfo objectForKey:@"notificationMode"] integerValue] == mode) {
            // 移除旧的通知
            [application cancelLocalNotification:notification];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"yichu"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

+ (BOOL)isEnablePasscode {
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:kPasscode];
    if (pwd.length > 0) {
        // 有设置密码
        return YES;
    } else {
        return NO;
    }
}

@end
