//
//  GroupBuyOrderDetail.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define THREAD_STATUS_GET_ORDER_DETAIL                  1
#define THREAD_STATUS_CONFIRM_RECEIVE                   2

#define TAG_PRODUCT_DETAIL_TABLEVIEW                    100
#define TAG_RECEIVER_TABLEVIEW                          101
#define TAG_PAYMENT_METHOD_TABLEVIEW                    102
#define TAG_DELIVERY_WAY_TABLEVIEW                      103
#define TAG_DELIVERY_TIME_TABLEVIEW                     104
#define TAG_ORDER_DETAIL_ALERTVIEW                      105
#define TAG_RECEIVE_CONFIRM_ALERTVIEW                   106
#define TAG_TOP_VIEW                                    107
#define ALIXPAY_CONFIRM                                 108
#define ALIXPAYGATE                                     421


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "GroupBuyOrderDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "GroupBuyService.h"
#import "GlobalValue.h"
#import "GoodReceiverVO.h"
#import "OnlinePay.h"
#import "PaymentMethodVO.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSAlertView.h"
#import "DataController.h"
#import "OTSOrderMfVC.h"
#import "OTSNaviAnimation.h"
#import "OTSUtility.h"
#import "OrderItemVO.h"
#import "OTSCopiableLabel.h"
#import "OTSChangePayButton.h"
#import "SDImageView+SDWebCache.h"

@interface GroupBuyOrderDetail ()
@property(retain) NSArray           *bankList;
@property(retain) UIButton          *m_TopBtn;
@property(retain) OrderV2           *orderDetailVO;     // orderVO in GrouponOrderVO doesnt has payment info, use this!
@end


@implementation GroupBuyOrderDetail

@synthesize m_OrderId
, m_TopBtn
, changePayBtn = _changePayBtn
, bankList = _bankList
, orderDetailVO = _orderDetailVO
, groupImageUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
-(void)changePaymentAction
{
    OnlinePay *onlinePay = [[[OnlinePay alloc] initWithNibName:@"OnlinePay" bundle:nil] autorelease];
    [onlinePay setIsFromOrder:NO];
    
    onlinePay.gatewayId = self.orderDetailVO.gateway;
    [onlinePay setOrderId:[m_OrderVO.orderVO orderId]];
    [onlinePay chooseBankCaller:self];
    
    [self pushVC:onlinePay animated:YES fullScreen:YES];
}

-(void)showNoAlixWallet
{
    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装支付宝客户端，或版本过低。请下载或更新支付宝客户端（耗时较长）。" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"重选", nil];
    [alert setTag:ALIXPAY_CONFIRM];
	[alert show];
	[alert release];
}


-(void)threadRequestSaveGateWay:(BankVO*)aBankVO
{
    BankVO *bankVO=[aBankVO retain];
    if (m_OrderVO)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading];
        });
        
        if ([self.orderDetailVO isGroupBuyOrder])
        {
            // change group buy order bank
            GroupBuyService* service = [[[GroupBuyService alloc] init] autorelease];
            
            int resultFlag = [service saveGateWayToGrouponOrder:[GlobalValue getGlobalValueInstance].token orderId:m_OrderVO.orderVO.orderId gatewayId:bankVO.gateway];
            
            if (resultFlag == 1)
            {
                m_OrderVO.orderVO.gateway = bankVO.gateway;
                self.orderDetailVO.gateway = bankVO.gateway;
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    OTSAlertView* alert = [[OTSAlertView alloc] initWithTitle:@"" message:@"保存支付方式失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [[alert autorelease] show];
                });
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateOrderDetail];
            
            [self hideLoading];
        });
    }
    [bankVO release];
}


