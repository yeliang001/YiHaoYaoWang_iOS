//
//  MyOrder.m
//  TheStoreApp
//
//  Created by jiming huang on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define THREAD_STATUS_GET_MY_ORDER  1

#define LOADMORE_HEIGHT 40
#define PULL_UP         55

#define ALIXPAY_CONFIRM 101
#define ALIXPAYGATE     421


#import "MyOrder.h"
#import "OrderService.h"
#import "GlobalValue.h"
#import "LoadingMoreLabel.h"
#import "AlertView.h"
#import "OrderItemVO.h"
#import "ProductVO.h"
#import "DataController.h"
#import "GroupBuyOrderDetail.h"
#import "OTSNaviAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "TheStoreAppAppDelegate.h"
#import "OTSChachedImageView.h"
#import "OrderV2.h"
#import "OTSUtility.h"
#import "UIScrollView+OTS.h"
#import "OTSOrderSubmitOKVC.h"
#import "OTSChangePayButton.h"
#import "OTSOnlinePayNotifier.h"
#import "OTSBadgeView.h"
#import "OTSImageView.h"
#import "YWOrderService.h"
#import "ResultInfo.h"

#import "MyOrderInfo.h"
#import "UserInfo.h"
#import "AlixPay.h"

#import <AlipaySDK/Alipay.h>
#import "JSONKit.h"

@interface MyOrder ()
@property(retain)NSArray        *bankList;
//@property(retain)OrderV2        *payChangingOrder;  // 正在修改payment的order
@property(nonatomic, retain)    OTSBadgeView *inProcessOrderBadgeView;

@property long long int payChangeIndex;
@end


@implementation MyOrder
@synthesize changePayBtn = _changePayBtn
, bankList = _bankList
, payChangeIndex
, inProcessOrderBadgeView = _inProcessOrderBadgeView;

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
-(OrderV2*)orderAtIndex:(NSUInteger)aIndex
{
    OrderV2* order = [OTSUtility safeObjectAtIndex:aIndex inArray:m_AllOrders];
    return order;
}

//-(OrderV2*)orderOfID:(long long)aOrderId
//{
//    for (OrderV2* order in m_AllOrders)
//    {
//        if ([order.orderId intValue] == aOrderId)
//        {
//            return order;
//        }
//    }
//
//    return nil;
//}

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


-(void)showNoAlixWallet
{
    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装支付宝客户端，或版本过低。建议您下载或更新支付宝客户端（耗时较长）。" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"取消", nil];
    [alert setTag:ALIXPAY_CONFIRM];
	[alert show];
	[alert release];
}


-(void)changePaymentAction:(id)sender
{
    UIButton* theBtn = (UIButton*)sender;
    payChangeIndex = theBtn.superview.tag;
    OrderV2 * order = [m_AllOrders objectAtIndex:payChangeIndex];
    
    if (order)
    {
        OnlinePay *onlinePay = [[[OnlinePay alloc] initWithNibName:@"OnlinePay" bundle:nil] autorelease];
        [onlinePay setIsFromOrder:NO];
        [onlinePay setGatewayId:[order gateway]];
        [onlinePay setOrderId:[order orderId]];
        [onlinePay chooseBankCaller:self];
        
        if ([order isGroupBuyOrder])
        {
            onlinePay.isFromGroupon = YES;
        }
        
        [self pushVC:onlinePay animated:YES fullScreen:YES];
    }
}


//改变支付方式V2
-(void)changePaymentActionV2
{
    OrderV2 * order = [m_AllOrders objectAtIndex:payChangeIndex];
    
    if (order)
    {
        OnlinePay *onlinePay = [[[OnlinePay alloc] initWithNibName:@"OnlinePay" bundle:nil] autorelease];
        [onlinePay setIsFromOrder:NO];
        [onlinePay setGatewayId:[order gateway]];
        [onlinePay setOrderId:[order orderId]];
        [onlinePay chooseBankCaller:self];
        
        if ([order isGroupBuyOrder])
        {
            onlinePay.isFromGroupon = YES;
        }
        
        [self pushVC:onlinePay animated:YES fullScreen:YES];
    }
}

