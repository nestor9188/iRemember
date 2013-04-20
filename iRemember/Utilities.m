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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
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
        customedDate = dateString;
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

@end
