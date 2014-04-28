//
//  WapViewController.h
//  TheStoreApp
//
//  Created by jun yuan on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum {
    kwapTypeFromMyStore = 0,
    kwapTypeFromGroup,
    kwapTypeFromMaterial,
    kwapTypeFromSearch,
    kwapTypeFromCategory
}EotsWapType;

#import <UIKit/UIKit.h>
#import "OTSBaseViewController.h"
@interface WapViewController : OTSBaseViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView*  webView;
    NSInteger wapType;      //0＝我的1号店，1＝团购 ，2＝物流，3=搜索，4=分类，5=收藏，6=购物车
    UIToolbar*toolBar;
    UIButton* forwardBtn;
    UIButton* backwardBtn;
    UIButton* refreshBtn;
    NSString* urlString;
    BOOL isFirstLoadWeb,isRefresh;
    UIView* to1MallLoadView;
    UIActivityIndicatorView* actIndicatorView;
    UIActivityIndicatorView* freshIndicator;
    UIImageView* head;
    CGPoint p,p1;
}
@property(nonatomic,retain)NSString* urlString;
@property(nonatomic,assign)NSInteger wapType;
@property(nonatomic,assign)BOOL isFirstLoadWeb;
- (void)gotoSuper;
@end
