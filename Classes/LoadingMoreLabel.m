//
//  LoadingMoreLabel.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadingMoreLabel.h"

@interface LoadingMoreLabel ()
@property(nonatomic, assign) UIScrollView *scrollView;
@end

@implementation LoadingMoreLabel
@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_FirstScroll=YES;
        m_LoadMoreIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width-120)/2, (frame.size.height-20)/2, 20, 20)];
        [m_LoadMoreIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:m_LoadMoreIndicator];
        [self setText:@"加载更多..."];
        [self setFont:[UIFont systemFontOfSize:15.0]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView selector:(SEL)aSelector target:(id)target
{
    if (m_FirstScroll)
    {
        DebugLog(@"first scroll ~~~~");
        m_FirstScroll = NO;
        m_ScrollViewContentHeight = [scrollView contentSize].height;
    }
    
    //DebugLog(@"~~~~~ m_ScrollViewContentHeight:%f, scrollview height:%f, need load more:%d", m_ScrollViewContentHeight, [scrollView frame].size.height, m_NeedLoadMore);
    
    if (m_ScrollViewContentHeight>[scrollView frame].size.height)
    {
        if (m_NeedLoadMore)
        {
            [scrollView setContentSize:CGSizeMake(320, m_ScrollViewContentHeight)];
        }
        else
        {
            [scrollView setContentSize:CGSizeMake(320, m_ScrollViewContentHeight - 50)];
        }
    }
//    else if (m_ScrollViewContentHeight>[scrollView frame].size.height && m_NeedLoadMore)
//    {
//        
//    }
    
    if (!m_IndicatorAnimating
        && [scrollView contentOffset].y + [scrollView frame].size.height > m_ScrollViewContentHeight - 50)
    {
        m_NeedLoadMore = YES;
        m_IndicatorAnimating = YES;
        [m_LoadMoreIndicator startAnimating];
        
        if ([target respondsToSelector:aSelector]) {
            [target performSelector:aSelector withObject:nil];
        }
        
        [scrollView setContentSize:CGSizeMake(320, m_ScrollViewContentHeight)];
    }
}

- (void)reset
{
    m_FirstScroll = YES;
    [m_LoadMoreIndicator stopAnimating];
    m_IndicatorAnimating = NO;
    
    //[_scrollView setContentSize:CGSizeMake(320, m_ScrollViewContentHeight)];
}

- (void)dealloc
{
    if (m_LoadMoreIndicator!=nil) {
        [m_LoadMoreIndicator release];
        m_LoadMoreIndicator=nil;
    }
    [super dealloc];
}

@end
