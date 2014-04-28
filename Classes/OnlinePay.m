//
//  OnlinePay.m
//  TheStoreApp
//
//  Created by yangxd on 11-8-3.
//  Copyright 2011 vsc. All rights reserved.
//

#import "OnlinePay.h"
#import "GlobalValue.h"
#import "Trader.h"
#import "Page.h"
#import "MyOrder.h"
#import "AlixPay.h"

#import "BankVO.h"

#import "CartService.h"
#import "OrderService.h"
#import "PayService.h"
#import "GroupBuyService.h"

#import "ASIHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "TheStoreAppAppDelegate.h"
#import "OTSAlertView.h"
#import "OTSUtility.h"
#import "MyStoreViewController.h"
#import "OTSNavigationBar.h"
#import "PaymentMethodVO.h"
#import "DoTracking.h"
//yao
#import "OrderInfo.h"



#define THREAD_STATUS_SAVE_PAYMENT 100
#define THREAD_STATUS_GET_BANKLIST 101
#define THREAD_STATUS_SUBMIT_ORDER_EX 102
#define THREAD_STATUS_SAVE_GATEWAY_ID   104

#define ALERTVIEW_TAG_SAVE_COUPON 200		// 保存抵用券到订单提示框标识
#define ALERTVIEW_TAG_SAVE_INVOICE 201		// 保存发票到订单提示框标识
#define ALERTVIEW_TAG_SUBMIT_ORDER 202		// 提交订单提示框标识
#define ALERTVIEW_TAG_CANCEL_ORDER 203		// 取消订单提示框标识
#define ALERTVIEW_TAG_OTHERS 204            // 其他提示框标识
#define ALERTVIEW_TAG_ONLINE_PAY_SUCCESS 205
#define ALERTVIEW_TAG_BANKLIST_NULL 206

#define ONLINE_PAY_SUCCESS 207

#define INDICATORY_BGALERT_MARGINLEFT 0
#define INDICATORY_BGALERT_MARGINTOP 0
#define INDICATORY_BGALERT_WIDTH 320
#define INDICATORY_BGALERT_HEIGHT 413
#define INDICATORY_MARGINLEFT 0
#define INDICATORY_MARGINTOP 0
#define INDICATORY_WIDTH 320
#define INDICATORY_HEIGHT 413

#define BANK_CELL_HEIGHT 60

#define PAYMENT_TAG_CASH 0					// 货到付款
#define PAYMENT_TAG_ONLINE 1				// 在线支付
#define PAYMENT_TAG_CREDITCARD 2			// 货到刷卡

#define UNIONPAY 403
#define UNIONPAY1MALL  203
#define ALIPAY_WEBSITE 400
#define ALIXPAYGATE        421
#define ALIPAY_GATEWAY      2

#define URL_ONLINE_PAY_HOME_PAGE        @"http://m.yihaodian.com/pay/iosSystem/"

#define SEG_BTN_TAG_LEFT        1590710
#define SEG_BTN_TAG_MIDDLE      1590711
#define SEG_BTN_TAG_RIGHT       1590712

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define EXTRA_JS_STR @"Alipay.ScrollCards.prototype = {goToPos : function (pos){if(pos === 'undefined'){return;}var self =this,cfg = self.cfg;if(typeof pos=='string'){id = pos;self.id=id;card=AI('#'+id);}else{id = self.id;card=AI(self.cards[id]);}if(AI.UA.system === 'android' || AI.UA.system === 'windows'){self.hideOtherCards();AI(self.getCurrentCard()).removeClass('hide');if (cfg.callback) {if (cfg.context) {cfg.callback.call(cfg.context, id, card);}else {cfg.callback.call(cfg.callback, id, card);}}return ;}if(pos === 0){self.prev();return;}card.removeClass('hide').addClass('current');self.container.addClass('out');}};"

//#define EXTRA_JS_STR @"scrollCards.constructor.prototype.goToPos = function (pos){alert('hahaha')};"

#define EXTRA_JS_STR_1 @"function moveCard0(id) {if (AI('.scrollCards')) {if (typeof id == 'undefined') {scrollCards.id = 0;scrollCards.goToPos(0);return;}scrollCards.id =id||0;var w = document.documentElement.offsetWidth;scrollCards.goToPos(-w);console.log(scrollCards.id,-w);}};"

//#define EXTRA_JS_STR_1 @"function moveCard0(id) {if (AI('.scrollCards')) {if (typeof id == 'undefined') {scrollCards.id = 0;scrollCards.scrollToPos(0);return;}scrollCards.id =id||0;var w = document.documentElement.offsetWidth;scrollCards.scrollToPos(-w);console.log(scrollCards.id,-w);}};"

//#define EXTRA_JS_STR_1 @"function moveCard0(id) {alert('ok');};"

#define JS_SEARCH_STR @"var scrollCard0 = function (id)"


@interface OnlinePay ()

@property(nonatomic, retain)UISegmentedControl* segCtrl;
@property(nonatomic, retain)UIButton *leftButton;
@property(nonatomic, retain)UIButton *midButton;
@property(nonatomic, retain)UIButton *rightButton;
@property BOOL                        isLinkClicked;   // 是否点击了WEBVIEW的链接

-(void)toOnlinePayView;         // 进入在线支付页面
-(void)initOnlinePayView;       // 初始化在线支付页面
-(void)initSelectBankView;      // 初始化支付平台选择页面
-(void)initBankTableView;       // 设置支付平台选择页面
-(void)initPaymentView;         // 初始支付方式页面


-(UIImage *)cachedImageForUrl:(NSURL *)url;                 // 缓存图片
-(void)didFinishRequestImage:(ASIHTTPRequest *)request;     // 加载图片成功
-(void)didFailRequestImage:(ASIHTTPRequest *)request;       // 加载图片失败


-(void)backCheckOrderView;          // 返回到检查订单页面

-(void)doSubmitOrderEX;             // 执行提交订单

// 交易插件退出回调方法，需要商户客户端实现 strResult：交易结果，若为空则用户未进行交易。
- (void) returnWithResult:(NSString *)strResult;

// 弹出银联插件
-(void)popTheUnionpayView:(UINavigationController*)aNavigate onlineOrderId:(NSNumber*)onlineOrderId;

// 显示提示框
-(void)showSubmitOrderExAlertView:(NSString *)result;       // 显示在线支付提交订单提示框
-(void)showSavePaymentAlertView:(NSString *)result;         // 显示保存付款方式提示框
-(void)showOnlinePayIsSuccessAlertView:(NSString *)result;  // 显示在线支付是否成功提示框

-(void)setUpThread;     // 建立线程
-(void)startThread;     // 开启线程
-(void)stopThread;      // 停止线程

- (void)onlinePayWebReload;
-(NSString*)urlPosixForAlipay;
@end






@implementation OnlinePay
@synthesize lastIndexPath;
@synthesize m_PopOverController;
@synthesize isFromOrder;
@synthesize isFromMyOrder;
@synthesize isSubmitOrder;
@synthesize isFromGroupon;
@synthesize isFromMyGroupon;
@synthesize isFromCheckOrder;
@synthesize isFromOrderSuccess;
@synthesize payMentWayArr, payMethodStr;
@synthesize orderId;
@synthesize isFromWap;
@synthesize gatewayId;
@synthesize methodID;
@synthesize m_delegate;
@synthesize isFromOrderDetail;
@synthesize onlyUsedForBankChosen, chooseBankCaller;
@synthesize bankArray = _bankArray;
@synthesize segCtrl = _segCtrl;
@synthesize leftButton = _leftButton, midButton = _midButton, rightButton = _rightButton;
@synthesize isLinkClicked = _isLinkClicked;


- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSubmitOrderEX) name:@"doSubmitOrderEX" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:@"CloseViewForEnterMyGroupBuy" object: nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	gatewayType = -1;
	selectedIndex = 0;
	isSelectedBank = NO;
    
    picRequests = [[NSMutableArray alloc] initWithCapacity:5];
	
	queue = [[NSOperationQueue alloc] init];
	cachedImage = [[NSMutableDictionary alloc] init];
    
	[self registerNotifications];
    
	if (isFromOrder)
    {
		selectedGatewayid = [[NSNumber alloc] initWithInt:[self.gatewayId intValue]];
		onlineOrderId = [[NSNumber alloc] initWithLongLong:[self.orderId longLongValue]];
		[self toOnlinePayView];
	}
    else if (isSubmitOrder)
    {
        selectedGatewayid = [[NSNumber alloc] initWithInt:[self.gatewayId intValue]];
        [self doSubmitOrderEX];
    }
    else if(isFromCheckOrder)
    {
        
        OTSNavigationBar* naviBar = [[[OTSNavigationBar alloc] initWithTitle:@"支付平台选择"
                                                                   backTitle:@" 返回"
                                                                  backAction:@selector(backCheckOrderView)
                                                            backActionTarget:self] autorelease];
        [self.view addSubview:naviBar];
        
        
        [self initPaymentTableView];
        
//        payMentWayExceptOnlinePayArr=[[NSMutableArray alloc] init];
//        for (PaymentMethodVO *paymentMehtod in payMentWayArr)
//        {
//            if ([paymentMehtod gatewayId]==nil && ![[paymentMehtod methodName] isEqualToString:@"网上支付"])
//            {
//                [payMentWayExceptOnlinePayArr addObject:paymentMehtod];
//            }else if([paymentMehtod gatewayId]==nil && [[paymentMehtod methodName] isEqualToString:@"网上支付"]){
//                payMentWayOnlineVO = paymentMehtod;
//            }
//        }
//        [self initPaymentView];
    }
    else
    {
		[self initSelectBankView];
	}
    
    self.m_delegate = (MyStoreViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:3];
    
    if (checkMarkView == nil)
    {
        checkMarkView = [[SharedDelegate checkMarkView] retain];
    }
}


#pragma mark 初始化支付平台选择页面
-(void)initPaymentView{
    OTSNavigationBar* naviBar = [[[OTSNavigationBar alloc] initWithTitle:@"付款方式"
                                                               backTitle:@" 返回"
                                                              backAction:@selector(backCheckOrderView)
                                                        backActionTarget:self] autorelease];
    [self.view addSubview:naviBar];
    
    loadingMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 310, 20)];
    loadingMsgLabel.text = @"支付平台加载中,请稍候...";
    [loadingMsgLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingMsgLabel setBackgroundColor:[UIColor clearColor]];
    loadingMsgLabel.textColor = UIColorFromRGB(0x333333);
    loadingMsgLabel.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:loadingMsgLabel];
    
//    currentState = THREAD_STATUS_GET_BANKLIST;
//    [self setUpThread];
}
-(void)initSelectBankView
{
    OTSNavigationBar* naviBar = [[[OTSNavigationBar alloc] initWithTitle:@"支付平台选择"
                                                               backTitle:@" 返回"
                                                              backAction:@selector(backCheckOrderView)
                                                        backActionTarget:self] autorelease];
    [self.view addSubview:naviBar];
    
	if (_bankArray && [_bankArray count] > 0)
    {
		[self initBankTableView];
	}
    else
    {
		loadingMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 310, 20)];
		loadingMsgLabel.text = @"支付平台加载中,请稍候...";
		[loadingMsgLabel setTextAlignment:NSTextAlignmentCenter];
		[loadingMsgLabel setBackgroundColor:[UIColor clearColor]];
		loadingMsgLabel.textColor = UIColorFromRGB(0x333333);
		loadingMsgLabel.font = [UIFont systemFontOfSize:18.0];
		[self.view addSubview:loadingMsgLabel];
		
//		currentState = THREAD_STATUS_GET_BANKLIST;
//		[self setUpThread];
	}
}

//--------------------出错以后退回到订单详情----------------------------------
-(void)callsomethingelse
{
    //Wait
    //若订单完成不调用此段代码
    if (!_orderdone) {
        if (packets==nil) {
            
            if (self.isFromGroupon||self.isFromMyGroupon || self.isFromWap) {
                //团购订单详情
                dispatch_async(dispatch_get_main_queue(), ^{
                    [m_delegate unionPaytoGroupBuyOrderDetail:onlineOrderId isFromMall:self.isFromWap];});
            }
            else
            {
                // 订单详情
                dispatch_async(dispatch_get_main_queue(), ^{
                    [m_delegate unionPaytoOrderDetail:onlineOrderId];
                });
            }
            done = YES;
        }
    }
    
}



#pragma mark 设置支付平台选择页面
-(void)initPaymentTableView{
    [loadingMsgLabel removeFromSuperview];
	[loadingMsgLabel release];
	loadingMsgLabel = nil;
	
//	if (_bankArray != nil && [_bankArray count] > 0)
//    {
        CGRect tvRc = CGRectMake(0, 44, self.view.frame.size.width, 367);
        tvRc.size.height = self.view.frame.size.height-SharedDelegate.tabBarController.tabBar.frame.size.height - 44;
        if (self.isFullScreen)
        {
            tvRc.size.height = self.view.frame.size.height - 44;
        }
        payMentTableView = [[UITableView alloc]initWithFrame:tvRc];
        [payMentTableView setDelegate:self];
		[payMentTableView setDataSource:self];
		[payMentTableView setBackgroundColor:[UIColor whiteColor]];
		[payMentTableView setShowsVerticalScrollIndicator:NO];
		[self.view addSubview:payMentTableView];
//    }
}
-(void)initBankTableView {
	[loadingMsgLabel removeFromSuperview];
	[loadingMsgLabel release];
	loadingMsgLabel = nil;
	
	if (_bankArray != nil && [_bankArray count] > 0)
    {
		// 滚动视图
		UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
		[scrollView setBackgroundColor:UIColorFromRGB(0xeeeeee)];
		[scrollView setShowsVerticalScrollIndicator:NO];
		// 商品列表
        CGRect tvRc = CGRectMake(0, 0, self.view.frame.size.width, 367);
        tvRc.size.height = self.view.frame.size.height-SharedDelegate.tabBarController.tabBar.frame.size.height;
        if (self.isFullScreen)
        {
            tvRc.size.height = self.view.frame.size.height;
        }
		bankTableView = [[UITableView alloc]initWithFrame:tvRc];
		[bankTableView setDelegate:self];
		[bankTableView setDataSource:self];
		[bankTableView setBackgroundColor:[UIColor whiteColor]];
		[bankTableView setShowsVerticalScrollIndicator:NO];
		[scrollView addSubview:bankTableView];
		[self.view addSubview:scrollView];
		[scrollView release];
	}
    else
    {
		[OTSUtility showAlertView:nil
                         alertMsg:@"暂无可选银行,请选用其他支付方式!"
                         alertTag:ALERTVIEW_TAG_BANKLIST_NULL];
	}
}
-(void)showNotSupportReseaon:(id)sender{
    UIButton* clickedBtn = (UIButton*)sender;
    int rowIndex = clickedBtn.tag;
    PaymentMethodVO* payWayVO = [payMentWayExceptOnlinePayArr objectAtIndex:rowIndex];
    float theX = clickedBtn.frame.origin.x +35;
    float theY = clickedBtn.frame.origin.y + 10 + clickedBtn.frame.size.height + 60*rowIndex;
    
    // 初始化内容VIEW
    UIViewController* contentViewVC = [[[UIViewController alloc]init] autorelease];
    contentViewVC.view.backgroundColor = [UIColor whiteColor];
    contentViewVC.view.layer.cornerRadius = 7.0;
    contentViewVC.view.layer.masksToBounds = YES;
    
    UILabel* reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 60)];
    [reasonLabel setText:payWayVO.errorInfo.errorInfo];
    [reasonLabel setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    [reasonLabel setFont:[UIFont systemFontOfSize:18.0]];
    [reasonLabel setTextAlignment:NSTextAlignmentCenter];
    [reasonLabel setAdjustsFontSizeToFitWidth:YES];
    reasonLabel.layer.cornerRadius = 7.0;
    reasonLabel.layer.masksToBounds = YES;
    [contentViewVC.view addSubview:reasonLabel];
    [reasonLabel release];
    
    UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 58, 290, 2)];
    [sepLine setBackgroundColor:[UIColor colorWithRed:228.0/255 green:228.0/255 blue:228.0/255 alpha:1]];
    [contentViewVC.view addSubview:sepLine];
    [sepLine release];
    
    // uilabel无法设置行间距，采用粗暴方法分成5个Label
    UILabel* commonLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 286, 24)];
    [commonLabel1 setText:@"  以下情况将无法使用货到支付服务"];
    [commonLabel1 setFont:[UIFont systemFontOfSize:16.0]];
    [commonLabel1 setBackgroundColor:[UIColor whiteColor]];
    [contentViewVC.view addSubview:commonLabel1];
    [commonLabel1 release];
    
    UILabel* commonLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 94, 286, 24)];
    [commonLabel2 setText:@"  -订单金额小于50 "];
    [commonLabel2 setFont:[UIFont systemFontOfSize:16.0]];
    [commonLabel2 setBackgroundColor:[UIColor whiteColor]];
    [contentViewVC.view addSubview:commonLabel2];
    [commonLabel2 release];
    
    UILabel* commonLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 118, 286, 24)];
    [commonLabel3 setText:@"  -购物车中存在特殊商品"];
    [commonLabel3 setFont:[UIFont systemFontOfSize:16.0]];
    [commonLabel3 setBackgroundColor:[UIColor whiteColor]];
    [contentViewVC.view addSubview:commonLabel3];
    [commonLabel3 release];
    
    UILabel* commonLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 142, 286, 24)];
    [commonLabel4 setText:@"  -已使用抵用券"];
    [commonLabel4 setFont:[UIFont systemFontOfSize:16.0]];
    [commonLabel4 setBackgroundColor:[UIColor whiteColor]];
    [contentViewVC.view addSubview:commonLabel4];
    [commonLabel4 release];
    
    UILabel* commonLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 166, 286, 24)];
    [commonLabel5 setText:@"  -当前收货地址不支持"];
    [commonLabel5 setFont:[UIFont systemFontOfSize:16.0]];
    [commonLabel5 setBackgroundColor:[UIColor whiteColor]];
    [contentViewVC.view addSubview:commonLabel5];
    [commonLabel5 release];
    
    self.m_PopOverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewVC] autorelease];
    self.m_PopOverController.delegate = self;
    self.m_PopOverController.popoverContentSize=CGSizeMake(290, 200);
    
    if ([self.m_PopOverController respondsToSelector:@selector(setContainerViewProperties:)])
    {
        [self.m_PopOverController setContainerViewProperties:[self improvedContainerViewProperties]];
    }
    
    //}
    [self.m_PopOverController presentPopoverFromRectV2:CGRectMake(theX,theY, 0, 0) inView:payMentTableView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark 执行提交订单
-(void)doSubmitOrderEX
{
	currentState = THREAD_STATUS_SUBMIT_ORDER_EX;
	[self setUpThread];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"doSubmitOrderEX" object:nil];
}


