//
//  Note.m
//  iRemember
//
//  Created by nest0r on 13-4-9.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "Note.h"

@implementation Note

- (id)initWithNoteID:(NSInteger)noteID content:(NSString *)content modifiedDate:(NSString *)modifiedDate state:(NSInteger)state fireDate:(NSString *)fireDate fireDistance:(NSInteger)fireDistance {
    self = [super init];
    if (self) {
        _noteID = noteID;
        _content = content;
        _modifiedDate = modifiedDate;
        _state = state;
        _fireDate = fireDate;
        _fireDistance = fireDistance;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        _noteID = 0;
        _content = @"";
        _modifiedDate = @"";
        _state = NoteStateDefault;
        _fireDate = @"";
        _fireDistance = 0;
    }
    return self;
}

@end