-(void)threadRequestSaveGateWay:(BankVO*)aBankVO
{
    
    BankVO *bankVO = [[aBankVO retain] autorelease];
    OrderV2 * order = [OTSUtility safeObjectAtIndex:payChangeIndex inArray:m_AllOrders];
    if (order)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading];
        });
        
        if ([order isGroupBuyOrder])
        {
            // change group buy order bank
            GroupBuyService* service = [[[GroupBuyService alloc] init] autorelease];
            
            int resultFlag = [service saveGateWayToGrouponOrder:[GlobalValue getGlobalValueInstance].token
                                                        orderId:order.orderId
                              
                                                      gatewayId:bankVO.gateway];
            
            if (resultFlag == 1)
            {
                order.gateway = bankVO.gateway;
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    OTSAlertView* alert = [[OTSAlertView alloc] initWithTitle:@"" message:@"保存支付方式失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [[alert autorelease] show];
                });
            }
            
        }
        else
        {
            // change normal order bank
            OrderService* service = [[[OrderService alloc] init] autorelease];
            
            SaveGateWayToOrderResult *result = [service saveGateWayToOrder:[GlobalValue getGlobalValueInstance].token
                                                                   orderId:order.orderId
                                                                 gateWayId:bankVO.gateway];
            
            if (result && ![result isKindOfClass:[NSNull class]])
            {
                if ([result.resultCode intValue] == 1)
                {
                    order.gateway = bankVO.gateway;
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(showError:) withObject:[result errorInfo] waitUntilDone:NO];
                }
                
            }
            else
            {
                [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateMyOrder];
            [self hideLoading];
        });
    }
    
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

-(void)handleNotifyBadgeChanged:(NSNotification*)aNotification
{
    int newOrderCount = [OTSOnlinePayNotifier sharedInstance].storeOrderCount;
    if (newOrderCount > 0)
    {
        self.inProcessOrderBadgeView.badgeNumber = newOrderCount;
        self.inProcessOrderBadgeView.hidden = NO;
    }
    else
    {
        self.inProcessOrderBadgeView.hidden = YES;
    }
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifyPaymentChanged:) name:OTS_ONLINEPAY_BANK_CHANGED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifyBadgeChanged:) name:OTS_NOTIFY_MY_ORDER_BADGE_CHANGED object:nil];
    
    [super viewDidLoad];
    [self initMyOrder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyOrder:) name:@"RefreshMyOrder" object:nil];
    
    [OTSOnlinePayNotifier sharedInstance].appBadgeNumber = 0;
    
    // iphone5适配 - dym
    CGRect rc = m_ScrollView.frame;
    rc.size.height = self.view.frame.size.height - 80;
    rc.origin.y = 80;
    m_ScrollView.frame = rc;

}

//刷新我的订单
-(void)refreshMyOrder:(NSNotification *)notification
{
    m_PageIndex=1;
    m_OrderTotalNum=0;
    if (m_AllOrders!=nil) {
        [m_AllOrders removeAllObjects];
    }
    
    //获取我的订单
    m_ThreadStatus=THREAD_STATUS_GET_MY_ORDER;
    [self setUpThread:YES];
}

//初始化我的订单
-(void)initMyOrder
{
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [m_ScrollView setBackgroundColor:[UIColor clearColor]];
    [m_ScrollView setAlwaysBounceVertical:YES];
    
    m_LoadingMoreLabel=[[LoadingMoreLabel alloc] initWithFrame:CGRectMake(0, 0, 320, LOADMORE_HEIGHT)];
    
    
    m_OrderType = kProcessing; //处理中的
    m_PageIndex=1;
    m_AllOrders=[[NSMutableArray alloc] init];
    m_CurrentTypeIndex=0;
    
    //获取我的订单
    m_ThreadStatus=THREAD_STATUS_GET_MY_ORDER;
    [self setUpThread:YES];
}

