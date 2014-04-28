//
//  OrderTrackView.m
//  yhd
//
//  Created by  on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OrderTrackView.h"
#import "DataHandler.h"
@implementation OrderTrackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame title:(NSString *)title time:(NSString *)time isFinish:(BOOL)isFinish{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *diImage=[[UIImageView alloc] initWithFrame:CGRectMake(28, 0, 22, 30)];
        
        [self addSubview:diImage];
        [diImage release];
        if(isFinish){
            diImage.image=[UIImage imageNamed:@"track_direen.png"];
        }else {
            diImage.image=[UIImage imageNamed:@"track_diblue.png"];
        }  
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 86.0, 20.0) ];
        titleLabel.textColor = kBlackColor;  
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[titleLabel.font fontWithSize:13.0];
        titleLabel.text=title;
        [self addSubview:titleLabel];
        [titleLabel release];
        
        NSString* strDateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* strDate = time;
        NSDate *createDate = nil;
        if (strDate && [strDate length] >= [strDateFormat length])
        {
            strDate = [strDate substringToIndex:[strDateFormat length]];
            
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:strDateFormat];
            createDate = [dateFormatter dateFromString:strDate];
        }
        NSTimeZone* zone=[NSTimeZone localTimeZone];
        int offset=[zone secondsFromGMTForDate:createDate];
        NSDate* localDate=[createDate dateByAddingTimeInterval:offset];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *destDateString = [dateFormatter stringFromDate:localDate];
        
        

        
        
        if (destDateString) {
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 75.0, 30.0) ];
            timeLabel.textColor = [UIColor grayColor];  
            timeLabel.textAlignment=NSTextAlignmentCenter;
            timeLabel.numberOfLines=2;
            timeLabel.backgroundColor=[UIColor clearColor];
            timeLabel.font=[titleLabel.font fontWithSize:13.0];
//            if ([destDateString length]>19) {
//                NSString *string=[destDateString substringToIndex:19];
                //NSLog(@"%@==%i",time,[time length]);
                timeLabel.text=[destDateString stringByReplacingOccurrencesOfString:@":" withString:@" : "];
//            }
            
            [self addSubview:timeLabel];
            [timeLabel release];

        }
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
