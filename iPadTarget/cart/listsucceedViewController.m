//
//  listsucceedViewController.m
//  yhd
//
//  Created by dev dev on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "listsucceedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OnlinePayViewController.h"
#import "OrderTrackViewController.h"
#import "TopView.h"
#import "OrderV2.h"
#import "OTSNaviAnimation.h"
#import "OTSChangePayButton.h"
#import "OTSUtility.h"
#import "BankVO.h"
#import "PayInWebView.h"
#import "SaveGateWayToOrderResult.h"
#import "AlixPay.h"
#import "MyListViewController.h"

@interface listsucceedViewController ()
{
    BOOL isChangePaymentViewShowing;
}
@property(nonatomic, retain)OTSChangePayButton * changePayBtn; // 切换支付方式按钮
@property(retain) NSArray           *bankList;
@property (nonatomic, readonly)OtsPadLoadingView *loadingView;
@end

@implementation listsucceedViewController
@synthesize ordernumber;
@synthesize mtotalprice;
@synthesize mpayViewIsHidden;
@synthesize mGateWayId;
@synthesize changePayBtn = _changePayBtn;
@synthesize bankList = _bankList;
@synthesize oldPayButton=_oldPayButton;
@synthesize payLaterBtn = _payLaterBtn;
@synthesize loadingView = _loadingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(OtsPadLoadingView*)loadingView
{
    if (_loadingView == nil)
    {
        _loadingView = [[OtsPadLoadingView alloc] init];
    }
    
    return _loadingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_OrderDone extraPramaDic:nil] autorelease];
    [DoTracking doJsTrackingWithParma:prama];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popPayInWebView:) name:@"popPayInWebView" object:nil];
    
    
    // Do any additional setup after loading the view from its nib.
    mtotalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",mtotalprice];
    mtotalPriceLabel.textColor = kRedColor;
    CGSize mSize = [mtotalPriceLabel.text sizeWithFont:mtotalPriceLabel.font];
    mtotalPriceLabel.frame = CGRectMake(mtotalPriceLabel.frame.origin.x, mtotalPriceLabel.frame.origin.y, mSize.width, mSize.height);
    
    mpayView.hidden = mpayViewIsHidden;
    
    mmassageView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mmassageView.layer.borderWidth =1;
    
    UIImage * bgImag = [UIImage imageNamed:@"topbarback@2x.png"];
    UIColor * color = [[UIColor alloc]initWithPatternImage:bgImag];
    mtopbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bg.png"]];
    [color release];
    self.navigationController.navigationBar.hidden = YES;
    
    [m_LoadingView setFrame:CGRectMake(0, 55, 1024, 693)];
    [self.view addSubview:m_LoadingView];
    [m_LoadingView setHidden:YES];
    
    [self performSelector:@selector(getOrderDetail) withObject:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderDetail) name:@"RefreshSuccessView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(needUpdateListSucceedStatusHD:) name:@"needUpdateListSucceedStatusHD" object:nil];
}

- (void)viewDidUnload
{
    [self setOldPayButton:nil];
    [self setPayLaterBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"order_submit"];
    
    //[self getOrderDetail];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"order_submit"];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [ordernumber release];
    [_oldPayButton release];
    [_bankList release];
    
    OTS_SAFE_RELEASE(_changePayBtn);
    
    [_payLaterBtn release];
    [super dealloc];
}

-(void)getOrderDetail
{
    [m_LoadingView setHidden:NO];
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetOrderDetail) toTarget:self withObject:nil];
}

-(void)newThreadGetOrderDetail
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    OrderV2 *orderV2=[service getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:ordernumber];
    if (orderV2==nil || [orderV2 isKindOfClass:[NSNull class]]) {
        [self performSelectorOnMainThread:@selector(showGetOrderDetailError:) withObject:[NSString stringWithString:@"网络异常，请检查网络配置..."] waitUntilDone:NO];
    } else {
        mdetailOrder=[orderV2 retain];
        self.bankList=[OTSUtility requestBanks];
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    }
    [pool drain];
}

-(void)showGetOrderDetailError:(NSString *)error
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView setTag:1];
    [alertView show];
    [alertView release];
}

-(void)needUpdateListSucceedStatusHD:(NSNotification*)aNote
{
    [self checkOrderStatusHD2:^()
     {
         [self getOrderDetail];
         [self.loadingView hide];
     }];
}