-(void)updateMyOrder
{
    //删除scrollview所有子view
    for (UIView *view in [m_ScrollView subviews])
    {
        if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    if ([m_AllOrders count]==0)
    {
        UILabel *msgLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 310, 40)];
        [msgLabel setBackgroundColor:[UIColor clearColor]];
        [msgLabel setTextColor:[UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.0]];
        [msgLabel setFont:[UIFont systemFontOfSize:16.0]];
        [msgLabel setNumberOfLines:10];
        
        switch (m_OrderType)
        {
                
            case kCompleted /*KOtsOrderTypeCompleted*/:
                [msgLabel setText:@"还没有已完成的订单！"];
                break;
                
            case kCanceled /* KOtsOrderTypeCanceld*/:
                [msgLabel setText:@"还没有取消过订单！"];
                break;
                
            case kProcessing /*KOtsOrderTypeProceeding*/:{
                [msgLabel setText:@"最近7天没有处理中的订单！"];
                break;
            }
                
            default:{ // 全部为空的操作
                UIImageView *nullImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 367)];
                [nullImage setImage:[UIImage imageNamed:@"null_myOrder.png"]];
                [self.view addSubview:nullImage];
                [nullImage release];
                
                break;
            }
        }
        
        [m_ScrollView addSubview:msgLabel];
        [msgLabel release];
        [m_ScrollView setContentSize:CGSizeMake(320, [m_ScrollView frame].size.height)];
        
        //上拉刷新控件
        if (_showRefreshPullUp)
        {
            if (_RefreshPullUp == nil)
            {
                RefreshTablePullUp *view = [[RefreshTablePullUp alloc] initWithFrame:CGRectMake(0.0f, [m_ScrollView frame].size.height-PULL_UP, 320, 650)];
                view.delegate = self;
                [m_ScrollView addSubview:view];
                [m_ScrollView setContentSize:CGSizeMake(320, [m_ScrollView frame].size.height)];
                _RefreshPullUp = view;
                _RefreshPullUp.hidden = NO;
            }
            [_RefreshPullUp setFrame:CGRectMake(0.0f, [m_ScrollView frame].size.height-PULL_UP, 320, 650)];
            [m_ScrollView bringSubviewToFront:_RefreshPullUp];
            
            if (KOtsOrderTypeProceeding)
            {
                m_LoadingMoreLabel.hidden = YES;
                _RefreshPullUp.hidden = NO;
            }
        }
    }
    else
    {
            CGFloat yValue=0.0;
            int i;
            for (i=0; i<[m_AllOrders count]; i++)
            {
                CGFloat height;
                MyOrderInfo *order = m_AllOrders[i];
                if ([order needPayByAlipay])
                {
                     height=207.0;
                }
                else
                {
                    height=156.0;
                }
                
                UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
                [tableView setTag:100+i];
                [tableView setBackgroundColor:[UIColor clearColor]];
                [tableView setBackgroundView:nil];
                [tableView setScrollEnabled:NO];
                [tableView setDelegate:self];
                [tableView setDataSource:self];
                [tableView setScrollsToTop:NO];
                [m_ScrollView addSubview:tableView];
                
                //为了适配ios7  //ios7上headerivew太长
                if (ISIOS7)
                {
                    tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,tableView.bounds.size.width, 10.f)] autorelease];
                }
                
                
                [tableView release];
                yValue+=height;
            }
            [m_ScrollView setContentSize:CGSizeMake(320, yValue+20)];
            
            //上拉刷新控件
            
            if (_showRefreshPullUp)
            {
                if (_RefreshPullUp == nil) {
                    //--------------------设置RefreshTablePullUp最小起始高度--------------------------
                    if (yValue < 270)
                    {
                        yValue = 270;
                    }
                    RefreshTablePullUp *view = [[RefreshTablePullUp alloc] initWithFrame:CGRectMake(0.0f, yValue, 320, 650)];
                    view.delegate = self;
                    _RefreshPullUp = view;
                    _RefreshPullUp.hidden = YES;
                }
                
                
                //------------------展开全部的时候要去掉pullup占用的空间----------------------
                if (!_refreashShowAll) {
                    //--------------------设置RefreshTablePullUp最小起始高度--------------------------
                    if (yValue < 270) {
                        yValue = 270;
                    }
                    [_RefreshPullUp setFrame:CGRectMake(0.0f, yValue, 320, 650)];
                }
            }
            
            //加载更多
            if ([m_AllOrders count]<m_OrderTotalNum && !_showRefreshPullUp)
            {
                [m_LoadingMoreLabel setFrame:CGRectMake(0, yValue, 320, LOADMORE_HEIGHT)];
                [m_ScrollView addSubview:m_LoadingMoreLabel];
                [m_ScrollView setContentSize:CGSizeMake(320, yValue+LOADMORE_HEIGHT)];
            }
            
            if (_showRefreshPullUp && m_OrderType == KOtsOrderTypeProceeding)
            {
                [m_ScrollView setContentSize:CGSizeMake(320, yValue+PULL_UP)];
                m_LoadingMoreLabel.hidden = YES;
                [m_LoadingMoreLabel removeFromSuperview];
                _RefreshPullUp.hidden = NO;
                [m_ScrollView addSubview:_RefreshPullUp];
                [m_ScrollView bringSubviewToFront:_RefreshPullUp];
            }
            
        }
//    }
    
    //处理中订单数量
    if (m_CurrentTypeIndex==0)
    {
        for (UIView *view in [m_TypeView subviews])
        {
            if ([view isKindOfClass:[UIButton class]] && [view tag]==0)
            {
                UIButton *button=(UIButton *)view;
                [button setTitle:@"处理中" forState:UIControlStateNormal];
                //[button setTitle:[NSString stringWithFormat:@"处理中（%d）",m_OrderTotalNum] forState:UIControlStateNormal];
                
                int newOrderCount = [OTSOnlinePayNotifier sharedInstance].storeOrderCount;
                if (newOrderCount > 0)
                {
                    [self.inProcessOrderBadgeView removeFromSuperview];
                    self.inProcessOrderBadgeView = [[[OTSCircleBadgeView alloc]
                                                     initWithPosition:CGPointMake(75, 0)
                                                     badgeNumber:newOrderCount]
                                                    autorelease];
                    [button addSubview:self.inProcessOrderBadgeView];
                }
            }
        }
    }
}


