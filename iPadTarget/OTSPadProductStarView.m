//
//  OTSPadProductStarView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-19.
//
//

#import "OTSPadProductStarView.h"

#define PADDING_X   10

@interface OTSPadProductStarView ()
@property (retain) UIImage  *starImage;
@end

@implementation OTSPadProductStarView
@synthesize count = _count;

-(void)setCount:(NSUInteger)aCount
{
    _count = aCount;
    [self setNeedsDisplay];
}

-(NSUInteger)count
{
    return _count;
}

-(void)extraInit
{
    _starImage = [[UIImage imageNamed:@"pdStar"] retain];
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _starImage.size.width * 5 + PADDING_X * 4, _starImage.size.height);
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self extraInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self extraInit];
    }
    return self;
}

- (void)dealloc
{
    [_starImage release];
    [super dealloc];
}

-(void)drawRect:(CGRect)rect
{
    CGSize starSize = _starImage.size;
    int offsetX = 0;
    for (int i = 0; i < self.count; i++)
    {
        [_starImage drawAtPoint:CGPointMake(offsetX, 0)];
        offsetX += starSize.width + PADDING_X;
    }
}

@end
