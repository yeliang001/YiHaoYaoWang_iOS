//
//  CheckOrder.m
//  CheckOrder
//
//  Created by yangxd on 11-02-20.
//  Updated by yangxd on 11-03-11  完善界面
//  Updated by yangxd on 11-04-19  添加下单成功后的晒单功能
//  Updated by yangxd on 11-06-14  修正输入发票内容时画面上移效果
//  Updated by yangxd on 11-07-20  添加在线支付功能
//  Copyright 2011 vsc. All rights reserved.
//

#import "CheckOrder.h"
#import "Page.h"
#import "RegexKitLite.h"
#import "GlobalValue.h"
#import "ProductVO.h"
#import "OrderVO.h"
#import "OrderItemVO.h"
#import "GoodReceiverVO.h"
#import "CouponVO.h"
#import "InvoiceVO.h"
#import "BankVO.h"
#import "OrderService.h"
#import "CartService.h"
#import "CouponService.h"
#import "GoodReceiver.h"
#import "PayService.h"
#import "MyOrder.h"
#import "OnlinePay.h"
#import <QuartzCore/QuartzCore.h>
#import "PaymentMethodVO.h"

#import "Invoice.h"
#import "AddressService.h"
#import "DataController.h"
#import "EditGoodsReceiver.h"
#import "AccountBalance.h"
#import "OTSSecurityValidationVC.h"
#import "NeedCheckResult.h"
#import "OTSNaviAnimation.h"
#import "AlertView.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSAlertView.h"
#import "OTSActionSheet.h"
#import "OTSBadgeButton.h"
#import "OTSOrderSubmitOKVC.h"
#import "OTSImageView.h"
#import "DoTracking.h"

#import "ProductInfo.h"
#import "JSONKit.h"
#import "YWOrderService.h"
#import "UserInfo.h"
#import "OrderResultInfo.h"
#import "OrderInfo.h"
#import "OrderPackageInfo.h"
#import "YWConst.h"
#import "YWLocalCatService.h"
#import "MobClick.h"
#import "GiftInfo.h"
#import "CartInfo.h"

#define ALERTVIEW_TAG_CANCEL_ORDER 203		 // 取消订单提示框标识
#define ALERTVIEW_TAG_OTHERS 204             // 其他提示框标识
#define ALERTVIEW_TAG_MSG_ORDER 205          //短信验证后保存订单仍然失败
#define ALERTVIEW_TAG_MSG_GATEWAY 206        //提示抵用券不支持货到支付
#define ALERTVIEW_TAG_ORDER_DISTRIBUTION 207 //提示有商品不能被配送
#define TAG_PAYMENT_CELL_LABEL      999

#define THREAD_STATUS_SUBMIT_ORDER          302
#define THREAD_STATUS_GET_SESSIONORDER      304
#define THREAD_STATUS_CLEAR_ALLPRODUCTS     305
#define THREAD_STATUS_SAVE_PAYMENT_ONLY     309
#define THREAD_STATUS_GET_PAYMENT_METHOD    310
#define THREAD_STATUS_SUBMIT_ORDER_EX       311
#define THREAD_STATUS_GET_RECEIVERLIST      312
#define THREAD_STATUS_GET_ACCOUNT_BALANCE   314     // 获取用户账户余额
#define THREAD_STATUS_GET_ACCOUNT_COUPON    315     // 获取用户可用抵用券
#define THREAD_STATUS_CHECKORDER            346     // 检查订单 yaowang

#define THE_HINT_COUPON                     2000
#define GOODS_TO_PAY                        @"货到付现金"
#define GOODS_TO_CARD                       @"货到刷卡"
#define GOODS_PAY_ONLINE                    @"网上支付"

#define BALANCE_PAY_CASH    0
#define BALANCE_PAY_GIFTCARD 1

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define CELL_HEIGHT 15
#define OTS_EMPTY_STR       @" "
#define OTS_FOCUS_COLOR     DARK_RED_COLOR
#define OTS_NORMAL_COLOR     [UIColor blackColor]

#define DARK_RED_COLOR  [UIColor colorWithRed:204.0/255.0 green:0.0 blue:1.0/255.0 alpha:1.0]

// Table view cell type define
typedef enum _KOtsCheckOrderCellType
{
    EOtsCoCellPaymentWay = 0    // 支付方式
    , EOtsCoCellCoupOn          // 抵用券
    , EOtsCoCellBalancePay      // 余额支付
    , EOtsCoCellGiftCardPay     // 礼品卡余额支付
    , EOtsCoCellInvoice         // 发票
}KOtsCheckOrderCellType;

@interface CheckOrder ()
{
    BOOL      isExpand;     //收缩状态
}
@property (retain)  NSMutableArray  *goodItems;     // 商品 + 赠品
@property (retain)  NSMutableDictionary *packGoodItems; //分包裹的  商品 + 赠品
@property (retain)  NSMutableDictionary *packGoodisExpand; //各个包裹的 收缩状态
@property(nonatomic)int balanceStyle;   // 余额使用方式，0为现金，1为礼品卡。

-(CGFloat)heightForMoneyFristRow;
-(UITableViewCell*)decorateCell:(UITableViewCell*)aCell type:(KOtsCheckOrderCellType)aType;
-(UITableViewCell*)cellWithStyle:(UITableViewCellStyle)aCellStype;
-(void)updatePaymentLabelScrollIfFocus:(BOOL)aScrollIfFocus;
-(void)setPaymentLabel:(NSString*)aPaymentStr;
-(NSArray*)gifts;
-(NSArray*)goods;
-(NSDictionary *)packgifts; //分包赠品
-(NSDictionary *)packgoods; //分包商品
@end

@implementation CheckOrder
@synthesize isBankNull;
@synthesize m_HasAddress;//传入参数，是否有收货地址
@synthesize m_UserSelectedGiftArray;//传入参数，用户已选赠品，包含NSMutableDictionary
@synthesize m_Mycoupon;//订单上绑定的抵用券
@synthesize m_delegate, m_Invoice, m_PayMethodStr;
@synthesize goodItems = _goodItems;
@synthesize packGoodItems = _packGoodItems;
@synthesize packGoodisExpand = _packGoodisExpand;
@synthesize balanceStyle;
@synthesize distributionArray;
@synthesize distributionError;
@synthesize m_MoneyTableView;
@synthesize m_ProductTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.goodItems = [NSMutableArray array];
    self.packGoodItems = [NSMutableDictionary dictionary];
    self.packGoodisExpand = [NSMutableDictionary dictionary];
    
    CGRect theRc = self.view.frame;
    theRc.origin.y = OTS_IPHONE_NAVI_BAR_HEIGHT;
    m_ScrollView.frame = theRc;
    
    if (self.isFullScreen)
    {
        [self strechViewToBottom:m_ScrollView];
    }
    
    [self initCheckOrder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveGoodReceiverToOrder:) name:@"SaveGoodReceiveToOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveInvoiceToOrder:) name:@"SaveInvoiceToOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector
     (saveCouponToOrder:) name:@"saveCouponToOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePaymentMethodLabel:) name:@"UpdatePaymentMethod" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCheckOrderView:) name:@"showCheckOrderView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payMentWayChanged:) name:@"PayMentWayChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeDistributionArray:) name:@"removeDistributionArray" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCartAndRefresh:) name:OTS_NOTIFY_GOTO_CART_AND_REFRESH object:nil];
    
	gatewayType=-1;
	methodID=-1;
	selectedIndex=0;
    fromTag = 0;
	m_OrderService=[[OrderService alloc]init];
    m_UseCouponMoney = 0.0;
    self.m_delegate = (MyStoreViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:3];
    
    m_ThreadState=THREAD_STATUS_CHECKORDER;
    [self setUpThread:YES];
}


//刷新支付方式显示, 货到支付
-(void)payMentWayChanged:(NSNotification *)notification{ // 从选择支付页面回来后需要更新4个值，分别是 paymentType， gatewayType，methodId, m_PayMethodStr
    NSString* tempPaymentMehtod = (NSString*)[notification object];
    
    _paymentType = [tempPaymentMehtod intValue];
    if ([tempPaymentMehtod intValue] == kYaoPaymentReachPay)
    {
        self.m_PayMethodStr = @"货到付现金";
    }
    else if ([tempPaymentMehtod intValue] == kYaoPaymentPosPay)
    {
        self.m_PayMethodStr = @"货到刷卡";
    }
    else if ([tempPaymentMehtod intValue] == kYaoPaymentAlipay)
    {
        self.m_PayMethodStr = @"支付宝客户端支付";
    }
    paymentType = [tempPaymentMehtod intValue];
    
//    
//    self.m_PayMethodStr = [tempPaymentMehtod methodName];
//    
//    if ([m_PayMethodStr isEqualToString:GOODS_TO_PAY])
//    {
//        paymentType = 2;
//    }
//    else if ([m_PayMethodStr isEqualToString:GOODS_TO_CARD])
//    {
//        paymentType = 3;
//    }
    
    methodID = [tempPaymentMehtod intValue];
    gatewayType = [tempPaymentMehtod intValue];
    [self setPaymentLabel:m_PayMethodStr];
}




