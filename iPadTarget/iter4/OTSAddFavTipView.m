//
//  OTSAddFavTipView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-22.
//
//

#import "OTSAddFavTipView.h"

@implementation OTSAddFavTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_textLabel release];
    [super dealloc];
}

-(void)awakeFromNib
{
    self.layer.opacity = 0;
}

-(void)showAboveView:(UIView *)aView text:(NSString*)aText
{
    self.textLabel.text = aText;
    
    if (aView)
    {
        CGRect thisRc = self.frame;
        thisRc.origin.x = (aView.frame.size.width - thisRc.size.width) * .5;
        thisRc.origin.y = - thisRc.size.height - 10;
        self.frame = thisRc;
        
        [UIView beginAnimations:@"show" context:NULL];
        [aView addSubview:self];
        self.layer.opacity = 1;
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(showFinished)];
        [UIView commitAnimations];
    }
}

-(void)showFinished
{
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(fadeAction) userInfo:nil repeats:NO];
}

-(void)fadeAction
{
    [UIView beginAnimations:@"fade" context:NULL];
    self.layer.opacity = 0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideFinished)];
    [UIView commitAnimations];
}

-(void)hideFinished
{
    [self removeFromSuperview];
}

@end
