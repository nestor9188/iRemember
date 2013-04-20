//
//  NotePreview.m
//  iRemember
//
//  Created by nest0r on 13-4-18.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "NotePreview.h"

@implementation NotePreview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor purpleColor]];
        [label setNumberOfLines:5];
        self.contentLabel = label;
        
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
