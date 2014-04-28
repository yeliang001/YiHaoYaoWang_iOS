//
//  BackToTopView.m
//  TheStoreApp
//
//  Created by xuexiang on 12-7-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "BackToTopView.h"
#import <QuartzCore/QuartzCore.h>

#define HeddenViewYpos [UIScreen mainScreen].applicationFrame.size.height-49
#define shownViewYpos HeddenViewYpos-40

@interface BackToTopView ()
//@property(nonatomic)float HeddenViewYpos;
@end

@implementation BackToTopView

@synthesize scrollScreenHeight;
@synthesize m_timer;

- (id)init {
    self = [super init];
    if (self) {
		[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.65]];
		UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(103, 5, 100, 30)];
		wordLabel.text = @"回到顶部";
		wordLabel.textAlignment = NSTextAlignmentCenter;
		wordLabel.textColor = [UIColor whiteColor];
        wordLabel.font = [UIFont boldSystemFontOfSize:14.0];
		wordLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:wordLabel];
		[wordLabel release];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(185, 12, 13, 16)];
        [imageView setImage:[UIImage imageNamed:@"backToTopArrow.png"]];
        [self addSubview:imageView];
        [imageView release];
        
		UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		[actionBtn addTarget:self action:@selector(backToTop:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:actionBtn];
		[actionBtn release];
        [self setFrame:CGRectMake(0, HeddenViewYpos, 320, 40)];
		startOffSet = 0;
    }
    return self;
}
-(void)backToTop:(id)sender{
	isBackToTop = YES;
	[m_scrollView scrollRectToVisible:CGRectMake(0, 0, m_scrollView.frame.size.width, m_scrollView.frame.size.height) animated:YES];
	isScrolling = NO;
	startOffSet = 0;
}
-(void)backToTopDisappear{
	[UIView setAnimationsEnabled:YES];
	[UIView beginAnimations:@"hidden" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
	[self setFrame:CGRectMake(0, HeddenViewYpos, 320, 40)];
	[UIView  commitAnimations];
	[UIView setAnimationsEnabled:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.m_timer != nil) {
		[self.m_timer invalidate];
		self.m_timer = nil;
	}
	m_scrollView = scrollView;
	currentOffSet = scrollView.contentOffset.y;
	if (scrollView.contentOffset.y <= 0) {							// 滑到顶部，隐藏按钮
		isBackToTop = NO;
		if (self.frame.origin.y == shownViewYpos) { 
			[self backToTopDisappear];
		}
		return;
	}
	if (!isBackToTop) {
		if (isScrolling) {											// 滑动中
			double subValue = currentOffSet - startOffSet;
			if (ABS(preSubValue) > ABS(subValue)) {					// 滑动中改变滑动方向，需重新设置startOffSet
				startOffSet = currentOffSet;
			}else
				if (subValue > 0) {									// subvalue大于0往下滑动，小于0往上滑动
					if (self.frame.origin.y == shownViewYpos) {
						[self backToTopDisappear];
					}
				}else
					if (ABS(subValue) > scrollScreenHeight) {		// 往上滑动超过一屏（大小可设置），在底部显示返回顶部
						if (self.frame.origin.y == HeddenViewYpos) {
							[UIView setAnimationsEnabled:YES];
							[UIView beginAnimations:@"show" context:nil];
							[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
							[UIView setAnimationDuration:0.3];
							[self setFrame:CGRectMake(0, shownViewYpos, 320, 40)];
							[UIView  commitAnimations];
							[UIView setAnimationsEnabled:NO];
						}
					}
			preSubValue = subValue;
		}else {														// 开始滑动
			startOffSet = currentOffSet;
			isScrolling = YES;
		}
	}
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	isScrolling = NO;
	if (self.frame.origin.y == shownViewYpos) {
		self.m_timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(backToTopDisappear) userInfo:nil repeats:NO];
	}
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (!decelerate) {
		isScrolling = NO;
		if (self.frame.origin.y == shownViewYpos) {
			self.m_timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(backToTopDisappear) userInfo:nil repeats:NO];
		}
	}
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
	isBackToTop = YES;
	return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	if (m_timer != nil) {
		[m_timer release];
		m_timer = nil;
	}
    [super dealloc];
}


@end