#pragma mark 设置alert点击操作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:
            [SharedPadDelegate.navigationController popToRootViewControllerAnimated:YES];
        case 5://show no install alix safe payment
            if (buttonIndex==1) {
//                [self changePaymentAction:nil];
            } else if (buttonIndex==0) {
                NSString * URLString = @"http://itunes.apple.com/cn/app/zhi-fu-bao-hd/id481294264?mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
            }
            break;
        default:
            break;
    }
}

-(void)updateUI
{
    orderNumberLabel.text = mdetailOrder.orderCode;
    if ([mdetailOrder.orderStatusForString isEqualToString:@"待结算"] && [mdetailOrder.paymentMethodForString isEqualToString:@"网上支付"])
    {
        
        //设置描述lable的文描
        UILabel *discriptionLable = (UILabel*)[self.view viewWithTag:103];
        discriptionLable.text = @"恭喜您，您的订单已经成功提交，在您支付成功后我们会为您尽快发货!";
        mpayView.hidden = NO;
        [m_PayInfoLabel setText:@"您需要支付"];
        [m_InfoLabel setHidden:YES];
        
        //use new pay button which can change payment
        self.oldPayButton.hidden = YES;
        
        CGRect topBtnRc = self.oldPayButton.frame;
        
        [self.changePayBtn removeFromSuperview];
        self.changePayBtn = [[[OTSChangePayButton alloc] initWithLongButton:NO] autorelease];
        _changePayBtn.frame = CGRectMake( topBtnRc.origin.x
                                         , topBtnRc.origin.y
                                         , _changePayBtn.frame.size.width
                                         , _changePayBtn.frame.size.height);
        
        //CGRect changePayBtnRc = _changePayBtn.frame;
        [mpayView addSubview:_changePayBtn];
        
        [self.changePayBtn.payButton addTarget:self action:@selector(payClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.changePayBtn.changePayButton addTarget:self action:@selector(changePaymentAction:) forControlEvents:UIControlEventTouchUpInside];
        self.changePayBtn.tag = [mdetailOrder.orderId intValue];
        
        _changePayBtn.payButton.enabled = _changePayBtn.changePayButton.enabled = YES;
        
        NSString* bankStr = nil;
        
        for (BankVO* bank in self.bankList)
        {
            if ([bank.gateway intValue] == [mdetailOrder.gateway intValue])
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
        
        [self.payLaterBtn setImage:[UIImage imageNamed:@"gotoshoppingClicked"] forState:UIControlStateNormal];
        [self.payLaterBtn setImage:[UIImage imageNamed:@"gotoshoppingClickedHigh"] forState:UIControlStateHighlighted];
    }
    
    else if ([mdetailOrder.paymentMethodForString isEqualToString:@"网上支付"])
    {
        //设置描述lable的文描
        UILabel *discriptionLable = (UILabel*)[self.view viewWithTag:103];
        discriptionLable.text = @"恭喜您，您的订单已经成功提交，我们会为您尽快发货!";
        mpayView.hidden=YES;
        [m_PayInfoLabel setText:@"您已支付"];
        [m_InfoLabel setHidden:YES];
        
        //gotoshoppingunClicked
        [self.payLaterBtn setImage:[UIImage imageNamed:@"gotoshoppingunClicked"] forState:UIControlStateNormal];
        [self.payLaterBtn setImage:nil forState:UIControlStateHighlighted];
    }
    
    else
    {
        //设置描述lable的文描
        UILabel *discriptionLable = (UILabel*)[self.view viewWithTag:103];
        discriptionLable.text = @"恭喜您，您的订单已经成功提交，我们会为您尽快发货!";
        mpayView.hidden=YES;
        [m_PayInfoLabel setText:@"您需要支付"];
        [m_InfoLabel setHidden:NO];
        
        [self.payLaterBtn setImage:[UIImage imageNamed:@"gotoshoppingunClicked"] forState:UIControlStateNormal];
        [self.payLaterBtn setImage:nil forState:UIControlStateHighlighted];
    }
    
    [m_LoadingView setHidden:YES];
}

-(void)changePaymentAction:(id)sender
{
    [[self.view viewWithTag:10000] removeFromSuperview];
    UIView * popBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:popBgView];
    [popBgView setBackgroundColor:[UIColor grayColor]];
    [popBgView setAlpha:0.6];
    [popBgView setTag:10000];
    
    [self pushChangePaymentView];
}

- (void)moveToRightSide:(UIView *)view{
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(240, 768, 545, 533);
    }
                     completion:^(BOOL finished)
     {
         [[self.view viewWithTag:10000] removeFromSuperview];
         [view removeFromSuperview];
     }];
}

