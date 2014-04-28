//
//  WapViewController.m
//  TheStoreApp
//
//  Created by jun yuan on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WapViewController.h"
#import "OTSNaviAnimation.h"
#import "OnlinePay.h"
#import "GTMBase64.h"
#import "GlobalValue.h"
#import "TheStoreAppAppDelegate.h"
#import "GlobalValue.h"
#import "OTSOnlinePayNotifier.h"
#import "UIScrollView+OTS.h"
#import "DoTracking.h"
#define UNIONPAY1MALL 203
@interface WapViewController ()

@end

@implementation WapViewController
@synthesize wapType;
@synthesize urlString;
@synthesize isFirstLoadWeb;
- (void)dealloc{
    [urlString release];
    if (to1MallLoadView != nil) {
        [to1MallLoadView release];
    }
    if (actIndicatorView!=nil) {
        [actIndicatorView release];
        actIndicatorView=nil;
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//初始化toolbar的items
- (void)initToolBarItems{
    NSMutableArray* ar=[[NSMutableArray alloc] init];
//    UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
//    [b setImage:[UIImage imageNamed:@"wap_home.png"] forState:UIControlStateNormal];
//    b.frame=CGRectMake(0, 0, 49, 49);
//    b.showsTouchWhenHighlighted=YES;
//    [b addTarget:self action:@selector(AppHome) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* baritem=[[UIBarButtonItem alloc] initWithCustomView:b];
//    [ar addObject:baritem];
//    [baritem release];
//    
//    UIBarButtonItem*baritem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    [ar addObject:baritem];
//    [baritem release];
    
    backwardBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backwardBtn setImage:[UIImage imageNamed:@"wap_backward.png"] forState:UIControlStateNormal];
    backwardBtn.frame=CGRectMake(0, 0, 49, 49);
    [backwardBtn addTarget:self action:@selector(webBackward) forControlEvents:UIControlEventTouchUpInside];
    backwardBtn.showsTouchWhenHighlighted=YES;

    UIBarButtonItem*baritem=[[UIBarButtonItem alloc] initWithCustomView:backwardBtn];
    [ar addObject:baritem];
    [baritem release];
    
    baritem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [ar addObject:baritem];
    [baritem release];
    
    forwardBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [forwardBtn setImage:[UIImage imageNamed:@"wap_foward.png"] forState:UIControlStateNormal];
    forwardBtn.frame=CGRectMake(0, 0, 49, 49);
    [forwardBtn addTarget:self action:@selector(webforward) forControlEvents:UIControlEventTouchUpInside];
    forwardBtn.showsTouchWhenHighlighted=YES;

    baritem=[[UIBarButtonItem alloc] initWithCustomView:forwardBtn];
    [ar addObject:baritem];
    [baritem release];
    
    baritem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [ar addObject:baritem];
    [baritem release];
    
    refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"wap_refresh.png"] forState:UIControlStateNormal];
    refreshBtn.frame=CGRectMake(0, 0, 49, 49);
    [refreshBtn addTarget:self action:@selector(webRefresh) forControlEvents:UIControlEventTouchUpInside];
    refreshBtn.showsTouchWhenHighlighted=YES;

    baritem=[[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    [ar addObject:baritem];
    [baritem release];
    
    baritem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [ar addObject:baritem];
    [baritem release];
    
    
    UIButton *b1=[UIButton buttonWithType:UIButtonTypeCustom];
    [b1 setImage:[UIImage imageNamed:@"wap_back.png"] forState:UIControlStateNormal];
    b1.frame=CGRectMake(0, 0, 49, 49);
    b1.showsTouchWhenHighlighted=YES;
    
    [b1 addTarget:self action:@selector(gotoSuper) forControlEvents:UIControlEventTouchUpInside];
    baritem=[[UIBarButtonItem alloc] initWithCustomView:b1];
    [ar addObject:baritem];
    [baritem release];
    
    baritem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [ar addObject:baritem];
    [baritem release];

    
    toolBar.items=ar;
    [ar release];
    
    actIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [actIndicatorView setFrame:CGRectMake((320-30)/2, (411-30)/2, 30, 30)];
    [actIndicatorView setHidden:YES];
    [self.view addSubview:actIndicatorView];
}
//判断前进 后退的状态
- (void)webStatus{
    if ([webView canGoBack]) {
        backwardBtn.enabled=YES;
    }else {
        backwardBtn.enabled=NO;
    }
    if ([webView canGoForward]) {
        forwardBtn.enabled=YES;
    }else {
        forwardBtn.enabled=NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    CGRect frame = self.view.frame;
    frame.origin.y = 20;
    self.view.frame = frame;
    
    //NSString* srcUrl=[self.urlString stringByAppendingFormat:@"?tracker_u=%@",[[[GlobalValue getGlobalValueInstance] trader] unionKey]];
    NSString* srcUrl;
    NSRange range = [self.urlString rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        srcUrl = [self.urlString stringByAppendingFormat:@"?tracker_u=%@",[[[GlobalValue getGlobalValueInstance] trader] unionKey]];
    }else {
        srcUrl = [self.urlString stringByAppendingFormat:@"&tracker_u=%@",[[[GlobalValue getGlobalValueInstance] trader] unionKey]];
    }
    srcUrl = [srcUrl stringByAppendingFormat:@"&DeviceCode=%@&InterfaceVersion=%@&ClientVersion=%@&ClientAppVersion=%@"
              ,[[[GlobalValue getGlobalValueInstance] trader] deviceCode]
              ,[[[GlobalValue getGlobalValueInstance] trader] interfaceVersion]
              ,[[[GlobalValue getGlobalValueInstance] trader] clientVersion]
              ,[[[GlobalValue getGlobalValueInstance] trader] clientAppVersion]];
    
    webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)];
    webView.scalesPageToFit=YES;
    [webView setDataDetectorTypes:UIDataDetectorTypeNone];
    webView.delegate=self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:srcUrl]]];
    [self.view addSubview:webView];
    [webView release];
    // URL 显示
    head=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 29)];
    head.image=[UIImage imageNamed:@"wap_head.png"];
    [self.view addSubview:head];
    [head release];
    UILabel*lab=[[UILabel alloc] initWithFrame:CGRectMake(15, 4, 290, 20)];
    lab.backgroundColor=[UIColor clearColor];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.numberOfLines=1;
    lab.lineBreakMode=UILineBreakModeTailTruncation;
    lab.text=srcUrl;
    lab.font=[UIFont systemFontOfSize:12];
    lab.textColor=[UIColor grayColor];
    [head addSubview:lab];
    [lab release];
    
    
    
    DebugLog(@"%d", __IPHONE_OS_VERSION_MAX_ALLOWED);
    DebugLog(@"%@", [[UIDevice currentDevice] systemVersion]);
    
    if ([webView respondsToSelector:@selector(scrollView)])
    {
        [webView.scrollView ScrollMeToTopOnly];
    }
    else
    {
        UIScrollView* webScrollView = [webView.subviews objectAtIndex:0];
        [webScrollView ScrollMeToTopOnly];
    }
    
    toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    toolBar.barStyle=UIBarStyleBlack;
    UIPanGestureRecognizer* swipe=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
