//
//  OTSOrderMfStatusTrackListView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSOrderMfStatusTrackListView.h"
#import "OrderStatusTrackVO.h"
#import "SplitLogInfo.h"

@interface OTSOrderMfStatusTrackListView ()
-(void)updateSubViews;
@end



@implementation OTSOrderMfStatusTrackListView
@synthesize statusTracks, currentDateStr;

-(void)setStatusTracks:(NSArray *)aStatusTracks
{
    if (aStatusTracks != statusTracks)
    {
        [statusTracks release];
        statusTracks = [aStatusTracks retain];
        
        [self updateSubViews];
    }
}

-(NSString*)dateStringFromStatusTrackTime:(NSString*)aTimeStr
{
    NSString* formatStr = @"yyyy-MM-dd";
    int len = [formatStr length];
    if (aTimeStr && [aTimeStr length] >= len) 
    {
        NSString* dateStr = [aTimeStr substringToIndex:len];
        return dateStr;
    }
    
    return nil;
}

-(NSString*)timeStringFromStatusTrackTime:(NSString*)aTimeStr
{
    NSString* formatStr = @"yyyy-MM-dd HH:mm:ss";
    
    int len = [formatStr length];
    if (aTimeStr && [aTimeStr length] >= len) 
    {
        NSRange range;
        range.location = 0;
        range.length = len;
        NSString* createTimeStr = [[aTimeStr copy] autorelease];
        NSString* timeStr = [createTimeStr substringWithRange:range];
        NSString* formatTimeStr = @"HH:mm:ss";
        int timeLen = [formatTimeStr length];
        if (timeStr && [timeStr length] >= timeLen)
        {
            range.location = len - timeLen;
            range.length = timeLen;
            
            timeStr = [timeStr substringWithRange:range];
            return timeStr;
        }
    }
    
    return nil;
}

-(UILabel*)labelWithFrame:(CGRect)aFrame fontColor:(UIColor*)aFontColor
{
    UILabel* label = [[[UILabel alloc] initWithFrame:aFrame] autorelease];
    label.font = [UIFont systemFontOfSize:13.f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = aFontColor;
    label.textAlignment = NSTextAlignmentLeft;
    
    return label;
}

-(UIView*)viewWithTime:(NSString*)aTimeStr 
               content:(NSString*)aContent 
                remark:(NSString*)aRemark 
                  posY:(int)aPosY 
                isLast:(BOOL)aIsLast
{
    CGRect viewRc = self.bounds;
    viewRc.origin.y = aPosY;
    UIView* view = [[[UIView alloc] initWithFrame:viewRc] autorelease];
    
    CGRect timeRc = CGRectMake(10, 5, 100, 40);
    UILabel* timeLbl = [self labelWithFrame:timeRc fontColor:aIsLast ? [UIColor redColor] : [UIColor blackColor]];
    timeLbl.text = aTimeStr;
    timeLbl.numberOfLines = 0;
    [timeLbl sizeToFit];
    [view addSubview:timeLbl];
    
    CGRect contentRc = CGRectMake(80, 5, 210, 30);
    UILabel* contentLbl = [self labelWithFrame:contentRc fontColor:aIsLast ? [UIColor redColor] : [UIColor blackColor]];
    contentLbl.text = aContent;
    contentLbl.numberOfLines = 0;
    [contentLbl sizeToFit];
    
    [view addSubview:contentLbl];
    viewRc.size.height = CGRectGetMaxY(contentLbl.frame);
    view.frame = viewRc;
    
    if (aRemark)
    {
        CGRect remarkRc = CGRectMake(80, CGRectGetMaxY(contentLbl.frame), 210, 60);
        UILabel* remarkLbl = [self labelWithFrame:remarkRc fontColor:aIsLast ? [UIColor redColor] : [UIColor lightGrayColor]];
        
        remarkLbl.text = aRemark;
        remarkLbl.numberOfLines = 0;
        [remarkLbl sizeToFit];
        [view addSubview:remarkLbl];
        
        viewRc.size.height = CGRectGetMaxY(remarkLbl.frame);
        view.frame = viewRc;
    }
    
    return view;
}

-(void)updateSubViews
{
    for (UIView* sub in self.subviews)
    {
        [sub removeFromSuperview];
    }
    
    int offsetY = 0;
    
    UIView* view = nil;
    
    int i = 0;
    int lastIndex = [statusTracks count] - 1;
    for (/*OrderStatusTrackVO* */ SplitLogInfo* status in statusTracks)
    {
        if (status)
        {
//            NSString* dateStr = [self dateStringFromStatusTrackTime:[status clonedCreateTime]];
//            if (![dateStr isEqualToString:currentDateStr])
//            {
//                self.currentDateStr = dateStr;
            
//                offsetY += 5;
//                UILabel* dateLbl = [self labelWithFrame:CGRectMake(10, offsetY, 100, 40) fontColor:[UIColor blackColor]];
//            dateLbl.text =  status.logTime;//dateStr;
//                dateLbl.numberOfLines = 0;
//                [dateLbl sizeToFit];
//                [self addSubview:dateLbl];
//                offsetY += dateLbl.frame.size.height + 2;
//            }
            
//            NSString* timeStr = [self timeStringFromStatusTrackTime:[status clonedCreateTime]];
            view = [self viewWithTime:status.logTime /*timeStr*/
                              content:status.note /*status.oprContent*/
                               remark:status.operatorUser /*status.oprRemark*/
                                 posY:offsetY isLast:(i == lastIndex)];
            
            [self addSubview:view];
            
            offsetY += view.frame.size.height;
        }
        
        i++;
    }
    
    self.frame = CGRectMake(self.frame.origin.x
                            , self.frame.origin.y
                            , self.frame.size.width
                            , offsetY);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

-(void)dealloc
{
    [statusTracks release];
    [currentDateStr release];
    
    [super dealloc];
}

@end