-(void)closeView
{
    [self removeSelf];
    //[SharedDelegate changeMaskFrameHasTabbar:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlinePayReleased" object:self];
}

-(void)chooseBankCaller:(id)aCaller
{
    self.onlyUsedForBankChosen = YES;
    self.chooseBankCaller = aCaller;
}

#pragma mark 进入在线支付页面
-(void)toOnlinePayView
{
    
    // <<BUG 0109127>>: 【支付】点击支付的时候要检查一下订单的状态---------->dym
    __block OrderVO *order = nil;
    [self.loadingView showInView:self.view];
    [self performInThreadBlock:^{
        
        order = [[[OTSServiceHelper sharedInstance] getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:self.orderId] retain];
        
    } completionInMainBlock:^{
        
        [self.loadingView hide];
        
        BOOL canPay = YES;
        if (order.hasPayedOnline)
        {
            [OTSUtility alert:@"订单已支付成功，无需再次支付。我们会尽快为您发货"];
            canPay = NO;
        }
        else if (order.isCanceled)
        {
            [OTSUtility alert:@"由于逾期未支付，订单已取消，请重新下单。"];
            canPay = NO;
        }
        
        [order release];
        
        if (!canPay)
        {
            [self popSelfAnimated:YES];
        }
    }];
    // <<BUG 0109127>>: 【支付】点击支付的时候要检查一下订单的状态<---------------
    
    
    //onlinePayView.frame = CGRectMake(0, 40, onlinePayView.frame.size.width, onlinePayView.frame.size.height);
    // 如果是从订单过来的并且不是从团购过来的
    // 或者是从我的团购订单过来的或者从我的订单过来的
    if ((isFromOrder&&!isFromGroupon) || isFromMyGroupon || isFromMyOrder)
    {
        //        [NSThread sleepForTimeInterval:1];  // why?
        
        if ([selectedGatewayid isEqualToNumber:[NSNumber numberWithInt:UNIONPAY]]||[selectedGatewayid isEqualToNumber:[NSNumber numberWithInt:UNIONPAY1MALL]])
        {
#if !TARGET_IPHONE_SIMULATOR
            UINavigationController *eUnionpayViewContent = [[UINavigationController alloc] initWithRootViewController:self];
            eUnionpayViewContent.delegate = self;
            [self popTheUnionpayView:eUnionpayViewContent onlineOrderId:onlineOrderId];
            [eUnionpayViewContent setNavigationBarHidden:YES animated:NO];
            
            [[eUnionpayViewContent.view layer] addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
            [SharedDelegate.tabBarController presentModalViewController:eUnionpayViewContent animated:NO];
#endif
        }
        else if([selectedGatewayid isEqualToNumber:[NSNumber numberWithInt:ALIXPAYGATE]])
        {
            [self popTheAlixpayView:onlineOrderId];
        }
        else
        {
            [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
            [self.view addSubview:onlinePayView];
            [self initOnlinePayView];
        }
    }
    else
    {
        [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
        [self.view addSubview:onlinePayView];
        [self initOnlinePayView];
    }
    
}

#warning 支付宝支付的代码
-(void)popTheAlixpayView:(NSNumber *)aOnlineorderid

{
    NSString *appScheme = @"yhyw";
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (onlineOrderId != nil)
    {
        orderString = [OTSUtility requestAliPaySignature:aOnlineorderid];
        //全局记录状态
        [[GlobalValue getGlobalValueInstance] setAlixpayOrderId:[NSNumber numberWithLongLong:[onlineOrderId longLongValue]]];
        [[GlobalValue getGlobalValueInstance] setIsFromOrderDetailForAlix:isFromOrderDetail];
        [[GlobalValue getGlobalValueInstance] setIsFromOrderSuccessForAlix:isFromOrderSuccess];
        [[GlobalValue getGlobalValueInstance] setIsFromOrderGROUPDetailForAlix:isFromMyGroupon];
        [[GlobalValue getGlobalValueInstance] setIsFromMyOrder:isFromMyOrder];
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        [alixpay pay:orderString applicationScheme:appScheme];
    }
}

-(void)popTheUnionpayView:(UINavigationController*)aNavigate onlineOrderId:(NSNumber *)aOnlineorderid
{
#if !TARGET_IPHONE_SIMULATOR
    packets = [OTSUtility requestSignature:aOnlineorderid];
    //-----------------------4302XML解析失败错误,确保需要验证的报文不为空,否则退回订单详情----------------------------
    //    UIViewController *viewCtrl = [[LTInterface getHomeViewControllerWithType:1 strOrder:packets andDelegate:self];
    UIViewController *viewCtrl = [LTInterface getHomeViewControllerWithType:packets
                                                                andDelegate:self];
    [aNavigate pushViewController:viewCtrl animated:YES];
#endif
}

-(NSString*)createJsFunction
{
    NSString* jsFunctionCreationFormatStr = @"var script%d = document.createElement('script');script%d.type = 'text/javascript';script%d.text = \"%@\"; document.getElementsByTagName('head')[0].appendChild(script%d);";
    
    int num = 1;
    NSString* jsFunctionCreationStr = [NSString stringWithFormat:jsFunctionCreationFormatStr, num, num, num, EXTRA_JS_STR, num];
    
    num++;
    NSString* jsFunction2 = [NSString stringWithFormat:jsFunctionCreationFormatStr, num, num, num, EXTRA_JS_STR_1, num];
    jsFunctionCreationStr = [NSString stringWithFormat:@"%@%@", jsFunctionCreationStr, jsFunction2];
    
    //    jsFunctionCreationStr = [NSString stringWithFormat:@"%@%@", jsFunctionCreationStr, @"Alipay.ScrollCards.constructor.prototype.age;"];
    return jsFunctionCreationStr;
}

- (void)excuteJsWithIndex:(NSUInteger)selectedSegmentIndex
{
    NSString* jsStr = @"scrollCard0();";
    //NSString* jsStr = @"moveCard0();";
    if (selectedSegmentIndex)
    {
        jsStr = [NSString stringWithFormat:@"scrollCard0(%d);", selectedSegmentIndex];
        //jsStr = [NSString stringWithFormat:@"moveCard0(%d);", selectedSegmentIndex];
    }
    
    //jsStr = [NSString stringWithFormat:@"%@%@", [self createJsFunction], jsStr];
    
    NSString* result = [onlineWebView stringByEvaluatingJavaScriptFromString:jsStr];
    DebugLog(@"js result:%@", result);
}

-(void)alipayOptionSelected:(id)sender
{
    NSUInteger  selectedSegmentIndex = _segCtrl.selectedSegmentIndex;
    DebugLog(@"selectedSegmentIndex: %d",selectedSegmentIndex);
    
    [self excuteJsWithIndex:selectedSegmentIndex];
}

#pragma mark 初始化在线支付页面
-(NSString*)addJSFunctionToHtml:(NSString*)aHtml
{
    if (aHtml)
    {
        NSString* jsFunctionStr = [NSString stringWithFormat:@"%@%@", EXTRA_JS_STR, JS_SEARCH_STR];
        
        NSString* newHtmlStr = [aHtml stringByReplacingOccurrencesOfString:JS_SEARCH_STR withString:jsFunctionStr];
        
        return newHtmlStr;
    }
    
    return nil;
}


- (NSString *)getOnlinePayWebUrl
{
    // http://m.yihaodian.com/pay/tradername/usertoken/provinceId/orderid/gatewayid
    
	// 测试环境
    //	NSString * urlStr = [NSString stringWithFormat:@"http://tst.m.yihaodian.com/pay/%@/%@/%@/%@/%@",
    //						 [GlobalValue getGlobalValueInstance].trader.traderName,
    //						 [GlobalValue getGlobalValueInstance].token,
    //						 [GlobalValue getGlobalValueInstance].provinceId,
    //						 onlineOrderId,
    //						 selectedGatewayid];
	// 真实环境
    NSNumber *locationId = nil;
    
    if (isFromGroupon || isFromMyGroupon)
    {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *filename=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"GroupBuyLocation.plist"];
        NSMutableArray *mArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
        if ([mArray count]==0)
        {
            //团购省份ID
            NSNumber *grouponProvinceId=[GlobalValue getGlobalValueInstance].provinceId;
            locationId=[NSNumber numberWithInt:[grouponProvinceId intValue]];
        }
        
        else
        {
            NSDictionary *dictionary=[mArray objectAtIndex:0];
            NSNumber *grouponProvinceId=[dictionary valueForKey:@"ProvinceId"];
            locationId=[NSNumber numberWithInt:[grouponProvinceId intValue]];
        }
        [mArray release];
        
    }
    
    else
    {
        locationId=[NSNumber numberWithInt:[[GlobalValue getGlobalValueInstance].provinceId intValue]];
    }
    
	NSString * urlStr = [NSString stringWithFormat:@"http://m.yihaodian.com/pay/%@/%@/%@/%@/%@",
						 [GlobalValue getGlobalValueInstance].trader.traderName,
						 [GlobalValue getGlobalValueInstance].token,
						 locationId,
						 onlineOrderId,
						 selectedGatewayid];
    
    if ([selectedGatewayid intValue] == ALIPAY_GATEWAY)
    {
        urlStr = [NSString stringWithFormat:@"%@%@", urlStr, [self urlPosixForAlipay]];
    }
    
    return urlStr;
}

- (void)onlinePayWebReload
{
    NSString *urlStr = [self getOnlinePayWebUrl];
	DebugLog(@"\n\n\n\n\nurlStr : %@\n\n\n\n\n", urlStr);
    
    // 支付宝
    //    if ([selectedGatewayid intValue] == ALIPAY_GATEWAY)
    //    {
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //            ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //            [request startSynchronous];
    //
    //            if (!request.error)
    //            {
    //                NSString* htmlStr = [NSString stringWithCString:request.responseData.bytes encoding:NSUTF8StringEncoding];
    //                //NSString* newHtmlStr = [self addJSFunctionToHtml:htmlStr];
    //
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //                    [onlineWebView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:[[NSBundle mainBundle]resourcePath]]];
    //                });
    //            }
    //
    //        });
    //    }
    //    else
    {
        [onlineWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }
    
    _isLinkClicked = NO;
}

-(UIButton*)buttonWithTitle:(NSString*)aTitle bgImage:(UIImage*)aBgImage selectedImage:(UIImage*)aSelectedImage atPos:(CGPoint)aPosition
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:aBgImage forState:UIControlStateNormal];
    [btn setBackgroundImage:aSelectedImage forState:UIControlStateSelected];
    btn.frame = CGRectMake(aPosition.x, aPosition.y, aBgImage.size.width, aBgImage.size.height);
    [btn setTitle:aTitle forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
    btn.titleLabel.shadowColor = [UIColor blackColor];
    btn.titleLabel.shadowOffset = CGSizeMake(1, 1);
    
    [btn addTarget:self action:@selector(segButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(UIButton*)selectedSegButton
{
    if (_leftButton.selected)
    {
        return _leftButton;
    }
    
    if (_midButton.selected)
    {
        return _midButton;
    }
    
    if (_rightButton.selected)
    {
        return _rightButton;
    }
    
    return nil;
}

-(NSString*)urlPosixForAlipay
{
    NSString* urlPosix = nil;
    
    switch ([self selectedSegButton].tag)
    {
        case SEG_BTN_TAG_LEFT:
        {
            urlPosix = @"/ALIPAY";
        }
            break;
            
        case SEG_BTN_TAG_MIDDLE:
        {
            urlPosix = @"/CREDITCARD";
        }
            break;
            
        case SEG_BTN_TAG_RIGHT:
        {
            urlPosix = @"/DEBITCARD";
        }
            break;
            
        default:
            break;
    }
    
    return urlPosix;
}

-(void)segButtonClicked:(UIButton*)aButton
{
    _leftButton.selected = _midButton.selected = _rightButton.selected = NO;
    aButton.selected = YES;
    
    [self onlinePayWebReload];
    
    //    if (!_isLinkClicked)
    //    {
    //        [self excuteJsWithIndex:aButton.tag - SEG_BTN_TAG_LEFT];
    //    }
    //    else
    //    {
    //        [self onlinePayWebReload];
    //    }
}

-(void)initOnlinePayView
{
    
    OTSNavigationBar* naviBar = [[[OTSNavigationBar alloc] initWithTitle:@"在线支付"
                                                               backTitle:@" 返回"
                                                              backAction:@selector(toPreviousPage)
                                                        backActionTarget:self] autorelease];
    [self.view addSubview:naviBar];
    
    // 支付宝支付选项
    if ([selectedGatewayid intValue] == ALIPAY_GATEWAY)
    {
        naviBar.titleLabel.text = @"";
        
        self.leftButton = [self buttonWithTitle:@"账号" bgImage:[UIImage imageNamed:@"segLeft"] selectedImage:[UIImage imageNamed:@"segLeftDark"]  atPos:CGPointMake(90, 8)];
        _leftButton.tag = SEG_BTN_TAG_LEFT;
        _leftButton.selected = YES;
        [naviBar addSubview:_leftButton];
        
        self.midButton = [self buttonWithTitle:@"信用卡" bgImage:[UIImage imageNamed:@"segMiddle"] selectedImage:[UIImage imageNamed:@"segMiddleDark"] atPos:CGPointMake(CGRectGetMaxX(_leftButton.frame) - 1, _leftButton.frame.origin.y)];
        _midButton.tag = SEG_BTN_TAG_MIDDLE;
        [naviBar addSubview:_midButton];
        
        self.rightButton = [self buttonWithTitle:@"储蓄卡" bgImage:[UIImage imageNamed:@"segRight"] selectedImage:[UIImage imageNamed:@"segRightDark"] atPos:CGPointMake(CGRectGetMaxX(_midButton.frame) - 0.5f, _midButton.frame.origin.y)];
        _rightButton.tag = SEG_BTN_TAG_RIGHT;
        [naviBar addSubview:_rightButton];
    }
    
    
    
    CGRect webRc = CGRectMake(0, 44, 320, 367);
    
    
    //webRc = onlineWebView.frame;
    float offsety = 5.0;
    webRc.size.height = self.view.frame.size.height-SharedDelegate.tabBarController.tabBar.frame.size.height+offsety;
    if (self.isFullScreen)
    {
        webRc.size.height = self.view.frame.size.height - OTS_IPHONE_NAVI_BAR_HEIGHT;
        
    }
    
    onlineWebView = [[UIWebView alloc]initWithFrame:webRc];
    [onlineWebView setScalesPageToFit:YES];
    [self onlinePayWebReload];
    //onlineWebView.frame = webRc;
    
	[onlineWebView setDelegate:self];
	[onlineWebView setOpaque:NO];
	onlineWebView.backgroundColor = [UIColor whiteColor];
    [onlinePayView addSubview:onlineWebView];
    
    
}

#pragma mark 返回上一页
-(void)toPreviousPage
{
    [self popSelfAnimated:YES];
}

//需要商户客户端实现 strResult：交易结果，若为空则用户未进行交易
#pragma mark 交易插件退出回调方法
- (void) returnWithResult:(NSString *)strResult
{
    NSString *tempNumber = @"";
    if (strResult!=nil) {
        NSRange range1 = [strResult rangeOfString:@"<respCode>"];
        NSRange range3 = [strResult rangeOfString:@"</respCode>"];
        int loca = range1.location +range1.length;
        int len =  range3.location -loca;
        tempNumber = [strResult substringWithRange:NSMakeRange(loca,len )];
    }
    if (strResult == nil || ![tempNumber isEqualToString:@"0000"]) {
        if (self.isFromGroupon||self.isFromMyGroupon || self.isFromWap) {
            //团购订单详情
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_delegate unionPaytoGroupBuyOrderDetail:onlineOrderId isFromMall:self.isFromWap];
                done = YES;
            });
        }
        else
        {
            // 订单详情
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_delegate unionPaytoOrderDetail:onlineOrderId];
                done = YES;
            });
        }
    }
    // 支付完成
    else
    {
        //检查订单然后刷新订单 不去卡UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_delegate unionPaytoOrderList];
            done = YES;
            _orderdone = YES;
            [self performInThreadBlock:^(){
                [self checkOrderStatus:nil];
            }];
        });
        
    }
}

