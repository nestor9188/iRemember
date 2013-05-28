//
//  NoteDatabase.h
//  iRemember
//
//  Created by nest0r on 13-4-9.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

typedef void (^RecoveryCompletionBlock)(BOOL success);

@interface NoteDatabase : NSObject

+ (NoteDatabase *)sharedInstance;

- (BOOL)insertNote:(Note *)note;
- (BOOL)updateNote:(Note *)note;
- (BOOL)deleteNote:(Note *)note;
- (void)recoveryFromCloudWithCompletionBlock:(RecoveryCompletionBlock)block;

- (NSMutableArray *)notes;

@end
