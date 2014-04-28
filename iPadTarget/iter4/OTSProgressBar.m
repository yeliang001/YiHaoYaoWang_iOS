//
//  OTSProgressBar.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import "OTSProgressBar.h"
#import "UIView+LayerEffect.h"

#define BORDER_THICK    4

@interface OTSProgressBar ()
@property (nonatomic, retain) UIView    *progressView;

-(CGRect)progressRect;
@end

@implementation OTSProgressBar
@synthesize progressView = _progressView;
@synthesize percent = _percent;

-(void)setPercent:(NSUInteger)percent
{
    _percent = [self adjustPercent:percent];
//    CGRect progressRc = self.bounds;
//    progressRc.size.width = progressRc.size.width * _percent / 100;
    self.progressView.frame = self.progressRect;//progressRc;
}

-(CGRect)progressRect
{
    CGRect progressRc = self.bounds;
    progressRc.origin.x += BORDER_THICK;
    progressRc.size.width -= BORDER_THICK * 2;
    progressRc.size.width = progressRc.size.width * _percent / 100;
    return progressRc;
}

-(NSUInteger)percent
{
    return _percent;
}

- (void)dealloc
{
    [_progressView release];
    
    [_bgView release];
    [super dealloc];
}

-(NSUInteger)adjustPercent:(NSUInteger)aPercent
{
    aPercent = MAX(0, aPercent);
    aPercent = MIN(100, aPercent);
    return aPercent;
}

-(void)awakeFromNib
{
    self.progressView = [[UIView alloc] initWithFrame:self.progressRect];
    self.progressView.backgroundColor = [UIView colorFromRGB:0xCC0000];
    
    [self insertSubview:self.progressView aboveSubview:self.bgView];
}

@end