- (void)moveToLeftSide:(UIView *)view{
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(240, 80, 545, 533);
    }
                     completion:^(BOOL finished)
     {
         
     }];
}

-(void)pushChangePaymentView
{
    if (!isChangePaymentViewShowing)
    {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"PayInWebView" owner:self options:nil];
        PayInWebView *  temppayView = [nib objectAtIndex:0];
        temppayView.mBankArray = self.bankList;
        temppayView.tag = 102;
        [self.view addSubview:temppayView];
        [temppayView setFrame:CGRectMake(240, 768, 545, 533)];
        [self moveToLeftSide:temppayView];
        
        isChangePaymentViewShowing = YES;
    }
    
}

#pragma mark - Notification
-(void)popPayInWebView:(NSNotification*)notification
{
    if (isChangePaymentViewShowing)
    {
        int selectedIndex = [notification.object intValue];
        
        if (selectedIndex >= 0)
        {
            BankVO* bankVO = (BankVO*)([self.bankList objectAtIndex:selectedIndex]);
            
            [self performInThreadBlock:^(){
                [self threadRequestSaveGateWay:bankVO];
            } completionInMainBlock:^(){
                [self updateUI];
                [self moveToRightSide:[self.view viewWithTag:102]];
            }];
        }
        else {
            [self moveToRightSide:[self.view viewWithTag:102]];
        }
        
        isChangePaymentViewShowing = NO;
    }
}


