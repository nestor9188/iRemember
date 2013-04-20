//
//  NoteViewController.h
//  iRemember
//
//  Created by nest0r on 13-4-9.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderViewController.h"
@class Note;

@interface NoteViewController : UIViewController<UITextViewDelegate, ReminderViewDelegate>

@property (strong, nonatomic) Note *note;

- (IBAction)dismiss:(id)sender;
- (IBAction)showReminderSettings:(id)sender;
- (IBAction)done:(id)sender;
@end