-(void)showError:(NSString *)error
{
    [AlertView showAlertView:nil alertMsg:error buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}

//加载更多
-(void)getMoreOrder
{
    m_ThreadStatus=THREAD_STATUS_GET_MY_ORDER;
    [self setUpThread:NO];
}

#warning 药网支付宝支付
//立即支付
-(void)onlinePay:(id)sender
{
    UIButton* theBtn = (UIButton*)sender;
    payChangeIndex = theBtn.superview.tag;
    MyOrderInfo *orderV2 = [OTSUtility safeObjectAtIndex:payChangeIndex inArray:m_AllOrders];
    
    
        YWOrderService *orderSer = [[YWOrderService alloc] init];
        NSString *signStr = [orderSer getOrderAlipaySign:orderV2.orderId];
        DebugLog(@"支付宝签名: %@",signStr);
        //支付宝支付
        NSString *appScheme = @"yhyw";
        //全局记录状态
        [[GlobalValue getGlobalValueInstance] setAlixpayOrderId:[NSNumber numberWithLongLong:[orderV2.orderId longLongValue]]];

        [[GlobalValue getGlobalValueInstance] setIsFromMyOrder:YES];
//        //获取安全支付单例并调用安全支付接口
//        AlixPay * alixpay = [AlixPay shared];
//        [alixpay pay:signStr applicationScheme:appScheme];
        [orderSer release];
        
        
        [[Alipay defaultService] pay:signStr From:appScheme CallbackBlock:^(NSString *resultString) {
            DebugLog(@"result = %@",resultString);
            NSDictionary *resultDic = [[resultString dataUsingEncoding:NSUTF8StringEncoding]  objectFromJSONData];
            
            NSString *status = resultDic[@"ResultStatus"];
            if ([status intValue] == 9000)
            {
                [self refreshMyOrder:nil];
            }

        }];
}

//返回
-(IBAction)returnBtnClicked:(id)sender
{
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
    [[NSNotificationCenter defaultCenter] postNotificationName:OTS_NOTIFY_MY_ORDER_BADGE_CHANGED object:nil];
}


-(void)typeBtnWithRefreshPullUp
{
    _RefreshPullUp.hidden = YES;
    _showRefreshPullUp = NO;
    m_LoadingMoreLabel.hidden = NO;
    
    [m_AllOrders removeAllObjects];
    
    if ([_48TempOrders count]!=0) {
        [_48TempOrders removeAllObjects];
    }
}

//按类型获取
-(IBAction)typeBtnClicked:(id)sender
{
    UIButton *button=sender;
    if ([button tag]==m_CurrentTypeIndex) {
        return;
    }
    m_CurrentTypeIndex=[button tag];
	m_PageIndex=1;
    m_OrderTotalNum=0;
    if (m_AllOrders!=nil) {
        [m_AllOrders removeAllObjects];
    }
    [m_ScrollView setContentOffset:CGPointMake(0, 0)];
    switch ([button tag]) {
        case 0: {
            for (UIView *view in [m_TypeView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button=(UIButton *)view;
                    if ([button tag]==0) {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_sel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    } else {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_unsel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
            }
            [self typeBtnWithRefreshPullUp];
            m_OrderType = kProcessing; //KOtsOrderTypeProceeding;
            m_ThreadStatus=THREAD_STATUS_GET_MY_ORDER;
            [self setUpThread:YES];
            break;
        }
        case 1: {
            for (UIView *view in [m_TypeView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button=(UIButton *)view;
                    if ([button tag]==1) {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_sel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    } else {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_unsel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
            }
            m_OrderType = kCanceled;  //KOtsOrderTypeCanceld;
            [self typeBtnWithRefreshPullUp];
            m_ThreadStatus=THREAD_STATUS_GET_MY_ORDER;
            [self setUpThread:YES];
            break;
        }
        case 2:
        {
            for (UIView *view in [m_TypeView subviews])
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    UIButton *button=(UIButton *)view;
                    if ([button tag]==2)
                    {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_sel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_unsel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
            }
            m_OrderType = kCompleted; //KOtsOrderTypeCompleted;
            [self typeBtnWithRefreshPullUp];
            m_ThreadStatus=THREAD_STATUS_GET_MY_ORDER;
            [self setUpThread:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark    新线程相关
-(void)setUpThread:(BOOL)showLoading {
	if (!m_ThreadRunning)
    {
		m_ThreadRunning=YES;
        [self showLoading:showLoading];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

//开启线程
-(void)startThread {
	while (m_ThreadRunning) {
		@synchronized(self) {
            switch (m_ThreadStatus) {
                case THREAD_STATUS_GET_MY_ORDER:
                {
                    //获取我的订单
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    YWOrderService *oServ = [[YWOrderService alloc] init];
                    ResultInfo *getMyOrderResult;
                    
                    @try
                    {
                        
                        NSDictionary *dic = @{@"pageindex" : [NSString stringWithFormat:@"%d", m_PageIndex],
                                               @"pagesize" : @"10",
                                            @"orderstatus" : [NSString stringWithFormat:@"%d",m_OrderType],
                                                 @"userid" : [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                                               @"username" : [GlobalValue getGlobalValueInstance].userInfo.uid, //uid是 用户名 ，草。。。。
                                                  @"token" : [GlobalValue getGlobalValueInstance].ywToken,
                                            };
                        getMyOrderResult = [[oServ getMyOrder:dic] retain];
                         
                    }
                    @catch (NSException * e)
                    {
                    }
                    @finally
                    {
                        [self stopThread];
                        if (getMyOrderResult.bRequestStatus && getMyOrderResult.responseCode == 200)
                        {
                            //-------------check the page order whether more than 7x24 hours, only for type KOtsOrderTypeProceeding ----
                            [m_AllOrders addObjectsFromArray:(NSMutableArray *)getMyOrderResult.resultObject];

                            m_OrderTotalNum = getMyOrderResult.recordCount;
                            maxPage = ceil(m_OrderTotalNum/10);
                            m_PageIndex++;
                            
                            [self performSelectorOnMainThread:@selector(updateMyOrder) withObject:nil waitUntilDone:NO];
						}
                        else
                        {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                        }
                        [m_LoadingMoreLabel performSelectorOnMainThread:@selector(reset) withObject:self waitUntilDone:NO];
                    }
                    [oServ release];
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
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
    [self hideLoading];
}


#pragma mark    tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    if ([indexPath row]==0)
    {
        int index=[tableView tag]-100;
        MyOrderInfo *orderV2=[OTSUtility safeObjectAtIndex:index inArray:m_AllOrders];
        if (orderV2!=nil)
        {
//            if ([orderV2 orderType]!=nil && [[orderV2 orderType] intValue]==2)
//            {//团购订单
//                [self removeSubControllerClass:[GroupBuyOrderDetail class]];
//                GroupBuyOrderDetail* orderDetail=[[[GroupBuyOrderDetail alloc] init] autorelease];
//                OrderV2 *orderV2 = [m_AllOrders objectAtIndex:index];
//                ProductVO *productVO=[[[orderV2 orderItemList] objectAtIndex:0] product];
//                orderDetail.groupImageUrl=productVO.miniDefaultProductUrl;
//                [orderDetail setM_OrderId:[orderV2 orderId]];
//                [self pushVC:orderDetail animated:YES];
//            }
//            
//            else
//            {//普通订单
                [self removeSubControllerClass:[OrderDetail class]];
               
            
                OrderDetail *orderDetail=[[[OrderDetail alloc] initWithNibName:@"OrderDetail" bundle:nil] autorelease];
                [orderDetail setM_OrderId:orderV2.orderId];
            //订单详细页中没有图片，fuck，这里把OrderProductInfo 数组穿过去，然后通过productId对比找图片
                orderDetail.productInfoArr = orderV2.productInfoArr;
                [self pushVC:orderDetail animated:YES];
//            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

//带立即支付按钮的第一行cell
-(UITableViewCell *)tableViewPayFirstCell:(UITableView *)tableView orderIndex:(NSUInteger)anOrderIndex
{
    MyOrderInfo *orderV2 = [m_AllOrders objectAtIndex:anOrderIndex];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyOrderPayFirstCell"];
    if (cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrderPayFirstCell"] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        //"订单编号："
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 75, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"订单编号："];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //团购图表
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(95, 10, 20, 20)];
        [imageView setTag:1];
        [imageView setImage:[UIImage imageNamed:@"icon_tuan.png"]];
        [cell addSubview:imageView];
        [imageView release];
        //订单编号
        label=[[UILabel alloc] initWithFrame:CGRectMake(120, 10, 180, 20)];
        [label setTag:2];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //价格+订单状态
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)];
        [label setTag:3];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont boldSystemFontOfSize:15.0]];
        [label setTextColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        [cell addSubview:label];
        [label release];
        //下单时间
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 50, 160, 20)];
        [label setTag:4];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        [cell addSubview:label];
        [label release];
        //包裹数量、商品数量
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 50, 100, 20)];
        [label setTag:5];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        
        // 立即支付
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(20, 76, 123, 43)];
        [button setTag:[tableView tag]];
        [button setBackgroundImage:[UIImage imageNamed:@"orange_btn.png"] forState:UIControlStateNormal];
        [button setTitle:@"立即支付" forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:16.0]];
        [button addTarget:self action:@selector(onlinePay:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        [button release];
        
        // New Button to change payment
        button.hidden = YES;
        CGRect topBtnRc = button.frame;
        self.changePayBtn = [[[OTSChangePayButton alloc] initWithLongButton:NO] autorelease];
        _changePayBtn.frame = CGRectMake( topBtnRc.origin.x
                                         , topBtnRc.origin.y
                                         , _changePayBtn.frame.size.width
                                         , _changePayBtn.frame.size.height);
        [cell addSubview:_changePayBtn];
        [self.changePayBtn.payButton addTarget:self action:@selector(onlinePay:) forControlEvents:UIControlEventTouchUpInside];
        [self.changePayBtn.changePayButton addTarget:self action:nil/*@selector(changePaymentAction:)*/ forControlEvents:UIControlEventTouchUpInside];
        self.changePayBtn.tag = anOrderIndex;
        
        // “XX银行”支付 or 重新购买
        
        _changePayBtn.hidden = YES;
        _changePayBtn.payButton.enabled = _changePayBtn.changePayButton.enabled = YES;
        
        NSString* payMethodStr = orderV2.payMethodName;
        NSString* orderStatusStr = orderV2.orderStatusName;
        DebugLog(@"pay methord:%@, order status:%@", payMethodStr, orderStatusStr);
        //如果订单是没有支付过，并且订单是网上支付 并且是审核通过的 那么就显示支付宝支付
        if ([orderV2 needPayByAlipay] /*[payMethodStr isEqualToString:@"网上支付"] && [orderStatusStr isEqualToString:@"待结算"]*/)
        {
            NSString* bankStr = @"支付宝客户端支付";
//            for (BankVO* bank in self.bankList)
//            {
//                if ([bank.gateway intValue] == [orderV2.gateway intValue])
//                {
//                    bankStr = bank.bankname;
//                }
//            }
//            
//            bankStr = bankStr ? bankStr : @"立即";
//            if ([bankStr rangeOfString:@"支付"].length == 0)
//                [self.changePayBtn.payButton setTitle:[NSString stringWithFormat:@"%@支付", bankStr]
//                                             forState:UIControlStateNormal];
//            else
                [self.changePayBtn.payButton setTitle:[NSString stringWithFormat:@"%@", bankStr] forState:UIControlStateNormal];
            
            _changePayBtn.hidden = NO;
            DebugLog(@"bankStr %@",bankStr);
        }
    }
    //团购图标
    UIImageView *grouponImg=(UIImageView *)[cell viewWithTag:1];
//    if ([[orderV2 orderType] intValue]==2) {//团购订单
//        [grouponImg setHidden:NO];
//    } else {
        [grouponImg setHidden:YES];
//    }
    //订单编号
    UILabel *orderCodeLabel=(UILabel *)[cell viewWithTag:2];
    [orderCodeLabel setText:[orderV2 orderId]];
//    if ([[orderV2 orderType] intValue]==2) {//团购订单
//        [orderCodeLabel setFrame:CGRectMake(120, 10, 180, 20)];
//    } else {
        [orderCodeLabel setFrame:CGRectMake(100, 10, 200, 20)];
//    }
    //价格+订单状态
    UILabel *orderPriceLabel=(UILabel *)[cell viewWithTag:3];
    [orderPriceLabel setText:[NSString stringWithFormat:@"￥%.2f    %@",[orderV2 theAllMoney],[orderV2 orderStatusName]]];
    //下单时间
    NSString *orderTime=[orderV2 orderDate];
    
    if ([orderTime length]>19) {
        orderTime=[orderTime substringWithRange:NSMakeRange(0, 19)];
    }
    UILabel *orderTimeLabel=(UILabel *)[cell viewWithTag:4];
    [orderTimeLabel setText:[NSString stringWithFormat:@"%@ 下单",orderTime]];
    //包裹数量、商品数量
//    int totalCount=0;
//    for (OrderItemVO *orderItemVO in [orderV2 orderItemList]) {
//        totalCount+=[[orderItemVO buyQuantity] intValue];
//    }
    UILabel *packageCountLabel=(UILabel *)[cell viewWithTag:5];
    [packageCountLabel setText:[NSString stringWithFormat:@"%d个包裹  共%d件",orderV2.packageCount ,orderV2.productNum]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//不带支付按钮的第一行cell
-(UITableViewCell *)tableViewFirstCell:(UITableView *)tableView orderV2:(MyOrderInfo *)orderV2
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyOrderFirstCell"];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrderFirstCell"] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        //"订单编号："
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 75, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"订单编号："];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //团购图表
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(95, 10, 20, 20)];
        [imageView setTag:1];
        [imageView setImage:[UIImage imageNamed:@"icon_tuan.png"]];
        [cell addSubview:imageView];
        [imageView release];
        //订单编号
        label=[[UILabel alloc] initWithFrame:CGRectMake(120, 10, 180, 20)];
        [label setTag:2];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //价格+订单状态
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)];
        [label setTag:3];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont boldSystemFontOfSize:15.0]];
        [label setTextColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        [cell addSubview:label];
        [label release];
        //下单时间
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 50, 160, 20)];
        [label setTag:4];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        [cell addSubview:label];
        [label release];
        //包裹数量、商品数量
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 50, 100, 20)];
        [label setTag:5];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
    }
    //团购图标
    UIImageView *grouponImg=(UIImageView *)[cell viewWithTag:1];
