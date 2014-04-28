//
//  WebViewController.h
//  TheStoreApp
//
//  Created by xuexiang on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "LTInterface.h"
#import "OTSUtility.h"
#import "OtsPadLoadingView.h" 

//使用本类必须使用 -（id)initWithFrame: WapType: URL: 进行初始化

@interface WebViewController : BaseViewController<UIWebViewDelegate,LTInterfaceDelegate>
{
    CGRect currentFrame;    // 页面的frame ,初始化必须传入参数。
    NSInteger wapType;      // 0＝我的1号店，1＝团购 ，2＝物流, 3=1号商城登录 ，4=商品列表进商城website，5＝购物车进mall购物车 初始化必须传入参数。
    NSString* m_UrlString;  // 商品详情页的URL, 初始化必须传入参数。
    NSInteger groupState;   // 团购页面状态，0全屏，1半屏。如果不需要用到页面大小改变。不需使用此属性
    
    UIWebView*  webView;
    UIToolbar*toolBar;
    UIImageView* toolBarBgImage;
    UIButton* forwardBtn;
    UIButton* backwardBtn;
    UIButton* refreshBtn;
    UIButton* toSuperBtn;
    
    BOOL isFirstToMallWeb;                          // 是否显示正在跳转至1MALL的页面
    BOOL isRefresh, isNeededShowUrl;
    UIView* to1MallLoadView;
    UIView* whiteBoardView;                         // 白色蒙板，在切换页面大小时覆盖主页面。避免显示之前页面的残影
    UIActivityIndicatorView* actIndicatorView;      // webview中央的刷新菊花
    UIActivityIndicatorView* freshIndicator;        // toolbar上的刷新菊花
    UIImageView* head;                              // 显示URL的背景图片
    UIImageView* btnSepLine;                        // toolbar上返回按钮后的竖线。因为需要在某些时刻隐藏，故声明为变量
    UILabel* URLstringLabel;
    CAGradientLayer* gradientLayer;                 // 渐变色，在团购详情中显示
    
    NSString* groupOrderCheckHomePageURL;           // 团购检查订单的第一个页面，用以做判断使后退按钮不可用
    
    UIViewController *UnionpayViewCtrl;             // 银联的内嵌容器
    NSString *packets;                              // 服务器取回的银联报文
    bool backreflushdone;
    NSNumber *_currentCheckOrderID;
}
@property(nonatomic,retain)NSString* m_UrlString;
@property(nonatomic,assign)NSInteger wapType;
@property(nonatomic,assign)BOOL isFirstToMallWeb;
@property(nonatomic,assign)NSInteger groupState;
@property(nonatomic,assign)BOOL isNeededShowUrl;
@property(nonatomic,assign)NSNumber *_currentCheckOrderID;

-(id)initWithFrame:(CGRect)frame WapType:(NSInteger)wapTypeInt URL:(NSString*)urlStr; // 初始化方法，使用该类必须使用该方法进行初始化

-(void)loadURL;
-(void)refreshWebView;
-(void)customSizeWithFrame:(CGRect)frame;           // 自定义该VC的FRAME，用于在页面中动态改变页面大小。不做页面大小改变的不需用此方法。绝大部分情况下不需要手动调用。

// 交易插件退出回调方法，需要商户客户端实现 strResult：交易结果，若为空则用户未进行交易。
- (void) returnWithResult:(NSString *)strResult;
// 弹出银联插件
-(void)popTheUnionpayView:(UINavigationController*)aNavigate onlineOrderId:(NSNumber*)onlineOrderId;
@end
