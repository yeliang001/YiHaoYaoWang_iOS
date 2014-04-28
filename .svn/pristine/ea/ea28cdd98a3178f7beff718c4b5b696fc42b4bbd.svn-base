//
//  OTSPageView.h
//  TheStoreApp
//
//  Created by jiming huang on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTSPageViewDelegate;
@class OTSStatusBar;
@class OTSScrollView;

@interface OTSPageView : UIView<UIScrollViewDelegate> {
@private
    NSTimer *m_Timer;
    NSInteger m_SleepTime;
    id<OTSPageViewDelegate> m_Delegate;
    //OTSScrollView *m_ScrollView;
    OTSStatusBar *m_StatusBar;
}

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate showStatusBar:(BOOL)showStatusBar sleepTime:(NSInteger)sleepTime;
-(id)initWithFrame:(CGRect)frame delegate:(id)delegate statusBar:(OTSStatusBar *)statusBar sleepTime:(NSInteger)sleepTime;
-(void)reloadPageView;
@end

@protocol OTSPageViewDelegate <NSObject>
-(void)pageView:(OTSPageView *)pageView didTouchOnPage:(NSIndexPath *)indexPath;
-(void)pageView:(OTSPageView *)pageView pageChangedTo:(NSIndexPath *)indexPath;
-(UIView *)pageView:(OTSPageView *)pageView pageAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)numberOfPagesInPageView:(OTSPageView *)pageView;
@end

@interface OTSStatusBar : UIView {
    int m_Count;
    int m_CurrentIndex;
}
-(void)setCount:(int)count currentIndex:(int)index;
-(void)setCurrentIndex:(int)index;
@end

@interface OTSDefaultStatusBar : OTSStatusBar {
    UIView *m_CurrentView;
}
-(void)setCount:(int)count currentIndex:(int)index;
-(void)setCurrentIndex:(int)index;
@end

@interface OTSDotStatusBar : OTSStatusBar {
    UIImageView *m_CurrentImageView;
}
-(void)setCount:(int)count currentIndex:(int)index;
-(void)setCurrentIndex:(int)index;
@end

@interface OTSScrollView : UIScrollView {
}
@end