//    if ([[orderV2 orderType] intValue]==2) {//团购订单
//        [grouponImg setHidden:NO];
//    } else {
        [grouponImg setHidden:YES];
//    }
    //订单编号
    UILabel *orderCodeLabel=(UILabel *)[cell viewWithTag:2];
    [orderCodeLabel setText:[orderV2 orderId]];
//    if ([[orderV2 orderType] intValue]==2) {//团购订单
//        [orderCodeLabel setFrame:CGRectMake(120, 10, 180, 20)];
//    } else {
        [orderCodeLabel setFrame:CGRectMake(100, 10, 200, 20)];
//    }
    //价格+订单状态
    UILabel *orderPriceLabel=(UILabel *)[cell viewWithTag:3];
    [orderPriceLabel setText:[NSString stringWithFormat:@"￥%.2f    %@",[orderV2 theAllMoney],[orderV2 orderStatusName]]];
    //下单时间
    NSString *orderTime=[orderV2 orderDate];
    if ([orderTime length]>19) {
        orderTime=[orderTime substringWithRange:NSMakeRange(0, 19)];
    }
    UILabel *orderTimeLabel=(UILabel *)[cell viewWithTag:4];
    [orderTimeLabel setText:[NSString stringWithFormat:@"%@ 下单",orderTime]];
    //包裹数量、商品数量
