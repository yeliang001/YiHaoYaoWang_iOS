//
//  OTSPageView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define STATUS_BAR_HEIGHT   4

#define TAG_SCROLLVIEW_SUBVIEW  1
#define TAG_STATUS_BAR  2

#import "OTSPageView.h"


@interface OTSPageView ()
@property(nonatomic, retain)OTSScrollView *scrollView;
@end

@implementation OTSPageView
@synthesize scrollView = _scrollView;

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate showStatusBar:(BOOL)showStatusBar sleepTime:(NSInteger)sleepTime
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        [self setUserInteractionEnabled:YES];
        m_Delegate=delegate;
        m_SleepTime=sleepTime;
        //scroll view
        _scrollView = [[OTSScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setScrollsToTop:NO];
        [self.scrollView setDelegate:self];
        [self addSubview:self.scrollView];
        //status bar
        if (showStatusBar) {
            m_StatusBar=[[OTSDefaultStatusBar alloc] initWithFrame:CGRectMake(0, frame.size.height-STATUS_BAR_HEIGHT, frame.size.width, STATUS_BAR_HEIGHT)];
            [self addSubview:m_StatusBar];
        } else {
            m_StatusBar=nil;
        }
        
        [self reloadPageView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate statusBar:(OTSStatusBar *)statusBar sleepTime:(NSInteger)sleepTime
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        [self setUserInteractionEnabled:YES];
        m_Delegate=delegate;
        m_SleepTime=sleepTime;
        //scroll view
        _scrollView = [[OTSScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setScrollsToTop:NO];
        [self.scrollView setDelegate:self];
        [self addSubview:self.scrollView];
        //status bar
        if (statusBar!=nil) {
            m_StatusBar=[statusBar retain];
            [self addSubview:m_StatusBar];
        } else {
            m_StatusBar=nil;
        }
        
        [self reloadPageView];
    }
    return self;
}

-(void)reloadPageView
{
    int count=0;
    if ([m_Delegate respondsToSelector:@selector(numberOfPagesInPageView:)]) {
        count=[m_Delegate numberOfPagesInPageView:self];
    }
    //scroll view
    int frameWidth=self.frame.size.width;
    int frameHeight=self.frame.size.height;
    [self.scrollView setContentSize:CGSizeMake(frameWidth*count, frameHeight)];
    [self.scrollView setContentOffset:CGPointZero];
    for (UIView *view in [self.scrollView subviews]) {
        if ([view tag]==TAG_SCROLLVIEW_SUBVIEW) {
            [view removeFromSuperview];
        }
    }
    int i;
    for (i=0; i<count; i++) {
        UIView *view;
        if ([m_Delegate respondsToSelector:@selector(pageView:pageAtIndexPath:)]) {
            view=[m_Delegate pageView:self pageAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        } else {
            view=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)] autorelease];
        }
        [view setTag:TAG_SCROLLVIEW_SUBVIEW];
        CGRect rect=[view frame];
        rect.origin.x=frameWidth*i;
        [view setFrame:rect];
        [self.scrollView addSubview:view];
    }
    //status bar
    if (m_StatusBar!=nil) {
        [m_StatusBar setCount:count currentIndex:0];
    }
    //timer
    if (count>1 && m_SleepTime>0) {
        if (m_Timer!=nil) {
            if ([m_Timer isValid]) {
                [m_Timer invalidate];
            }
            [m_Timer release];
        }
        m_Timer=[[NSTimer scheduledTimerWithTimeInterval:m_SleepTime target:self selector:@selector(autoCyclePageView:) userInfo:nil repeats:YES] retain];
    }
}