-(void)checkOrderStatus:(NSDictionary *)object
{
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    OrderV2 * v2 =nil;
    int timeout = 0;
    if (onlineOrderId) {
        do {
            v2 = [service getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:onlineOrderId];
            sleep(0.2);
            timeout++;
        } while ([v2.orderStatus intValue] == 3 && timeout<40);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyOrder" object:nil];
        });
    }
}
#pragma mark -
#pragma mark popView
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
    
	bgImageName = @"ProvinceInAddress@2x.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 4; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13
	bgCapSize = 0; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = 8;// bgMargin;
	props.bottomBgMargin = 12;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin =7;// contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = -2;//contentMargin;
	props.bottomContentMargin = -6;
	
	props.arrowMargin = 0.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDownGray.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;
}
- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.m_PopOverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

#pragma mark 返回到检查订单页面
-(void)backCheckOrderView
{
    [self popSelfAnimated:YES];
    //[SharedDelegate changeMaskFrameHasTabbar:NO];
}

#pragma mark -
#pragma mark 设置列表的行点击事件
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//     [self backCheckOrderView];
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayMentWayChanged" object:m_payWayVO];
    
    if (indexPath.section == 0)
    {
        if ((indexPath.row == 0 && ![_checkingOrder isSupportCod]) || (indexPath.row == 1 && ![_checkingOrder isSupportPos]))
        {
            return;
        }
    }
   
    
    //0:货到付款 1:支付宝 2:货到刷卡
    NSString *selectedPayment = @"";
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {//货到付款
            selectedPayment = @"0";
        }
        else
        {//pos
             selectedPayment = @"2";
        }
    }
    else
    {
        //支付宝
        selectedPayment = @"1";
    }
    
    // 选中标识切换
    UITableViewCell * newCell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView* markView = (UIImageView*)[newCell viewWithTag:99];
    [markView setImage:[UIImage imageNamed:@"goodReceiver_sel.png"]];
    
    UITableViewCell * oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    UIImageView* markViewOld = (UIImageView*)[oldCell viewWithTag:99];
    [markViewOld setImage:[UIImage imageNamed:@"goodReceiver_unsel.png"]];
    
    [self setLastIndexPath:indexPath];
    selectedIndex = [lastIndexPath row];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayMentWayChanged" object:selectedPayment];
    [self backCheckOrderView];
    /*
    if ([indexPath section] == 1 || !isFromCheckOrder)
    {
        
        if ([indexPath row] != [_bankArray count])
        {
            isSelectedBank = YES;
            m_BankVO = [_bankArray objectAtIndex:[indexPath row]];
            
            if (selectedGatewayid!=nil)
            {
                [selectedGatewayid release];
            }
            selectedGatewayid = [m_BankVO.gateway retain];
            
            
            if (onlyUsedForBankChosen && chooseBankCaller)
            {
                DebugLog(@"choose bank, notify with bankVO:%@, caller:%@", m_BankVO, chooseBankCaller);
                [[NSNotificationCenter defaultCenter] postNotificationName:OTS_ONLINEPAY_BANK_CHANGED object:[NSArray arrayWithObjects:chooseBankCaller, m_BankVO, nil]];
                [self popSelfAnimated:YES];
                return;
            }
            
            
            if (isFromGroupon) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePaymentMethod" object:m_BankVO];
                [self backCheckOrderView];
            } else if (isFromMyGroupon) {
                [payBtn setEnabled:NO];
                gatewayType = [selectedGatewayid intValue];
                currentState = THREAD_STATUS_SAVE_GATEWAY_ID;
                [self setUpThread];
            } else if (isFromMyOrder) {
                [payBtn setEnabled:NO];
                gatewayType=[selectedGatewayid intValue];
                onlineOrderId = [[NSNumber alloc] initWithLongLong:[self.orderId longLongValue]];
                [self toOnlinePayView];
            }
            else if (isFromOrderDetail) {
                selectedGatewayid = m_BankVO.gateway;
                onlineOrderId = [[NSNumber alloc] initWithLongLong:[self.orderId longLongValue]];
                [self toOnlinePayView];
            }
            else if(isFromCheckOrder){
                [payBtn setEnabled:NO];
                self.methodID = [payMentWayOnlineVO.methodId intValue];
                gatewayType = [selectedGatewayid intValue];
                isUseOnlinePay = YES;
                currentState = THREAD_STATUS_SAVE_PAYMENT;
                [self setUpThread];
            }else {
                [payBtn setEnabled:NO];
                gatewayType = [selectedGatewayid intValue];
                currentState = THREAD_STATUS_SAVE_PAYMENT;
                [self setUpThread];
            }
        }
    }
    else
    {  // 货到支付
        m_payWayVO = [payMentWayExceptOnlinePayArr objectAtIndex:[indexPath row]];
        if ([m_payWayVO.isSupport isEqualToString:@"true"]) {
            [payBtn setEnabled:NO];
            self.methodID = [m_payWayVO.methodId intValue];
            gatewayType = [[m_payWayVO gatewayId] intValue];
            isUseOnlinePay = NO;
            currentState = THREAD_STATUS_SAVE_PAYMENT;
            [self setUpThread];
        }else {
            return;
        }
    }
	// 选中标识切换
    UITableViewCell * newCell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView* markView = (UIImageView*)[newCell viewWithTag:99];
    [markView setImage:[UIImage imageNamed:@"goodReceiver_sel.png"]];
    
    UITableViewCell * oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    UIImageView* markViewOld = (UIImageView*)[oldCell viewWithTag:99];
    [markViewOld setImage:[UIImage imageNamed:@"goodReceiver_unsel.png"]];
    
    [self setLastIndexPath:indexPath];
    selectedIndex = [lastIndexPath row];
     */
}
#pragma mark 设置列表行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == payMentTableView)
    {
        if (section == 0) {
//            return [payMentWayExceptOnlinePayArr count];
            return 2;
        }
        else
        {
            return 1;
        }
    }
	return [_bankArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == payMentTableView) {
        return 2;
    }else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == payMentTableView) {
        if (section == 0) {
            return @"货到支付";
        }
        if (section == 1) {
            return @"网上支付";
        }
    }
    return nil;
}
#pragma mark 设置列表行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
	static NSString * OnlinePayIdentifier = @"OnlinePayIdentifier";
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:OnlinePayIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OnlinePayIdentifier] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // 获得主视图
    UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 59)];
    myView.backgroundColor = [UIColor whiteColor];
    // 支付方式名称
	UILabel * payWay = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 140, 18)];
    [payWay setBackgroundColor:[UIColor clearColor]];
    payWay.textColor = UIColorFromRGB(0x333333);
    payWay.font = [UIFont boldSystemFontOfSize:16.0];
    // 选中标识
    UIImageView* markViewOld = (UIImageView*)[cell viewWithTag:99];
    if (markViewOld.superview != nil) {
        [markViewOld removeFromSuperview];
    }
    UIImageView* markView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 24, 24)];
    [markView setTag:99];
    
    //Yaowang支付
    if (tableView == payMentTableView && section == 1)
    {
        //网上支付
        UIImageView * bankImg = [[UIImageView alloc] initWithFrame:CGRectMake(210, 15, 91, 30)];
        bankImg.image = [UIImage imageNamed:@"bank_img_default.png"];
        payWay.text = @"支付宝客户端支付";
        [myView addSubview:bankImg];
        [bankImg release];

        UILabel * alixpayLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 45, 220, 18)];
        [alixpayLab setBackgroundColor:[UIColor clearColor]];
        alixpayLab.textColor = UIColorFromRGB(0x999999);
        alixpayLab.font = [UIFont systemFontOfSize:13.0];
        alixpayLab.text = @"安装支付宝客户端用户使用";
        [myView addSubview:alixpayLab];
        [alixpayLab release];
        
        [markView setImage:[UIImage imageNamed:@"goodReceiver_unsel.png"]];
        [myView addSubview:markView];
    
    }
    else
    {   //货到付款
        
        if (indexPath.row == 0)
        {
            payWay.text = @"货到付现金";
        }
        else
        {
            payWay.text = @"货到刷卡";
        }
        
        if ((indexPath.row == 0 && ![_checkingOrder isSupportCod]) || (indexPath.row == 1 && ![_checkingOrder isSupportPos]))
        {
            UIButton* notSupportBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 10, 70, 40)];
            [notSupportBtn setTitle:@"不支持" forState:UIControlStateNormal];
            [notSupportBtn setTitleColor:[UIColor colorWithRed:89.0/255 green:127.0/255 blue:165.0/255 alpha:1] forState:UIControlStateNormal];
            [notSupportBtn setTag:row];
            [notSupportBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//            [notSupportBtn addTarget:self action:@selector(showNotSupportReseaon:) forControlEvents:UIControlEventTouchUpInside];
            [myView addSubview:notSupportBtn];
            [notSupportBtn release];
            
            payWay.textColor = [UIColor grayColor];
        }
        
        
        
        
        //下划线
