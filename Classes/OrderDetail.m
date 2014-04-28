 //
//  OrderDetail.m
//  TheStoreApp
//
//  Created by jiming huang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define THREAD_STATUS_GET_ORDER_DETAIL  1
#define THREAD_STATUS_CANCEL_ORDER  2
#define THREAD_STATUS_REBUY_ORDER   3
#define THREAD_STATUS_ADD_CART  4

#define VIEW_TAG_CANCEL_ORDER_BUTTON    1

#define ALERTVIEW_TAG_CANCEL_ORDER_CONFIRM  1
#define ALERTVIEW_TAG_REBUY_CONFIRM 2
#define ALIXPAY_CONFIRM             101
#define ALIXPAYGATE                     421

#import "OrderDetail.h"
#import "OrderService.h"
#import "GlobalValue.h"
#import "AlertView.h"
#import "OTSNaviAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderItemVO.h"
#import "ProductVO.h"
#import "DataController.h"
#import "InvoiceVO.h"
#import "OTSAlertView.h"
#import "OnlinePay.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSOrderMfVC.h"
#import "DoTracking.h"
#import "ErrorStrings.h"
#import "OTSChangePayButton.h"
#import "OTSOnlinePayNotifier.h"
#import "OTSProductDetail.h"
#import "OTSImageView.h"
#import "QuitOrderViewController.h"

#import "YWOrderService.h"
#import "OrderDetailInfo.h"
#import "OrderContact.h"
#import "InvoiceInfo.h"
#import "AlixPay.h"
#import "OrderPackageInfo.h"
#import "MyOrder.h"
#import "MyOrderInfo.h"
#import "MobClick.h"
#import <AlipaySDK/Alipay.h>
#import "JSONKit.h"

@interface OrderDetail ()
@property(retain)NSArray        *bankList;
@end

@implementation OrderDetail
@synthesize m_OrderId//传入参数，订单id
, changePayBtn = _changePayBtn
, bankList = _bankList;

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
    [onlinePay setGatewayId:[m_OrderV2 gateway]];
    [onlinePay setOrderId:[m_OrderV2 orderId]];
    [onlinePay chooseBankCaller:self];
    
    [self pushVC:onlinePay animated:YES fullScreen:YES];
}

-(void)showNoAlixWallet
{
    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装支付宝客户端，或版本过低。建议您下载或更新支付宝客户端。" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"取消", nil];
    [alert setTag:ALIXPAY_CONFIRM];
	[alert show];
	[alert release];
}

