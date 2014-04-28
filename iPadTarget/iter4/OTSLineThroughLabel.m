//
//  OTSLineThroughLabel.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-16.
//
//

#import "OTSLineThroughLabel.h"

@interface OTSLineThroughLabel ()
@property (retain) UIView       *line;
@end

@implementation OTSLineThroughLabel
@synthesize line = _line;

- (void)dealloc
{
    [_line release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor grayColor];
    }
    return self;
}



- (void)adjustMyLayout
{    
//    CGSize newSize = [self.text sizeWithFont:self.font constrainedToSize:self.frame.size];
//    CGRect myRc = self.frame;
//    myRc.size.width = newSize.width > 0 ? newSize.width : myRc.size.width;
//    self.frame = myRc;
    [self sizeToFit];
    
    if (self.line == nil)
    {
        self.line = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.line];
    }
    
    self.line.frame = CGRectMake(0, self.frame.size.height * .5f, self.frame.size.width, 1);
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    [self adjustMyLayout];
    
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self adjustMyLayout];
}

@end