-(void)threadRequestSaveGateWay:(BankVO*)aBankVO
{
    BankVO *bankVO = [[aBankVO retain] autorelease];
    if (mdetailOrder)
    {
        //[self.loadingView showInView:self.view];
        
        if ([mdetailOrder isGroupBuyOrder])
        {
            // change group buy order bank
            //GroupBuyService* service = [[[GroupBuyService alloc] init] autorelease];
            
            int resultFlag = [[OTSServiceHelper sharedInstance] saveGateWayToGrouponOrder:[GlobalValue getGlobalValueInstance].token
                                                                                  orderId:mdetailOrder.orderId
                                                                                gatewayId:bankVO.gateway];
            if (resultFlag == 1)
            {
                DebugLog(@"gateway saved OK: %d, bankName:%@", [bankVO.gateway intValue], bankVO.bankname);
                mdetailOrder.gateway = bankVO.gateway;
            }
            else
            {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"保存支付方式失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            }
        }
        else
        {
            // change normal order bank
            //OrderService* service = [[[OrderService alloc] init] autorelease];
            
            SaveGateWayToOrderResult *result = [[OTSServiceHelper sharedInstance] saveGateWayToOrder:[GlobalValue getGlobalValueInstance].token
                                                                                             orderId:mdetailOrder.orderId
                                                                                           gateWayId:bankVO.gateway];
            
            if (result && ![result isKindOfClass:[NSNull class]])
            {
                if ([result.resultCode intValue] == 1)
                {
                    DebugLog(@"gateway saved OK: %d, bankName:%@", [bankVO.gateway intValue], bankVO.bankname);
                    mdetailOrder.gateway = bankVO.gateway;
                    mGateWayId = bankVO.gateway;
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
        
        //[self.loadingView hide];
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

// 弹出银联插件
-(void)popTheUnionpayView:(UINavigationController*)aNavigate onlineOrderId:(NSNumber*)onlineOrderId
{
    NSString *packets;     //服务器取回的银联报文
    packets = [OTSUtility requestSignature:onlineOrderId];
    UnionpayViewCtrl = [LTInterface getHomeViewControllerWithType:1 strOrder:packets andDelegate:self];
    [aNavigate pushViewController:UnionpayViewCtrl animated:YES];
    [self.loadingView showInView:self.view];
}

// 弹出支付宝安全支付
-(void)popTheAlixpayView:(NSNumber *)aOnlineorderid
{
    NSString *appScheme = @"yhdhd";
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (aOnlineorderid != nil) {
        orderString = [OTSUtility requestAliPaySignature:aOnlineorderid];
        //获取安全支付单例并调用安全支付接口
        //全局记录状态
        [[GlobalValue getGlobalValueInstance] setAlixpayOrderId:[NSNumber numberWithLongLong:[aOnlineorderid longLongValue]]];
        
        AlixPay * alixpay = [AlixPay shared];
        [alixpay pay:orderString applicationScheme:appScheme];
    }
}

// 交易插件退出回调方法，需要商户客户端实现 strResult：交易结果，若为空则用户未进行交易。
- (void) returnWithResult:(NSString *)strResult{

    NSString *_respcode = @"";
    if (strResult!=nil) {
        NSRange range1 = [strResult rangeOfString:@"<respCode>"];
        NSRange range3 = [strResult rangeOfString:@"</respCode>"];
        int loca = range1.location +range1.length;
        int len =  range3.location -loca;
        _respcode = [strResult substringWithRange:NSMakeRange(loca,len )];
    }
    if([_respcode isEqualToString:@"0000"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"needUpdateListSucceedStatusHD" object:self userInfo:nil]; ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UnionpayViewCtrl release];
        UnionpayViewCtrl = nil;
        [self.loadingView hide];
    });
    //等待支付状态变为被处理
    /*
    backreflushdone = NO;
    if([_respcode isEqualToString:@"0000"])
    {
        NSTimer *_busTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(checkOrderStatusHD:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_busTimer forMode:NSRunLoopCommonModes];
        do
        {
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
            
        }while (!backreflushdone);
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_respcode isEqualToString:@"0000"]) { 
            MyListViewController *myListVC=[[[MyListViewController alloc] initWithNibName:@"MyListViewController" bundle:nil]autorelease];
            [SharedPadDelegate.navigationController pushViewController:myListVC animated:YES];
        }
        [UnionpayViewCtrl release];
        UnionpayViewCtrl = nil;
        [self.loadingView hide];
    });
     */
}

-(void)checkOrderStatusHD:(NSDictionary *)object
{
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    OrderV2 * v2 =nil;
    int timeout = 0;
    if (ordernumber) {
        do {
            v2 = [service getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:ordernumber];
            [NSThread sleepForTimeInterval:0.2];
            timeout++;
        } while (![v2.orderStatus isEqualToNumber:[NSNumber numberWithInt:4]]&&timeout<50);
    }
    backreflushdone = YES;
}

//检查状态并回调
-(void)checkOrderStatusHD2:(void(^)(void))callback
{
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    OrderV2 * v2 =nil;
    int timeout = 0;
    if (ordernumber) {
        do {
            v2 = [service getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:ordernumber];
            [NSThread sleepForTimeInterval:0.2];
            timeout++;
        } while ([v2.orderStatus intValue] == 3 && timeout<40);
        
        callback();
    }
}

-(IBAction)payClicked:(id)sender
{
    [MobClick event:@"onlinepay"];
    
    [self performInThreadBlock:^(){
        //-----------------获取支付网关的Dictionary----------------------
        NSString* rootPath = [[NSBundle mainBundle]resourcePath];
        NSString* path = [rootPath stringByAppendingPathComponent:@"gateway.plist"];
        NSDictionary *gateWay=[NSDictionary dictionaryWithContentsOfFile:path];
        _mallCup = [[gateWay objectForKey:@"1MALLCUP"] intValue];
        _storeCup = [[gateWay objectForKey:@"1STORECUP"] intValue];
        _storeAlix = [[gateWay objectForKey:@"1STOREALIX"] intValue];
    } completionInMainBlock:^(){
        if ([mGateWayId isEqualToNumber:[NSNumber numberWithInt:_mallCup]]||[mGateWayId isEqualToNumber:[NSNumber numberWithInt:_storeCup]]) {
            [self popTheUnionpayView:self.navigationController onlineOrderId:ordernumber];
        }
        else if([mGateWayId isEqualToNumber:[NSNumber numberWithInt:_storeAlix]])
        {
            //检查是否安装了支付宝客户端
            if (![self checkalixpayClient]){
                [self showNoAlixsafepayment];
            }
            else {
                [self popTheAlixpayView:ordernumber];
            }
        }
        else
        {
            OnlinePayViewController * temppay = [[OnlinePayViewController alloc]init];
            [temppay setMOrderId:ordernumber];
            [temppay setMGateWayId:mGateWayId];
            [self.navigationController pushViewController:temppay animated:YES];
            [temppay release];
        }
    }];
    
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

-(void)showNoAlixsafepayment
{
    UIAlertView * mAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未安装支付宝客户端，或版本过低。请下载或更新支付宝客户端（耗时较长）。" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"取消", nil];
    mAlert.tag=5;
    [mAlert show];
    [mAlert release];
}


-(IBAction)goonShoppingClicked:(id)sender
{
    [self.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)listDetailClicked:(id)sender
{
    OrderTrackViewController *myController =
    [[OrderTrackViewController alloc]initWithNibName:nil bundle:nil] ;
    myController.orderDetail=mdetailOrder;
    
    [self.navigationController pushViewController:myController animated:NO];
    [myController release];
}

@end
