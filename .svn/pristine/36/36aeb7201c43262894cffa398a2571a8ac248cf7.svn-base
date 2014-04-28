//
//  BackToTopView.h
//  TheStoreApp
//
//  Created by xuexiang on 12-7-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BackToTopView : UIView {
	double startOffSet;						// 开始滑动时的偏移量
	double currentOffSet;					// 当前的偏移量
	double scrollScreenHeight;				// scrollview可见的可滑动的屏幕高度，需要初始化时设置
	double preSubValue;						// 上一次滑动的的距离（包括符号）,用以处理滑动中变相滑动的情况
	
	
	UIScrollView *m_scrollView;				// 所处理的scrollview，由方法传递而来
	
	BOOL isScrolling;						// 标帜是否正在滑动中（往上滑动）
	BOOL isBackToTop;						// 是否正在回到顶部
	NSTimer *m_timer;						// 定时器，用以在返回顶部view出现3秒后无操作自动消失
}
@property(nonatomic)double scrollScreenHeight;
@property(nonatomic,retain)NSTimer *m_timer;
- (void)backToTop:(id)sender;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
@end
