//
//  LoadingMoreLabel.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadingMoreLabel.h"

@implementation LoadingMoreLabel

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_FirstScroll=YES;
        m_LoadMoreIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width-180)/2, (frame.size.height-36)/2, 36, 36)];
        [m_LoadMoreIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:m_LoadMoreIndicator];
        [self setText:@"正在载入"];
        [self setFont:[UIFont systemFontOfSize:19.0]];
        [self setTextAlignment:UITextAlignmentCenter];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView selector:(SEL)aSelector target:(id)target
{
    if (m_FirstScroll) {
        m_FirstScroll=NO;
        m_ScrollViewContentHeight=[scrollView contentSize].height;
    }
    if (m_ScrollViewContentHeight>[scrollView frame].size.height && !m_NeedLoadMore) {
        [scrollView setContentSize:CGSizeMake(1024, m_ScrollViewContentHeight-50)];
    } else if (m_ScrollViewContentHeight>[scrollView frame].size.height && m_NeedLoadMore) {
        [scrollView setContentSize:CGSizeMake(1024, m_ScrollViewContentHeight)];
    }
    if ([scrollView contentOffset].y+[scrollView frame].size.height>m_ScrollViewContentHeight-50 && !m_IndicatorAnimating) {
        m_NeedLoadMore=YES;
        m_IndicatorAnimating=YES;
        [m_LoadMoreIndicator startAnimating];
        if ([target respondsToSelector:aSelector]) {
            [target performSelector:aSelector withObject:nil];
        }
        [scrollView setContentSize:CGSizeMake(1024, m_ScrollViewContentHeight)];
    }
}

- (void)reset
{
    m_FirstScroll=YES;
    [m_LoadMoreIndicator stopAnimating];
    m_IndicatorAnimating=NO;
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