-(void)threadRequestSaveGateWay:(BankVO*)aBankVO
{
    BankVO *bankVO=[aBankVO retain];
    if (m_OrderV2)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading];
        });
        
        if (![m_OrderV2 isGroupBuyOrder])
        {
            // change normal order bank
            OrderService* service = [[[OrderService alloc] init] autorelease];
            
            SaveGateWayToOrderResult *result = [service saveGateWayToOrder:[GlobalValue getGlobalValueInstance].token orderId:m_OrderV2.orderId gateWayId:bankVO.gateway];
            
            
            if (result && ![result isKindOfClass:[NSNull class]])
            {
                if ([result.resultCode intValue] == 1)
                {//成功
                    m_OrderV2.gateway = bankVO.gateway;
                    m_RefreshMyOrder = YES; // 退出时刷新my order
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(showError:) withObject:[result errorInfo] waitUntilDone:NO];
                }
            }
            else
            {
                [self performSelectorOnMainThread:@selector(showError:) withObject:@"保存支付方式失败" waitUntilDone:NO];
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
    
    m_DetailView.frame = self.view.frame;
    
    CGRect theRc = m_ScrollView.frame;
    theRc.origin.y = OTS_IPHONE_NAVI_BAR_HEIGHT;
    m_ScrollView.frame = theRc;
    m_DetailScrollView.frame = theRc;
    
    [self strechViewToBottom:m_ScrollView];
    [self strechViewToBottom:m_DetailScrollView];
    
    // change button style, create new button and hide the original
    m_TopBtn.hidden = YES;
    CGRect topBtnRc = m_TopBtn.frame;
    self.changePayBtn = [[[OTSChangePayButton alloc] initWithLongButton:YES] autorelease];
    _changePayBtn.frame = CGRectMake((self.view.frame.size.width - _changePayBtn.frame.size.width) / 2
                                     , topBtnRc.origin.y
                                     , _changePayBtn.frame.size.width
                                     , _changePayBtn.frame.size.height);
    [m_TopBtn.superview addSubview:_changePayBtn];
    [self.changePayBtn.payButton addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.changePayBtn.changePayButton addTarget:self action:@selector(changePaymentAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton* but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.backgroundColor=[UIColor whiteColor];
    but.frame=CGRectMake(320-60, 0, 60, 44);
    
    [self initOrderDetail];
}

//初始化订单详情
-(void)initOrderDetail
{
    //获取订单详情
    m_ThreadStatus=THREAD_STATUS_GET_ORDER_DETAIL;
    [self setUpThread:YES];
}

//刷新订单详情
-(void)updateOrderDetail
{
    for (UIView *view in [m_ScrollView subviews])
    {
        if ([view isKindOfClass:[UITableView class]] || ([view isKindOfClass:[UIButton class]]&&[view tag]==VIEW_TAG_CANCEL_ORDER_BUTTON)) {
            [view removeFromSuperview];
        }
    }
    [m_ScrollView setHidden:NO];
    [m_ScrollView setContentOffset:CGPointMake(0, 0)];
    //订单编号
    [m_OrderCodeLabel setText:[NSString stringWithFormat:@"订单编号：%@",_orderDetail.orderId]];
    //包裹数量
    [m_PackageCountLabel setText:[NSString stringWithFormat:@"%d个包裹",[_orderDetail.orderPackageArr count]]];
    //下单时间

    [m_OrderTimeLabel setText:[NSString stringWithFormat:@"%@ 下单",_orderDetail.orderDate]];
    
    _changePayBtn.hidden = m_TopBtn.hidden = YES;
    _changePayBtn.payButton.enabled = _changePayBtn.changePayButton.enabled = m_TopBtn.enabled = YES;
    

    
    if ([_orderDetail needPayByAlipay])
    {
        [self.changePayBtn.payButton setTitle:@"支付宝支付" forState:UIControlStateNormal];
        _changePayBtn.hidden = NO;
    }

    //包裹
    CGFloat yValue=115.0;
    int i;
    for (i=0; i<[_orderDetail.orderPackageArr count]; i++)
    {
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 155) style:UITableViewStyleGrouped];
        [tableView setTag:100+i];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setBackgroundView:nil];
        [tableView setScrollEnabled:NO];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [m_ScrollView addSubview:tableView];
        [tableView release];
        yValue+=155.0;
    }
    //金额相关
    
    //为了适配iOS7
    if (ISIOS7)
    {
        yValue -= 20;
    }
    
    m_MoneyTable=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 199+20+10) style:UITableViewStyleGrouped];
    [m_MoneyTable setBackgroundColor:[UIColor clearColor]];
    [m_MoneyTable setBackgroundView:nil];
    [m_MoneyTable setScrollEnabled:NO];
    [m_MoneyTable setDelegate:self];
    [m_MoneyTable setDataSource:self];
    //为了适配ios7
    if (ISIOS7)
    {
        m_MoneyTable.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,m_MoneyTable.bounds.size.width, 1.f)] autorelease];
    }
    
    [m_ScrollView addSubview:m_MoneyTable];
    [m_MoneyTable release];
    yValue+=199.0+20;
    
    //收货人信息
    //为了适配ios7
    if (ISIOS7)
    {
        yValue += 30;
    }
    CGFloat height=125.0;
    if (_orderDetail.orderContact.sendContactMobile != nil && _orderDetail.orderContact.sendContactMobile.length > 0    /*[[m_OrderV2 goodReceiver] receiverMobile]!=nil && ![[[m_OrderV2 goodReceiver] receiverMobile] isEqualToString:@""]*/) {
        height+=20.0;
    }
    if (_orderDetail.orderContact.sendContactPhone != nil && _orderDetail.orderContact.sendContactPhone.length >0/*[[m_OrderV2 goodReceiver] receiverPhone]!=nil && ![[[m_OrderV2 goodReceiver] receiverPhone] isEqualToString:@""]*/) {
        height+=20.0;
    }
    m_ReceiverTable=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
    [m_ReceiverTable setBackgroundColor:[UIColor clearColor]];
    [m_ReceiverTable setBackgroundView:nil];
    [m_ReceiverTable setScrollEnabled:NO];
    [m_ReceiverTable setDelegate:self];
    [m_ReceiverTable setDataSource:self];

    [m_ScrollView addSubview:m_ReceiverTable];
    [m_ReceiverTable release];
    yValue+=height;
    //支付方式
    m_PaymentTable=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 92) style:UITableViewStyleGrouped];
    [m_PaymentTable setBackgroundColor:[UIColor clearColor]];
    [m_PaymentTable setBackgroundView:nil];
    [m_PaymentTable setScrollEnabled:NO];
    [m_PaymentTable setDelegate:self];
    [m_PaymentTable setDataSource:self];

    [m_ScrollView addSubview:m_PaymentTable];
    [m_PaymentTable release];
    yValue+=92.0;

    //发票信息
    if (_orderDetail.invoiceInfo != nil /*[m_OrderV2 invoiceList]!=nil && [[m_OrderV2 invoiceList] count]>0*/)
    {
//        InvoiceVO *invoiceVO=[[m_OrderV2 invoiceList] objectAtIndex:0];
        if (_orderDetail.invoiceInfo.invoiceTypeId != kYaoInvoiceHeadNone /*[[invoiceVO type] intValue]!= -1*/)
        {
            m_InvoiceTable=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 127) style:UITableViewStyleGrouped];
            yValue+=127.0;
        }
        else
        {
            m_InvoiceTable=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 92) style:UITableViewStyleGrouped];
            yValue+=92.0;
        }
    } else {
        m_InvoiceTable=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 92) style:UITableViewStyleGrouped];
        yValue+=92.0;
    }
    [m_InvoiceTable setBackgroundColor:[UIColor clearColor]];
    [m_InvoiceTable setBackgroundView:nil];
    [m_InvoiceTable setScrollEnabled:NO];
    [m_InvoiceTable setDelegate:self];
    [m_InvoiceTable setDataSource:self];

    [m_ScrollView addSubview:m_InvoiceTable];
    [m_InvoiceTable release];
    
    if ([_orderDetail canBeCanceled]  /*[[m_OrderV2 orderStatusForString] isEqualToString:@"待结算"] || [[m_OrderV2 orderStatusForString] isEqualToString:@"待处理"]*/)
    {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(220, yValue+20, 90, 30)];
        [button setTag:VIEW_TAG_CANCEL_ORDER_BUTTON];
        [button setBackgroundImage:[UIImage imageNamed:@"gray_btn.png"] forState:UIControlStateNormal];
        [button setTitle:@"取消订单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:16.0]];
        [button addTarget:self action:@selector(cancelOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [m_ScrollView addSubview:button];
        [button release];
        yValue+=50.0;
    }
    
    [m_ScrollView setContentSize:CGSizeMake(320, yValue+20)];
}

-(void)showError:(NSString *)error
{
    [AlertView showAlertView:nil alertMsg:error buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}

//-(IBAction)quitOrderClicked:(id)sender{
//    UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"请选择服务种类" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退货",@"换货期限已于13年13月11日过期", nil];
//    [sheet showInView:self.view];
//    for (UIButton* btn in sheet.subviews) {
//        if ([btn isKindOfClass:[UIButton class]]) {
//            if (btn.tag==2) {
//                btn.enabled=NO;
//            }
//        }
//    }
//    [sheet release];
//}
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
//    if (buttonIndex==0) {
//        QuitOrderViewController* quitVc=[[[QuitOrderViewController alloc] init] autorelease];
//        quitVc.isGroup=NO;
//        [self pushVC:quitVc animated:YES fullScreen:YES];
//    }
//}
//返回
-(IBAction)returnBtnClicked:(id)sender
{
    UIView* superView = self.view.superview;
    if (superView && superView.tag == KOTSVCTag_OTSOrderSubmitOKVC)
    {
        if ([m_OrderV2.orderStatusForString isEqualToString:OTS_ORDER_VO_STATUS_STR_CANCELED])
        {
            [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
            [((OTSBaseViewController*)SharedDelegate.tabBarController.selectedViewController) removeAllMyVC];
            [SharedDelegate enterMyStoreWithUpdate:NO];
            
            MyOrder *myOrderVC = [[[MyOrder alloc]initWithNibName:@"MyOrder" bundle:nil] autorelease];
            [[GlobalValue getGlobalValueInstance] setToOrderFromPage:[NSNumber numberWithInt:0]];
            
            [((OTSBaseViewController*)SharedDelegate.tabBarController.selectedViewController) pushVC:myOrderVC animated:YES];
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
    
    
    if (m_RefreshMyOrder)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyOrder" object:nil];
    }
}

//立即支付or重新购买
-(IBAction)topBtnClicked:(id)sender
{
    UIButton *button=sender;
    NSString *title=[button titleForState:UIControlStateNormal];
    if ([title rangeOfString:@"支付"].location != NSNotFound)
    {
        //检查是否安装了支付宝客户端
//        if (![self checkalixpayClient] && [[m_OrderV2 gateway] integerValue] == ALIXPAYGATE)
//        {
//            [self showNoAlixWallet];
//        }
//        else
//        {
            YWOrderService *orderSer = [[YWOrderService alloc] init];
            NSString *signStr = [orderSer getOrderAlipaySign:_orderDetail.orderId];
            DebugLog(@"支付宝签名: %@",signStr);
            //支付宝支付
            NSString *appScheme = @"yhyw";
            //全局记录状态
            [[GlobalValue getGlobalValueInstance] setIsFromMyOrder:YES];
            //获取安全支付单例并调用安全支付接口
//            AlixPay * alixpay = [AlixPay shared];
//            [alixpay pay:signStr applicationScheme:appScheme];
            
            [[Alipay defaultService] pay:signStr From:appScheme CallbackBlock:^(NSString *resultString) {
                DebugLog(@"result = %@",resultString);
                
                NSDictionary *resultDic = [[resultString dataUsingEncoding:NSUTF8StringEncoding]  objectFromJSONData];
                
                NSString *status = resultDic[@"ResultStatus"];
                if ([status intValue] == 9000)
                {
                    [self initOrderDetail];
                }

            }];
            
            
            [orderSer release];
            
//        }
    }
    else if ([title isEqualToString:@"重新购买"])
    {
        UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"重新购买提示" message:@"确定要重新购买该订单中的商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setTag:ALERTVIEW_TAG_REBUY_CONFIRM];
        [alert show];
        [alert release];
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

//取消订单
-(void)cancelOrderBtnClicked:(id)sender
{
    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"取消订单提示" message:@"确定要取消该订单吗？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert setTag:ALERTVIEW_TAG_CANCEL_ORDER_CONFIRM];
	[alert show];
	[alert release];
}

//重新购买结果
-(void)showRebuyOrderResult:(NSNumber *)resultNum
{
    int result=[resultNum intValue];
    if (result==1) {
        
        [SharedDelegate enterCartWithUpdate:YES];
    } else if (result==0) {
        [self showError:@"重新购买失败！"];
    } else {
        [self showError:@"网络异常，请检查网络配置..."];
    }
}

-(IBAction)detailReturnBtnClicked:(id)sender
{
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"reveal"];
    [m_DetailView removeFromSuperview];
}

//初始化商品明细
-(void)initDetailView
{
    m_AnimationStop=YES;
    
    
    OrderPackageInfo *pack = _orderDetail.orderPackageArr[_selectedPackageIndex];
    
    //商品金额
    [m_DetailTotalMoneyLabel setText:[NSString stringWithFormat:@"￥%.2f",[pack.allGoodsMoney floatValue]]];
    //商品件数
    int totalCount=0;
    
    for (OrderProductDetail *product in pack.packageProductArr)
    {
        totalCount += [product.productCount intValue];
    }
    [m_DetailCountLabel setText:[NSString stringWithFormat:@"共%d件",totalCount]];
    //商品列表
    CGFloat yValue=41.0;
    int count=[pack.packageProductArr count];
    if (count>0)
    {
        [m_DetailTable setFrame:CGRectMake(0, yValue, 320, 85.0*count)];
        [m_DetailTable reloadData];
    }
    yValue+=85.0*count;
    //赠品
    for (UIView *view in [m_DetailGiftScrollView subviews])
    {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    BOOL hasGift=NO;
    CGFloat xValue=0.0;
    for (OrderItemVO *orderItemVO in [m_CurrentSubOrder orderItemList])
    {
        ProductVO *productVO=[orderItemVO product];
        if ([[productVO isGift] intValue]==1) {
            hasGift=YES;
        }
        if ([[productVO isGift] intValue]==1)
        {
            OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, 4, 40, 40)];
            [imageView loadImgUrl:productVO.miniDefaultProductUrl];
            [m_DetailGiftScrollView addSubview:imageView];
            [imageView release];
            xValue+=50.0;
        }
    }
    [m_DetailGiftView setFrame:CGRectMake(0, yValue, 320, 49)];
    [m_DetailGiftScrollView setContentSize:CGSizeMake(xValue-10.0, 47)];
    if (hasGift) {
        [m_DetailGiftView setHidden:NO];
        [m_DetailScrollView setContentSize:CGSizeMake(320, yValue+49)];
    } else {
        [m_DetailGiftView setHidden:YES];
        [m_DetailScrollView setContentSize:CGSizeMake(320, yValue)];
    }
    
    //让scrollview滑动
    if ([m_DetailScrollView contentSize].height<=367) {
        [m_DetailScrollView setContentSize:CGSizeMake(320, [m_DetailScrollView frame].size.height+1)];
    }
    
    //为了适配iOS7适配

    
    [self.view addSubview:m_DetailView];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"reveal"];
}

//加入购物车
-(void)accessoryButtonTap:(UIControl *)button withEvent:(UIEvent *)event {
    if (!m_AnimationStop) {//正在显示购物车动画
        return;
    }
    NSIndexPath *indexPath=[m_DetailTable indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:m_DetailTable]];//获得NSIndexPath
	if (indexPath==nil) {
		return;
	} else {
		int index=[indexPath row];//获得选择的第几行
		m_DetailProduct=[[[m_CurrentSubOrder orderItemList] objectAtIndex:index] product];
		if ([m_DetailProduct.canBuy isEqualToString:@"true"]) {
			m_ThreadStatus=THREAD_STATUS_ADD_CART;
			[self setUpThread:NO];
		} else {
            [AlertView showAlertView:nil alertMsg:@"很抱歉,该商品已经卖光啦!你可以收藏商品,下次购买" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
		}
	}
}

#pragma mark 购物车动画
-(void)startAnimation {
	if (m_AnimationStop) {
		[SharedDelegate showAddCartAnimationWithDelegate:self];
		m_AnimationStop=NO;
	}
}

-(void)showAddCartAnimation
{
    NSNumber *buyQuantity;
    if (m_DetailProduct.shoppingCount!=nil && [m_DetailProduct.shoppingCount intValue]>1) {//有N件起购限制
        buyQuantity=[NSNumber numberWithInt:[m_DetailProduct.shoppingCount intValue]];
    } else {//无N件起购限制
        buyQuantity=[NSNumber numberWithInt:1];
    }
	[self startAnimation];
    [SharedDelegate setCartNum:[buyQuantity intValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
}

-(void)animationFinished
{
    m_AnimationStop=YES;
}

#pragma mark    新线程相关
-(void)setUpThread:(BOOL)showLoading
{
	if (!m_ThreadRunning)
    {
		m_ThreadRunning=YES;
        [self showLoading:showLoading];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

//开启线程
-(void)startThread {
	while (m_ThreadRunning)
    {
		@synchronized(self)
        {
            switch (m_ThreadStatus)
            {
                case THREAD_STATUS_GET_ORDER_DETAIL: {//获取订单详情
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    YWOrderService *oServ=[[YWOrderService alloc] init];
                    OrderDetailInfo *tmpOrderVO;
                    
                    @try
                    {
                        
//                        tmpOrderVO=[oServ getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:m_OrderId];
                        
                        tmpOrderVO = [oServ getOrderDetail:m_OrderId];
                    }
                    
                    @catch (NSException * e)
                    {
                    }
                    
                    @finally
                    {
                        if (_orderDetail != nil)
                        {
                            [_orderDetail release];
                        }
                        if (tmpOrderVO!=nil && ![tmpOrderVO isKindOfClass:[NSNull class]])
                        {
                            _orderDetail = [tmpOrderVO retain];
                            
						}
                        else
                        {
                            _orderDetail = nil;
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                        }
                    }
                    [oServ release];
                    
                    // retrieved bank list
                    if (_orderDetail)
                    {
//                        self.bankList = [OTSUtility requestBanks];
                        
                        [self performSelectorOnMainThread:@selector(updateOrderDetail) withObject:nil waitUntilDone:NO];
                    }
                    
                    
                    [self stopThread];
                    [pool drain];
                    break;
                }
                    
                case THREAD_STATUS_CANCEL_ORDER:
                {
                    //取消订单
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    YWOrderService *oServ=[[YWOrderService alloc] init];
                    BOOL result;
                    @try
                    {
//						result=[oServ cancelOrder:[GlobalValue getGlobalValueInstance].token orderId:m_OrderId];
                        result = [oServ cancelOrder:_orderDetail.orderId orderStatus:[NSString stringWithFormat:@"%d", _orderDetail.orderStatus]];
                    }
                    @catch (NSException * e)
                    {
                    }
                    @finally
                    {
                        if (result)
                        {
                            [MobClick event:@"cancelOrder"];
                            
                            m_ThreadStatus=THREAD_STATUS_GET_ORDER_DETAIL;
                            m_RefreshMyOrder=YES;//返回时需要刷新我的订单
                            
                            [[OTSOnlinePayNotifier sharedInstance] retrieveOrders];

                        }
                        else 
                        {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"订单取消失败！" waitUntilDone:NO];
                            [self stopThread];
                        }
                    }
                    [oServ release];
                    [pool drain];
                    break;
                }
                    
                case THREAD_STATUS_REBUY_ORDER:
                {
                    //重新购买
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    OrderService *oServ=[[OrderService alloc] init];
                    int result;
                    @try {
						result=[oServ rebuyOrder:[GlobalValue getGlobalValueInstance].token orderId:m_OrderId];
                    } @catch (NSException * e) {
                    } @finally {
                        [self stopThread];
                        [self performSelectorOnMainThread:@selector(showRebuyOrderResult:) withObject:[NSNumber numberWithInt:result] waitUntilDone:NO];
                    }
                    [oServ release];
                    [pool drain];
                    break;
                }
                    
                case THREAD_STATUS_ADD_CART:
                {
                    //加入购物车
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
					ProductVO *productVO=m_DetailProduct;
                    NSNumber *buyQuantity;
					if (productVO.shoppingCount!=nil && [productVO.shoppingCount intValue]>1) {//有N件起购限制
						buyQuantity=[NSNumber numberWithInt:[productVO.shoppingCount intValue]];
					} else {//无N件起购限制
						buyQuantity=[NSNumber numberWithInt:1];
					}
                    CartService *cSer=[[[CartService alloc] init] autorelease];
                    AddProductResult *result;
                    @try {
                        result=[cSer addSingleProduct:[GlobalValue getGlobalValueInstance].token productId:[NSNumber numberWithInt:[productVO.productId intValue]] merchantId:[NSNumber numberWithInt:[productVO.merchantId intValue]] quantity:buyQuantity promotionid:[productVO promotionId]];
                        
                        if (result!=nil && ![result isKindOfClass:[NSNull class]]) {
                            if ([[result resultCode] intValue]==1) {//成功
                                [self performSelectorOnMainThread:@selector(showAddCartAnimation) withObject:nil waitUntilDone:NO];
                            } else {
                                [self performSelectorOnMainThread:@selector(showError:) withObject:[result errorInfo] waitUntilDone:NO];
                            }
                        } else {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                        }
                    }
                    @catch (NSException *exception) {
                    }
                    @finally {
                        [self stopThread];
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
	m_ThreadRunning=NO;
	m_ThreadStatus=-1;
    [self hideLoading];
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
}

#pragma mark    alertView的deleaget
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case ALERTVIEW_TAG_CANCEL_ORDER_CONFIRM: {
            if (buttonIndex==1) {
                m_ThreadStatus=THREAD_STATUS_CANCEL_ORDER;
                [self setUpThread:YES];
            }
            break;
        }
        case ALERTVIEW_TAG_REBUY_CONFIRM: {
            if (buttonIndex==1) {
                m_ThreadStatus=THREAD_STATUS_REBUY_ORDER;
                [self setUpThread:YES];
            }
            break;
        }
        case ALIXPAY_CONFIRM:{
            if (buttonIndex==1) {
//                [self changePaymentAction];
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

#pragma mark    tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    
    if (tableView==m_DetailTable)
    {
        //订单中的商品列表界面
        
        OrderPackageInfo *pack = _orderDetail.orderPackageArr[_selectedPackageIndex];
        OrderProductDetail *product = pack.packageProductArr[indexPath.row];
        
        
        if (product.isOTC)
        {
            //处方药不显示
            [self callPhone];
        }
        else
        {
            OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[product.productId longLongValue] promotionId:nil fromTag:PD_FROM_OTHER] autorelease];
            [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
            [self pushVC:productDetail animated:YES fullScreen:self.isFullScreen];
        }
        
    }
    
    else if ([tableView tag]>=100)
    {
        int packageIndex = tableView.tag - 100;
        
        if ([indexPath row]==0)
        {
            //物流查询
            [self removeSubControllerClass:[OTSOrderMfVC class]];
            OTSOrderMfVC *orderMfVC=[[[OTSOrderMfVC alloc] initWithNibName:@"OTSOrderMfVC" bundle:nil] autorelease];
//            orderMfVC.theOrder=m_OrderV2;
            
            orderMfVC.orderDetail = _orderDetail;
            orderMfVC.subPackIndex = packageIndex;
            [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
            [self pushVC:orderMfVC animated:YES fullScreen:self.isFullScreen];
        }
        
        else if ([indexPath row]==1)
        {
            //商品明细
            _selectedPackageIndex = [tableView tag]-100;
            m_CurrentSubOrder=[[m_OrderV2 childOrderList] objectAtIndex:[tableView tag]-100];
            [self initDetailView];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==m_MoneyTable) {
        return 2;
    } else if (tableView==m_ReceiverTable) {
        return 1;
    } else if (tableView==m_PaymentTable) {
        return 1;
    }
    /*
     else if (tableView==m_ArriveTimeTable) {
     return 1;
     } else if (tableView==m_DeliverTable) {
     return 1;
     }
     */
    else if (tableView==m_InvoiceTable)
    {
        return 1;
    }
    else if (tableView==m_DetailTable)
    {
        //要显示的包裹
        OrderPackageInfo *packInfo = _orderDetail.orderPackageArr[_selectedPackageIndex];
        return [packInfo.packageProductArr count];
    }
    else
    {
        if ([tableView tag]>=100)
        {
            return 2;
        } else {
            return 0;
        }
    }
}

//计算所有包裹中的商品数量
- (NSInteger)caluTotalProductCount
{
    NSInteger totalCount = 0;
    for (OrderPackageInfo *package in _orderDetail.orderPackageArr)
    {
        for (OrderProductDetail *product in package.packageProductArr)
        {
            totalCount += [product.productCount intValue];
        }
    }
    return totalCount;
}

//计算总商品价格
- (float)caluTotalProductPrice
{
    float totalPrice = 0;
    for (OrderPackageInfo *package in _orderDetail.orderPackageArr)
    {
        for (OrderProductDetail *product in package.packageProductArr)
        {
            totalPrice += [product.productCount intValue] * [product.price floatValue];
        }
    }
    return totalPrice;
}


-(UITableViewCell *)moneyTableViewCellAtIndex:(NSInteger)index
{
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    if (index==0)
    {
        //"总数量"label
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 150, 20)];
        [label setText:@"总数量："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //总数量label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 10, 120, 20)];
        [label setText:[NSString stringWithFormat:@"%d件",[self caluTotalProductCount]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        //"商品总金额"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 150, 20)];
        [label setText:@"商品总金额："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //商品总金额label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 30, 120, 20)];
        [label setText:[NSString stringWithFormat:@"￥%.2f",[self caluTotalProductPrice]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        //"运费"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 50, 150, 20)];
        
        NSString* strTransferFee = /*m_OrderV2.orderTotalWeight ? [NSString stringWithFormat:@"运费(%.2fkg)：", [m_OrderV2.orderTotalWeight floatValue]] : */@"运费：";
        [label setText:strTransferFee];
        [label setBackgroundColor:[UIColor clearColor]];
        
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //+
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, 50, 20, 20)];
        [label setText:@"＋"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        //运费label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 50, 120, 20)];
        [label setText:[NSString stringWithFormat:@"￥%.2f",_orderDetail.theFei]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        //"账户余额抵扣"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 70, 150, 20)];
        [label setText:@"现金账户余额抵扣："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //-
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, 70, 20, 20)];
        [label setText:@"－"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        //账户余额抵扣label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 70, 120, 20)];
        [label setText:[NSString stringWithFormat:@"￥%.2f",[[m_OrderV2 accountAmount] floatValue]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        
        //"账户余额抵扣"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 90, 150, 20)];
        [label setText:@"礼品卡账户余额抵扣："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //-
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, 90, 20, 20)];
        [label setText:@"－"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        //账户余额抵扣label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 90, 120, 20)];
        [label setText:[NSString stringWithFormat:@"￥%.2f",[[m_OrderV2 cardAmount] floatValue]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        //"抵用券抵扣"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 110, 150, 20)];
        [label setText:@"抵用券抵扣："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //-
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, 110, 20, 20)];
        [label setText:@"－"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        //抵用券抵扣label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 110, 120, 20)];
        [label setText:[NSString stringWithFormat:@"￥%.2f",[[m_OrderV2 couponAmount] floatValue]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        //       ////////////////////
        //"满减抵扣"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 130, 150, 20)];
        [label setText:@"满减抵扣："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //-
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, 130, 20, 20)];
        [label setText:@"－"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        //满减抵扣label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 130, 120, 20)];
        [label setText:[NSString stringWithFormat:@"￥%.2f",  [self caluTotalProductPrice]-_orderDetail.theAllMoney /*[[m_OrderV2 cashAmount] floatValue]*/]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
    }
    else if (index==1)
    {
        //"还需支付"label
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 44)];
        [label setText:@"需支付："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //还需支付金额label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 120, 44)];
        [label setText:[NSString stringWithFormat:@"￥%.2f",_orderDetail.theAllMoney /*[[m_OrderV2 paymentAccount] floatValue]*/]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
    }
    return cell;
}

-(UITableViewCell *)receiverTableViewCellAtIndex:(NSInteger)index
{
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (index==0)
    {
        //获取送货地址VO
//        GoodReceiverVO *goodReciverVO=m_OrderV2.goodReceiver;
//        if (goodReciverVO==nil)
//        {//无地址时
//            [[cell textLabel] setText:@"请选择收货地址"];
//            [[cell textLabel] setTextColor:[UIColor blackColor]];
//            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
//        }
//        else
//        {
        
        OrderContact *contact = _orderDetail.orderContact;
        
            CGFloat yValue=5.0;
            //收货人
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
            [label setText:contact.sendReceivePeople];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
            yValue+=22.0;
            //送货地址
            label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
            [label setText:contact.sendParticularAddress];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
            yValue+=22.0;
            //省份、城市、地区
            label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
            if ([contact.sendProvinceName isEqualToString:@"上海"] || [contact.sendProvinceName isEqualToString:@"上海市"])
            {
                //上海只显示两级区域
                [label setText:[NSString stringWithFormat:@"%@ %@",contact.sendProvinceName,contact.sendCountyName]];
            }
            else
            {
                [label setText:[NSString stringWithFormat:@"%@ %@ %@",contact.sendProvinceName, contact.sendCityName,contact.sendCountyName]];
            }
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
            yValue+=22.0;
            //获取手机信息
            if (contact.sendContactMobile!=nil && ![contact.sendContactMobile isKindOfClass:[NSNull class]])
            {
                label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
                [label setText:contact.sendContactMobile];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor blackColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                yValue+=22.0;
            }
            //获取电话信息
            if (contact.sendContactPhone != nil && ![contact.sendContactPhone isKindOfClass:[NSNull class]])
            {
                label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
                [label setText:contact.sendContactPhone];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor blackColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
//    }
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"---->>> %s",__func__);
    if (tableView==m_MoneyTable)
    {
        return [self moneyTableViewCellAtIndex:[indexPath row]];
    }
    
    else if (tableView==m_ReceiverTable)
    {
        return [self receiverTableViewCellAtIndex:[indexPath row]];
    }
    
    else if (tableView==m_PaymentTable)
    {
        UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        [[cell textLabel] setText:_orderDetail.payMethodName/*[m_OrderV2 paymentMethodForString]*/];
        [[cell textLabel] setTextColor:[UIColor blackColor]];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
        return cell;
    }

    else if (tableView==m_InvoiceTable)
    {
        UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        
        InvoiceInfo *invoceInfo = _orderDetail.invoiceInfo;
        if (invoceInfo.invoiceTypeId != kYaoInvoiceHeadNone)
        {
//            InvoiceVO *invoiceVO=[[m_OrderV2 invoiceList] objectAtIndex:0];
//            if (([[invoiceVO type] intValue]!= -1)) {
                //发票类型
                NSString *invoiceType=@"普通商品";
//                if ([[invoiceVO type] intValue]==1)
//                {
                    //3c类商品
//                    invoiceType=@"3C类商品";
//                }
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:[NSString stringWithFormat:@"发票类型：%@",invoiceType]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                //发票抬头
                label=[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:[NSString stringWithFormat:@"发票抬头：%@",invoceInfo.invoiceHead]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                //发票内容
                label=[[UILabel alloc] initWithFrame:CGRectMake(20, 50, 280, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:[NSString stringWithFormat:@"发票内容：%@",invoceInfo.invoiceConentId]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
            }
//        else {
//                [[cell textLabel] setText:[invoiceVO title]];
//                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
//            }
//        }
    else
    {
            [[cell textLabel] setText:@"不开发票"];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
        
    }
        
        return cell;
    }
    
    //点击商品之后显示的详细商品列表
    else if (tableView==m_DetailTable)
    {
        //要显示的包裹
        OrderPackageInfo *pack = _orderDetail.orderPackageArr[_selectedPackageIndex];
        
        
        UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        if ([pack.packageProductArr count]>0)
        {
            
            OrderProductDetail *product = pack.packageProductArr[indexPath.row];
            
            
            if (product.isOTC)
            {
                //是处方药
                //商品图片
                OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(10, 11, 40, 40)];
                [imageView setImage:[UIImage imageNamed:@"1mall_eye.png"]];
                [cell addSubview:imageView];
                [imageView release];
                //商品名称
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(60, 11, 200, 40)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setNumberOfLines:2];
                [label setText:@"订单信息请咨询药师!"];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                
                label=[[UILabel alloc] initWithFrame:CGRectMake(60, 51, 200, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:@"400-007-0958"];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                
                
            }
            else
            {
                //商品图片
                OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(10, 11, 40, 40)];
                [imageView loadImgUrl:[self getProductPicByProductId:product.productId]];
                [cell addSubview:imageView];
                [imageView release];
                
                //商品名称
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(60, 11, 200, 40)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setNumberOfLines:2];
                [label setText:product.productName];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                
                //数量
                label=[[UILabel alloc] initWithFrame:CGRectMake(60, 51, 60, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:[NSString stringWithFormat:@"%@件",product.productCount]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                //单价
                label=[[UILabel alloc] initWithFrame:CGRectMake(130, 51, 130, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextAlignment:NSTextAlignmentRight];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [label setText:[NSString stringWithFormat:@"单价：￥%.2f",[product.price floatValue]]];
                [cell addSubview:label];
                [label release];
            }
           
            
            
        }
        
        return cell;
    }
    
    else
    {
        //包裹信息

        if ([tableView tag]>=100)
        {
            int index=[tableView tag]-100;
//            OrderV2 *orderV2=[[m_OrderV2 childOrderList] objectAtIndex:index];
            //包裹info
            OrderPackageInfo *packInfo =  _orderDetail.orderPackageArr[index];
            
            UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if ([indexPath row]==0)
            {
                [[cell textLabel] setText:[NSString stringWithFormat:@"￥%.2f  %@",([packInfo.allGoodsMoney floatValue]-packInfo.getRedeceMoneyByPromotion) ,[_orderDetail  payStatusName]]];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
                [[cell textLabel] setTextColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
                [[cell detailTextLabel] setText:@"物流查询"];
                [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:15.0]];
            }
            else
            {
                if (packInfo.packageProductArr.count == 1)
                {
                    //商品图片
                    OrderProductDetail *product = packInfo.packageProductArr[0];
                    OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(20, 12, 40, 40)];
                    [cell addSubview:imageView];
                    [imageView release];
                    
                    //商品名称
                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(73, 10, 130, 43)];
                    [label setNumberOfLines:2];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setFont:[UIFont systemFontOfSize:15.0]];
                    [cell addSubview:label];
                    [label release];
                    
                    
                    if (product.isOTC)
                    {
                        [imageView setImage:[UIImage imageNamed:@"1mall_eye.png"]];
                    }
                    else
                    {
                        [imageView loadImgUrl:[self getProductPicByProductId:product.productId]];
                        
                        [label setText:[product productName]];
                    }
                }
                else
                {
                    //scroll view
                    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(20, 1, 190, 61)];
                    [cell addSubview:scrollView];
                    [scrollView release];
                    
                    CGFloat xValue=0.0;
                    int i;
                    for (i=0; i < packInfo.packageProductArr.count; i++)
                    {
                        OrderProductDetail *productVO = packInfo.packageProductArr[i];

                        OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, 10, 40, 40)];

                        if (productVO.isOTC)
                        {
                           [imageView setImage:[UIImage imageNamed:@"1mall_eye.png"]];
                        }
                        else
                        {
                            [imageView loadImgUrl:[self getProductPicByProductId:productVO.productId]];
                        }
                       
                        [scrollView addSubview:imageView];
                        [imageView release];
                        xValue+=50.0;
                    }
                    [scrollView setContentSize:CGSizeMake(xValue-10.0, 61)];
                }
                
//                if (!productVO.isOTC)
//                {
                    [[cell detailTextLabel] setText:@"查看明细"];
//                }
                
                [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:15.0]];
            }
            return cell;
        } else {
            UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
            [cell setBackgroundColor:[UIColor whiteColor]];
            return cell;
        }
    }
}

//在之前“我的订单”列表中传过来的商品数组，通过productId对比 获得图片，，，fuck，。。 因为订单详情中没有图片，。。。。
- (NSString *)getProductPicByProductId:(NSString *)productId
{
    for (OrderProductInfo *myOrderListProductInfo in _productInfoArr)
    {
        if ([myOrderListProductInfo.productId isEqualToString:productId])
        {
            return myOrderListProductInfo.productPicture;
        }
    }
    return nil;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DebugLog(@"---->>> %s",__func__);
    
    if (tableView==m_MoneyTable) {
        return nil;
    } else if (tableView==m_ReceiverTable) {
        return @"收货地址";
    } else if (tableView==m_PaymentTable) {
        return @"支付方式";
    }
    /*
     else if (tableView==m_ArriveTimeTable) {
     return @"预计到货时间";
     } else if (tableView==m_DeliverTable) {
     return @"送货方式";
     }
     */
    else if (tableView==m_InvoiceTable)
    {
        return @"发票信息";
    }
    else
    {
        if ([tableView tag]>=100)
        {
            int index=[tableView tag]-100;
//            OrderV2 *orderV2=[[m_OrderV2 childOrderList] objectAtIndex:index];
//            int totalCount=0;
//            for (OrderItemVO *orderItemVO in [orderV2 orderItemList])
//            {
//                totalCount+=[[orderItemVO buyQuantity] intValue];
//            }
            
            //到每个包裹中，遍历每个商品的购买数量 再加起来
            int totalCount=0;
            OrderPackageInfo *packInfo = _orderDetail.orderPackageArr[index];
            for (OrderProductDetail *product in packInfo.packageProductArr)
            {
                totalCount += [product.productCount intValue];
            }
            return [NSString stringWithFormat:@"包裹%d    共%d件",[tableView tag]-99,totalCount];
        }
        else
        {
            return nil;
        }
    }
    
    DebugLog(@"－－－－>>end %s",__func__);
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DebugLog(@"---->>> %s",__func__);
    
    if (tableView==m_MoneyTable)
    {
        if ([indexPath row]==0)
        {
            return 140.0+20.f;
        }
        else
        {
            return 44.0;
        }
    } else if (tableView==m_ReceiverTable)
    {
        CGFloat height=77.0;
        if (_orderDetail.orderContact.sendContactMobile !=nil && ![_orderDetail.orderContact.sendContactMobile isKindOfClass:[NSNull class]] && _orderDetail.orderContact.sendContactMobile.length > 0)
        {
            height+=20.0;
        }
        if (_orderDetail.orderContact.sendContactPhone !=nil && ![_orderDetail.orderContact.sendContactPhone isKindOfClass:[NSNull class]] && _orderDetail.orderContact.sendContactPhone.length > 0)
        {
            height+=20.0;
        }
        return height;
    }
    else if (tableView==m_PaymentTable)
    {
        return 44.0;
    }
    else if (tableView==m_InvoiceTable)
    {
        if (_orderDetail.invoiceInfo.invoiceTypeId != kYaoInvoiceHeadNone /*[m_OrderV2 invoiceList]!=nil && [[m_OrderV2 invoiceList] count]>0*/)
        {
//            InvoiceVO *invoiceVO=[[m_OrderV2 invoiceList] objectAtIndex:0];
//            if ([[invoiceVO type] intValue]!= -1)
//            {
                return 79.0;
//            }
        }
        return 44.0;
    }
    else if (tableView==m_DetailTable)
    {   
        return 85.0;
    }
    else
    {
        if ([tableView tag]>=100)
        {
            if ([indexPath row]==0)
            {
                return 44.0;
            } else {
                return 63.0;
            }
        }
        else
        {
            return 0.0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    DebugLog(@"---->>> %s",__func__);
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    DebugLog(@"---->>> %s",__func__);
//    if (tableView == m_ReceiverTable)
//    {
//        return 20.f;
//    }
//    else
//    if (tableView==m_PaymentTable)
//    {
//        return 0.1f;
//    }
//    else if (tableView==m_InvoiceTable)
//    {
//        return 25.f;
//    }
    if (tableView == m_DetailTable)
    {
        return 0.01;
    }
    
    return 30.f;
}


//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}

-(void)releaseResource
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_OrderCodeLabel);
    OTS_SAFE_RELEASE(m_PackageCountLabel);
    OTS_SAFE_RELEASE(m_OrderTimeLabel);
    OTS_SAFE_RELEASE(m_TopBtn);
    OTS_SAFE_RELEASE(m_DetailView);
    OTS_SAFE_RELEASE(m_DetailScrollView);
    OTS_SAFE_RELEASE(m_DetailGiftView);
    OTS_SAFE_RELEASE(m_DetailGiftScrollView);
    OTS_SAFE_RELEASE(m_DetailTable);
    OTS_SAFE_RELEASE(m_DetailTotalMoneyLabel);
    OTS_SAFE_RELEASE(m_DetailCountLabel);
    OTS_SAFE_RELEASE(m_OrderId);
    OTS_SAFE_RELEASE(m_OrderV2);
    OTS_SAFE_RELEASE(_changePayBtn);
    OTS_SAFE_RELEASE(_bankList);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseResource];
}

-(void)dealloc
{
    [self releaseResource];
    [_orderDetail release];
    [_productInfoArr release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark  电话咨询
- (void)callPhone
{
    UIActionSheet *actionSheet=[[OTSActionSheet alloc] initWithTitle:@"客服工作时间 : 每日 9:00-21:00" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"400-007-0958", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    actionSheet.tag = 100001;
    [actionSheet release];
}
#pragma mark actionsheet相关
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    

        switch (buttonIndex){
            case 0:
            {
                UIDeviceHardware *hardware=[[UIDeviceHardware alloc] init];
                //判断设备是否iphone
                NSRange range = [[hardware platformString] rangeOfString:@"iPhone"];
                if (range.length <= 0)
                {
                    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
                    [AlertView showAlertView:nil alertMsg:@"您的设备不支持此项功能,感谢您对1号药店的支持!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
                }
                else
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000070958"]];
                }
                [hardware release];
                break;
            }
            default:
                break;
        }

}

@end