-(void)handleNotifyPaymentChanged:(NSNotification*)aNotification
{
    NSArray* arr = [aNotification object];
    id caller = [arr objectAtIndex:0];
    if (caller == self)
    {
        BankVO* bankVO = (BankVO*)([arr objectAtIndex:1]);
        
        [self otsDetatchMemorySafeNewThreadSelector:@selector(threadRequestSaveGateWay:) toTarget:self withObject:bankVO];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifyPaymentChanged:) name:OTS_ONLINEPAY_BANK_CHANGED object:nil];
    
    [super viewDidLoad];
    
    [m_ScrollView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, ApplicationWidth, ApplicationHeight-NAVIGATION_BAR_HEIGHT-TABBAR_HEIGHT)];
    [m_DetailView setFrame:CGRectMake(0, 0, ApplicationWidth, ApplicationHeight-TABBAR_HEIGHT)];
    [m_DetailScrollView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, ApplicationWidth, ApplicationHeight-NAVIGATION_BAR_HEIGHT-TABBAR_HEIGHT)];
    
    if (self.isFullScreen)
    {
        [self strechViewToBottom:m_ScrollView];
        [self strechViewToBottom:m_DetailScrollView];
        m_DetailScrollView.backgroundColor = m_ScrollView.backgroundColor;
        [self strechViewToBottom:m_DetailView];
    }
    
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:@"CloseViewForEnterMyGroupBuy" object: nil];
    
    m_CurrentState=THREAD_STATUS_GET_ORDER_DETAIL;
    [self setUpThread];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)closeView
{
    if ([self view]!=nil && [[self view] superview]!=nil) {
        [self removeSelf];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderDetailReleased" object:self];
}

//返回
-(IBAction)returnBtnClicked:(id)sender
{
    UIView* superView = self.view.superview;
    if (superView && superView.tag == KOTSVCTag_OTSOrderSubmitOKVC) 
    {
        if ([m_OrderVO.orderVO.orderStatusForString isEqualToString:OTS_ORDER_VO_STATUS_STR_CANCELED])
        {
            [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
            [((OTSBaseViewController*)SharedDelegate.tabBarController.selectedViewController) removeAllMyVC];
            [SharedDelegate enterMyStoreWithUpdate:NO];
            
            MyOrder *myOrderVC = [[[MyOrder alloc]initWithNibName:@"MyOrder" bundle:nil] autorelease];
            [[GlobalValue getGlobalValueInstance] setToOrderFromPage:[NSNumber numberWithInt:0]];
            
            [((OTSBaseViewController*)SharedDelegate.tabBarController.selectedViewController) pushVC:myOrderVC animated:YES fullScreen:self.isFullScreen];
        }
        else
        {
            [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
            [self removeSelf];
        }
    }
    else
    {
        [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
        [self removeSelf];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderDetailReleased" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyOrder" object:nil];
}

//立即支付or物流查询
-(IBAction)topBtnClicked:(id)sender
{
    UIButton *button=sender;
    
    if ([[button titleForState:UIControlStateNormal] rangeOfString:@"支付"].location != NSNotFound)
    {
        //检查是否安装了支付宝客户端
        if (![self checkalixpayClient] && [m_OrderVO.orderVO.gateway integerValue] == ALIXPAYGATE) {
            [self showNoAlixWallet];
        }
        else
        {
            [self removeSubControllerClass:[OnlinePay class]];
            
            //    if ([[button titleForState:UIControlStateNormal] isEqualToString:@"立即支付"]) {
            //        [self removeSubControllerClass:[OnlinePay class]];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OnlinePayReleased" object:nil];
            OnlinePay *onlinePay = [[[OnlinePay alloc] initWithNibName:@"OnlinePay" bundle:nil] autorelease];
            onlinePay.isFullScreen = self.isFullScreen;
            onlinePay.isFromOrder = YES;
            [onlinePay setIsFromMyGroupon:YES];
            [onlinePay setOrderId:m_OrderId];
            onlinePay.gatewayId = m_OrderVO.orderVO.gateway;
            
            [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
            [self.view addSubview:onlinePay.view];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOnlinePayNull:) name:@"OnlinePayReleased" object:onlinePay];
        }
    } 
    else 
    {
        //物流查询
        OTSOrderMfVC* orderMfVC = [[[OTSOrderMfVC alloc] initWithNibName:@"OTSOrderMfVC" bundle:nil] autorelease];
        orderMfVC.theOrder = m_OrderVO.orderVO;
        [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
        [self.view addSubview:orderMfVC.view];
    }
}

//检查是否安装了支付宝客户端
-(BOOL) checkalixpayClient{
    
    BOOL ret ;
    
	NSURL *safepayUrl = [NSURL URLWithString:@"safepay://"];
    NSURL *alipayUrl = [NSURL URLWithString:@"alipay://"];
    
    if ([[UIApplication sharedApplication] canOpenURL:alipayUrl]) {
        
        ret = YES;
	}
    else if ([[UIApplication sharedApplication] canOpenURL:safepayUrl]) {
        
        ret = YES;
	}
	else {
        ret = NO;
	}
    
    return ret;
}

//确认收货
-(void)confirmBtnClicked:(id)sender
{
    UIAlertView *alert=[[OTSAlertView alloc]initWithTitle:nil message:@"您要确认收货吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert autorelease];
    [alert setTag:TAG_RECEIVE_CONFIRM_ALERTVIEW];
    [alert show];
}

-(void)doConfirmGoodsRecieved
{
    m_CurrentState=THREAD_STATUS_CONFIRM_RECEIVE;
    [self setUpThread];
}

-(void)updateOrderDetail
{
    [m_ScrollView setContentOffset:CGPointMake(0, 0)];
    //删除子view
    for (UIView *view in [m_ScrollView subviews]) {
        if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UIButton class]] || [view tag]==TAG_TOP_VIEW) {
            [view removeFromSuperview];
        }
    }
    
    //top view
    CGFloat height=133.0;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    [view setTag:TAG_TOP_VIEW];
    [view setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]];
    [m_ScrollView addSubview:view];
    [view release];
    
    //"订单编号："
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"订单编号："];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [view addSubview:label];
    [label release];
    //团购图标
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(85, 10, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"icon_tuan.png"]];
    [view addSubview:imageView];
    [imageView release];
    //订单编号
    label=[[OTSCopiableLabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [label setText:[[m_OrderVO orderVO] orderCode]];
    [view addSubview:label];
    [label release];
    //"包裹状态："
    label=[[UILabel alloc] initWithFrame:CGRectMake(10, 32, 75, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"包裹状态："];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [view addSubview:label];
    [label release];
    //包裹状态
    label=[[UILabel alloc] initWithFrame:CGRectMake(85, 32, 225, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[[m_OrderVO orderVO] orderStatusForString]];
    [label setFont:[UIFont boldSystemFontOfSize:15.0]];
    [label setTextColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
    [view addSubview:label];
    [label release];
    //下单时间
    NSString *orderTime=[[m_OrderVO orderVO] createOrderLocalTime];
    if ([orderTime length]>19) {
        orderTime=[orderTime substringWithRange:NSMakeRange(0, 19)];
    }
    label=[[UILabel alloc] initWithFrame:CGRectMake(10, 54, 160, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"%@ 下单",orderTime]];
    [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    [label setFont:[UIFont systemFontOfSize:13.0]];
    [view addSubview:label];
    [label release];
    
    // 立即支付or物流查询
    
    self.m_TopBtn = [[[UIButton alloc] initWithFrame:CGRectMake(23, 82, 274, 39)] autorelease];
    [m_TopBtn setBackgroundImage:[UIImage imageNamed:@"orange_long_btn.png"] forState:UIControlStateNormal];
    if ([[[m_OrderVO orderVO] orderStatusForString] isEqualToString:@"待结算"]) {
        [m_TopBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    } else {
        [m_TopBtn setTitle:@"物流查询" forState:UIControlStateNormal];
    }
    [[m_TopBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:18.0]];
    [m_TopBtn addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:m_TopBtn];
    
    // new change pay button
    m_TopBtn.hidden = YES;
    CGRect topBtnRc = m_TopBtn.frame;
    self.changePayBtn = [[[OTSChangePayButton alloc] initWithLongButton:YES] autorelease];
    _changePayBtn.frame = CGRectMake((self.view.frame.size.width - _changePayBtn.frame.size.width) / 2
                                     , topBtnRc.origin.y
                                     , _changePayBtn.frame.size.width
                                     , _changePayBtn.frame.size.height);
    [m_TopBtn.superview addSubview:_changePayBtn];
    [self.changePayBtn.payButton addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.changePayBtn.changePayButton addTarget:self action:@selector(changePaymentAction) forControlEvents:UIControlEventTouchUpInside];
    
    // “XX银行”支付 or 物流查询
    
    _changePayBtn.hidden = m_TopBtn.hidden = YES;
    _changePayBtn.payButton.enabled = _changePayBtn.changePayButton.enabled = m_TopBtn.enabled = YES;
    
    NSString* payMethodStr = m_OrderVO.orderVO.paymentMethodForString;
    NSString* orderStatusStr = m_OrderVO.orderVO.orderStatusForString;
    DebugLog(@"pay methord:%@, order status:%@", payMethodStr, orderStatusStr);
    if ([payMethodStr isEqualToString:@"网上支付"]
        && [orderStatusStr isEqualToString:@"待结算"])
    {
        NSString* bankStr = nil;
        
        for (BankVO* bank in self.bankList)
        {
            if ([bank.gateway intValue] == [self.orderDetailVO.gateway intValue])
            {
                bankStr = bank.bankname;
                break;
            }
        }
        
        bankStr = bankStr ? bankStr : @"立即";
        if ([bankStr rangeOfString:@"支付"].length == 0)
            [self.changePayBtn.payButton setTitle:[NSString stringWithFormat:@"%@支付", bankStr]
                                         forState:UIControlStateNormal];
        else
            [self.changePayBtn.payButton setTitle:[NSString stringWithFormat:@"%@", bankStr]
                                         forState:UIControlStateNormal];
        _changePayBtn.hidden = NO;
        //[m_TopBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    }
    else
    {
        //[self.changePayBtn.payButton setTitle:@"物流查询" forState:UIControlStateNormal];
        [m_TopBtn setTitle:@"物流查询" forState:UIControlStateNormal];
        m_TopBtn.hidden = NO;
    }
    
    
    
    
    //line
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 132.0, 320, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
    [view addSubview:lineView];
    [lineView release];
    
    //商品详情table view
    CGFloat yValue=133.0;
    height=224.0;
    if ([[[m_OrderVO grouponVO] isGrouponSerial] intValue]==1) {
        height+=20.0;
    }
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_PRODUCT_DETAIL_TABLEVIEW];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];
    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    yValue+=height;
    
    //收货人信息table view
    height=125.0;
    if ([[[m_OrderVO orderVO] goodReceiver] receiverMobile]!=nil && ![[[[m_OrderVO orderVO] goodReceiver] receiverMobile] isEqualToString:@""]) {
        height+=20.0;
    }
    if ([[[m_OrderVO orderVO] goodReceiver] receiverPhone]!=nil && ![[[[m_OrderVO orderVO] goodReceiver] receiverPhone] isEqualToString:@""]) {
        height+=20.0;
    }
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_RECEIVER_TABLEVIEW];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];
    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;

    [tableView release];
    yValue+=height;
    
    //支付方式
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 92) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_PAYMENT_METHOD_TABLEVIEW];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];

    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    yValue+=92.0;
    
    //送货方式
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 92) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_DELIVERY_WAY_TABLEVIEW];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];

    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    yValue+=92.0;
    
    //预计发货时间
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 106) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_DELIVERY_TIME_TABLEVIEW];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];

    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    yValue+=106.0;
    
    //确认收货
    if ([[[m_OrderVO orderVO] orderStatusForString] isEqualToString:@"已发货"]) {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(23, yValue+20, 274, 39)];
        [button setBackgroundImage:[UIImage imageNamed:@"orange_long_btn.png"] forState:UIControlStateNormal];
        [button setTitle:@"确认收货" forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:18.0]];
        [button addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [m_ScrollView addSubview:button];
        [button release];
        yValue+=60.0;
    }
    
    [m_ScrollView setContentSize:CGSizeMake(320, yValue+20)];
}