//        UIView *underLine=[[UIView alloc] initWithFrame:CGRectMake(241, 40, 46, 1)];
//        [underLine setBackgroundColor:[UIColor colorWithRed:89.0/255 green:127.0/255 blue:165.0/255 alpha:1]];
//        [myView addSubview:underLine];
//        [underLine release];
        
       
        
        [markView setImage:[UIImage imageNamed:@"goodReceiver_unsel.png"]];
        [myView addSubview:markView];
        
    }

    
    
    
    
    
    
    
    
    
    
    
/*
    
    
    
    // 初始化网上支付
    if ((tableView == payMentTableView && section == 1) || tableView != payMentTableView)
    
    {
        
        BankVO * bankVO = [_bankArray objectAtIndex:row];
        UIImageView * bankImg = [[UIImageView alloc] initWithFrame:CGRectMake(210, 15, 91, 30)];
        NSURL * url = nil;
        NSArray * cells = [bankTableView visibleCells];
        for (int i = 0; [_bankArray count] > i; i++) {
            if (row >= i && row <= ([cells count] + i)) {
                url = [NSURL URLWithString:bankVO.logo];
            }
        }
        if (url!=nil) {
            bankImg.image = [self cachedImageForUrl:url];
        }else {
            bankImg.image = [UIImage imageNamed:@"bank_img_default.png"];
        }
        if (bankImg.image == nil) {
            bankImg.image = [UIImage imageNamed:@"bank_img_default.png"];
        }
        payWay.text = bankVO.bankname;
        [myView addSubview:bankImg];
        [bankImg release];
        
        //支付宝客户端支付说明
        if ([bankVO.gateway intValue] == ALIXPAYGATE) {
            UILabel * alixpayLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 45, 220, 18)];
            [alixpayLab setBackgroundColor:[UIColor clearColor]];
            alixpayLab.textColor = UIColorFromRGB(0x999999);
            alixpayLab.font = [UIFont systemFontOfSize:13.0];
            alixpayLab.text = @"安装支付宝客户端用户使用";
            [myView addSubview:alixpayLab];
        }
        
        if ([bankVO.gateway intValue] == ALIPAY_WEBSITE) {
            UILabel * alixpayLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 45, 220, 18)];
            [alixpayLab setBackgroundColor:[UIColor clearColor]];
            alixpayLab.textColor = UIColorFromRGB(0x999999);
            alixpayLab.font = [UIFont systemFontOfSize:13.0];
            alixpayLab.text = @"有支付宝帐户的用户使用";
            [myView addSubview:alixpayLab];
        }
        
        if ([gatewayId intValue]==[[bankVO gateway] intValue])
        {
            [markView setImage:[UIImage imageNamed:@"goodReceiver_sel.png"]];
            self.lastIndexPath = indexPath;
        }
        else
        {
            [markView setImage:[UIImage imageNamed:@"goodReceiver_unsel.png"]];
        }
        [myView addSubview:markView];
        
    }else {  // 初始化货到付款
        PaymentMethodVO* payWayVO = [payMentWayExceptOnlinePayArr objectAtIndex:row];
        payWay.text = [payWayVO methodName];
        if (![payWayVO.isSupport isEqualToString:@"true"]) {
            UIButton* notSupportBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 10, 70, 40)];
            [notSupportBtn setTitle:@"不支持" forState:UIControlStateNormal];
            [notSupportBtn setTitleColor:[UIColor colorWithRed:89.0/255 green:127.0/255 blue:165.0/255 alpha:1] forState:UIControlStateNormal];
            [notSupportBtn setTag:row];
            [notSupportBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [notSupportBtn addTarget:self action:@selector(showNotSupportReseaon:) forControlEvents:UIControlEventTouchUpInside];
            [myView addSubview:notSupportBtn];
            [notSupportBtn release];
            //下划线
            UIView *underLine=[[UIView alloc] initWithFrame:CGRectMake(241, 40, 46, 1)];
            [underLine setBackgroundColor:[UIColor colorWithRed:89.0/255 green:127.0/255 blue:165.0/255 alpha:1]];
            [myView addSubview:underLine];
            [underLine release];
            
            payWay.textColor = [UIColor grayColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([payMethodStr isEqualToString:payWay.text])
        {
            [markView setImage:[UIImage imageNamed:@"goodReceiver_sel.png"]];
            self.lastIndexPath = indexPath;
        }
        else
        {
            [markView setImage:[UIImage imageNamed:@"goodReceiver_unsel.png"]];
        }
    }
 
 */
    [myView addSubview:payWay];
    [myView addSubview:markView];
    [cell addSubview:myView];
    
    [myView release];
    [payWay release];
    [markView release];
    
	return cell;
}
#pragma mark 设置列表行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    m_BankVO = [_bankArray objectAtIndex:[indexPath row]];
    DebugLog(@">>>>> %d",[tableView numberOfSections]);
    int  bankcellheight = 0;
    NSUInteger section = [indexPath section];
    if ([tableView numberOfSections] == 2 && section == 1 && ([m_BankVO.gateway isEqualToNumber:[NSNumber numberWithInt:ALIXPAYGATE]]||[m_BankVO.gateway isEqualToNumber:[NSNumber numberWithInt:ALIPAY_WEBSITE]])) {
        bankcellheight =  70;
    }
    else if ([tableView numberOfSections] == 1 && section == 0 && ([m_BankVO.gateway isEqualToNumber:[NSNumber numberWithInt:ALIXPAYGATE]]||[m_BankVO.gateway isEqualToNumber:[NSNumber numberWithInt:ALIPAY_WEBSITE]])) {
        bankcellheight =  70;
    }
    else
        bankcellheight =BANK_CELL_HEIGHT;
    
    return bankcellheight;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString * requestString = [[request URL] absoluteString];
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        _isLinkClicked = YES;
    }
    
	//DebugLog(@"%@",requestString);
	NSArray * components = [requestString componentsSeparatedByString:@"/"];
	for (NSString* tmpStr in components) {
		if ([tmpStr isEqualToString:@"payokbacktoiphone"]) {
			OrderDone *od = [[OrderDone alloc] init];
            if (!isFromMyGroupon||!isFromMyOrder) {
                [od setIsFullScreen:YES];
            }
			od.onlineOrderId = onlineOrderId;
			[self.view addSubview:od.view];
			[od release];
			return NO;
		}
	}
	NSArray * components1 = [requestString componentsSeparatedByString:@":"];
	if ([components1 count] > 1 && [(NSString *)[components1 objectAtIndex:0] isEqualToString:@"thestore"]){
		OrderDone *od = [[OrderDone alloc] init];
        if (!isFromMyGroupon||!isFromMyOrder) {
            [od setIsFullScreen:YES];
        }
		od.onlineOrderId = onlineOrderId;
		[self.view addSubview:od.view];
		[od release];
		return NO;
	}
    
    //增加新版招商银行的监听
    NSRange range1 = [requestString rangeOfString:@"http://netpay.yihaodian.com/online-payment/notify/402/1/1/"];
    NSRange range2 = [requestString rangeOfString:@"Succeed=Y"];
    if (range1.location!=NSNotFound && range2.location!=NSNotFound) {
        OrderDone *od = [[OrderDone alloc] init];
        if (!isFromMyGroupon||!isFromMyOrder) {
            [od setIsFullScreen:YES];
        }
        od.onlineOrderId = onlineOrderId;
        [self.view addSubview:od.view];
        [od release];
        return NO;
    }
    
    //支付宝返回按钮处理
    BOOL alipaybackbtn = [requestString hasPrefix:@"http://m.yihaodian.com/alipaymerchant.action"];
    if (alipaybackbtn) {
        return NO;
    }
    
	/*NSArray * components = [requestString componentsSeparatedByString:@":"];
     if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"thestore"]) {
     MyStoreViewController *myStore=(MyStoreViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:3];
     [myStore orderDoneToOrderDetail:[NSNumber numberWithInt:[onlineOrderId intValue]]];
     return NO;
     }*/
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    if ([selectedGatewayid intValue] == ALIPAY_GATEWAY)
    //    {
    //        UIButton* selectedBtn = [self selectedSegButton];
    //        if (selectedBtn && selectedBtn.tag > SEG_BTN_TAG_LEFT)
    //        {
    //            [self excuteJsWithIndex:selectedBtn.tag - SEG_BTN_TAG_LEFT];
    //        }
    //    }
    
    //    NSString* html =[webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    //    if ([html rangeOfString:JS_SEARCH_STR].location != NSNotFound
    //        && [html rangeOfString:EXTRA_JS_STR].location == NSNotFound)
    //    {
    //        NSString* newHtmlStr = [self addJSFunctionToHtml:html];
    //        [webView loadHTMLString:newHtmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
    //        return;
    //    }
    
    
}