//    int totalCount=0;
//    for (OrderItemVO *orderItemVO in [orderV2 orderItemList]) {
//        totalCount+=[[orderItemVO buyQuantity] intValue];
//    }
    UILabel *packageCountLabel=(UILabel *)[cell viewWithTag:5];
    [packageCountLabel setText:[NSString stringWithFormat:@"%d个包裹  共%d件",orderV2.packageCount,orderV2.productNum]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//单个商品的第二行cell
-(UITableViewCell *)tableViewSecondCellForSingleProduct:(UITableView *)tableView orderV2:(MyOrderInfo *)orderV2
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyOrderSecondCellForSingle"];
    if (cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrderSecondCellForSingle"] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        //商品图片
        OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(20, 12, 40, 40)];
        [imageView setTag:1];
        [cell addSubview:imageView];
        [imageView release];
        //商品名称
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(73, 10, 227, 43)];
        [label setTag:2];
        [label setNumberOfLines:2];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
    }
    //商品图片
//    ProductVO *productVO=[[[orderV2 orderItemList] objectAtIndex:0] product];
    OrderProductInfo *product = orderV2.productInfoArr[0];
    OTSImageView *imageView=(OTSImageView *)[cell viewWithTag:1];
   
    //商品名称
    UILabel *label=(UILabel *)[cell viewWithTag:2];
    
    
    if (product.isOTC)
    {
        //如果是处方药
        [imageView setImage:[UIImage imageNamed:@"1mall_eye.png"]];
    }
    else
    {
        [imageView loadImgUrl:product.productPicture];
        [label setText:[product productName]];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}

