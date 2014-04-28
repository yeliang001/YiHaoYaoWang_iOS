//
//  RefreshTablePullUp.h
//  TheStoreApp
//
//  Created by towne on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,	
} PullRefreshState;


@protocol RefreshTablePullUpDelegate;
@interface RefreshTablePullUp : UIView {
	
	id _delegate;
	PullRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
    
}

@property(nonatomic,assign) id <RefreshTablePullUpDelegate> delegate;

- (void)setState:(PullRefreshState)aState;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@end

@protocol RefreshTablePullUpDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(RefreshTablePullUp*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(RefreshTablePullUp*)view;
@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(RefreshTablePullUp*)view;
@end