-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    isStop = YES;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    isStop = NO;
    if (!running) {
        [bankTableView reloadData];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate && !running) {
        isStop = NO;
        [bankTableView reloadData];
    } else {
        isStop = YES;
    }
}
#pragma mark 响应alert操作
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
	if (buttonIndex == 0) {
		switch (alertView.tag) {
			case ALERTVIEW_TAG_ONLINE_PAY_SUCCESS : {	// 在线支付是否成功
                if (myOrderView!=nil) {
                    [myOrderView release];
                }
				myOrderView = [[MyOrder alloc]initWithNibName:@"MyOrder" bundle:nil];
				NSNumber * number = [[NSNumber alloc] initWithInt:0];
				[[GlobalValue getGlobalValueInstance] setToOrderFromPage:number];
				[number release];
				CATransition *animation = [CATransition animation];
				animation.duration = 0.3f;
				animation.timingFunction = UIViewAnimationCurveEaseInOut;
				[animation setType:kCATransitionPush];
				[animation setSubtype: kCATransitionFromRight];
				[self.view.layer addAnimation:animation forKey:@"Reveal"];
				[self.view addSubview:myOrderView.view];
				break;
			}
			case ALERTVIEW_TAG_BANKLIST_NULL:
            {
				[self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
				[self removeSelf];
                
				[[NSNotificationCenter defaultCenter] postNotificationName:@"returnCheckOrderAfterNullBank" object:self];
				break;
			}
			default:
				break;
		}
	}
}
#pragma mark -
#pragma mark 建立线程
-(void)setUpThread{
	if (!running) {
		running = YES;
        //		[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowShowLoading" object:[NSNumber numberWithBool:YES]];
        [self showLoading:YES];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}
#pragma mark 开启线程
-(void)startThread {
	while (running) {
		@synchronized(self){
			NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
            switch (currentState) {
				case THREAD_STATUS_SUBMIT_ORDER_EX: {	// 在线支付订单提交
                    if (m_OrderServ!=nil) {
                        [m_OrderServ release];
                    }
					m_OrderServ = [[OrderService alloc] init];
                    @try {
						int result = [m_OrderServ submitOrderEx:[GlobalValue getGlobalValueInstance].token];
						[self performSelectorOnMainThread:@selector(showSubmitOrderExAlertView:)
											   withObject:[NSString stringWithFormat:@"%d", result] waitUntilDone:NO];
                    } @catch (NSException * e) {
                    } @finally {
                        [self stopThread];
                    }
					break;
				}
				case THREAD_STATUS_SAVE_PAYMENT:{	// 保存付款方式
                    if (m_OrderServ!=nil) {
                        [m_OrderServ release];
                    }
					m_OrderServ = [[OrderService alloc] init];
					int result = 0;
					@try {
                        
                        DebugLog(@"methodID========%d",methodID);
                        DebugLog(@"gatewayType========%d",gatewayType);
                        
						result = [m_OrderServ savePaymentToSessionOrder:[GlobalValue getGlobalValueInstance].token methodid:[NSNumber numberWithInt:methodID] gatewayid:[NSNumber numberWithInt:gatewayType]];
						[self performSelectorOnMainThread:@selector(showSavePaymentAlertView:)
											   withObject:[NSString stringWithFormat:@"%d", result] waitUntilDone:NO];
					}
					@catch (NSException * e) {
					}
					@finally {
                        // 需传入额外的methodID, gatewayId
                        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SavePayment extraPrama:[NSNumber numberWithInt:methodID], [NSNumber numberWithInt:gatewayType], nil]autorelease];
                        [DoTracking doJsTrackingWithParma:prama];
						[self stopThread];
					}
					break;
				}
				case THREAD_STATUS_GET_BANKLIST: {	// 获取支付平台列表
                    if (m_PayServ!=nil) {
                        [m_PayServ release];
                    }
					m_PayServ = [[PayService alloc] init];
                    
					@try
                    {
                        self.bankArray = [OTSUtility requestBanks];
                        if (isFromCheckOrder) {
                            [self performSelectorOnMainThread:@selector(initPaymentTableView) withObject:nil waitUntilDone:NO];
                        }else {
                            [self performSelectorOnMainThread:@selector(initBankTableView) withObject:nil waitUntilDone:NO];
                        }
					}
					@catch (NSException * e) {
					}
					@finally {
						[self stopThread];
					}
					break;
				}
                case THREAD_STATUS_SAVE_GATEWAY_ID: { //保存网关id到团购订单
                    if (m_GroupBuyServ!=nil) {
                        [m_GroupBuyServ release];
                    }
                    m_GroupBuyServ=[[GroupBuyService alloc] init];
                    @try {
                        int result=[m_GroupBuyServ saveGateWayToGrouponOrder:[GlobalValue getGlobalValueInstance].token orderId:orderId gatewayId:[NSNumber numberWithInt:gatewayType]];
                        if([GlobalValue getGlobalValueInstance].token == nil){
                            break;
						}
                        [self performSelectorOnMainThread:@selector(gotoOnlinePay:) withObject:[NSString stringWithFormat:@"%d", result] waitUntilDone:YES];
                        [NSThread sleepForTimeInterval:1];//防止用户点击
                    } @catch (NSException * e) {
                    } @finally {
                        [self stopThread];
                    }
                    break;
                }
                default:
                    break;
            }
			[pool release];
		}
	}
}
#pragma mark 停止线程
-(void)stopThread {
	running = NO;
	currentState = -1;
    [self hideLoading];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
}
#pragma mark 缓存图片
-(UIImage *)cachedImageForUrl:(NSURL *)url{
	id cachedObject=[cachedImage objectForKey:url];
	if (cachedObject==nil) {
        if (!isStop) {
            [cachedImage setObject:@"Loading..." forKey:url];
            ASIHTTPRequest* picRequest = [ASIHTTPRequest requestWithURL:url];
            picRequest.delegate=self;
            picRequest.didFinishSelector=@selector(didFinishRequestImage:);
            picRequest.didFailSelector=@selector(didFailRequestImage:);
            [queue addOperation:picRequest];
            [picRequests addObject:picRequest];
        }
	} else if (![cachedObject isKindOfClass:[UIImage class]]) {
		cachedObject=nil;
	}
	return cachedObject;
}
#pragma mark 加载图片成功
-(void)didFinishRequestImage:(ASIHTTPRequest *)request
{
	NSData * imageData = [request responseData];
	UIImage * image = [UIImage imageWithData:imageData];
	if (image != nil)
    {
		[cachedImage setObject:image forKey:request.url];
		[bankTableView reloadData];
        [payMentTableView reloadData];
	}
    
    [picRequests removeObject:request];
}

