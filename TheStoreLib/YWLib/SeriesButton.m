//
//  SeriesButton.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-3.
//
//

#import "SeriesButton.h"

#define kColorSelected @"EE2C2C"
#define kColorDisable @"DFDFDF"
#define kColorNormal @"E5E5E5"
#define kColorTitleDisable @"999999"
#define kColorTitleNormal @"333333"

@implementation SeriesButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithString:kColorNormal]];
        [self setTitleColor:[UIColor colorWithString:kColorTitleNormal] forState:UIControlStateNormal];
    }
    return self;
}

- (void)dealloc
{
    [_seriesName release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self refreshStatus];
}
- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self refreshStatus];
}


- (void)refreshStatus
{
    if (self.selected)
    {
        [self setBackgroundColor:[UIColor colorWithString:kColorSelected]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if(!self.enabled)
    {
        [self setBackgroundColor:[UIColor colorWithString:kColorDisable]];
        [self setTitleColor:[UIColor colorWithString:kColorTitleDisable] forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundColor:[UIColor colorWithString:kColorNormal]];
        [self setTitleColor:[UIColor colorWithString:kColorTitleNormal] forState:UIControlStateNormal];
    }
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
