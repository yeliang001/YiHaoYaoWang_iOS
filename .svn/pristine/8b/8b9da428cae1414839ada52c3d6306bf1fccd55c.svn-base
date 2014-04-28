//
//  OTSLoadingView.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSLoadingView : UIView
{
    UIActivityIndicatorView* actIndicatorView;
    UITextView* textView;
    CGRect      textViewDefaultRect;
    UIButton* transparentButton;
}

-(id)init;

-(void)showInView:(UIView*)aView;
-(void)showInView:(UIView*)aView maskColor:(UIColor*)aMaskColor;
-(void)showInView:(UIView*)aView offsetY:(int)aOffsetY;

-(void)showInView:(UIView*)aView title:(NSString*)aTitle;
-(void)showTipInView:(UIView*)aView title:(NSString*)aTitle;

-(void)showTipInView:(UIView*)aView title:(NSString*)aTitle titleColor:(UIColor*)aTitleColor;

-(void)showInView:(UIView*)aView 
            title:(NSString*)aTitle 
      autoDismiss:(BOOL)aAutoDismiss 
 indicateActivity:(BOOL)aShowIndicator
          offsetY:(int)aOffsetY;

-(void)showInView:(UIView*)aView 
            title:(NSString*)aTitle 
      autoDismiss:(BOOL)aAutoDismiss 
 indicateActivity:(BOOL)aShowIndicator 
          offsetY:(int)aOffsetY 
       titleColor:(UIColor*)aTitleColor 
        maskColor:(UIColor*)aMaskColor;

-(void)hide;
@end

// 全局loadingView
@interface OTSGlobalLoadingView : OTSLoadingView 
+ (OTSGlobalLoadingView *)sharedInstance;
@end