//    swipe.delegate=self;
    [toolBar addGestureRecognizer:swipe];
    [swipe release];
    
    [self.view addSubview:toolBar];
    [toolBar release];
    [self initToolBarItems];
    freshIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    freshIndicator.frame=CGRectMake(170, 10, 30, 30);
    [toolBar addSubview:freshIndicator];
    [freshIndicator release];
    freshIndicator.hidden=YES;
    isRefresh=NO;
    [self webStatus];
    
    // 显示初入商城的初始跳转画面
    if (isFirstLoadWeb) {
        isFirstLoadWeb = NO;
        to1MallLoadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ApplicationWidth, ApplicationHeight)];
        [to1MallLoadView setBackgroundColor:[UIColor whiteColor]];
        
        UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];//加载等待的转圈控件
        [actView setCenter:CGPointMake(90, 240)];
        [actView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		[to1MallLoadView addSubview:actView];
        [actView startAnimating];
        [actView release];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(83, 128, 151, 101)];
        [imageView setImage:[UIImage imageNamed:@"to1MallLoading.png"]];
        [to1MallLoadView addSubview:imageView];
        [imageView release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(108, 231, 200, 20)];
        [label setText:@"正在跳转到1号商城..."];
        [label setFont:[UIFont systemFontOfSize:14]];
        [to1MallLoadView addSubview:label];
        [label release];
        
        [self.view addSubview:to1MallLoadView];
        [self performSelector:@selector(removeTo1MallView) withObject:nil afterDelay:0.8];
    }
    
