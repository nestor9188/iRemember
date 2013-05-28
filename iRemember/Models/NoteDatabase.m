//
//  NoteDatabase.m
//  iRemember
//
//  Created by nest0r on 13-4-9.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "NoteDatabase.h"
#import <sqlite3.h>

@interface NoteDatabase ()

@property (nonatomic) sqlite3 *notesDB;
@property (strong, nonatomic) NSString *databasePath;
@property (copy) RecoveryCompletionBlock completionBlock;


- (BOOL)execSQL:(NSString *)sql;

@end

@implementation NoteDatabase

+ (NoteDatabase *)sharedInstance {
    static NoteDatabase *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSMutableArray *)notes {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    _databasePath = [docPath stringByAppendingPathComponent:@"iRemember.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    const char *dbPath = [_databasePath UTF8String];
    NSMutableArray *notes = [[NSMutableArray alloc] init];
    // 检查表单是否存在，不存在就建立
    
    if ([fileManager fileExistsAtPath:_databasePath] == NO) {
        if (sqlite3_open(dbPath, &_notesDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS note(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, modified_date TEXT, state INTEGER DEFAULT (0), fire_date TEXT, fire_distance INTEGER DEFAULT (0))";
          if (sqlite3_exec(_notesDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
            NSLog(@"创建表失败");
          }
        } else {
          NSLog(@"打开／创建数据库失败");
        }
    }
    
    // 查询数据库中note并放入数组

    if (sqlite3_open(dbPath, &_notesDB) == SQLITE_OK) {
        sqlite3_stmt *statement;
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, content, modified_date, state, fire_date, fire_distance FROM note ORDER BY state DESC, modified_date DESC"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_notesDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            NSLog(@"OK");
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSInteger noteID = sqlite3_column_int(statement, 0);
                NSString *content = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *modifiedDate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSInteger state = sqlite3_column_int(statement, 3);
                NSString *fireDate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                NSInteger fireDistance = sqlite3_column_int(statement, 5);
                Note *note = [[Note alloc] initWithNoteID:noteID
                                                  content:content
                                             modifiedDate:modifiedDate
                                                    state:state
                                                 fireDate:fireDate
                                             fireDistance:fireDistance];
                [notes addObject:note];
            }
        }
        sqlite3_close(_notesDB);
    }
    return notes;
}

- (BOOL)insertNote:(Note *)note {
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO note (content, modified_date, state, fire_date, fire_distance) VALUES (\"%@\", \"%@\", \"%d\", \"%@\", \"%d\")", note.content, note.modifiedDate, note.state, note.fireDate, note.fireDistance];
    if ([self execSQL:insertSQL]) {
        return YES;
    }
    return NO;
}

- (BOOL)updateNote:(Note *)note {
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE note SET content = '%@', state = '%d', modified_date = '%@', fire_date = '%@', fire_distance = '%d' WHERE id = '%d'", note.content, note.state, note.modifiedDate, note.fireDate, note.fireDistance, note.noteID];
    if ([self execSQL:updateSQL]) {
        return YES;
    }
    return NO;
}

- (BOOL)deleteNote:(Note *)note {
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM note WHERE id = '%d'", note.noteID];
    if ([self execSQL:deleteSQL]) {
        return YES;
    }
    return NO;
}

- (void)recoveryFromCloudWithCompletionBlock:(RecoveryCompletionBlock)block {
    self.completionBlock = block;

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"cloud_recovery", @"command",
                                   nil];
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   NSLog(@"recovery: %@", json);
                                   BOOL success = YES;
                                   if ([json objectForKey:@"error"] == nil && [[json objectForKey:@"result"] count] > 0) {
                                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                       NSString *docPath = [paths objectAtIndex:0];
                                       _databasePath = [docPath stringByAppendingPathComponent:@"iRemember.sqlite"];
                                       NSFileManager *fileManager = [NSFileManager defaultManager];
                                       [fileManager removeItemAtPath:_databasePath error:nil];
                                       [[NoteDatabase sharedInstance] notes];
                                       
                                       NSArray *tempNotes = [json objectForKey:@"result"];
                                       for (NSDictionary *note in tempNotes) {
                                           int noteID = [[note objectForKey:@"id"] intValue];
                                           NSString *content = [note objectForKey:@"content"];
                                           int state = [[note objectForKey:@"state"] intValue];
                                           NSString *modifiedDate = [note objectForKey:@"modified_date"];
                                           NSString *fireDate = [note objectForKey:@"fire_date"];
                                           int fireDistance = [[note objectForKey:@"fire_distance"] intValue];
                                           Note *aNote = [[Note alloc] initWithNoteID:noteID
                                                                              content:content
                                                                         modifiedDate:modifiedDate
                                                                                state:state
                                                                             fireDate:fireDate
                                                                         fireDistance:fireDistance];
                                           if (![self insertNote:aNote]) {
                                               success = NO;
                                           };
                                       }
                                       [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kSQLQueue];
                                   } else {
                                       success = NO;
                                   }
                                    block(success);
                               }];
}

- (BOOL)execSQL:(NSString *)sql {
    char *err;
    if (sqlite3_exec(_notesDB, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK) {
        sqlite3_close(_notesDB);
        NSLog(@"数据库操作成功，执行语句为: %@", sql);
        
        // 数据库操作成功后，将此条记录插入SQL队列
        NSString *sqlQueue = [[NSUserDefaults standardUserDefaults] objectForKey:kSQLQueue];
        if (sqlQueue.length > 0) {
            sqlQueue = [NSString stringWithFormat:@"%@<->%@", sqlQueue, sql];
        } else {
            sqlQueue = sql;
        }
        [[NSUserDefaults standardUserDefaults] setObject:sqlQueue forKey:kSQLQueue];
        return YES;
    } else {
        NSLog(@"数据库操作失败～～～");
        sqlite3_close(_notesDB);
    }
    return NO;
}

@end
