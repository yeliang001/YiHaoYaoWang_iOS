//
//  OTSAliPayWebView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSAliPayWebView.h"
#import "OTSUtil.h"
#import "OTSNaviAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+MD5Addition.h"
#import "OTSLoadingView.h"
#import "OTSUtility.h"
#import "ASIHTTPRequest.h"
#import "OTSUnionLoginHelper.h"


#define STR_ALIPAY_GATEWAY              @"http://mapi.alipay.com/gateway.do"
#define STR_ALIPAY_INPUT_CHARSET        @"utf-8"
#define STR_ALIPAY_LOGIN_SERVICE        @"user_auth"
#define STR_ALIPAY_PARTNER              @"2088701462230533"//@"2088101010297618"
#define STR_ALIPAY_RETURN_URL           @"http://m.yihaodian.com/mw/zfbforclient"
#define STR_ALIPAY_RETURN_URL_FAILED    @"http://m.yihaodian.com/mw/login"
#define STR_ALIPAY_SERVICE              @"wap.user.common.login"
#define STR_ALIPAY_SIGN_TYPE            @"MD5"
#define STR_ALIPAY_SIGN_MAGIC_NUM       @"ixe366rw7hjgtpud92a18r7e531yiszv"//@"icpx42teljxnx3lq8inmla9o0rojggik"

//#define HTML_USER_NAME_FIELD            @"<input name=\"logonId\" type=\"text\" value=\""

@interface OTSAliPayWebView ()
@property (nonatomic) BOOL loginWithAliButNotTaobao;
@end

@implementation OTSAliPayWebView
@synthesize aliPayDelegate, loginWithAliButNotTaobao = _loginWithAliButNotTaobao;

#pragma mark -
-(void)getRidOfWebView
{
    if (webView)
    {
        [webView stopLoading];
        [webView setDelegate:nil];
        [webView release];
        webView = nil;
    }
}

-(void)giveBirthToWebView
{
    [self getRidOfWebView];
    
    UIView* titleImageView = [self viewWithTag:OTS_MAGIC_TAG_NUMBER];
    
    CGRect webRect = self.bounds;
    webRect.origin.y = CGRectGetMaxY(titleImageView.frame);
    webRect.size.height = [UIScreen mainScreen].applicationFrame.size.height - webRect.origin.y;
    webView = [[UIWebView alloc] initWithFrame:webRect];
    webView.delegate = self;
    [self addSubview:webView];
}

-(void)navigateBackAction
{
    [[OTSGlobalLoadingView sharedInstance] hide];
    
    [self getRidOfWebView];
    
    if (self.superview)
    {
        [self.superview.layer addAnimation:[OTSNaviAnimation animationFade] forKey:OTS_VIEW_ANIM_KEY];
        [self removeFromSuperview];
    }
}


#pragma mark -
-(NSString*)signForRequestWithID:(NSString*)aRequestId
{
    NSString* signFormat = @"input_charset=%@&login_service=%@&partner=%@&request_id=%@&return_url=%@&return_url_failed=%@&service=%@%@";
    NSString* signStr = [NSString stringWithFormat:signFormat
                         , STR_ALIPAY_INPUT_CHARSET
                         , STR_ALIPAY_LOGIN_SERVICE
                         , STR_ALIPAY_PARTNER
                         , aRequestId
                         , STR_ALIPAY_RETURN_URL
                         , STR_ALIPAY_RETURN_URL_FAILED
                         , STR_ALIPAY_SERVICE
                         , STR_ALIPAY_SIGN_MAGIC_NUM];
    
    return [signStr stringFromMD5];
}

-(NSString*)urlForAliLogin
{
    // 产生request ID
    NSString* reqestIdStr = nil;
    
    NSDate* now = [NSDate date];
    [now timeIntervalSince1970];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    reqestIdStr = [dateFormat stringFromDate:now];
    
    int randomNumber = arc4random() % 10000;
    
    reqestIdStr = [NSString stringWithFormat:@"%@%d", reqestIdStr, randomNumber];
    
    DebugLog(@"%@", reqestIdStr);

    
    //签名
    NSString* signStr = [self signForRequestWithID:reqestIdStr];
    
    NSString* urlFormat = @"%@?input_charset=%@&login_service=%@&partner=%@&request_id=%@&return_url=%@&return_url_failed=%@&service=%@&sign_type=%@&sign=%@";
    
    // URL
    return [NSString stringWithFormat:urlFormat
            , STR_ALIPAY_GATEWAY
            , STR_ALIPAY_INPUT_CHARSET
            , STR_ALIPAY_LOGIN_SERVICE
            , STR_ALIPAY_PARTNER
            , reqestIdStr
            , STR_ALIPAY_RETURN_URL
            , STR_ALIPAY_RETURN_URL_FAILED
            , STR_ALIPAY_SERVICE
            , STR_ALIPAY_SIGN_TYPE
            , signStr];
}



#pragma mark -
-(void)goLogin
{
    if (webView == nil)
    {
        [self giveBirthToWebView];
    }
    
    NSString* urlStr = [self urlForAliLogin];
    DebugLog(@"ALI PAY URL:\n%@", urlStr);

//    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    request.delegate = self;
//
//    [request startAsynchronous];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];

    [[OTSGlobalLoadingView sharedInstance] showInView:self];
}

//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSMutableString* htmlStr = [NSMutableString stringWithString:[request responseString]];
//    DebugLog(@"page html:\n\n%@\n\n", htmlStr);
//    
//    NSMutableString *userNameReplaceStr = [NSMutableString stringWithString:HTML_USER_NAME_FIELD];
//    [userNameReplaceStr appendString:@"101@qq.com"];
//    
//    int result = [htmlStr replaceOccurrencesOfString:HTML_USER_NAME_FIELD withString:userNameReplaceStr options:NSLiteralSearch  range:NSMakeRange(0, [htmlStr length])];
//    
//    DebugLog(@"replace count:%d page html:\n\n%@\n\n", result, htmlStr);
//    
//    [webView loadHTMLString:htmlStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    [self navigateBackAction];
//}


