//
//  ReminderViewController.h
//  iRemember
//
//  Created by nest0r on 13-4-11.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegerInputTableViewCell.h"
#import "DateInputTableViewCell.h"
#import "Note.h"

@class ReminderViewController;

@protocol ReminderViewDelegate

- (void)reminderView:(ReminderViewController *)reminderView noteSettingChanged:(Note *)note;

@end

@interface ReminderViewController : UITableViewController<IntegerInputTableViewCellDelegate, DateInputTableViewCellDelegate>

@property (strong, nonatomic) Note *note;
@property (weak, nonatomic) id<ReminderViewDelegate> delegate;

- (id)initWithNote:(Note *)note;

@end