-(void)initCheckOrder
{
    //收货人信息
    m_ReceiverTableView = [self tableViewFromTemplate];

    [m_ScrollView addSubview:m_ReceiverTableView];
    
    //支付方式
    m_PaymentTableView = [self tableViewFromTemplate];

    [m_ScrollView addSubview:m_PaymentTableView];
    
    //发票信息
    invoiceTV = [self tableViewFromTemplate];

    [m_ScrollView addSubview:invoiceTV];
    
    //提交订单
    m_SubmitBtn=[[UIButton alloc] initWithFrame:CGRectMake(9, 0, 302, 43)];
    [m_SubmitBtn setBackgroundImage:[UIImage imageNamed:@"orange_long_btn.png"] forState:UIControlStateNormal];
    [m_SubmitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [m_SubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[m_SubmitBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:18.0]];
    [m_SubmitBtn addTarget:self action:@selector(submitOrderBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [m_ScrollView addSubview:m_SubmitBtn];
    [m_SubmitBtn release];
    
    [m_ScrollView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [m_ScrollView setHidden:YES];
}

- (void)updateCheckOrder
{
    
    if (_packageIsExpandingArr)
    {
        [_packageIsExpandingArr release];
    }
    //每个元素代表这个包裹是否已经展开，默认@“0” 表示没展开 @“1”表示展开
    _packageIsExpandingArr = [[NSMutableArray alloc] initWithCapacity:checkOrder.orderPackageArr.count];
    for (int i = 0; i < checkOrder.orderPackageArr.count; ++i)
    {
        [_packageIsExpandingArr addObject:[NSNumber numberWithBool:NO]];
    }
    
    
    double yValue=0.0;
    //收货人信息
    if ([checkOrder goodReceiver]==nil)
    {
        [m_ReceiverTableView setFrame:CGRectMake(0, yValue, 320, 100)];
        yValue+=100;
    }
    else
    {
        m_HasAddress = YES;
        //255.0-44.0*3 去除收货地址的3行 行高
        double height=255.0-44.0*3;
        if ([[checkOrder goodReceiver] receiverMobile]!=nil && [[checkOrder goodReceiver] receiverMobile].length > 0)
        {
            height+=22.0;
        }
        if ([[checkOrder goodReceiver] receiverPhone]!=nil && [[checkOrder goodReceiver] receiverPhone].length > 0)
        {
            height+=22.0;
        }
        [m_ReceiverTableView setFrame:CGRectMake(0, yValue, 320, height)];
        yValue+=height;
    }
    [m_ReceiverTableView reloadData];
    
    
    //支付方式
    [m_PaymentTableView setFrame:CGRectMake(0, yValue, 320, 182+44)];
    [m_PaymentTableView reloadData];
    yValue += 88;
    
    //发票信息
    invoiceTV.frame = CGRectMake(0, yValue, 320, 100);
    [invoiceTV reloadData];

    //刷新商品table及下面部分:包裹 金额等
    [self updateCheckOrderForProductTable];
}



-(void)gotoCartAndRefresh:(NSNotification *)notification
{
    [SharedDelegate enterCartWithUpdate:YES];
}

//保存收货人信息到订单
-(void)saveGoodReceiverToOrder:(NSNotification *)notification
{
    _addressId = [(NSString *)notification.object retain];
    if (_orderProducts.count == 0)
    {
        _orderProducts = [GlobalValue getGlobalValueInstance].currentOrderProductList;
    }
    m_ThreadState=THREAD_STATUS_CHECKORDER;
	[self setUpThread:YES];
}




//保存发票信息到订单
-(void)saveInvoiceToOrder:(NSNotification *)notification
{
	NSArray* tempArray = (NSArray*)[notification object];
	if (editInvoiceVO != nil) {
		[editInvoiceVO release];
	}
	editInvoiceVO = [[tempArray objectAtIndex:0] retain];
	titleStyle = [tempArray objectAtIndex:1];						//抬头类型 个人为0，公司为1
	
	NSNumber* isHadSave = [tempArray objectAtIndex:2];				//标帜从“返回”返回，还是从“保存”返回 0为保存，1为返回
	if (isHadSave == [NSNumber numberWithInt:0])
    {
		[m_InvoiceLabel setText:editInvoiceVO.title];
		[m_Invoice setM_InvoiceTitle:editInvoiceVO.title];
		[m_Invoice setM_InvoiceContent:editInvoiceVO.content];
		[m_Invoice setM_InvoiceAmount:m_CheckOrderVO.productAmount];
		isNeedInvoice = YES;
		//将抬头保存到本地
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* directory = [paths objectAtIndex:0];
		NSString* fileName = [directory stringByAppendingPathComponent:@"InvoiceTitle.plist"];
		[editInvoiceVO.title writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
	}
    else
    {
		NSNumber* isNeed = [tempArray objectAtIndex:3];
		if ([isNeed intValue] == 1) {						//不需要需要发票
			[m_InvoiceLabel setText:@"否"];
			isNeedInvoice = NO;
		}
	}
}

-(void)setPaymentLabel:(NSString*)aPaymentStr
{
    [m_PaymentWayDetailLbl setText:aPaymentStr];
    
    if (aPaymentStr && [aPaymentStr length] > 0)
    {
        UIView* view = [m_PaymentWayDetailLbl.superview viewWithTag:TAG_PAYMENT_CELL_LABEL];
        if (view && [view isKindOfClass:[UILabel class]])
        {
            ((UILabel*)view).textColor = [UIColor blackColor];
        }
    }
}



//显示view
-(void)showCheckOrderView:(NSNotification *)notification
{
    [self.view setHidden:NO];
}



-(UITableView*)tableViewFromTemplate
{
    UITableView* tv=[[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 50) style:UITableViewStyleGrouped] autorelease];
    [tv setBackgroundColor:[UIColor clearColor]];
    [tv setBackgroundView:nil];
    [tv setScrollEnabled:NO];
    [tv setDelegate:self];
    [tv setDataSource:self];
    
    //为了适配iOS7
    if(ISIOS7)
    {
         tv.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,tv.bounds.size.width, 1.f)] autorelease];
    }
    
    
    return tv;
}



//移除包裹的table view
-(void)removeTagTable:(int) num;
{
    for (int i=0; i<num; i++) {
        UITableView *temTable = (UITableView *)[self.view viewWithTag:100+i];
        [temTable removeFromSuperview];
    }
    //移出商品信息的那个标签
    UILabel *temlable = (UILabel *)[self.view viewWithTag:100001];
    [temlable removeFromSuperview];
    [m_MoneyTableView removeFromSuperview];
    [m_ProductTableView removeFromSuperview];
}

//只刷新商品table及下面部分
-(void)updateCheckOrderForProductTable
{
    CGFloat yValue=invoiceTV.frame.origin.y+invoiceTV.frame.size.height;
    
    //这里若有子订单则显示包裹 否则显示商品信息
    if ([checkOrder.orderPackageArr count]>0)
    {
        UIView *pLable = [m_ScrollView viewWithTag:11111];
        [pLable removeFromSuperview];
        
        [self removeTagTable:[checkOrder.orderPackageArr count]];
        //包裹
    
        
        //为了适配iOS7
        if (!ISIOS7)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, yValue, 200, 30)];
            [label setText:@"配送方式"];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont boldSystemFontOfSize:17.0]];
            [label setTextColor:[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:110.0/255.0 alpha:1.0]];
            label.tag = 11111;
            [m_ScrollView addSubview:label];
            [label release];
            yValue+=25;
        }

        
        
        int i;
        for (i=0; i<[checkOrder.orderPackageArr count]; i++)
        {
            OrderPackageInfo *package = [checkOrder.orderPackageArr objectAtIndex:i];
            
            float h = 41.0;
            //为了适配iOS7
            if (ISIOS7)
            {
                h += 40;
            }
            
            if ([package.packageProductArr count] == 1)
            {//如果这个包裹只有一个商品
                h += 53.0;  //*([self countOfPackageProductTable:i]-1);
            }
            else
            {//如果包裹有多个商品
                h += 53.0*([self countOfPackageProductTable:i]-2) + 30.0;
            }
            //为了适配iOS7
            if (ISIOS7)
            {
                yValue -=40;
            }
            
            UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, h) style:UITableViewStyleGrouped];
            tableView.sectionHeaderHeight = 0;
            tableView.sectionFooterHeight = 0;
            [tableView setTag:100+i];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setBackgroundView:nil];
            [tableView setScrollEnabled:NO];
            [tableView setTableHeaderView:nil];
            [tableView setTableFooterView:nil];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [m_ScrollView addSubview:tableView];
            [tableView release];
            yValue+=h;
        }
        
        
        
        self.m_MoneyTableView = [self tableViewFromTemplate];
        [m_MoneyTableView setFrame:CGRectMake(0, yValue, 320, 110+25 /*280*/)];
        [m_ScrollView addSubview:m_MoneyTableView];
        yValue+= 110;//260.f;
    }
    else
    {
        //商品信息
        self.m_ProductTableView = [self tableViewFromTemplate];
        [m_ScrollView addSubview:m_ProductTableView];
        //商品信息显示
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, yValue, 200, 30)];
        [label setText:@"商品信息"];
        [label setTag:100001];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont boldSystemFontOfSize:17.0]];
        
        [label setTextColor:[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:110.0/255.0 alpha:1.0]];
        [m_ScrollView addSubview:label];
        [label release];
        yValue+=25;
        
        int goodCount = self.goodItems.count;
        float height = 0.f;
        if ([self isNeedExpand])
        {
            if (!isExpand)
            {
                goodCount = 3;
            }
            
            height = goodCount  * 95.f + 44.f;
        }
        else
        {
            height = goodCount  * 95.f;
        }
        
        height += [self heightForMoneyFristRow] + 44.0 + 60.f;
        
        currentProTabY=yValue;
        [m_ProductTableView setFrame:CGRectMake(0, yValue, 320, height+25)];
        [m_ProductTableView reloadData];
        yValue+=height;
    }
    
    yValue += 25; //现在增加了满减，所以多25 不知道应该加哪里 先放这
    //提交订单
    [m_SubmitBtn setFrame:CGRectMake(9, yValue, 302, 43)];
    yValue+=53.0;
    
    [m_ScrollView setContentSize:CGSizeMake(320, yValue)];
    [m_ScrollView setHidden:NO];
    
    //用户无收货地址，进入新建地址界面
    if (_checkedOrderResult.resultCode != 1 && [_checkedOrderResult isNoAddress])// && !m_HasAddress)
    {
        m_HasAddress = YES;
        [self enterEditGoodsReceiverFromCart];
        return;
    }
    else if (_checkedOrderResult.resultCode != 1 && ![_checkedOrderResult isNoAddress])
    {
        [self showError:_checkedOrderResult.errorStr];
        [self backBtnClicked:nil];
    }
    
    
    //[self checkThePaymentStatus];
}