-(void)setOnlinePayNull:(NSNotification *)notification
{
    [self removeSubControllerClass:[OnlinePay class]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OnlinePayReleased" object:nil];
}

-(void)showError:(NSString *)error
{
    UIAlertView *alert = [[OTSAlertView alloc]initWithTitle:nil message:error delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert setTag:TAG_ORDER_DETAIL_ALERTVIEW];
    [alert show];
    [alert release];
    alert=nil;
}

//团购商品明细中返回
-(IBAction)detailReturnBtnClicked:(id)sender
{
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [m_DetailView removeFromSuperview];
}

#pragma mark 线程相关部分
//建立线程
-(void)setUpThread {
	if (!m_ThreadIsRunning) {
		m_ThreadIsRunning = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GrouponShowLoading" object:[NSNumber numberWithBool:YES]];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

//开启线程
-(void)startThread {
	while (m_ThreadIsRunning) {
		@synchronized(self) {
            switch (m_CurrentState) {
                    
                case THREAD_STATUS_GET_ORDER_DETAIL: {//团购获取订单详情
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    if (m_Service!=nil) {
                        [m_Service release];
                    }
                    m_Service=[[GroupBuyService alloc] init];
                    GrouponOrderVO *tempVO=nil;
                    @try {
						tempVO=[m_Service getMyGrouponOrder:[GlobalValue getGlobalValueInstance].token orderId:m_OrderId];
                    } @catch (NSException * e) {
                    } @finally {
                        if (m_OrderVO!=nil) {
                            [m_OrderVO release];
                        }
                        if (tempVO==nil || [tempVO isKindOfClass:[NSNull class]]) {
                            m_OrderVO=nil;
                        } else {
                            m_OrderVO=[tempVO retain];
                        }
                        if (m_OrderVO==nil) {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                        } 
                    }
                    
                    // retrieved bank list
                    if (m_OrderVO.orderVO)
                    {
                        OrderService* orderServ = [[[OrderService alloc] init] autorelease];
                        self.orderDetailVO = [orderServ getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token  orderId:m_OrderVO.orderVO.orderId];
                        
                        //                        PayService* payServ = [[[PayService alloc] init] autorelease];
                        //                        Page* page = [payServ getBankVOList:[GlobalValue getGlobalValueInstance].trader
                        //                                                       name:@"" type:[NSNumber numberWithInt:-1]
                        //                                                currentPage:[NSNumber numberWithInt:1]
                        //                                                   pageSize:[NSNumber numberWithInt:20]];
                        self.bankList = [OTSUtility requestBanks];
                        
                        [self performSelectorOnMainThread:@selector(updateOrderDetail) withObject:nil waitUntilDone:NO];
                    }
                    
                    [self stopThread];
                    
                    [pool drain];
                    break;
                }
                    
                case THREAD_STATUS_CONFIRM_RECEIVE: {//确认收货
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    if (m_Service!=nil) {
                        [m_Service release];
                    }
                    m_Service=[[GroupBuyService alloc] init];
                    int result;
                    @try {
						result=[m_Service updateOrderFinish:[GlobalValue getGlobalValueInstance].token orderId:m_OrderId];
                    } @catch (NSException * e) {
                    } @finally {
                        if (result==1) {
                            m_CurrentState=THREAD_STATUS_GET_ORDER_DETAIL;
                        } else {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                            [self stopThread];
                        }
                    }
                    [pool drain];
                    break;
                }
                default:
                    break;
            }
		}
	}
}

//停止线程
-(void)stopThread {
	m_ThreadIsRunning = NO;
	m_CurrentState = -1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GrouponHideLoading" object:nil];
}

#pragma mark alertView相关delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case TAG_ORDER_DETAIL_ALERTVIEW: {
            [self returnBtnClicked:nil];
            break;
        }
        case TAG_RECEIVE_CONFIRM_ALERTVIEW: {
            if (buttonIndex == 1) {
                [self doConfirmGoodsRecieved];
            }
            break;
        }
        case ALIXPAY_CONFIRM:{
            if (buttonIndex==1) {
                [self changePaymentAction];
            } else if (buttonIndex==0) {
                NSString * URLString = @"http://itunes.apple.com/cn/app/id333206289?mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    switch ([tableView tag]) {
		case TAG_PRODUCT_DETAIL_TABLEVIEW: {
            if ([indexPath row]==0) {
                [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
                [self.view addSubview:m_DetailView];
                
                if (self.isFullScreen)
                {
                    [self strechViewToBottom:m_DetailView];
                    [self strechViewToBottom:m_DetailScrollView];
                }
                
                GrouponVO *grouponVO=[m_OrderVO grouponVO];
                OrderItemVO *orderItemVO=[OTSUtility safeObjectAtIndex:0 inArray:[[m_OrderVO orderVO] orderItemList]];
                //团购商品图片
//                NSString *fileName=[NSString stringWithFormat:@"group_mid_%@",[grouponVO nid]];
//                NSData *data=[DataController applicationDataFromFile:fileName];
//                UIImage *image;
//                if (data!=nil) {
//                    image=[UIImage imageWithData:data];
//                } else {
//                    image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[grouponVO middleImageUrl]]]];
//                    if (image==nil) {
//                        image=[UIImage imageNamed:@"defaultimg320x120.png"];
//                    }
//                }
                NSString* imageUrl=[grouponVO middleImageUrl];
                if (imageUrl==nil||!imageUrl.length) {
                    imageUrl=orderItemVO.product.miniDefaultProductUrl;
                }
                UIImageView *imageView=(UIImageView *)[m_DetailScrollView viewWithTag:1];
//                [imageView setImage:image];
                [imageView setImageWithURL:[NSURL URLWithString:imageUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"defaultimg320x120.png"]];
                //团购名称
                CGFloat yValue=209.0;
                NSString *string=[grouponVO name];
                CGFloat stringWidth=[string sizeWithFont:[UIFont systemFontOfSize:15.0]].width;
                NSInteger lineCount=stringWidth/223.0;
                if (stringWidth/223.0>lineCount) {
                    lineCount++;
                }
                UILabel *label=(UILabel *)[m_DetailScrollView viewWithTag:2];
                [label setNumberOfLines:lineCount];
                [label setText:string];
                CGRect rect=[label frame];
                rect.size.height=20.0*lineCount;
                [label setFrame:rect];
                yValue+=20.0*lineCount+10.0;
                //"商品名称："
                label=(UILabel *)[m_DetailScrollView viewWithTag:3];
                rect=[label frame];
                rect.origin.y=yValue;
                [label setFrame:rect];
                //商品名称
                string=[[orderItemVO product] cnName];
                stringWidth=[string sizeWithFont:[UIFont systemFontOfSize:15.0]].width;
                lineCount=stringWidth/223.0;
                if (stringWidth/223.0>lineCount) {
                    lineCount++;
                }
                label=(UILabel *)[m_DetailScrollView viewWithTag:4];
                [label setNumberOfLines:lineCount];
                rect=[label frame];
                rect.origin.y=yValue;
                rect.size.height=20.0*lineCount;
                [label setFrame:rect];
                [label setText:string];
                yValue+=20.0*lineCount+10.0;
                //"团购价格："
                label=(UILabel *)[m_DetailScrollView viewWithTag:5];
                rect=[label frame];
                rect.origin.y=yValue;
                [label setFrame:rect];
                //团购价格
                label=(UILabel *)[m_DetailScrollView viewWithTag:6];
                rect=[label frame];
                rect.origin.y=yValue;
                [label setFrame:rect];
                [label setText:[NSString stringWithFormat:@"￥%.2f",[[grouponVO price] floatValue]]];
                yValue+=30.0;
                
                [m_DetailScrollView setContentSize:CGSizeMake(320, yValue+10.0)];
                //让scrollview滑动
                if (yValue+10.0<=[m_DetailScrollView frame].size.height) {
                    [m_DetailScrollView setContentSize:CGSizeMake(320, [m_DetailScrollView frame].size.height+1)];
                }
            }
            break;
        }
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ([tableView tag]) {
		case TAG_PRODUCT_DETAIL_TABLEVIEW:
			return 3;
			break;
		case TAG_RECEIVER_TABLEVIEW:
			return 1;
			break;
		case TAG_PAYMENT_METHOD_TABLEVIEW:
			return 1;
			break;
        case TAG_DELIVERY_WAY_TABLEVIEW:
			return 1;
			break;
        case TAG_DELIVERY_TIME_TABLEVIEW:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    GrouponVO *grouponVO=[m_OrderVO grouponVO];
    OrderItemVO *orderItemVO=[OTSUtility safeObjectAtIndex:0 inArray:[[m_OrderVO orderVO] orderItemList]];
    switch ([tableView tag]) {
		case TAG_PRODUCT_DETAIL_TABLEVIEW: {
            if ([indexPath row]==0) {
                //商品图片
//                NSString *fileName=[NSString stringWithFormat:@"group_mini_%@",[grouponVO nid]];
//                NSData *data=[DataController applicationDataFromFile:fileName];
//                UIImage *image;
//                if (data!=nil) {
//                    image=[UIImage imageWithData:data];
//                } else {
//                    NSData *netData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[grouponVO miniImageUrl]]];
//                    if (netData!=nil) {
//                        image=[UIImage imageWithData:netData];
//                        [DataController writeApplicationData:netData name:fileName];
//                    } else {
//                        image=[UIImage imageNamed:@"defaultimg55.png"];
//                    }
//                }
                UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 40, 40)];
                NSString* imageStr=nil;
                if (grouponVO.miniImageUrl!=nil&&grouponVO.miniImageUrl.length) {
                    imageStr=grouponVO.miniImageUrl;
                }else{
                    imageStr=groupImageUrl;
                }
                [imageView setImageWithURL:[NSURL URLWithString:imageStr] refreshCache:NO placeholderImage:[UIImage imageNamed:@"defaultimg55.png"]];
                [cell addSubview:imageView];
                [imageView release];
                //商品名称
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(73, 10, 200, 44)];
                [label setText:[[orderItemVO product] cnName]];
                [label setNumberOfLines:2];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                
                cell.selectionStyle=UITableViewCellSelectionStyleBlue;
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            } else if ([indexPath row]==1) {
                CGFloat yValue=10.0;
                //您选择了
                if ([[[m_OrderVO grouponVO] isGrouponSerial] intValue]==1) {
                    NSString *color=[[grouponVO grouponSerialVO] productColor];
                    NSString *size=[[grouponVO grouponSerialVO] productSize];
                    
                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, yValue, 110, 20)];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setFont:[UIFont systemFontOfSize:15.0]];
                    [label setText:@"您选择了："];
                    [cell addSubview:label];
                    [label release];
                    
                    label=[[UILabel alloc] initWithFrame:CGRectMake(140, yValue, 160, 20)];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setFont:[UIFont systemFontOfSize:15.0]];
                    [label setText:[NSString stringWithFormat:@"%@/%@",color,size]];
                    [label setTextAlignment:NSTextAlignmentRight];
                    [cell addSubview:label];
                    [label release];
                    yValue+=20.0;
                }
                
                //商品数量
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, yValue, 110, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setText:@"商品数量："];
                [cell addSubview:label];
                [label release];
                
                label=[[UILabel alloc] initWithFrame:CGRectMake(140, yValue, 160, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setText:[NSString stringWithFormat:@"%@件",[grouponVO productNumber]]];
                [label setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:label];
                [label release];
                yValue+=20.0;
                
                //团购价格
                label=[[UILabel alloc] initWithFrame:CGRectMake(20, yValue, 110, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setText:@"团购价格："];
                [cell addSubview:label];
                [label release];
                
                label=[[UILabel alloc] initWithFrame:CGRectMake(140, yValue, 160, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setText:[NSString stringWithFormat:@"￥%.2f",[[grouponVO price] floatValue]]];
                [label setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:label];
                [label release];
                yValue+=20.0;
                
                //商品总金额
                label=[[UILabel alloc] initWithFrame:CGRectMake(20, yValue, 110, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setText:@"商品总金额："];
                [cell addSubview:label];
                [label release];
                
                label=[[UILabel alloc] initWithFrame:CGRectMake(140, yValue, 160, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setText:[NSString stringWithFormat:@"￥%.2f",[[grouponVO price] floatValue]*[[grouponVO productNumber] intValue]]];
                [label setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:label];
                [label release];
                yValue+=20.0;
                
                //账户余额抵扣
                label=[[UILabel alloc] initWithFrame:CGRectMake(20, yValue, 110, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setText:@"账户余额抵扣："];
                [cell addSubview:label];
                [label release];
                
                label=[[UILabel alloc] initWithFrame:CGRectMake(160, 70, 20, 20)];
                [label setText:@"－"];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:14.0]];
                [cell addSubview:label];
                [label release];
                
                label=[[UILabel alloc] initWithFrame:CGRectMake(180, yValue, 120, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setText:[NSString stringWithFormat:@"￥%.2f",[[[m_OrderVO orderVO] accountAmount] floatValue]]];
                [label setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:label];
                [label release];
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.accessoryType=UITableViewCellAccessoryNone;
            } else {
                //还需支付金额
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 110, 44)];
                [label setText:@"还需支付金额："];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                
                label=[[UILabel alloc] initWithFrame:CGRectMake(140, 0, 160, 44)];
                [label setText:[NSString stringWithFormat:@"￥%.2f",[[[m_OrderVO orderVO] paymentAccount] floatValue]]];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:label];
                [label release];
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
			break;
        }
		case TAG_RECEIVER_TABLEVIEW: {
            GoodReceiverVO *goodReciverVO=[[m_OrderVO orderVO] goodReceiver];
            if (goodReciverVO==nil) {//无地址时
                [[cell textLabel] setText:@"请选择收货地址"];
                [[cell textLabel] setTextColor:[UIColor blackColor]];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            } else {
                CGFloat yValue=5.0;
                //收货人
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
                [label setText:goodReciverVO.receiveName];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor blackColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                yValue+=22.0;
                //送货地址
                label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
                [label setText:goodReciverVO.address1];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor blackColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                yValue+=22.0;
                //省份、城市、地区
                label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
                if ([goodReciverVO.provinceName isEqualToString:@"上海"]) {//上海只显示两级区域
                    [label setText:[NSString stringWithFormat:@"%@ %@",goodReciverVO.provinceName,goodReciverVO.cityName]];
                } else {
                    [label setText:[NSString stringWithFormat:@"%@ %@ %@",goodReciverVO.provinceName, goodReciverVO.cityName,goodReciverVO.countyName]];
                }
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor blackColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                yValue+=22.0;
                //获取手机信息
                if (goodReciverVO.receiverMobile!=nil && ![[goodReciverVO receiverMobile] isEqualToString:@""]) {
                    label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
                    [label setText:goodReciverVO.receiverMobile];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setTextColor:[UIColor blackColor]];
                    [label setFont:[UIFont systemFontOfSize:15.0]];
                    [cell addSubview:label];
                    [label release];
                    yValue+=22.0;
                }
                //获取电话信息
                if (goodReciverVO.receiverPhone!=nil && ![[goodReciverVO receiverPhone] isEqualToString:@""]) {
                    label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
                    [label setText:goodReciverVO.receiverPhone];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setTextColor:[UIColor blackColor]];
                    [label setFont:[UIFont systemFontOfSize:15.0]];
                    [cell addSubview:label];
                    [label release];
                }
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
			break;
        }
		case TAG_PAYMENT_METHOD_TABLEVIEW: {
            [[cell textLabel] setText:[[m_OrderVO orderVO] paymentMethodForString]];
            [[cell textLabel] setTextColor:[UIColor blackColor]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
			break;
        }
        case TAG_DELIVERY_WAY_TABLEVIEW: {
            [[cell textLabel] setText:[[m_OrderVO orderVO] deliveryMethodForString]];
            [[cell textLabel] setTextColor:[UIColor blackColor]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
			break;
        }
        case TAG_DELIVERY_TIME_TABLEVIEW: {
            NSString *deliverStartDate=[[m_OrderVO orderVO] deliverStartDate];
            NSString *deliverEndDate=[[m_OrderVO orderVO] deliverEndDate];
            if ([deliverStartDate length]>=10) {
                deliverStartDate=[deliverStartDate substringWithRange:NSMakeRange(0, 10)];
            }
            if ([deliverEndDate length]>=10) {
                deliverEndDate=[deliverEndDate substringWithRange:NSMakeRange(0, 10)];
            }
            
            [[cell textLabel] setText:[NSString stringWithFormat:@"%@到%@",deliverStartDate,deliverEndDate]];
            [[cell textLabel] setTextColor:[UIColor blackColor]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
			break;
        }
		default:
			break;
	}
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([tableView tag]) {
		case TAG_PRODUCT_DETAIL_TABLEVIEW: {
            if ([indexPath row]==0) {
                return 64.0;
            } else if ([indexPath row]==1) {
                CGFloat height=101.0;
                if ([[[m_OrderVO grouponVO] isGrouponSerial] intValue]==1) {
                    height+=20.0;
                }
                return height;
            } else {
                return 44.0;
            }
			break;
        }
		case TAG_RECEIVER_TABLEVIEW: {
			CGFloat height=77.0;
            if ([[[m_OrderVO orderVO] goodReceiver] receiverMobile]!=nil && ![[[[m_OrderVO orderVO] goodReceiver] receiverMobile] isEqualToString:@""]) {
                height+=20.0;
            }
            if ([[[m_OrderVO orderVO] goodReceiver] receiverPhone]!=nil && ![[[[m_OrderVO orderVO] goodReceiver] receiverPhone] isEqualToString:@""]) {
                height+=20.0;
            }
            return height;
			break;
        }
		case TAG_PAYMENT_METHOD_TABLEVIEW:
			return 44.0;
			break;
        case TAG_DELIVERY_WAY_TABLEVIEW:
			return 44.0;
			break;
        case TAG_DELIVERY_TIME_TABLEVIEW:
			return 58.0;
			break;
		default:
			return 0.0;
			break;
	}
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ([tableView tag]) {
		case TAG_PRODUCT_DETAIL_TABLEVIEW:
			return nil;
			break;
		case TAG_RECEIVER_TABLEVIEW:
			return @"收货人信息";
			break;
		case TAG_PAYMENT_METHOD_TABLEVIEW:
			return @"支付方式";
			break;
        case TAG_DELIVERY_WAY_TABLEVIEW:
			return @"送货方式";
			break;
        case TAG_DELIVERY_TIME_TABLEVIEW:
			return @"预计发货时间";
			break;
		default:
			return nil;
			break;
	}
}

//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}



#pragma mark -
-(void)releaseMyResoures
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OnlinePayReleased" object:nil];
    
    OTS_SAFE_RELEASE(groupImageUrl);
    OTS_SAFE_RELEASE(m_OrderId);
    OTS_SAFE_RELEASE(m_OrderVO);
    OTS_SAFE_RELEASE(m_Service);
    
    // release outlet
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_DetailView);
    OTS_SAFE_RELEASE(m_DetailScrollView);
    OTS_SAFE_RELEASE(m_TopBtn);
    
    OTS_SAFE_RELEASE(_changePayBtn);
    OTS_SAFE_RELEASE(_bankList);
    OTS_SAFE_RELEASE(_orderDetailVO);
    
    
	// remove vc
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
    [super dealloc];
}
@end
