//
//  WaterFlowViewCell.m
//  WaterFlowStyle
//
//  Created by siqin.ljp on 12-5-16.
//  Copyright (c) 2012年 Taobao. All rights reserved.
//

#import "WaterFlowViewCell.h"

@implementation WaterFlowViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize indexPath = _indexPath;

@synthesize backImageView = _backImageView;

-(id)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        self.reuseIdentifier = identifier;
        self.clipsToBounds = YES;
        
        self.backImageView = [[[UIImageView alloc] init] autorelease];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.backImageView.clipsToBounds = YES;
        self.backImageView.backgroundColor = [UIColor colorWithRed:51 / 255.0f green:114 / 255.0f blue:242 / 255.0f alpha:0.4];
//        [self.backImageView setImage:[UIImage imageNamed:@"note_pink_170.jpg"]];
        [self.backImageView setUserInteractionEnabled:NO];
        
        self.contentLabel = [[[UILabel alloc] init] autorelease];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel setNumberOfLines:5];
        [self.contentLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentLabel setUserInteractionEnabled:NO];
        self.contentLabel.textColor = [UIColor colorWithRed:28 / 255.0f green:40 / 255.0f blue:62 / 255.0f alpha:1.0];

        [self addTarget:self.delegate
                 action:@selector(didSelectedCell:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithIdentifier:(NSString *)identifier background:(NSString *)background {
    self = [super init];
    if (self) {
        self.reuseIdentifier = identifier;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:background]];

        self.contentLabel = [[[UILabel alloc] init] autorelease];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel setNumberOfLines:5];
        [self.contentLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentLabel setUserInteractionEnabled:NO];
        
        [self addTarget:self.delegate
                 action:@selector(didSelectedCell:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)layoutSubviews
{
    if (!self.backImageView.superview) {
        CGRect rect = self.frame;
        rect.origin.x = rect.origin.y = 0.0f;
        self.backImageView.frame = rect;
        [self addSubview:self.backImageView];
        [self sendSubviewToBack:self.backImageView];
    }
    
    if (!self.contentLabel.superview) {
        CGRect rect = self.frame;
        rect.origin.x = rect.origin.y = 10.0f;
        rect.size.width = rect.size.width - 20.0f;
        rect.size.height = rect.size.height - 20.0f;
        self.contentLabel.frame = rect;
        [self insertSubview:self.contentLabel aboveSubview:self.backImageView];
    }
}

@end


/* ************************************************** */
@implementation WFIndexPath

@synthesize column = _column;
@synthesize row = _row;

+ (WFIndexPath *)indexPathForRow:(NSInteger)row inColumn:(NSInteger)column
{
    WFIndexPath *indexPath = [[[WFIndexPath alloc] init] autorelease];
    
    indexPath.column = column;
    indexPath.row = row;
    
    return indexPath;
}

@end