#pragma mark 返回按钮
-(IBAction)backBtnClicked:(id)sender
{
	PhoneCartViewController* cart = [SharedDelegate.tabBarController.viewControllers objectAtIndex:2];
	[cart setUniqueScrollToTopFor:cart.cartTableView];
    [self removeSelf];
    [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
}

#pragma mark 提交订单按钮
- (BOOL)isOrderFullyPayed
{
    return [m_NeedPayMoneyLabel.text isEqualToString:@"￥0.00"];
}

-(IBAction)submitOrderBtnClicked:(id)sender
{
	if (checkOrder.goodReceiver == nil)
    {
        [self showAlertView:nil alertMsg:@"送货地址不能为空!" alertTag:ALERTVIEW_TAG_OTHERS];
	}
    else if (isNeedInvoice == NO && checkOrder.isMustInvoice)
    {
        [self showAlertView:nil alertMsg:@"该商品必须开发票" alertTag:3333];
    }
    else if (methodID == -1)
    {
        [self showAlertView:nil alertMsg:@"请选择付款方式!" alertTag:ALERTVIEW_TAG_OTHERS];
    }
    else
    {
        //提交订单
        m_ThreadState = THREAD_STATUS_SUBMIT_ORDER;
        [self setUpThread:YES];
        
    }
}

#pragma mark - Address Manage
//跳转到地址列表页
-(void)enterGoodsReceiverList
{
	GoodReceiver* goodRecieverVC = [[[GoodReceiver alloc]initWithNibName:@"GoodReceiver" bundle:nil] autorelease];
    [goodRecieverVC setM_FromTag:FROM_CHECK_ORDER];
    [goodRecieverVC setM_DefaultReceiverId:checkOrder.goodReceiver.nid];
    
    [self pushVC:goodRecieverVC animated:YES fullScreen:YES];
}

//进入新建地址界面
-(void)enterEditGoodsReceiver
{
    EditGoodsReceiver *editGoodRecieverVC = [[[EditGoodsReceiver alloc] initWithNibName:@"EditGoodsReceiver" bundle:nil] autorelease];
    [editGoodRecieverVC setM_FromTag:FROM_CHECK_ORDER];
    
    [self pushVC:editGoodRecieverVC animated:YES fullScreen:YES];
}

//从购物车直接进入新建地址界面
-(void)enterEditGoodsReceiverFromCart
{
    EditGoodsReceiver *editGoodRecieverVC = [[EditGoodsReceiver alloc] initWithNibName:@"EditGoodsReceiver" bundle:nil];
    [editGoodRecieverVC setM_FromTag:FROM_CHECK_ORDER];
//    [editGoodRecieverVC setIsFromCart:YES];
    [self pushVC:editGoodRecieverVC animated:YES fullScreen:YES];
}

//进入收货地址界面
-(void)enterGoodsReceiver
{
    if (m_NowHasAddress) {
        [self enterGoodsReceiverList];
    } else {
        [self enterEditGoodsReceiver];
    }
}



#pragma mark -
-(void)goToOrderDone:(OrderInfo *)order
{
    
    OTSOrderSubmitOKVC* submitOKVC = [[[OTSOrderSubmitOKVC alloc] initWithOrderId:0] autorelease];
    submitOKVC.order = order;
    submitOKVC.paymentType = _paymentType; //见字段说明 fuck
    submitOKVC.packageCount = checkOrder.orderPackageArr.count;
    submitOKVC.productCount = [checkOrder orderProductCount];
    [self pushVC:submitOKVC animated:YES fullScreen:YES];
}



#pragma mark - alert
//显示提示框
-(void)showAlertView:(NSString *) alertTitle alertMsg:(NSString *)alertMsg alertTag:(int)tag {
	[[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
    UIAlertView *alert;
    alert=[[OTSAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    alert.tag=tag;
	[alert show];
	[alert release];
}

-(void)submitOrderSuccess:(OrderInfo *)orderInfo
{
    //友盟统计事件
    [MobClick event:@"submitorder"];
    NSLog(@"%lf",[orderInfo orderTotalMoney]);
    [self umengEvent:@"OrderMoney" attributes:@{@"device" : @"iPhone",@"channel" : kYWChannel} number:[orderInfo orderTotalMoney]];
    
    
    DebugLog(@"payingOrder %@",orderInfo.orderId);
    [self goToOrderDone:orderInfo];
//    [self otsDetatchMemorySafeNewThreadSelector:@selector(goToOrderDone:) toTarget:self withObject:orderInfo];
    [SharedDelegate clearCartNum];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
    
    //清空购物车数据库
    YWLocalCatService *localSer = [[YWLocalCatService alloc] init];
    [localSer cleanLocalCart];
    [localSer release];
    
    //去掉所有的赠品
    [_selectedGiftList removeAllObjects];
}

-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(CGFloat)number
{
    NSString *numberKey = @"188";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[NSString stringWithFormat:@"%.2f",number] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}


-(void)showError:(NSString *)errorInfo
{
    [AlertView showAlertView:nil alertMsg:errorInfo buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}



//进入在线支付页面
-(void)enterOnlinePayWithOrderId:(NSNumber *)orderId
{
    //清空购物车
    m_ThreadState=THREAD_STATUS_CLEAR_ALLPRODUCTS;
    [self setUpThread:YES];
    
    //进入在线支付页面
    [self removeSubControllerClass:[OnlinePay class]];
    
    OnlinePay* onlinePayVC = [[[OnlinePay alloc] initWithNibName:@"OnlinePay" bundle:nil] autorelease];
    [onlinePayVC setIsFromOrder:YES];
    [onlinePayVC setOrderId:orderId];
    [onlinePayVC setGatewayId:[NSNumber numberWithInt:gatewayType]];
    
    [self pushVC:onlinePayVC animated:YES fullScreen:YES];
}

-(void)updatePaymentShow
{
    [self setPaymentLabel:m_PayMethodStr];
}

//网络异常
-(void)netError
{
    [AlertView showAlertView:nil alertMsg:@"网络异常，请检查网络配置..." buttonTitles:nil
                    alertTag:ALERTVIEW_TAG_COMMON];
}




#pragma mark 建立线程
-(void)setUpThread:(BOOL)showLoading
{
	if (!m_ThreadRunning)
    {
		m_ThreadRunning=YES;
        [self showLoading:showLoading];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}
#pragma mark 开启线程
-(void)startThread {
	while (m_ThreadRunning) {
		@synchronized(self)
        {
            switch (m_ThreadState)
            {
                case THREAD_STATUS_GET_ACCOUNT_BALANCE:
                {//获取账户余额
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    UserService *service=[[UserService alloc] init];
                    UserVO *tempVO;
                    @try {
                        tempVO=[service getMyYihaodianSessionUser:[GlobalValue getGlobalValueInstance].token];
                    }
                    @catch (NSException * e) {
                    }
                    @finally {
                        if (tempVO!=nil && ![tempVO isKindOfClass:[NSNull class]]) {
                            m_BalanceMoney=[[tempVO availableAmount] doubleValue];
                            m_FrozenMoney=[[tempVO frozenAmount] doubleValue];
                            
                            numberOfGiftCard = [[tempVO cardNum] intValue];
                            m_GiftCardBalance = [[tempVO availableCardAmount]doubleValue];
                            m_FrozenGiftCardBalance = [[tempVO frozenCardAmount]doubleValue];
                            
                            [self performSelectorOnMainThread:@selector(enterAccountBalancePay) withObject:nil waitUntilDone:NO];
                            [[GlobalValue getGlobalValueInstance]setCurrentUser:tempVO];
                        } else {
                            m_BalanceMoney=0.0;
                            m_FrozenMoney=0.0;
                            [self performSelectorOnMainThread:@selector(netError) withObject:nil waitUntilDone:NO];
                        }
                        [self stopThread];
                    }
                    [pool drain];
                    break;
                }
                    
                case THREAD_STATUS_CHECKORDER:
                {
          
                    NSDictionary *paramDic = @{@"shopcartdata":[self createOrderJsonString],
                                                  @"addressid":_addressId==nil? @"":_addressId,
                                                 @"provinceid":[GlobalValue getGlobalValueInstance].provinceId,
                                           @"clienttotalmoney": [NSString stringWithFormat:@"%.2f",_cartInfo.money],  //[self caluTotalMoney],
                                                     @"userid":[GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                                                      @"token":[GlobalValue getGlobalValueInstance].ywToken,
                                                   @"username":[GlobalValue getGlobalValueInstance].userInfo.uid,
                                               @"promotionflag":[self makeSureIsJoinPromotion] //－1是不参与， 1是参与促销
                                               };
                    
                    YWOrderService *orderSer = [[YWOrderService alloc] init];
                    OrderResultInfo *orderResult = [orderSer checkOrder:paramDic];
                    _checkedOrderResult = [orderResult retain];
                    if (orderResult.bRequestStatus)
                    {
                        checkOrder = [orderResult.orderInfo retain];
                    }
                    
                    [self performSelectorOnMainThread:@selector(updateCheckOrder) withObject:nil waitUntilDone:NO];
                    [self stopThread];
                    
                    break;
                }
                    
                case  THREAD_STATUS_SUBMIT_ORDER:
                {
                    //fuck 一号店发票类型是：0 个人 1公司  药店：公司1，个人0，不开3
                    NSString *invoiceHeadType = @"";
                    NSString *invoiceTypeName = @"";
                    if (!isNeedInvoice)
                    {
                        //不开发票
                        invoiceHeadType = @"3";
                        editInvoiceVO = [[InvoiceVO alloc] init];
                        editInvoiceVO.title = @"";
                        editInvoiceVO.content = @"";
                        
                    }
                    else if ([titleStyle intValue] == 0)
                    {
                         //个人
                        invoiceHeadType = @"0";
                        invoiceTypeName = @"个人";
                    }
                    else if ([titleStyle intValue] == 1)
                    {
                        //公司
                        invoiceHeadType = @"1";
                        invoiceTypeName = @"公司";
                    }
                    
                    //构造发票信息， xml格式
                    NSString *invoiceXML;
                    if (isNeedInvoice)
                    {
                         invoiceXML = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><XMLInfo><EcOrd_Order_InvoiceDataXml><InvoiceTypeId>0</InvoiceTypeId><InvoiceHeadTypeId>%@</InvoiceHeadTypeId><InvoiceHead>%@</InvoiceHead><InvoiceConent>%@</InvoiceConent></EcOrd_Order_InvoiceDataXml></XMLInfo>",invoiceHeadType,editInvoiceVO.title,editInvoiceVO.content];
                    }
                    else
                    {
                        invoiceXML = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><XMLInfo><EcOrd_Order_InvoiceDataXml><InvoiceTypeId>3</InvoiceTypeId><InvoiceHeadTypeId>1</InvoiceHeadTypeId><InvoiceHead>不开发票</InvoiceHead><InvoiceConent>1</InvoiceConent></EcOrd_Order_InvoiceDataXml></XMLInfo>";
                    }
                   

                    NSDictionary *paramDic = @{@"provinceid": [GlobalValue getGlobalValueInstance].provinceId,
                                               @"addressid" : checkOrder.goodReceiver.nid,
                                               @"clienttotalmoney":[NSString stringWithFormat:@"%.2f", _cartInfo.money /*checkOrder.orderProductTotalPrice*/],
                                               @"clienttotalfare" : [NSString stringWithFormat:@"%.2f",_cartInfo.fare], //checkOrder.fare,
                                               @"clientpaymode" : [NSString stringWithFormat:@"%d",methodID],
                                               @"invoicetype" : invoiceHeadType,
                                               @"invoicetitle" : invoiceTypeName,
                                               @"invoiceheader" : editInvoiceVO.title,
                                               @"invoiceinfo" : invoiceXML,
                                               @"shopcartdata" :[self createOrderJsonString]/*[self createTrueOrderJsonString]*/,
                                               @"userid":[GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                                               @"token":[GlobalValue getGlobalValueInstance].ywToken,
                                               @"username":[GlobalValue getGlobalValueInstance].userInfo.uid,
                                                @"promotionflag":[self makeSureIsJoinPromotion],
                                               @"versioninfo": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                               };
                    DebugLog(@"paramDic %@",paramDic);
                    YWOrderService *oSer = [[YWOrderService alloc] init];
                    ResultInfo *result = [oSer submitOrder:paramDic];
                    if (result.bRequestStatus == YES && result.responseCode == 200)
                    {
                        if (result.resultCode != 1)
                        {
//                            [self showAlertView:nil alertMsg:[result errorStr] alertTag:ALERTVIEW_TAG_OTHERS];
//                            [self showError:result.errorStr];
                            [self performSelectorOnMainThread:@selector(showError:) withObject:result.errorStr waitUntilDone:NO];
                            [self stopThread];
                        }
                        else
                        {
                            [self performSelectorOnMainThread:@selector(submitOrderSuccess:) withObject:(OrderInfo *)result.resultObject waitUntilDone:NO];
                        }
                    }
                    else
                    {
                        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                    }
                    [oSer release];
            
                    
                    [self stopThread];
                    break;
                }
                default:
                    break;
            }
            
		}
	}
}

- (NSString *)makeSureIsJoinPromotion
{
    //确定此订单是不是有促销内容
    //－1是不参与， 1是参与促销
    NSString *promotionFlag = @"-1";
    if (_selectedGiftList.count > 0)
    {
        promotionFlag = @"1";
    }
    else
    {
        for (NSDictionary *productDic in self.orderProducts)
        {
            ProductInfo *product = productDic[@"product"];
            if (product.promotionIdOfReduce != 0)
            {
                promotionFlag = @"1";
                break;
            }
        }
    }
    
    return promotionFlag;
}



-(void)updateGoodItems
{
    [self.goodItems removeAllObjects];
    [self.goodItems addObjectsFromArray:self.goods];
    
    //更新包裹商品
    [self updatePackGoodItems];
}

-(void)updatePackGoodItems
{
    [self.packGoodItems removeAllObjects];
    [self.packGoodItems addEntriesFromDictionary:self.packgoods];
}

#pragma mark - 订单数据
//拼成订单json，构造购物车的商品json 用于给服务器检查购物车
- (NSString *)createOrderJsonString
{
    NSMutableArray *orderArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.orderProducts)
    {
        ProductInfo *productInfo = dic[@"product"];
        NSString *count = dic[@"selectCount"];
        
        NSMutableDictionary *orderDic = [[NSMutableDictionary alloc] init];
        [orderDic setObject:[NSString stringWithFormat:@"%d",productInfo.bigCatalogId] forKey:@"catalogid"];  ///ttt
        [orderDic setObject:productInfo.price forKey:@"price"];
        [orderDic setObject:productInfo.weight forKey:@"weight"];
        [orderDic setObject:@"1" forKey:@"itemtype"]; //1：普通商品 2延保 3套餐 6赠品  7换购  ///tttt
        [orderDic setObject:count forKey:@"itemcount"];//商品数量
        [orderDic setObject:productInfo.sellerId forKey:@"venderid"];
        [orderDic setObject:productInfo.productId forKey:@"itemid"];
        [orderDic setObject:productInfo.productNO forKey:@"itemcode"];
        [orderDic setObject:@"1" forKey:@"isstore"]; //是否有货  0 不知道 1有货 2无货
        [orderDic setObject:@"1" forKey:@"status"]; //商品状态
        [orderDic setObject:@"0" forKey:@"returnmoney"]; //反现 暂时没有，定为0   //////TODO
        [orderDic setObject:productInfo.promotionIdOfReduce!=0?[NSString stringWithFormat:@"%d",productInfo.promotionIdOfReduce] : @"" forKey:@"promotionCutId"];// 促销满减
        //满赠的id
        NSString *promotionSendId = @"";
        if (_selectedGiftList.count > 0 && productInfo.promotionIdOfGift!=0)
        {
            promotionSendId = [NSString stringWithFormat:@"%d",productInfo.promotionIdOfGift];
        }
        [orderDic setObject:promotionSendId forKey:@"promotionSendId"];// 促销满赠
        [orderDic setObject:@"" forKey:@"promotionReturnId"];// 促销满返
        [orderDic setObject:@"" forKey:@"promotionid"];// 促销id
        [orderDic setObject:@"" forKey:@"promotionRetemptionId"];// 促销换购
        
        [orderArr addObject:orderDic];
        [orderDic release];
    }
    
    //促销中的赠品信息
    if (_selectedGiftList.count > 0)
    {
        for  (GiftInfo *gift in _selectedGiftList)
        {
            ProductInfo *productInfo = gift.detailProduct;
            
            NSMutableDictionary *orderDic = [[NSMutableDictionary alloc] init];
            [orderDic setObject:[NSString stringWithFormat:@"%d", productInfo.bigCatalogId] forKey:@"catalogid"]; //商品分类
            [orderDic setObject:[NSString stringWithFormat:@"%.f",gift.markPrice] forKey:@"price"]; //价格
            [orderDic setObject:productInfo.weight forKey:@"weight"];
            [orderDic setObject:@"6" forKey:@"itemtype"]; //1：普通商品 2延保 3套餐 6赠品  7换购
            [orderDic setObject:[NSString stringWithFormat:@"%d",gift.selectedCount] forKey:@"itemcount"];//商品数量
            [orderDic setObject:productInfo.sellerId forKey:@"venderid"];
            [orderDic setObject:[NSString stringWithFormat:@"%d",gift.itemId] forKey:@"itemid"];
            [orderDic setObject:gift.giftId forKey:@"itemcode"];
            [orderDic setObject:@"1" forKey:@"isstore"]; //是否有货  0 不知道 1有货 2无货
            [orderDic setObject:@"1" forKey:@"status"]; //商品状态
            [orderDic setObject:@"0" forKey:@"returnmoney"]; //反现 暂时没有，定为0   //////TODO
            [orderDic setObject:@"" forKey:@"promotionCutId"];// 促销满减
            [orderDic setObject:[NSString stringWithFormat:@"%d",gift.promotionId] forKey:@"promotionSendId"];// 促销满赠
            [orderDic setObject:@"" forKey:@"promotionReturnId"];// 促销满返
            [orderDic setObject:@"" forKey:@"promotionid"];// 促销id
            [orderDic setObject:@"" forKey:@"promotionRetemptionId"];// 促销换购
            
            
            [orderArr addObject:orderDic];
            [orderDic release];
 
        }
        
    }
    
    
    NSString *resultJsonStr =  [orderArr JSONString];
    [orderArr release];
    DebugLog(@"拼成订单Json: %@",resultJsonStr);
    return resultJsonStr;
}

//下单时给服务器的商品信息
- (NSString *)createTrueOrderJsonString
{
        NSMutableArray *orderArr = [[NSMutableArray alloc] init];
        for (OrderPackageInfo *package in checkOrder.orderPackageArr)
        {
            
            for (OrderProductDetail *productInfo in package.packageProductArr)
            {
                NSMutableDictionary *orderDic = [[NSMutableDictionary alloc] init];
                [orderDic setObject:productInfo.catelogId forKey:@"catalogid"];
                [orderDic setObject:productInfo.price forKey:@"price"];
                [orderDic setObject:productInfo.weight forKey:@"weight"];
                [orderDic setObject:@"1" forKey:@"itemtype"]; //1：普通商品 2延保 3套餐 6赠品  7优惠券
                [orderDic setObject:productInfo.productCount forKey:@"itemcount"];//商品数量
                [orderDic setObject:productInfo.venderId forKey:@"venderid"];
                [orderDic setObject:productInfo.productId forKey:@"itemid"];
                [orderDic setObject:productInfo.productNo forKey:@"itemcode"];
                [orderDic setObject:@"1" forKey:@"isstore"]; //是否有货  0 不知道 1有货 2无货
                [orderDic setObject:@"1" forKey:@"status"]; //商品状态
                [orderDic setObject:@"0" forKey:@"returnmoney"]; //反现 暂时没有，定为0
                
                [orderArr addObject:orderDic];
                [orderDic release];
            }
        }

        NSString *resultJsonStr =  [orderArr JSONString];
        [orderArr release];
        DebugLog(@"拼成订单Json: %@",resultJsonStr);
        return resultJsonStr;
}
    
    
    
//因为有促销信息，所以不自己计算购物车价格了，直接把购物车里的数据传过来，直接得到总价
//计算购物车中所有商品的钱
//- (NSString *)caluTotalMoney
//{
//    CGFloat totalMoney = 0.0;
//    for (NSDictionary *dic in self.orderProducts)
//    {
//        ProductInfo *productInfo = dic[@"product"];
//        NSString *count = dic[@"selectCount"];
//        
//        totalMoney += [productInfo.price floatValue] * [count intValue];
//    }
//    DebugLog(@"订单的总价格 %@",[NSString stringWithFormat:@"%.2lf",totalMoney]);
//    return [NSString stringWithFormat:@"%.2lf",totalMoney];
//}


#pragma mark 停止线程
-(void)stopThread {
	m_ThreadRunning=NO;
	m_ThreadState=-1;
    [self hideLoading];
}

#pragma mark tableview相关部分

//设置列表行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==m_ReceiverTableView)
    {
        return [self receiverTableViewCellAtIndex:[indexPath row]];
    }
    else if (tableView==m_ProductTableView)
    {
        return [self productTableViewCellAtIndex:[indexPath row]];
        
    }
    else if (tableView==m_PaymentTableView)
    {
        return [self paymentTableViewCellAtIndex:[indexPath row]];
    }
    
    else if (tableView == invoiceTV)
    {
        return [self decorateCell:[self cellWithStyle:UITableViewCellStyleValue1] type:EOtsCoCellInvoice];
    }
    else if (tableView==m_MoneyTableView)
    {
        return [self moneyTableViewCellAtIndex:[indexPath row]];
    }
    //包裹
    else if ([tableView tag]>=100)
    {
        return [self packageTableViewCellAtIndexPath:indexPath iN:tableView];
    }
    else
    {
        UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        return cell;
    }
}

-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==m_ReceiverTableView)
    {
        if ([indexPath row]==0)
        {
            [self receiverTableViewClicked];
        }
        else if(indexPath.row==3)
        {
            [self showDeliverAmountRegular];
        }
    }
    
    else if (tableView==m_ProductTableView)
    {
        [self productTableViewClicked:[indexPath row]];
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    else if (tableView==m_PaymentTableView)
    {
        if ([indexPath row] == 0)
        {
            //付款方式
            [self paymentMethodTableViewClicked];
        }
        
        if ([indexPath row] == 1)
        {
            [self useCouponClicked];
        }
        else if ([indexPath row] == 2)
        {
            self.balanceStyle = BALANCE_PAY_GIFTCARD;
            [self balancePayClicked];
        }
        else if ([indexPath row] == 3)
        {
            self.balanceStyle = BALANCE_PAY_CASH;
            [self balancePayClicked];
        }
    }
    
    else if (tableView == invoiceTV)
    {
        [self InvoiceTableViewClicked];
    }
    
    else if (tableView == m_MoneyTableView)
    {
    }
    // tableView tag > 100 表示是包裹的 table
    else if ([tableView tag]>=100)
    {
        int packageTableIndex = tableView.tag - 100;
        int packageCellIndex = [indexPath row];
        [self packageProductTableViewClicked:packageTableIndex Cell:packageCellIndex];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}



//选择银行
-(void)showChooseBankView
{
    [self removeSubControllerClass:[OnlinePay class]];
    NSMutableArray *mArray=[NSMutableArray array];
    for (PaymentMethodVO *paymentMehtod in m_PaymentMethods)
    {
        if ([paymentMehtod gatewayId]==nil)
        {
            [mArray addObject:paymentMehtod];
        }
    }
    
    OnlinePay* onlinePayVC = [[[OnlinePay alloc] initWithNibName:@"OnlinePay" bundle:nil] autorelease];
    [onlinePayVC setMethodID:methodID];
    [onlinePayVC setIsFromCheckOrder:YES];
    [onlinePayVC setGatewayId:[NSNumber numberWithInt:gatewayType]];
    [onlinePayVC setPayMentWayArr:mArray];
    [onlinePayVC setPayMethodStr:self.m_PayMethodStr];
    
    //yaowang
    onlinePayVC.checkingOrder = checkOrder;
    
    [self pushVC:onlinePayVC animated:YES fullScreen:YES];
}


//设置列表行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==m_ReceiverTableView) {
        //收货地址留一行
        return 1;
    }
    else if (tableView==m_ProductTableView)
    {
        return [self countOfProductTable];
        
//#if 0
//        if (count<=3) {
//            if (m_UserSelectedGiftArray!=nil && [m_UserSelectedGiftArray count]>0) {
//                return count+1+2;
//            } else {
//                return count+2;
//            }
//        } else if (count>3 && !m_ShowAllProduct) {
//            if (m_UserSelectedGiftArray!=nil && [m_UserSelectedGiftArray count]>0) {
//                return 5+2;
//            } else {
//                return 4+2;
//            }
//        } else {
//            if (m_UserSelectedGiftArray!=nil && [m_UserSelectedGiftArray count]>0) {
//                return count+2+2;
//            } else {
//                return count+1+2;
//            }
//        }
//#endif
        
    }
    else if (tableView==m_PaymentTableView)
    {
        return 1;
    }
    
    else if (tableView == invoiceTV)
    {
        return 1;
    }
    else if (tableView==m_MoneyTableView)
    {
        return 2;
    }
    // tableView tag > 100 表示是包裹的 table
    else if ([tableView tag]>=100)
    {
        int packageIndex = tableView.tag - 100;
        return [self countOfPackageProductTable:packageIndex];
    }
    
    return 0;
}

// 设置列表表头
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==m_ReceiverTableView)
    {
        return @"收货地址";
    }
    else if (tableView==m_PaymentTableView)
    {
        return @"支付信息";
    }
    
    else if (tableView == invoiceTV)
    {
        return @"发票信息";
    }
    else if (tableView==m_MoneyTableView)
    {
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==m_ReceiverTableView)
    {
        return 25.f;
    }
    else if (tableView==m_PaymentTableView)
    {
        return 25.f;
    }
    
    else if (tableView == invoiceTV)
    {
        return 25.f;
    }

    return 0.01f;

}

//设置列表行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==m_ReceiverTableView)
    {
        if ([indexPath row]==0)
        {
            if ([checkOrder goodReceiver]==nil)
            {
                return 44.0;
            }
            else
            {
                double height=76.0;
                if ([[checkOrder goodReceiver] receiverMobile]!=nil && [[checkOrder goodReceiver] receiverMobile].length > 0)
                {
                    height+=22.0;
                }
                if ([[checkOrder goodReceiver] receiverPhone]!=nil && [[checkOrder goodReceiver] receiverPhone].length > 0 ) {
                    height+=22.0;
                }
                return height;
            }
        } else {
            return 44.0;
        }
    }
    
    else if (tableView==m_ProductTableView)
    {
        
        int count = [self countOfProductTable];
        if ([self isNeedExpand] && indexPath.row == count - 3)
        {
            return 44.f;
        }
        else if (indexPath.row == count - 2)
        {
            return [self heightForMoneyFristRow];
        }
        else if (indexPath.row == count - 1)
        {
            return 44.f;
        }
        
        return 105.f;
        
//#if 0
//        if (count>3)
//        {
//            if (!m_ShowAllProduct)
//            {
//                //有赠品 且未展开显示前3个商品＋1个展开＋1个赠品＋2金额
//                if (m_UserSelectedGiftArray!=nil&&m_UserSelectedGiftArray.count) {
//                    if ([indexPath row]==3 || [indexPath row]==4) {
//                        return 44.0;
//                    }else if (indexPath.row==5) {
//                        return [self heightForMoneyFristRow];
//                    }else if (indexPath.row==6) {
//                        return 44;
//                    }
//                }else {//没赠品 没展开商品 3个＋1展开＋2金额
//                    if (indexPath.row==3) {
//                        return 44;
//                    }else if (indexPath.row==4) {
//                        return [self heightForMoneyFristRow];
//                    }else if (indexPath.row==5) {
//                        return 44;
//                    }
//                }
//                return 105.0;
//            }
//            
//            else
//            {//展开了
//                //有赠品
//                if (m_UserSelectedGiftArray!=nil&&m_UserSelectedGiftArray.count) {
//                    if (indexPath.row==count||[indexPath row] == count+1) {
//                        return 44;
//                    }else if (indexPath.row==count+2) {
//                        return [self heightForMoneyFristRow];
//                    }else if (indexPath.row==count+3) {
//                        return 44;
//                    }
//                    return 105;
//                }else {
//                    if (indexPath.row==count) {
//                        return 44;
//                    }else if (indexPath.row==count+1) {
//                        return [self heightForMoneyFristRow];
//                    }else if (indexPath.row==count+2) {
//                        return 44;
//                    }
//                    return 105;
//                }
//            }
//            
//        } else {
//            // 商品数量小于3，全部显示，不存在展开收起栏
//            //有赠品 显示商品数+1赠品＋2金额
//            if (m_UserSelectedGiftArray!=nil&&m_UserSelectedGiftArray.count) {
//                if (indexPath.row==count) {
//                    return 44;
//                }else if (indexPath.row==count+1) {
//                    return [self heightForMoneyFristRow];
//                }else if (indexPath.row==count+2) {
//                    return 44;
//                }
//                
//            }else {
//                //没赠品   商品+金额
//                if (indexPath.row==count ){
//                    return [self heightForMoneyFristRow];
//                }else if (indexPath.row==count+1) {
//                    return 44;
//                }
//            }
//            
//            return 105.0;
//        }
//#endif
        
    }
    
    else if (tableView==m_PaymentTableView)
    {
        return 44.0;
    }
    
    else if (tableView == invoiceTV)
    {
        return 44.0;
    }
    
    else if (tableView==m_MoneyTableView) // 这里压根就没用到，扯蛋玩意儿。这个被并到 productTableView里面去了。去那里改吧，骚年！！！
    {
        if ([indexPath row]==0)
        {
            //满减 和 赠品 的坐标偏移
            float OffsetY= 53+25; //135.0+23+25;
            return OffsetY;
        }
        else if ([indexPath row]==1)
        {
            return 44.0;
        }
    }
    //包裹
    else if ([tableView tag]>=100)
    {
        
        int Tableindex = [tableView tag] - 100;
//        NSString *nindex  = [NSString stringWithFormat:@"%d",Tableindex];
        
        int cellcount = [self countOfPackageProductTable:Tableindex];
        
        if ([indexPath row]==0)
        {
            return 30.0;
        }
        if ([self isNeedExpand:Tableindex] && [indexPath row] == cellcount - 1)
        {
            return 30.0;
        }
        else
        {
            return 53.0;
        }
    }
    
    return 0.0;
}



-(void)receiverTableViewClicked
{
    [self enterGoodsReceiverList];
}
//运费规则
-(void)showDeliverAmountRegular{
    
    
}
-(void)balancePayClicked
{
    if ([[m_PaymentWayDetailLbl text] isEqualToString:OTS_EMPTY_STR] && [checkOrder goodReceiver]==nil) {
        [self showAlertView:nil alertMsg:@"您目前没有选择送货地址,请先选择您的送货地址!" alertTag:ALERTVIEW_TAG_OTHERS];
    } else if ([[m_PaymentWayDetailLbl text] isEqualToString:OTS_EMPTY_STR] && m_AddressNotSupport) {
        [self showAlertView:nil alertMsg:@"您目前的送货地址不支持任何支付方式,请先确认您的送货地址!" alertTag:ALERTVIEW_TAG_OTHERS];
    } else {
        m_ThreadState=THREAD_STATUS_GET_ACCOUNT_BALANCE;
        [self setUpThread:YES];
    }
}

-(void)useCouponClicked
{
    if ([[m_PaymentWayDetailLbl text] isEqualToString:OTS_EMPTY_STR] && [checkOrder goodReceiver]==nil) {
        [self showAlertView:nil alertMsg:@"您目前没有选择送货地址,请先选择您的送货地址!" alertTag:ALERTVIEW_TAG_OTHERS];
    } else if ([[m_PaymentWayDetailLbl text] isEqualToString:OTS_EMPTY_STR] && m_AddressNotSupport) {
        [self showAlertView:nil alertMsg:@"您目前的送货地址不支持任何支付方式,请先确认您的送货地址!" alertTag:ALERTVIEW_TAG_OTHERS];
    } else {
        m_ThreadState=THREAD_STATUS_GET_ACCOUNT_COUPON;
        [self setUpThread:NO];
    }
}

-(void)InvoiceTableViewClicked
{
    if ([checkOrder goodReceiver]==nil)
    {
        [self showAlertView:nil alertMsg:@"您目前没有选择送货地址,请先选择您的送货地址!" alertTag:ALERTVIEW_TAG_OTHERS];
    }
//    else if([m_CheckOrderVO.paymentMethodForString isEqualToString:@"此地址不支持货到付款"])
//    {
//        [self showAlertView:nil alertMsg:@"您目前的送货地址不正确,请先确认您的送货地址!" alertTag:ALERTVIEW_TAG_OTHERS];
//    }
    else if([checkOrder orderTotalMoney] == 0.0)
    {
		[self showAlertView:nil alertMsg:@"商品金额为0，无法开具发票" alertTag:ALERTVIEW_TAG_OTHERS];
	}
    else
    {
        
        //  Invoice* invoiceVC = [[[Invoice alloc] initWithNibName:@"Invoice" bundle:nil] autorelease];  //此方法会导致viewdidload会在被release的时候立即调用，暂停使用
        if (m_Invoice != nil)
        {
            [m_Invoice release];
            m_Invoice = nil;
        }
        Invoice* invoiceVC = [[[Invoice alloc] init] autorelease];
        self.m_Invoice = invoiceVC;
        invoiceVC.isMedicalInstrument = checkOrder.isMedicalInstrument; //是不是医疗器械
        invoiceVC.isFullScreen = YES;
        
		if ( editInvoiceVO == nil )
        {
			NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString* directory = [paths objectAtIndex:0];
			NSString* fileName = [directory stringByAppendingPathComponent:@"InvoiceTitle.plist"];
			if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
            {
				NSString* tempstr = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
				if (![tempstr isEqualToString:@"个人"])
                {
					[m_Invoice setM_InvoiceTitle:tempstr];
					DebugLog(@"title is:%@ ",tempstr);
				}
			}
		}
        else
        {
			if (![editInvoiceVO.title isEqualToString:@"个人"])
            {
				[m_Invoice setM_InvoiceTitle:editInvoiceVO.title];
			}
			[m_Invoice setM_InvoiceContent:editInvoiceVO.content];
			[m_Invoice setM_InvoiceAmount:m_CheckOrderVO.productAmount];
		}
        
        
		[m_Invoice setM_InvoiceType:m_CheckOrderVO.canIssuedInvoiceType];
		DebugLog(@"the invoice type is:%d",[m_CheckOrderVO.canIssuedInvoiceType intValue]);
		if(m_CheckOrderVO.invoiceList!=nil && [m_CheckOrderVO.invoiceList count]>0)
        {
            if (editInvoiceVO!=nil)
            {
                [editInvoiceVO release];
            }
			editInvoiceVO = [[m_CheckOrderVO.invoiceList objectAtIndex:0] retain];
			if (![editInvoiceVO.title isEqualToString:@"个人"])
            {
				[m_Invoice setM_InvoiceTitle:editInvoiceVO.title];
			}
			[m_Invoice setM_InvoiceContent:editInvoiceVO.content];
			[m_Invoice setM_InvoiceAmount:editInvoiceVO.amount];
		}
        
        [self pushVC:m_Invoice animated:YES fullScreen:YES];
	}
}

-(void)productTableViewClicked:(NSInteger)index
{
    if ([self isNeedExpand] && index == [self countOfProductTable] - 3)
    {
        isExpand = !isExpand;
        [self updateCheckOrderForProductTable];
    }
}

-(void)packageProductTableViewClicked:(int)Tableindex Cell:(int)CellIndex
{
//    NSString *nindex  = [NSString stringWithFormat:@"%d",Tableindex];
    if ([self isNeedExpand:Tableindex] && CellIndex == [self countOfPackageProductTable:Tableindex] - 1)
    {
        NSNumber* boolNumber = _packageIsExpandingArr[Tableindex];
        BOOL  packExpand = [boolNumber boolValue];
        packExpand = !packExpand;
        boolNumber = [NSNumber numberWithBool:packExpand];
//        [self.packGoodisExpand setObject:boolNumber forKey:nindex];
        _packageIsExpandingArr[Tableindex] = boolNumber;
        [self updateCheckOrderForProductTable];
    }
}


-(void)paymentMethodTableViewClicked
{
    if ([[m_PaymentWayDetailLbl text] isEqualToString:OTS_EMPTY_STR]
        && [checkOrder goodReceiver] == nil)
    {
        [self showAlertView:nil alertMsg:@"您目前没有选择送货地址,请先选择您的送货地址!" alertTag:ALERTVIEW_TAG_OTHERS];
    }
//    else if ([[m_PaymentWayDetailLbl text] isEqualToString:OTS_EMPTY_STR]
//            /* && m_AddressNotSupport*/)
//    {
//        [self showAlertView:nil alertMsg:@"您目前的送货地址不支持任何支付方式,请先确认您的送货地址!" alertTag:ALERTVIEW_TAG_OTHERS];
//    }
    else
    {
        [self showChooseBankView];
    }
}


#pragma mark -
-(UITableViewCell *)receiverTableViewCellAtIndex:(NSInteger)index
{
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (index==0)
    {
        //获取送货地址VO
        GoodReceiverVO *goodReciverVO=checkOrder.goodReceiver;
        if (goodReciverVO==nil)
        {//无地址时
            [[cell textLabel] setText:@"请选择收货地址"];
            [[cell textLabel] setTextColor:OTS_FOCUS_COLOR];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
        } else {
            double yValue=5.0;
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
            if (goodReciverVO.receiverMobile!=nil) {
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
            if (goodReciverVO.receiverPhone!=nil) {
                label=[[UILabel alloc]initWithFrame:CGRectMake(20,yValue,260,22)];
                [label setText:goodReciverVO.receiverPhone];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor blackColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

//包裹table中每个cell
-(void)showProductInfoOnCell:(UITableViewCell *)cell withOrderItem:(OrderProductDetail*)product
{
    if (product == nil)
    {
        return;
    }
//    ProductVO * aProduct = [orderItemV2 product];
    
    //商品名称
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 220, 40)];
    [label setNumberOfLines:1];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:product.productName];
    [label setFont:[UIFont systemFontOfSize:14.0]];
    [cell addSubview:label];
    [label release];
    
    //单价
    double price=[product.price doubleValue];
    label=[[UILabel alloc] initWithFrame:CGRectMake(100, 26, 200, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
//    if ([aProduct.activitypoint intValue])
//    {
//        [label setText:[NSString stringWithFormat:@"单价:%@积分+￥%.2f",aProduct.activitypoint,price]];
//    }else
//    {
        [label setText:[NSString stringWithFormat:@"单价:￥%.2f",price]];
//    }
    [label setFont:[UIFont systemFontOfSize:14.0]];
    [label setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:label];
    [label release];
    
    //数量
    label=[[UILabel alloc] initWithFrame:CGRectMake(240, 5, 60, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    int buyquantity = [product.productCount intValue];
    [label setText:[NSString stringWithFormat:@"x%d",buyquantity]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [label setTextColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
    [label setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:label];
    [label release];
    
//    if (aProduct.isGiftProduct)
//    {
//        UILabel *giftLabel= [[[UILabel alloc] initWithFrame:CGRectMake(11, 55, 38, 16)] autorelease];
//        giftLabel.text=@"赠品";
//        giftLabel.adjustsFontSizeToFitWidth=YES;
//        giftLabel.font=[UIFont systemFontOfSize:14];
//        giftLabel.textColor=[UIColor whiteColor];
//        giftLabel.textAlignment=NSTextAlignmentCenter;
//        giftLabel.backgroundColor=[UIColor colorWithRed:0.686 green:0.078 blue:0.01 alpha:1];
//        
//        [cell.contentView addSubview:giftLabel];
//    }
//    
//    else if (aProduct.isJoinRedemption)
//    {
//        UILabel *promotionLab = [[[UILabel alloc] initWithFrame:CGRectMake(11, 55, 38, 16)] autorelease];
//        promotionLab.text=@"换购";
//        promotionLab.adjustsFontSizeToFitWidth=YES;
//        promotionLab.font=[UIFont systemFontOfSize:14];
//        promotionLab.textColor=[UIColor whiteColor];
//        promotionLab.textAlignment=NSTextAlignmentCenter;
//        promotionLab.backgroundColor=[UIColor colorWithRed:0.863 green:0.408 blue:0.01 alpha:0.8];
//        
//        [cell.contentView addSubview:promotionLab];
//    }
}

-(void)showProductInfoOnCell:(UITableViewCell *)cell withProduct:(ProductVO*)aProduct
{
    if (aProduct == nil)
    {
        return;
    }
    
    //商品图片
    //OrderItemVO *orderItemVO=[[m_CheckOrderVO orderItemList] objectAtIndex:index];
    OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(20, 12, 40, 40)];
    [imageView loadImgUrl:aProduct.miniDefaultProductUrl];
    [cell addSubview:imageView];
    [imageView release];
    
    
    //商品名称
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(70, 5, 230, 50)];
    [label setNumberOfLines:2];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[aProduct cnName]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [cell addSubview:label];
    [label release];
    
    //数量
    label=[[UILabel alloc] initWithFrame:CGRectMake(70, 60, 90, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    int buyquantity = [aProduct purchaseAmount];
    [label setText:[NSString stringWithFormat:@"数量：%d",buyquantity]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [cell addSubview:label];
    [label release];
    
    //单价
    double price=[aProduct.realPrice doubleValue];
    label=[[UILabel alloc] initWithFrame:CGRectMake(170, 60, 130, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"单价：￥%.2f",price]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [label setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:label];
    [label release];
    
    if (aProduct.activitypoint.intValue) {
        label=[[UILabel alloc] initWithFrame:CGRectMake(170, 85, 130, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[NSString stringWithFormat:@"+%@积分",aProduct.activitypoint]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
    }
    if (aProduct.isGiftProduct)
    {
        UILabel *giftLabel= [[[UILabel alloc] initWithFrame:CGRectMake(11, 55, 38, 16)] autorelease];
        giftLabel.text=@"赠品";
        giftLabel.adjustsFontSizeToFitWidth=YES;
        giftLabel.font=[UIFont systemFontOfSize:14];
        giftLabel.textColor=[UIColor whiteColor];
        giftLabel.textAlignment=NSTextAlignmentCenter;
        giftLabel.backgroundColor=[UIColor colorWithRed:0.686 green:0.078 blue:0.01 alpha:1];
        
        [cell.contentView addSubview:giftLabel];
    }
    
    else if (aProduct.isJoinRedemption)
    {
        UILabel *promotionLab = [[[UILabel alloc] initWithFrame:CGRectMake(11, 55, 38, 16)] autorelease];
        promotionLab.text=@"换购";
        promotionLab.adjustsFontSizeToFitWidth=YES;
        promotionLab.font=[UIFont systemFontOfSize:14];
        promotionLab.textColor=[UIColor whiteColor];
        promotionLab.textAlignment=NSTextAlignmentCenter;
        promotionLab.backgroundColor=[UIColor colorWithRed:0.863 green:0.408 blue:0.01 alpha:0.8];
        
        [cell.contentView addSubview:promotionLab];
    }
}


-(void)showProductInfoOnCell:(UITableViewCell *)cell index:(NSInteger)index
{
    //商品图片
    OrderItemVO *orderItemVO=[[m_CheckOrderVO orderItemList] objectAtIndex:index];
    OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(20, 12, 40, 40)];
    [imageView loadImgUrl:orderItemVO.product.miniDefaultProductUrl];
    
    [cell addSubview:imageView];
    [imageView release];
    
    
    //商品名称
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(70, 5, 230, 50)];
    [label setNumberOfLines:2];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[[orderItemVO product] cnName]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [cell addSubview:label];
    [label release];
    //数量
    label=[[UILabel alloc] initWithFrame:CGRectMake(70, 60, 90, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"数量：%@",[orderItemVO buyQuantity]]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [cell addSubview:label];
    [label release];
    //单价
    double price=[[[orderItemVO product] price] doubleValue];
    label=[[UILabel alloc] initWithFrame:CGRectMake(170, 60, 130, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"单价：￥%.2f",price]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [label setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:label];
    [label release];
}





-(NSDictionary *)packgifts
{
    return nil;
}

-(NSDictionary *)packgoods
{
    int count = m_CheckOrderVO.childOrderList.count;
    
    if (count > 0)
    {
        NSMutableDictionary *packgoods = [NSMutableDictionary dictionaryWithCapacity:count];
        for (int i = 0; i < count; i++)
        {
            NSString * nindex = [NSString stringWithFormat:@"%d",i];
            
            OrderV2 *packageV2 = [[m_CheckOrderVO childOrderList] objectAtIndex:i];
            NSMutableArray * packProducts = [NSMutableArray array];
            for (int i=0; i< [packageV2.orderItemList count]; i++) {
                ProductVO *productV2 = [[packageV2.orderItemList objectAtIndex:i] product];
                [packProducts addObject:productV2];
            }
            [packgoods setObject:packProducts forKey:nindex];
        }
        
        return packgoods;
    }
    
    return nil;
}

//如果只有一个包裹，然后算这个包裹中的商品个数，如果大于3就需要折合
-(BOOL)isNeedExpand
{
    NSArray *packageArr = checkOrder.orderPackageArr;
    if (packageArr.count > 0)
    {
        OrderPackageInfo *package = packageArr[0];
        return [package.packageProductArr count] > 3;
    }
    return NO;
}

//多个包裹时 第几个包裹是不是需要折合
//-(BOOL)isNeedExpand:(NSString *)nindex
//{
//    return  [[self.packGoodItems objectForKey:nindex] count] > 1;
//}

//第nIndex个包裹是不是需要折合展示
-(BOOL)isNeedExpand:(int)nindex
{
    NSArray *packageArr = checkOrder.orderPackageArr;
    OrderPackageInfo *package = packageArr[nindex];
    
    //多个包裹中，如果商品数量多余1个就需要折合
    return  [package.packageProductArr count] > 1;
}

-(UITableViewCell *)moneyTableViewCellAtIndex:(NSInteger)index
{
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    if (index==0)
    {
        cell.backgroundColor = OTS_COLOR_FROM_RGB(0xfffeee);
        
        //"商品总金额"label
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 150, 23)];
        [label setText:@"商品总金额："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //商品总金额label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 5, 120, 23)];
        [label setText:[NSString stringWithFormat:@"￥%.2f", [checkOrder orderProductTotalPrice]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        //"运费"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 28, 150, 23)];
        NSString* strTransferFee = m_CheckOrderVO.orderTotalWeight ? [NSString stringWithFormat:@"运费(%.2fkg)：", [checkOrder orderTotalWeight]] : @"运费：";
        [label setText:strTransferFee];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //+
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, 28, 20, 23)];
        [label setText:@"＋"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        //运费label
        label=[[UILabel alloc] initWithFrame:CGRectMake(180, 28, 120, 23)];
        [label setText:[NSString stringWithFormat:@"￥%.2f",[checkOrder.fare floatValue]]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:label];
        [label release];
        
        float offsetcash = 28 + 25;
        //YaoWang 暂时没有
        /*
        //"账户余额抵扣"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 51, 150, 23)];
        [label setText:@"现金账户余额抵扣："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //-
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, 51, 20, 23)];
        [label setText:@"－"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        
        //账户余额抵扣label
        m_AccountPayLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 51, 120, 23)];
        [m_AccountPayLabel setText:[NSString stringWithFormat:@"￥%.2f",m_AccountPayMoney]];
        [m_AccountPayLabel setBackgroundColor:[UIColor clearColor]];
        [m_AccountPayLabel setFont:[UIFont systemFontOfSize:15.0]];
        [m_AccountPayLabel setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:m_AccountPayLabel];
        [m_AccountPayLabel release];
        
        //"账户余额抵扣"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, 74, 150, 23)];
        [label setText:@"礼品卡账户余额抵扣："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //-
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, 74, 20, 23)];
        [label setText:@"－"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        
        //账户余额抵扣label
        m_GiftCardPayLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 74, 120, 23)];
        [m_GiftCardPayLabel setText:[NSString stringWithFormat:@"￥%.2f",m_GiftCardPayMoney]];
        [m_GiftCardPayLabel setBackgroundColor:[UIColor clearColor]];
        [m_GiftCardPayLabel setFont:[UIFont systemFontOfSize:15.0]];
        [m_GiftCardPayLabel setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:m_GiftCardPayLabel];
        [m_GiftCardPayLabel release];
        
        float offsetcash = 74;
        
        offsetcash += 25;
        //"抵用券抵扣"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, offsetcash, 150, 23)];
        [label setText:@"抵用券抵扣："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //-
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, offsetcash, 20, 23)];
        [label setText:@"－"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        //抵用券抵扣label
        m_UseCouponLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, offsetcash, 120, 23)];
        [m_UseCouponLabel setText:[NSString stringWithFormat:@"￥%.2f",m_UseCouponMoney]];
        [m_UseCouponLabel setBackgroundColor:[UIColor clearColor]];
        [m_UseCouponLabel setFont:[UIFont systemFontOfSize:15.0]];
        [m_UseCouponLabel setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:m_UseCouponLabel];
        [m_UseCouponLabel release];
        offsetcash += 25;*/
        //"促销活动立减"label
        label=[[UILabel alloc] initWithFrame:CGRectMake(20, offsetcash, 150, 23)];
        [label setText:@"促销活动立减："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        //-
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, offsetcash, 20, 23)];
        [label setText:@"－"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:label];
        [label release];
        
        //促销活动立减 金额
        m_FullDiscoun=[[UILabel alloc] initWithFrame:CGRectMake(180, offsetcash, 120, 23)];
        [m_FullDiscoun setText:[NSString stringWithFormat:@"￥%.2f",[checkOrder orderProductTotalPrice] - _cartInfo.money]];
        [m_FullDiscoun setBackgroundColor:[UIColor clearColor]];
        [m_FullDiscoun setFont:[UIFont systemFontOfSize:15.0]];
        [m_FullDiscoun setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:m_FullDiscoun];
        [m_FullDiscoun release];
        //        }
        /*
        offsetcash += 25;
        
        UILabel* coin=[[UILabel alloc] initWithFrame:CGRectMake(20, offsetcash, 150, 23)];
        coin.text=@"积分使用：";
        coin.backgroundColor=[UIColor clearColor];
        coin.font=[UIFont systemFontOfSize:15.0];
        [cell addSubview:coin];
        [coin release];
        
        UILabel*integralLab=[[UILabel alloc] initWithFrame:CGRectMake(180, offsetcash, 120, 23)];
        [integralLab setText:[NSString stringWithFormat:@"%@积分",m_CheckOrderVO.needPoint]];
        [integralLab setBackgroundColor:[UIColor clearColor]];
        [integralLab setFont:[UIFont systemFontOfSize:15.0]];
        [integralLab setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:integralLab];
        [integralLab release];*/
        
    } else if (index==1) {
        
        
        //"还需支付"label
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 44)];
        [label setText:@"需支付："];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        
        //应付总金额label
//        double needPayMoney=[m_CheckOrderVO.productAmount doubleValue]+[m_CheckOrderVO.deliveryAmount doubleValue]-m_AccountPayMoney-m_UseCouponMoney-[m_CheckOrderVO.cashAmount doubleValue]-m_GiftCardPayMoney;
        m_NeedPayMoneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 120, 44)];
//        if (needPayMoney > 0) {
            [m_NeedPayMoneyLabel setText:[NSString stringWithFormat:@"￥%.2f",_cartInfo.money + _cartInfo.fare /*checkOrder.orderTotalMoney*/]];
//        }else{
//            [m_NeedPayMoneyLabel setText:@"￥0.00"];
//        }
        
        [m_NeedPayMoneyLabel setTextColor:[UIColor redColor]];
        [m_NeedPayMoneyLabel setBackgroundColor:[UIColor clearColor]];
        [m_NeedPayMoneyLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [m_NeedPayMoneyLabel setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:m_NeedPayMoneyLabel];
        [m_NeedPayMoneyLabel release];

    }
    return cell;
}

-(UITableViewCell *)productTableViewCellAtIndex:(NSInteger)index
{
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    int totalQuantity = 0;
    
    for (ProductVO *product in self.goodItems)
    {
        totalQuantity += product.purchaseAmount;
    }
    
    int count = [self countOfProductTable];
    
    ProductVO *product = nil;
    if (index < count - 2)
    {
        if ([self isNeedExpand] && index == count - 3)
        {
            if (!isExpand)
            {
                [[cell textLabel] setText:[NSString stringWithFormat:@"共%d件，查看更多▼",totalQuantity]];
            }
            else
            {
                [[cell textLabel] setText:[NSString stringWithFormat:@"共%d件，收起更多▲",totalQuantity]];
            }
            
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else
        {
            product = [self.goodItems objectAtIndex:index];
        }
    }
    
    else if (index == count - 2)
    {
        cell = [self moneyTableViewCellAtIndex:0];
    }
    
    else
    {
        cell = [self moneyTableViewCellAtIndex:1];
    }
    
    [self showProductInfoOnCell:cell withProduct:product];
    
    //[self showProductInfoOnCell:cell index:index];
    
#if 0
    if (count<=3) {
        if (index<count) {//商品信息
            [self showProductInfoOnCell:cell index:index];
        }
        else if(index==count) //赠品
        {
            if (m_UserSelectedGiftArray!=nil&&m_UserSelectedGiftArray.count) {
                [self showGiftForProductTableViewCell:cell];
            }else {
                cell=[self moneyTableViewCellAtIndex:0];
            }
        }else if(index==count+1){
            if (m_UserSelectedGiftArray!=nil&&m_UserSelectedGiftArray.count) {
                cell= [self moneyTableViewCellAtIndex:0];
            }else {
                cell= [self moneyTableViewCellAtIndex:1];
            }
        }else {
            cell=[self moneyTableViewCellAtIndex:1];
        }
    } else if (count>3 && !m_ShowAllProduct) {
        if (index<3) {//商品信息
            [self showProductInfoOnCell:cell index:index];
        }
        else if (index==3) {////统计信息 查看更多
            [[cell textLabel] setText:[NSString stringWithFormat:@"共%d件，查看更多▼",totalQuantity]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        }
        else if (index==4) {//赠品
            if (m_UserSelectedGiftArray!=nil&&m_UserSelectedGiftArray.count) {
                [self showGiftForProductTableViewCell:cell];
            }else {
                cell=[self moneyTableViewCellAtIndex:0];
            }
        }else if (index==5) {
            if (m_UserSelectedGiftArray!=nil&&m_UserSelectedGiftArray.count) {
                cell= [self moneyTableViewCellAtIndex:0];
            }else {
                cell=[self moneyTableViewCellAtIndex:1];
            }
        }else if (index==6) {
            cell=[self moneyTableViewCellAtIndex:1];
        }
    } else {
        if (index<count) {//商品信息
            [self showProductInfoOnCell:cell index:index];
        }
        else if (index==count) { //统计信息 收起更多
            [[cell textLabel] setText:[NSString stringWithFormat:@"共%d件，收起更多▲",totalQuantity]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        }
        else if(index == count+1){//赠品
            if (m_UserSelectedGiftArray!=nil&&m_UserSelectedGiftArray.count) {
                [self showGiftForProductTableViewCell:cell];
            }else {
                cell=[self moneyTableViewCellAtIndex:0];
            }
        }else if (index==count+2) {
            if (m_UserSelectedGiftArray!=nil&&m_UserSelectedGiftArray.count) {
                cell=[self moneyTableViewCellAtIndex:0];
            }else {
                cell=[self moneyTableViewCellAtIndex:1];
            }
        }else {
            cell= [self moneyTableViewCellAtIndex:1];
        }
    }
#endif
    
    return cell;
}

-(UITableViewCell*)cellWithStyle:(UITableViewCellStyle)aCellStype
{
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:aCellStype reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}

-(UITableViewCell *)paymentTableViewCellAtIndex:(NSInteger)index
{
    UITableViewCell *cell = [self cellWithStyle:UITableViewCellStyleValue1];
    
    if (index == 0)
    {
        [self decorateCell:cell type:EOtsCoCellPaymentWay];
    }
    
    else if (index == 1)
    {
        [self decorateCell:cell type:EOtsCoCellCoupOn];
    }
    else if (index == 2){
        [self decorateCell:cell type:EOtsCoCellGiftCardPay];
    }
    else if (index == 3)
    {
        [self decorateCell:cell type:EOtsCoCellBalancePay];
    }
    
    return cell;
}

//包裹table的实现
-(UITableViewCell *)packageTableViewCellAtIndexPath:(NSIndexPath *)indexPath iN:(UITableView *)tableView
{
    UITableViewCell *cell = [self cellWithStyle:UITableViewCellStyleValue1];
    
    // table 的索引
    int index=[tableView tag]-100;
    
    // table 之下每个cell的索引  两级结构
    int cellindex = [indexPath row];
//    NSString *nindex  = [NSString stringWithFormat:@"%d",index];
    
    int cellcount = [self countOfPackageProductTable:index];
//    OrderV2 *packageV2=[[m_CheckOrderVO childOrderList] objectAtIndex:index];
    OrderPackageInfo *package = checkOrder.orderPackageArr[index];
    
    int totalQuantity = 0;
    for (int i=0; i< [package.packageProductArr count]; i++)
    {
        OrderProductDetail *product = package.packageProductArr[i];
        totalQuantity += [product.productCount intValue];
    }
    
    if (cellindex == 0)
    {
        [[cell textLabel] setText:[NSString stringWithFormat:@"包裹%d",index+1]];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [[cell textLabel] setTextColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:1.0]];

//        OrderProductDetail * firstProduct = [package.packageProductArr objectAtIndex:0];
//        if ([firstProduct.isFresh intValue]==1)
//        {
//            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"生鲜商品收货后48小时内可以退换货"]];
//            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12.0]];
//            [[cell detailTextLabel] setTextColor:UIColorFromRGB(0x999999)];
//        }
    }
    else if(cellindex < cellcount)
    {
        if ([self isNeedExpand:index] && cellindex == cellcount - 1)
        {
            if (![_packageIsExpandingArr[index] intValue])
            {
                [[cell textLabel] setText:[NSString stringWithFormat:@"                    共%d件，查看更多▼",totalQuantity]];
            }
            else
            {
                [[cell textLabel] setText:[NSString stringWithFormat:@"                    共%d件，收起更多▲",totalQuantity]];
            }
            
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else
        {
//            OrderItemVO *orderItemV2 = [packageV2.orderItemList objectAtIndex:cellindex-1];
            
            OrderProductDetail * product = [package.packageProductArr objectAtIndex:cellindex-1];
            [self showProductInfoOnCell:cell withOrderItem:product];
        }
    }
    
    return cell;
}


-(UITableViewCell*)decorateCell:(UITableViewCell*)aCell type:(KOtsCheckOrderCellType)aType
{
    switch (aType)
    {
        case EOtsCoCellInvoice:
        {
            //需要发票
            aCell.textLabel.text = @"需要发票";
            aCell.textLabel.textColor = [UIColor blackColor];
            aCell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            
            //是否需要发票
            m_InvoiceLabel = aCell.detailTextLabel;
            m_InvoiceLabel.font = [UIFont systemFontOfSize:15.0];
            m_InvoiceLabel.text = editInvoiceVO ? editInvoiceVO.title : @"否";
            
            aCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case EOtsCoCellCoupOn:
        {
            [[aCell textLabel] setText:@"使用抵用券"];
            [[aCell textLabel] setTextColor:[UIColor blackColor]];
            [[aCell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            //可用抵用券余额
            if ([m_CheckOrderVO.couponAmount doubleValue]>0.0) {
                OTSBadgeButton *aCpBtn=[[OTSBadgeButton alloc] initWithFrame:CGRectMake(235, 10, 42, 24) badgeNumber:[m_CheckOrderVO.couponAmount intValue]];
                [aCpBtn setBgImg:[UIImage imageNamed:@"couponBG"]];
                [aCell addSubview:aCpBtn];
                [aCpBtn release];
            } else {
                [[aCell detailTextLabel] setText:@"否"];
            }
            [[aCell detailTextLabel]setFont:[UIFont systemFontOfSize:15.0]];
            aCell.selectionStyle=UITableViewCellSelectionStyleBlue;
            aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case EOtsCoCellBalancePay:
        {
            aCell.textLabel.text = @"使用现金账户余额";
            aCell.textLabel.textColor = [UIColor blackColor];
            aCell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            
            //账户余额支付
            m_NeedAccountPayLabel = aCell.detailTextLabel;
            [m_NeedAccountPayLabel setFont:[UIFont systemFontOfSize:15.0]];
            m_NeedAccountPayLabel.text = m_AccountPayMoney > 0.0 ? [NSString stringWithFormat:@"￥%.2f",m_AccountPayMoney] : @"否";
            
            aCell.selectionStyle=UITableViewCellSelectionStyleBlue;
            aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case EOtsCoCellGiftCardPay:
        {
            aCell.textLabel.text = @"使用礼品卡账户余额";
            aCell.textLabel.textColor = [UIColor blackColor];
            aCell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            
            //账户余额支付
            m_cardPayLabel = aCell.detailTextLabel;
            [m_cardPayLabel setFont:[UIFont systemFontOfSize:15.0]];
            m_cardPayLabel.text = m_GiftCardPayMoney > 0.0 ? [NSString stringWithFormat:@"￥%.2f",m_GiftCardPayMoney] : @"否";
            
            aCell.selectionStyle=UITableViewCellSelectionStyleBlue;
            aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case EOtsCoCellPaymentWay:
        {
            //请选择付款方式
            aCell.textLabel.text = @"请选择付款方式";
            aCell.textLabel.textColor = OTS_FOCUS_COLOR;
            aCell.textLabel.tag = TAG_PAYMENT_CELL_LABEL;
            aCell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            m_PaymentWayLbl = aCell.textLabel;
            
            //付款方式
            m_PaymentWayDetailLbl = [aCell detailTextLabel];
            [m_PaymentWayDetailLbl setFont:[UIFont systemFontOfSize:15.0]];
            
            
            if ([m_CheckOrderVO goodReceiver] == nil)
            {//无收货地址
                self.m_PayMethodStr = OTS_EMPTY_STR;
                gatewayType=-1;
                aCell.selectionStyle=UITableViewCellSelectionStyleNone;
                aCell.accessoryType=UITableViewCellAccessoryNone;
            }
            else
            {//有收货地址
                // 需额外传入goodReceiverId
//                JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveReciveToOrder extraPrama:[m_CheckOrderVO goodReceiver].nid, nil]autorelease];
//                [DoTracking doJsTrackingWithParma:prama];
                
                if ([m_PaymentMethods count] == 0)
                {
                    m_AddressNotSupport = YES;
                    self.m_PayMethodStr = OTS_EMPTY_STR;
                    gatewayType=-1;
                    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    aCell.accessoryType = UITableViewCellAccessoryNone;
                }
                else
                {
                    m_AddressNotSupport = NO;
                    bool hasDefaultPaymentMethod = NO;
                    PaymentMethodVO *paymentMethod = nil;
                    
                    for (paymentMethod in m_PaymentMethods)
                    {
                        NSString *isDefaultPaymentMethod = [paymentMethod isDefaultPaymentMethod];
                        
                        if ([isDefaultPaymentMethod isEqualToString:@"true"])
                        {//有默认的付款方式
                            hasDefaultPaymentMethod = YES;
                            methodID = [paymentMethod.methodId intValue];
                            paymentType = [paymentMethod.paymentType intValue];
                            self.m_PayMethodStr = paymentMethod.methodName;
                            gatewayType = paymentMethod.gatewayId ? [paymentMethod.gatewayId intValue] : gatewayType;
                            break;
                        }
                    }
                    
                    if (!hasDefaultPaymentMethod)
                    {
                        self.m_PayMethodStr = OTS_EMPTY_STR;
                        gatewayType=-1;
                    }
                }
            }
            
            [m_PaymentWayDetailLbl setText:m_PayMethodStr];
            [self updatePaymentLabelScrollIfFocus:NO];
            aCell.selectionStyle=UITableViewCellSelectionStyleBlue;
            aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        default:
            break;
    }
    
    return aCell;
}

-(void)updatePaymentLabelScrollIfFocus:(BOOL)aScrollIfFocus
{
    if ([m_PaymentWayDetailLbl.text isEqualToString:OTS_EMPTY_STR])
    {
        m_PaymentWayLbl.textColor = OTS_FOCUS_COLOR;
        if (aScrollIfFocus)
        {
            // TODO:scroll to position of the label
        }
    }
    else
    {
        m_PaymentWayLbl.textColor = OTS_NORMAL_COLOR;
    }
}


#pragma mark -

-(NSUInteger)countOfProductTable
{
    int count = self.goodItems.count;
    
    if ([self isNeedExpand])
    {
        if (!isExpand)
        {
            count = 3;
        }
        
        count++;
    }
    
    count += 2;
    return count;
}

//返回每个包裹tableview的行数，
-(NSUInteger)countOfPackageProductTable:(int)index
{
    //第index个包裹中 有几个商品
    OrderPackageInfo *pack = checkOrder.orderPackageArr[index];
    int count = pack.packageProductArr.count;
    
    if ([self isNeedExpand:index])
    {
        NSNumber *flag = _packageIsExpandingArr[index];
        if (![flag boolValue])
        {
            count = 1;
        }
        count++;    // 加上伸缩按钮
    }
    //加上包裹头子
    count ++;
    return count;
}

-(int) packcountOfchildlist:(NSUInteger)packageIndex
{
    OrderV2 *packageV2 = [[m_CheckOrderVO childOrderList] objectAtIndex:packageIndex];
    int packCount = [[packageV2 orderItemList] count];
    return packCount;
}


-(CGFloat)heightForMoneyFristRow{
    //满减 和 赠品 的坐标偏移
    float OffsetY= 130+25.0+20;
    return OffsetY;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
-(void)releaseMyResoures
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    OTS_SAFE_RELEASE(m_CheckOrderVO);
    OTS_SAFE_RELEASE(m_Invoice);
    OTS_SAFE_RELEASE(m_OrderService);
    OTS_SAFE_RELEASE(m_Mycoupon);
    OTS_SAFE_RELEASE(m_PayMethodStr);
    OTS_SAFE_RELEASE(m_PaymentMethods);
    OTS_SAFE_RELEASE(m_UserSelectedGiftArray);
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(distributionArray);
    OTS_SAFE_RELEASE(distributionError);
    OTS_SAFE_RELEASE(m_ProductTableView);
    OTS_SAFE_RELEASE(m_MoneyTableView);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
    [_goodItems release];
    [_packGoodItems release];
    [_packGoodisExpand release];
    [_orderProducts release];
    [_invoiceInfo release];
    [_checkedOrderResult release];
    [_selectedGiftList release];
    [_cartInfo release];
    [super dealloc];
}







@end