-(void)autoCyclePageView:(NSTimer *)timer
{
    if ([m_Delegate numberOfPagesInPageView:self]<=1) {
        return;
    }
    if ([self.scrollView contentOffset].x>=self.scrollView.frame.size.width*([m_Delegate numberOfPagesInPageView:self]-1)) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        int index=[self.scrollView contentOffset].x/self.scrollView.frame.size.width;
        CGPoint offset=[self.scrollView contentOffset];
        offset.x=self.frame.size.width*(index+1);
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    int index=[self.scrollView contentOffset].x/self.scrollView.frame.size.width;
    if ([m_Delegate respondsToSelector:@selector(pageView:didTouchOnPage:)]) {
        [m_Delegate pageView:self didTouchOnPage:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset=[self.scrollView contentOffset];
    int index=offset.x/scrollView.frame.size.width;
    if (m_StatusBar!=nil) {
        [m_StatusBar setCurrentIndex:index];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGPoint offset=[self.scrollView contentOffset];
    int index=offset.x/scrollView.frame.size.width;
    if (m_StatusBar!=nil) {
        [m_StatusBar setCurrentIndex:index];
    }
}

-(void)dealloc
{
    if (m_Timer!=nil) {
        if ([m_Timer isValid]) {
            [m_Timer invalidate];
        }
        [m_Timer release];
        m_Timer=nil;
    }
    OTS_SAFE_RELEASE(_scrollView);
    OTS_SAFE_RELEASE(m_StatusBar);
    [super dealloc];
}

@end

@implementation OTSStatusBar

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_Count=1;
        m_CurrentIndex=0;
    }
    return self;
}

-(void)setCount:(int)count currentIndex:(int)index
{
    m_Count=count;
    m_CurrentIndex=index;
}

-(void)setCurrentIndex:(int)index
{
    m_CurrentIndex=index;
}

@end

@implementation OTSDefaultStatusBar

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        [self setBackgroundColor:[UIColor colorWithRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:0.5]];
        m_CurrentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height)];
        [m_CurrentView setBackgroundColor:[UIColor colorWithRed:180.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        [self addSubview:m_CurrentView];
        [m_CurrentView release];
    }
    return self;
}

-(void)setCount:(int)count currentIndex:(int)index
{
    m_Count=count;
    [self setCurrentIndex:index];
    //只有一个page时隐藏红线
    if (count<=1) {
        [m_CurrentView setHidden:YES];
    } else {
        [m_CurrentView setHidden:NO];
    }
}

-(void)setCurrentIndex:(int)index
{
    m_CurrentIndex=index;
    CGRect rect=[m_CurrentView frame];
    rect.size.width=self.frame.size.width/m_Count;
    rect.origin.x=self.frame.size.width*index/m_Count;
    [m_CurrentView setFrame:rect];
}

@end

@implementation OTSDotStatusBar

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_CurrentImageView=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-10, frame.size.height/2-10, 20, 20)];
        [m_CurrentImageView setImage:[UIImage imageNamed:@"cart_gift_select_point.png"]];
        [self addSubview:m_CurrentImageView];
        [m_CurrentImageView release];
    }
    return self;
}

-(void)setCount:(int)count currentIndex:(int)index
{
    m_Count=count;
    CGFloat totalWidth=m_Count*20+(m_Count-1)*25;
    CGFloat startX=self.frame.size.width/2-totalWidth/2;
    int i;
    for (i=0; i<count; i++) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(startX+45*i, self.frame.size.height/2-10, 20, 20)];
        [imageView setImage:[UIImage imageNamed:@"cart_gift_unsel_point.png"]];
        [self addSubview:imageView];
        [imageView release];
    }
    [self setCurrentIndex:index];
}

-(void)setCurrentIndex:(int)index
{
    m_CurrentIndex=index;
    
    CGFloat totalWidth=m_Count*20+(m_Count-1)*25;
    CGFloat startX=self.frame.size.width/2-totalWidth/2;
    CGFloat currentX=startX+45*index;
    CGRect rect=m_CurrentImageView.frame;
    rect.origin.x=currentX;
    [m_CurrentImageView setFrame:rect];
    [self bringSubviewToFront:m_CurrentImageView];
}

@end

@implementation OTSScrollView
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview touchesEnded:touches withEvent:event];
}

@end