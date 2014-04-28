//
//  OtsPadLoadingView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-6.
//
//

#import "OtsPadLoadingView.h"

@interface OtsPadLoadingView ()
@property(nonatomic, retain)UIActivityIndicatorView *activityView;
@end

@implementation OtsPadLoadingView
@synthesize activityView = _activityView;

-(void)dealloc
{
    [_activityView release];
    [super dealloc];
}

- (id)init
{
    self = [super initWithImage:[UIImage imageNamed:@"activity_bg.png"]];
    self.alpha = 0.5;
    
    if (self)
    {
        self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        _activityView.frame = CGRectMake(25.f, 25.f, 25.f, 25.f);
        [self addSubview:_activityView];
    }
    
    return self;
}

-(void)showInView:(UIView*)aView
{
    if (aView)
    {
        CGRect viewRc = aView.bounds;
//        CGRect originRC = self.frame;
        CGRect newRC = CGRectMake((viewRc.size.width - self.frame.size.width) / 2
                                   , (viewRc.size.height - self.frame.size.height) / 2
                                   , self.frame.size.width
                                   , self.frame.size.height);
        self.frame = newRC;
        [aView addSubview:self];
        [_activityView startAnimating];
    }
}

-(void)showInView:(UIView *)aView withFrame:(CGRect)frame
{
    if (aView!=nil) {
        CGRect newRC = CGRectMake((frame.size.width - self.frame.size.width) / 2
                                  , (frame.size.height - self.frame.size.height) / 2
                                  , self.frame.size.width
                                  , self.frame.size.height);
        [self setFrame:newRC];
        [aView addSubview:self];
        [_activityView startAnimating];
    }
}

-(void)hide
{
    [_activityView stopAnimating];
    [self removeFromSuperview];
}

@end
