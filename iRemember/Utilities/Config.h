//
//  Config.h
//  iRemember
//
//  Created by nest0r on 13-4-17.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

enum NoteState {
    NoteStateDefault = 0,
    NoteStateRemindByDate,
    NoteStateRemindByLocation,
    NoteStateRemindByDateAndLocation,
    NoteStateRemindFinished
};
typedef NSInteger NoteState;

#define kNoteFontSize           @"NoteFontSize"
#define kNoteFontColor          @"NoteFontColor"
#define kPasscode               @"Passcode"

#define kSQLQueue               @"SQL_QUEUE"
