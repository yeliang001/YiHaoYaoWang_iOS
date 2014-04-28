//
//  OTSPhoneWeRockBubbleView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-31.
//
//

#import "OTSPhoneWeRockBubbleView.h"
#import "OTSUtility.h"

@interface OTSPhoneWeRockBubbleView ()
@property (retain) NSTimer      *timer;
@end

@implementation OTSPhoneWeRockBubbleView
@synthesize timeLabel;
@synthesize interval = _interval;
@synthesize timer = _timer;

- (void)dealloc {
    [timeLabel release];
    
    [_timer invalidate];
    [_timer release];
    
    [super dealloc];
}

-(void)showWithInterval:(int)aInterval
{
    self.interval = aInterval;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doShowWithInterval) userInfo:nil repeats:YES];
}



-(void)doShowWithInterval
{
    static int counter = 0;
    
    if (counter < 5)
    {
        int theInterval = self.interval;//(60 * 60 * 15) + 60 * 30 + 30;
        
        if (theInterval <= 0)
        {
            counter = 0;
            self.interval = 0;
            [self.timer invalidate];
            self.timer = nil;
            
            self.hidden = YES;
            return;
        }
        
//        int hours = theInterval / (60 * 60);
//        theInterval -= hours * (60 * 60);
//        int minutes = theInterval / 60;
//        theInterval -= minutes * 60;
//        int seconds =  theInterval % 60;
        
        NSString *intervalStr = [OTSUtility timeStringFromInterval:theInterval];//[NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
        self.timeLabel.text = intervalStr;
        self.hidden = NO;
        self.timeLabel.hidden = NO;
        
        counter++;
        _interval--;
    }
    else
    {
        counter = 0;
        [self.timer invalidate];
        self.timer = nil;
        
        self.hidden = YES;
    }
}

@end
