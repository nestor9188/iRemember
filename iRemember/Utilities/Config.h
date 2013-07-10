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

#if TARGET_IPHONE_SIMULATOR
#define kHostURL            @"http://127.0.0.1/iremember/"
#elif TARGET_OS_IPHONE
#define kHostURL            @"http://222.76.147.133/iremember/"
#endif

#define kNoteFontSize           @"NoteFontSize"
#define kNoteFontColor          @"NoteFontColor"
#define kBackground             @"Background"
#define kPasscode               @"Passcode"

#define kSQLQueue               @"SQL_QUEUE"
