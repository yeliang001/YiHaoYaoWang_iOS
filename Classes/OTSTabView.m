//
//  OTSTabView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSTabView.h"
#import "OTSUtility.h"

@interface OTSTabView()
@property(assign)UIImage * img_sort_sel;
@property(assign)UIColor * color_sort_sel;
@property(assign)UIImage * img_sort_unsel;
@property(assign)UIColor * color_sort_unsel;
-(void)initTabView;
@end

@implementation OTSTabView
@synthesize img_sort_sel;
@synthesize color_sort_sel;
@synthesize img_sort_unsel;
@synthesize color_sort_unsel;

-(id)initWithFrame:(CGRect)frame titles:(NSArray *)titles imgtabs:(NSArray *)imgtabs delegate:(id<OTSTabViewDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_Delegate=delegate;
        if ([m_Delegate respondsToSelector:@selector(initParam:)]) {
            [m_Delegate performSelector:@selector(initParam) withObject:nil];
        }
        ///init param
        m_Titles=[[NSArray alloc] initWithArray:titles];
        if (!imgtabs) {
            img_sort_sel = [UIImage imageNamed:@"sort_sel.png"];
            color_sort_sel = [UIColor whiteColor];
            img_sort_unsel = [UIImage imageNamed:@"sort_unsel.png"];
            color_sort_unsel = [UIColor blackColor];
            
        }
        else
        {
            img_sort_sel = [UIImage imageNamed:[imgtabs objectAtIndex:0]];
            if ([[imgtabs objectAtIndex:1] isEqual:@"white"]) {
                color_sort_sel = [UIColor whiteColor];
            }
            else if([[imgtabs objectAtIndex:1] isEqual:@"black"])
            {
                color_sort_sel = [UIColor blackColor];
            }
            img_sort_unsel = [UIImage imageNamed:[imgtabs objectAtIndex:2]];
            if ([[imgtabs objectAtIndex:3] isEqual:@"white"]) {
                color_sort_unsel = [UIColor whiteColor];
            }
            else if([[imgtabs objectAtIndex:3] isEqual:@"black"])
            {
                color_sort_unsel = [UIColor blackColor];
            }
        }
        [self initTabView];
    }
    return self;
}

-(void)initTabView
{
    int count=[m_Titles count];
    int i;
    for (i=0; i<count; i++) {
        NSString *title=[OTSUtility safeObjectAtIndex:i inArray:m_Titles];
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*i/count, 0, self.frame.size.width/count, self.frame.size.height)];
        [button setTag:100+i];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        if (i==0) {
            [button setBackgroundImage:img_sort_sel forState:UIControlStateNormal];
            [button setTitleColor:color_sort_sel forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:img_sort_unsel forState:UIControlStateNormal];
            [button setTitleColor:color_sort_unsel forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button release];
    }
}

-(void)tabClicked:(id)sender
{
    UIButton *button=sender;
    if (button.tag==100+m_SelectedIndex) {
        if ([m_Delegate respondsToSelector:@selector(tabClickedAtIndex:)]) {
            [m_Delegate performSelector:@selector(tabClickedAtIndex:) withObject:[NSNumber numberWithInt:m_SelectedIndex]];
        }
        return;
    }
    
    m_SelectedIndex=button.tag-100;
    
    int count=[m_Titles count];
    int i;
    for (i=0; i<count; i++) {
        UIButton *button=(UIButton *)[self viewWithTag:100+i];
        if (i==m_SelectedIndex) {
            [button setBackgroundImage:img_sort_sel forState:UIControlStateNormal];
            [button setTitleColor:color_sort_sel forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:img_sort_unsel forState:UIControlStateNormal];
            [button setTitleColor:color_sort_unsel forState:UIControlStateNormal];
        }
    }
    if ([m_Delegate respondsToSelector:@selector(tabClickedAtIndex:)]) {
        [m_Delegate performSelector:@selector(tabClickedAtIndex:) withObject:[NSNumber numberWithInt:m_SelectedIndex]];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_Titles);
    [super dealloc];
}

@end
