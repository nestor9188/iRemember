//
//  Note.h
//  iRemember
//
//  Created by nest0r on 13-4-9.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (readwrite, nonatomic) NSInteger noteID;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *modifiedDate;
@property (readwrite, nonatomic) NSInteger state;
@property (strong, nonatomic) NSString *fireDate;
@property (readwrite, nonatomic) NSInteger fireDistance;

- (id)initWithNoteID:(NSInteger)noteID content:(NSString *)content modifiedDate:(NSString *)modifiedDate state:(NSInteger)state fireDate:(NSString *)fireDate fireDistance:(NSInteger)fireDistance;

@end