#pragma mark 加载图片失败
-(void)didFailRequestImage:(ASIHTTPRequest *)request
{
    [picRequests removeObject:request];
}


#pragma mark 显示在线支付是否成功提示框
-(void)showOnlinePayIsSuccessAlertView:(NSString *)result
{
	switch ([result intValue])
    {
		case 0:
			[OTSUtility showAlertView:nil alertMsg:@"支付失败!" alertTag:ALERTVIEW_TAG_ONLINE_PAY_SUCCESS];
			break;
		case 1:
			[OTSUtility showAlertView:nil alertMsg:@"支付成功!" alertTag:ALERTVIEW_TAG_ONLINE_PAY_SUCCESS];
			break;
		default:
			[OTSUtility showAlertView:nil alertMsg:@"网络异常,请检查网络配置..." alertTag:ALERTVIEW_TAG_ONLINE_PAY_SUCCESS];
			break;
	}
}


#pragma mark 显示在线支付提交订单提示框
-(void)showSubmitOrderExAlertView:(NSString *)result {
	switch ([result intValue]) {
		case 0:
			[OTSUtility showAlertView:nil alertMsg:@"提交失败!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -1:
			[OTSUtility showAlertView:nil alertMsg:@"用户没有登录!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -2:
			[OTSUtility showAlertView:nil alertMsg:@"订单限制!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -3:
			[OTSUtility showAlertView:nil alertMsg:@"抵用券出错!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -4:
			[OTSUtility showAlertView:nil alertMsg:@"产品售完!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -5:
			[OTSUtility showAlertView:nil alertMsg:@"库存出错!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -6:
			[OTSUtility showAlertView:nil alertMsg:@"订单验证错误!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -7:
			[OTSUtility showAlertView:nil alertMsg:@"dsp错误!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -8:
			[OTSUtility showAlertView:nil alertMsg:@"秒杀产品错误!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -9:
			[OTSUtility showAlertView:nil alertMsg:@"每日一销产品错误!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -10:
			[OTSUtility showAlertView:nil alertMsg:@"到达每日下单上限!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -11:
			[OTSUtility showAlertView:nil alertMsg:@"礼品错误!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -12:
			[OTSUtility showAlertView:nil alertMsg:@"账户金额不足!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -19:
			[OTSUtility showAlertView:nil alertMsg:@"订单不存在!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		default:
            if (onlineOrderId!=nil) {
                [onlineOrderId release];
            }
			onlineOrderId = [[NSNumber alloc] initWithLongLong:[result longLongValue]];
			[self toOnlinePayView];
			break;
	}
}
#pragma mark 显示保存付款方式提示框
-(void)showSavePaymentAlertView:(NSString *)result {
	switch ([result intValue]) {
		case 1:
            if (!isUseOnlinePay && isFromCheckOrder) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayMentWayChanged" object:m_payWayVO];
                [self backCheckOrderView];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePaymentMethod" object:m_BankVO];
                [self backCheckOrderView];
            }
            
			break;
		case 0:
			[OTSUtility showAlertView:nil alertMsg:@"操作失败!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		default:
			[OTSUtility showAlertView:nil alertMsg:@"网络异常,请检查网络配置..." alertTag:ALERTVIEW_TAG_OTHERS];
			break;
	}
}
-(void)gotoOnlinePay:(NSString *)result {
    switch ([result intValue]) {
		case 1: {
            //去在线支付页面
            onlineOrderId = [[NSNumber alloc] initWithLongLong:[self.orderId longLongValue]];
            [self toOnlinePayView];
            break;
        }
		case 0:
			[OTSUtility showAlertView:nil alertMsg:@"操作失败!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		default:
			[OTSUtility showAlertView:nil alertMsg:@"网络异常,请检查网络配置..." alertTag:ALERTVIEW_TAG_OTHERS];
			break;
	}
}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
-(void)releaseMyResoures
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doSubmitOrderEX" object:nil];
    
    for (ASIHTTPRequest* req in picRequests)
    {
        [req setDelegate:nil];
    }
    OTS_SAFE_RELEASE(picRequests);
    
    OTS_SAFE_RELEASE(payBtn);
    OTS_SAFE_RELEASE(bankTableView);
    
    OTS_SAFE_RELEASE(onlineWebView);
    OTS_SAFE_RELEASE(loadingMsgLabel);
    OTS_SAFE_RELEASE(cachedImage);
    OTS_SAFE_RELEASE(queue);
    
    OTS_SAFE_RELEASE(lastIndexPath);
    OTS_SAFE_RELEASE(selectedGatewayid);
    OTS_SAFE_RELEASE(gatewayId);
    OTS_SAFE_RELEASE(onlineOrderId);
    OTS_SAFE_RELEASE(orderId);
    OTS_SAFE_RELEASE(myOrderView);
    
    OTS_SAFE_RELEASE(m_OrderServ);
    OTS_SAFE_RELEASE(m_PayServ);
    OTS_SAFE_RELEASE(m_CartServ);
    OTS_SAFE_RELEASE(m_GroupBuyServ);
    OTS_SAFE_RELEASE(checkMarkView);
    OTS_SAFE_RELEASE(_bankArray);
    OTS_SAFE_RELEASE(_segCtrl);
    
    OTS_SAFE_RELEASE(_leftButton);
    OTS_SAFE_RELEASE(_midButton);
    OTS_SAFE_RELEASE(_rightButton);
    
    // release outlet
    OTS_SAFE_RELEASE(onlinePayView);
    OTS_SAFE_RELEASE(packets);
    OTS_SAFE_RELEASE(payMentTableView);
    OTS_SAFE_RELEASE(payMentWayExceptOnlinePayArr);
    
	// remove vc
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [viewController viewWillAppear:animated];
    
    if ([viewController isKindOfClass:[OnlinePay class]]) {
        done = NO;
        NSTimer *_busTimer = [NSTimer timerWithTimeInterval:.1f target:self selector:@selector(callsomethingelse) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_busTimer forMode:NSRunLoopCommonModes];
        do
        {
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
            
        }while (!done);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [navigationController dismissModalViewControllerAnimated:NO];
            [navigationController release];
        });
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewDidAppear:animated];
}

+(UIViewController*)getPresentingViewController:(UIViewController*)aViewController
{
    if (!aViewController) {
        DebugLog(@"viewController is nil");
        return nil;
    }
    UIViewController *presentingViewCtrl=nil;
    if ([aViewController parentViewController]) {
        //ios4
        presentingViewCtrl = aViewController.parentViewController;
    }else if([aViewController respondsToSelector:@selector(presentingViewController)]){
        //ios5
        if ([aViewController performSelector:@selector(presentingViewController)]) {
            presentingViewCtrl = [aViewController performSelector:@selector(presentingViewController)];
        }else{
            DebugLog(@"No presentingViewController");
        }
    }else{
        DebugLog(@"No presentingViewController");
    }
    return presentingViewCtrl;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
    [_checkingOrder release];
    [super dealloc];
}
@end