//
//  OTSTablePullToLoadView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSTablePullToLoadView.h"

@implementation OTSPullTableView
@synthesize pullToLoadView, originalContentHeight, isReloadingOK;

-(void)extraInit
{
    //self.bounces = NO;
    pullToLoadView = [[OTSTablePullToLoadView alloc] initWithTableView:self];
    [self addSubview:pullToLoadView];
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) 
    {
        [self extraInit];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self extraInit];
    }
    
    return self;
}

-(void)reloadData
{
    [super reloadData];
    [pullToLoadView updateMyPos];
    isReloadingOK = NO;
}

-(void)dealloc
{
    [pullToLoadView release];
    
    [super dealloc];
}

@end


#define MY_HEIGHT   50

@implementation OTSTablePullToLoadView

-(void)updateMyPos
{
    float contentHeight = tableView.contentSize.height;
    if (contentHeight > 0)
    {
        CGRect myRc = self.frame;
        myRc.origin.y = contentHeight;
        self.frame = myRc;
    }
}

-(void)show:(BOOL)aShow
{
    if (aShow)
    {
        self.hidden = NO;
        tableView.contentSize = CGSizeMake(tableView.contentSize.width, tableView.originalContentHeight + MY_HEIGHT);
    }
    else
    {
        self.hidden = YES;
        tableView.contentSize = CGSizeMake(tableView.contentSize.width, tableView.originalContentHeight);
    }
}



-(void)showMe
{
    [self show:YES];
}

-(void)hideMe
{
    [self show:NO];
}

-(void)assembleSubView
{
    //
    UIActivityIndicatorView* indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    indicatorView.frame = CGRectMake(110
                                     , (self.frame.size.height - indicatorView.frame.size.height) / 2
                                     , indicatorView.frame.size.width
                                     , indicatorView.frame.size.height);
    [self addSubview:indicatorView];
    [indicatorView startAnimating];
    
    //
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor blackColor];
    label.text = @"加载更多...";
    [label sizeToFit];
    label.frame = CGRectMake(CGRectGetMaxX(indicatorView.frame) + 5
                             , (self.frame.size.height - label.frame.size.height) / 2
                             , label.frame.size.width
                             , label.frame.size.height);
    [self addSubview:label];
}


-(id)initWithTableView:(OTSPullTableView*)aTableView
{
    CGRect tvRC = aTableView.frame;
    CGRect myRC = CGRectMake(0, 0, tvRC.size.width, MY_HEIGHT);
    
    self = [self initWithFrame:myRC];
    if (self) 
    {
        tableView = aTableView;
        //self.backgroundColor = [UIColor clearColor];
        [self assembleSubView];
        self.hidden = YES;
//        isShowing = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

@end
