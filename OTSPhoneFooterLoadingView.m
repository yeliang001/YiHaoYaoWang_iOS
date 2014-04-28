//
//  OTSPhoneFooterLoadingView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-8.
//
//

#import "OTSPhoneFooterLoadingView.h"

@implementation OTSPhoneFooterLoadingView
@synthesize actView;
@synthesize labelView;

- (void)dealloc {
    [actView release];
    [labelView release];
    [super dealloc];
}

-(void)awakeFromNib
{
    [self.actView startAnimating];
}

-(void)addToView:(UIView*)aView
{
    if (aView)
    {
        CGRect viewRc = aView.frame;
        CGRect thisRc = self.frame;
        thisRc.origin.y = viewRc.size.height;
        self.frame = thisRc;
        
        [aView addSubview:self];
    }
}

@end