-(void)stopLoading
{
    [[OTSGlobalLoadingView sharedInstance] hide];
    
    [webView stopLoading];
}

#pragma mark -
-(void)assembleSubViews
{
    CGRect screenRect = [UIScreen mainScreen].applicationFrame;
    // 导航条背景
    UIImage* naviBarImage = [UIImage imageNamed:@"title_bg.png"];
    UIImageView* naviBgImageView = [[[UIImageView alloc] initWithImage:naviBarImage] autorelease];
    CGRect naviRect = naviBgImageView.frame;
    naviRect.size.height = NAVIGATION_BAR_HEIGHT;
    naviRect.size.width = screenRect.size.width;
    naviBgImageView.frame = naviRect;
    naviBgImageView.tag = OTS_MAGIC_TAG_NUMBER;
    [self addSubview:naviBgImageView];
    
    // 导航条文字
    UILabel* naviTitle = [[[UILabel alloc] initWithFrame:naviBgImageView.bounds] autorelease];
    naviTitle.text = @"支付宝账号登录";
    naviTitle.textAlignment = NSTextAlignmentCenter;
    naviTitle.textColor = [UIColor whiteColor];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.font = [UIFont boldSystemFontOfSize:20.f];
    [OTSUtility setShadowForView:naviTitle];
    [self addSubview:naviTitle];
    
    // 导航条左侧按钮
    UIButton* leftNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [OTSUtility setShadowForView:leftNaviBtn.titleLabel];
    leftNaviBtn.frame = CGRectMake(NAVIGATION_BTN_MARGIN_X, NAVIGATION_BTN_MARGIN_Y, NAVIGATION_BTN_WIDTH, NAVIGATION_BTN_HEIGHT);
    [leftNaviBtn setBackgroundImage:[UIImage imageNamed:@"title_left_cancel.png"] forState:UIControlStateNormal];
    [leftNaviBtn setBackgroundImage:[UIImage imageNamed:@"title_left_cancel_sel.png"] forState:UIControlStateHighlighted];
    [leftNaviBtn addTarget:self action:@selector(navigateBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftNaviBtn];
    
    //web view
    [self giveBirthToWebView];
}



-(void)dealloc
{
    [self getRidOfWebView];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _loginWithAliButNotTaobao = YES;
        
        [self assembleSubViews];
        self.backgroundColor = [UIColor lightGrayColor];
        webView.delegate = self;
    }
    
    return self;
}

-(void)handleAliPayLoginResult:(NSArray*)aResultInfoArr
{
    DebugLog(@"web view:handleAliPayLoginResult");
    if (aliPayDelegate && [aliPayDelegate respondsToSelector:_cmd])
    {
        [aliPayDelegate performSelector:_cmd withObject:aResultInfoArr];
    }
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* requestUrl = [request.URL absoluteString];
    DebugLog(@"\n:%@", requestUrl);
     
    NSRange range = [requestUrl rangeOfString:@"zfbbacktoclient"];
    if (range.location != NSNotFound)
    {
        range = [requestUrl rangeOfString:@"?"];
        requestUrl = [requestUrl substringFromIndex:range.location + 1];
        NSArray *subComponents = [requestUrl componentsSeparatedByString:@"&"];
        NSMutableArray* returnInfoArrs = [NSMutableArray arrayWithCapacity:4];
        
        for (NSString* str in subComponents)
        {
            range = [str rangeOfString:@"="];
            NSString *value = [str substringFromIndex:range.location + 1];
            [returnInfoArrs addObject:value];
            DebugLog(@"%@", value);
        }

        [self handleAliPayLoginResult:returnInfoArrs];
        
        [self navigateBackAction];
        
        return NO;
    }
    else if ([requestUrl isEqualToString:STR_ALIPAY_RETURN_URL_FAILED])
    {
        [self navigateBackAction];
        return NO;
    }
    else if ([requestUrl rangeOfString:@"common_login_ssl.htm"].location != NSNotFound) // 支付宝账号登录
    {
        // 支付宝登录action
        [[OTSUnionLoginHelper sharedInstance] saveAliUserNameFromWebView:aWebView isAliUserName:_loginWithAliButNotTaobao];
    }
    else if ([requestUrl rangeOfString:@"common_login_taobao_ssl.htm"].location != NSNotFound)  // 淘宝账号登录
    {
        // 支付宝登录action
        [[OTSUnionLoginHelper sharedInstance] saveAliUserNameFromWebView:aWebView isAliUserName:_loginWithAliButNotTaobao];
    }
    
    else if ([requestUrl rangeOfString:@"common_login.htm"].location != NSNotFound)  // 点击"支付宝账号登录"链接
    {
        self.loginWithAliButNotTaobao = YES;
    }
    
    else if ([requestUrl rangeOfString:@"common_login_taobao.htm"].location != NSNotFound)  // 点击"淘宝账号登录"链接
    {
        self.loginWithAliButNotTaobao = NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[OTSGlobalLoadingView sharedInstance] showInView:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [[OTSUnionLoginHelper sharedInstance] handleAliLoginWithWebView:aWebView isAliUserName:_loginWithAliButNotTaobao];
    [[OTSGlobalLoadingView sharedInstance] hide];
    
    //NSString *ss=[webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    //DebugLog(@"%@", ss);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self navigateBackAction];
    //[OTSUtil alert:@"抱歉，支付宝网站故障，暂时无法访问哦！" title:@"访问错误"];
}

@end