//    UIImageView* wapLine=[[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 1, 49)];
//    wapLine.image=[UIImage imageNamed:@"wap_line.png"];
//    [toolBar addSubview:wapLine];
//    [wapLine release];
    [self performSelector:@selector(hiddenHead) withObject:nil afterDelay:3];
}
-(void)swiped:(UISwipeGestureRecognizer*)gesture{
    
    BOOL end=NO;
    if (gesture.state==UIGestureRecognizerStateBegan) {
         p=[gesture locationInView:toolBar];
        DebugLog(@"%f %f",p.x,p.y);
        
    }
    if(gesture.state==UIGestureRecognizerStateEnded){
         p1=[gesture locationInView:toolBar];
        end=YES;
        DebugLog(@"%f %f",p1.x,p1.y);
    }
    if (end&&p1.y-p.y>10&&ABS(p1.x-p.x)<10) {
        [self gotoSuper];
    }
}
// 隐藏URL
- (void)hiddenHead{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    head.frame = CGRectMake(0, -29, 320, 29);
   // head.alpha=0;
   // webView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
    [UIView commitAnimations];
    //[head removeFromSuperview];
    [self performBlock:^{
        [head removeFromSuperview];
    }afterDelay:0.4];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - actions
-(void)removeSelf
{
    if (wapType != 5) {
        [[OTSOnlinePayNotifier sharedInstance] retrieveOrders];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cartload" object:nil];
    [super removeSelf];
}

//返回首页
- (void)AppHome{
    CATransition *animation=[CATransition animation];
	[animation setDuration:0.3f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setType:kCATransitionReveal];
	[animation setSubtype: kCATransitionFromTop];
	[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];

//	[self.view.superview.layer addAnimation:[OTSNaviAnimation animationMoveInFromTop] forKey:@"Reveal"];
    [SharedDelegate enterHomePageRoot];
    [self removeSelf];
}
//返回入口
- (void)gotoSuper{
    CATransition *animation=[CATransition animation];
	[animation setDuration:0.3f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setType:kCATransitionReveal];
	[animation setSubtype: kCATransitionFromTop];
	[self.view.superview.layer addAnimation:animation forKey:@"Reveal"];

//    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationMoveInFromTop] forKey:@"Reveal"];
	[self removeSelf];
}

#pragma mark webView Action
-(void)webforward{
    [webView goForward];
    [self webStatus];
}

-(void)webBackward{
    [webView goBack];
    [self webStatus];
}

-(void)webRefresh{
    isRefresh=YES;
    [webView reload];
}
-(void)removeTo1MallView{
    if (to1MallLoadView.superview != nil) {
        [to1MallLoadView removeFromSuperview];
        isFirstLoadWeb = NO;
    }
}

-(void)showLoading
{
    [actIndicatorView setHidden:NO];
    [actIndicatorView startAnimating];
}

-(void)hideLoading
{
    [actIndicatorView setHidden:YES];
    [actIndicatorView stopAnimating];
}
#pragma mark webDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    if (isRefresh) {
        refreshBtn.hidden=YES;
        freshIndicator.hidden=NO;
        [freshIndicator startAnimating];

    }
    [self showLoading];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (isRefresh) {
        refreshBtn.hidden=NO;
        freshIndicator.hidden=YES;
        isRefresh=NO;
        [freshIndicator stopAnimating];
    }
    [self webStatus];
    [self hideLoading];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DebugLog(@"%@", request);
    
    NSString *requestString=[[request URL] absoluteString];
    if ([requestString rangeOfString:@"http://m.yihaodian.com/mw/index"].location!=NSNotFound) {
        [self gotoSuper];
        return NO;
    }
    DebugLog(@"---------\nwap loading url:\n%@\n", requestString);
	NSArray *components=[requestString componentsSeparatedByString:@"/"];
    //银联支付
    if ([components count]>3 && [(NSString *)[components objectAtIndex:[components count]-3] isEqualToString:@"bankunite"]) {
        NSString *base64TokenStr=[components objectAtIndex:[components count]-2];
        NSData *tokenData=[GTMBase64 decodeString:base64TokenStr];
        NSString *newToken=[[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding] autorelease];
        if (newToken!=nil && ![newToken isEqualToString:@""] && ![newToken isEqualToString:[GlobalValue getGlobalValueInstance].token]) {
            [[OTSUserSwitcher sharedInstance] switchToMoreUserWithToken:newToken];
        }
        NSString *orderIdStr=[components objectAtIndex:[components count]-1];
        int orderId=[orderIdStr intValue];
        [SharedDelegate enterOnlinePayWithOrderId:orderId];
        [self removeSelf];
        return NO;
    }
    
    //稍后支付
    if ([components count]>2 && [(NSString *)[components objectAtIndex:[components count]-2] isEqualToString:@"layerpay"]) {
        NSString *base64TokenStr=[components objectAtIndex:[components count]-1];
        NSData *tokenData=[GTMBase64 decodeString:base64TokenStr];
        NSString *newToken=[[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding] autorelease];
        if (newToken!=nil && ![newToken isEqualToString:@""] && ![newToken isEqualToString:[GlobalValue getGlobalValueInstance].token]) {
            [[OTSUserSwitcher sharedInstance] switchToMoreUserWithToken:newToken];
        }
        [SharedDelegate enterHomePageRoot];
        [self removeSelf];
        return NO;
    }
    
    //网上支付成功
    if ([components count]>2 && [(NSString *)[components objectAtIndex:[components count]-2] isEqualToString:@"mallpayok"]) {
        NSString *base64TokenStr=[components objectAtIndex:[components count]-1];
        NSData *tokenData=[GTMBase64 decodeString:base64TokenStr];
        NSString *newToken=[[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding] autorelease];
        if (newToken!=nil && ![newToken isEqualToString:@""] && ![newToken isEqualToString:[GlobalValue getGlobalValueInstance].token]) {
            [[OTSUserSwitcher sharedInstance] switchToMoreUserWithToken:newToken];
        }
        [SharedDelegate enterMyStoreWithUpdate:YES];
        [self removeSelf];
        return NO;
    }
    
    //1号商城联合登录
    if ([components count]>2 && [(NSString *)[components objectAtIndex:[components count]-2] isEqualToString:@"1malltoclient"]) {
        NSString *base64TokenStr=[components objectAtIndex:[components count]-1];
        NSData *tokenData=[GTMBase64 decodeString:base64TokenStr];
        NSString *newToken=[[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding] autorelease];
        if (newToken!=nil && ![newToken isEqualToString:@""] && ![newToken isEqualToString:[GlobalValue getGlobalValueInstance].token]) {
            [[OTSUserSwitcher sharedInstance] switchToMoreUserWithToken:newToken];
            [[OTSUserSwitcher sharedInstance] changeProvinceForToken:newToken];//将token切换到当前省份
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OneMallUnionLoginOK" object:nil];
        [self removeSelf];
        return NO;
    }
    
    //过滤掉website定位省份
    NSRange range=[requestString rangeOfString:@"?cid=&uid=&website_id="];
    if (range.location!=NSNotFound) {
        return NO;
    }
    range=[requestString rangeOfString:@"/mw/getproidbygeo"];
    if (range.location!=NSNotFound) {
        return NO;
    }
    range=[requestString rangeOfString:@"/mw/buypro"];
    if (range.location!=NSNotFound) {
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_AddCart extraPramaDic:nil]autorelease];
        [DoTracking doJsTrackingWithParma:prama];
    }
    
    //记录1mall传回的token
    [[OTSUserSwitcher sharedInstance] handleWapReuestString:requestString];
    
    return YES;
}
@end