//多个商品的第二行cell
-(UITableViewCell *)tableViewSecondCellForMultiProduct:(UITableView *)tableView orderV2:(MyOrderInfo *)orderV2
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyOrderSecondCellForMulti"];
    if (cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrderSecondCellForMulti"] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        //左箭头
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 24, 7, 13)];
        [imageView setImage:[UIImage imageNamed:@"shopList_left_arrow.png"]];
        [cell addSubview:imageView];
        [imageView release];
        //scroll view
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(40, 1, 240, 61)];
        [scrollView setTag:1];
        [cell addSubview:scrollView];
        [scrollView release];
        //右箭头
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(293, 24, 7, 13)];
        [imageView setImage:[UIImage imageNamed:@"shopList_right_arrow.png"]];
        [cell addSubview:imageView];
        [imageView release];
    }
    UIScrollView *scrollView=(UIScrollView *)[cell viewWithTag:1];
    for (UIView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat xValue=0.0;
    int i;
    for (i=0; i<[[orderV2 productInfoArr] count]; i++)
    {
        OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, 10, 40, 40)];
        OrderProductInfo *productVO=[[orderV2 productInfoArr] objectAtIndex:i];
        
        if (productVO.isOTC)
        {
            [imageView setImage:[UIImage imageNamed:@"1mall_eye.png"]];
        }
        else
        {
            [imageView loadImgUrl:productVO.productPicture];
        }
        
        [scrollView addSubview:imageView];
        [imageView release];
        xValue+=50.0;
    }
    [scrollView setContentSize:CGSizeMake(xValue-10.0, 61)];
    [scrollView setContentSize:CGSizeMake(xValue-10.0, 61)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [tableView tag] - 100;
    MyOrderInfo *orderV2 = [m_AllOrders objectAtIndex:index];
    if ([indexPath row] == 0)
    {
        //为支付的，网上支付的，已经通过审核的 需要显示支付宝支付
        if ([orderV2 needPayByAlipay] /*[[orderV2 paymentMethodForString] isEqualToString:@"网上支付"]&& [[orderV2 orderStatusForString] isEqualToString:@"待结算"]*/)
        {
            return [self tableViewPayFirstCell:tableView orderIndex:index];
        }
        
        else
        {
            return [self tableViewFirstCell:tableView orderV2:orderV2];
        }
    }
    else
    {
        if ([[orderV2 productInfoArr] count]==1)
        {//单个商品
            return [self tableViewSecondCellForSingleProduct:tableView orderV2:orderV2];
        }
        else
        {//多个商品
            return [self tableViewSecondCellForMultiProduct:tableView orderV2:orderV2];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index=[tableView tag]-100;
    MyOrderInfo *orderV2=[OTSUtility safeObjectAtIndex:index inArray:m_AllOrders];
    //为支付的 网上支付的 审核通过的 需要显示支付
    if ( [orderV2 needPayByAlipay]  /*[[orderV2 paymentMethodForString] isEqualToString:@"网上支付"] && [[orderV2 orderStatusForString] isEqualToString:@"待结算"]*/)
    {
        if ([indexPath row]==0)
        {
            return 129;
        }
        else
        {
            return 63.0;
        }
    }
    else
    {
        if ([indexPath row]==0)
        {
            return 78.0;
        } else {
            return 63.0;
        }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	[m_ScrollView ScrollMeToTopOnly];
}
//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark    alertView的deleaget
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case ALIXPAY_CONFIRM:{
            if (buttonIndex==1)
            {
//                [self changePaymentActionV2];
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

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    if (!_showRefreshPullUp)
    {
        if (scrollView!=m_ScrollView || m_AllOrders==nil || [m_AllOrders count]>=m_OrderTotalNum)
        {
            return;
        }
        //----------------解决接口pageindex 与查出的list 不匹配的问题------------------------------------
        if(maxPage <= m_PageIndex -1 && [_48TempOrders count]!=0)
        {
            [self performInThreadBlock:^(){
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                for (OrderV2 *v2 in _48TempOrders)
                {
                    [tempArray addObject:v2];
                }
                [_48TempOrders removeAllObjects];
                [m_AllOrders addObjectsFromArray:tempArray];
                [tempArray release];
            } completionInMainBlock:^() {
                [self updateMyOrder];
            }];
            return;
        }
        [m_LoadingMoreLabel scrollViewDidScroll:scrollView selector:@selector(getMoreOrder) target:self];
    }
    else
    {
    	[_RefreshPullUp egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
	if (_showRefreshPullUp) {
        
        [_RefreshPullUp egoRefreshScrollViewDidEndDragging:scrollView];
        
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    for (UIView *view in [m_ScrollView subviews]) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    _reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    
    _RefreshPullUp.hidden = YES;
    _showRefreshPullUp = NO;
    m_LoadingMoreLabel.hidden = NO;
    _refreashShowAll = YES;
    _reloading = NO;
	[_RefreshPullUp egoRefreshScrollViewDataSourceDidFinishedLoading:m_ScrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:4.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
    //    _showRefreshPullUp = NO;
    //	return [NSDate date]; // should return date data source was last changed
    return  nil;
	
}

-(void)releaseResource
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_TypeView);
    OTS_SAFE_RELEASE(m_LoadingMoreLabel);
    OTS_SAFE_RELEASE(m_AllOrders);
    OTS_SAFE_RELEASE(_RefreshPullUp);
    
    OTS_SAFE_RELEASE(_changePayBtn);
    OTS_SAFE_RELEASE(_bankList);
    OTS_SAFE_RELEASE(_48TempOrders);
    OTS_SAFE_RELEASE(_inProcessOrderBadgeView);
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
    
    [super dealloc];
}

@end
