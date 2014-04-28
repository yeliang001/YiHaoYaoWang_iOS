//
//  OTSSearchView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSSearchView.h"
#import "SearchBar.h"
@implementation OTSSearchView
@synthesize m_SearchBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [imageView setImage:[UIImage imageNamed:@"searchBar_bg.png"]];
        [self addSubview:imageView];
        [imageView release];
        
        m_SearchBar=[[SearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [m_SearchBar setPlaceholder:@"输入搜索关键字"];
        [m_SearchBar setDelegate:delegate];
        [self addSubview:m_SearchBar];
        if ([delegate respondsToSelector:@selector(setM_HomePageSearchBar:)]) {
            [delegate performSelector:@selector(setM_HomePageSearchBar:) withObject:m_SearchBar];
        }
        
        UIButton *searchCancel=[[UIButton alloc] initWithFrame:CGRectMake(272, 5, 43, 30)];
        [searchCancel setBackgroundImage:[UIImage imageNamed:@"search_cancel_btn.png"] forState:UIControlStateNormal];
        [searchCancel setTitle:@"取消" forState:UIControlStateNormal];
        [[searchCancel titleLabel] setFont:[UIFont boldSystemFontOfSize:13.0]];
        [searchCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[searchCancel titleLabel] setShadowColor:[UIColor darkGrayColor]];
        [[searchCancel titleLabel] setShadowOffset:CGSizeMake(1, -1)];
        [searchCancel addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchDown];
        [searchCancel setHidden:YES];
        [self addSubview:searchCancel];
        [searchCancel release];
        if ([delegate respondsToSelector:@selector(setM_HomePageSearchBarCancelBtn:)]) {
            [delegate performSelector:@selector(setM_HomePageSearchBarCancelBtn:) withObject:searchCancel];
        }
        
        m_Delegate=delegate;
    }
    return self;
}

-(void)cancelBtnClicked:(id)sender
{
    if ([m_Delegate respondsToSelector:@selector(homePageCancelBtnClicked)]) {
        [m_Delegate performSelector:@selector(homePageCancelBtnClicked)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_SearchBar);
    [super dealloc];
}

@end
