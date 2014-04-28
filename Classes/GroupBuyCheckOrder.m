//
//  GroupBuyCheckOrder.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define THREAD_STATUS_CREATE_ORDER                  1
#define THREAD_STATUS_SUBMIT_ORDER                  2
#define THREAD_STATUS_CLEAR_ACCOUNT_PAY_MONEY       3

#define TAG_ORDER_DETAIL_TABLEVIEW                  100
#define TAG_RECEIVER_TABLEVIEW                      101
#define TAG_PAYMENT_TABLEVIEW                       102
#define TAG_MONEY_TABLEVIEW                         103
#define TAG_REMARK_TABLEVIEW                        104
#define TAG_PRODUCT_COUNT                           105
#define TAG_PAYMENT_TEXTFIELD                       107
#define TAG_REMARK_TEXTFIELD                        108
#define TAG_SET_PAYMENT_METHOD_ACTIONSHEET          109
#define TAG_RECEIVER_PERSON_LABEL                   110
#define TAG_RECEIVER_ADDRESS_LABEL                  111
#define TAG_RECEIVER_CITY_LABEL                     112
#define TAG_RECEIVER_CODE_LABEL                     113
#define TAG_RECEIVER_MOBIL_LABEL                    114
#define TAG_RECEIVER_PHONE_LABEL                    115
#define TAG_SUBMIT_ORDER_BUTTON                     116
#define TAG_CANCEL_ORDER_BUTTON                     117
#define TAG_REMARK_PROMPT_LABEL                     118
#define TAG_COMMIT_ORDER_ALERTVIEW                  119
#define TAG_CREATE_ORDER_ALERTVIEW                  120
#define TAG_PAYMENT_CELL_LABEL                      999

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "GroupBuyCheckOrder.h"
#import "GroupBuyService.h"
#import "GlobalValue.h"
#import "GoodReceiverVO.h"
#import "UserVO.h"
#import "PaymentMethodVO.h"
#import <QuartzCore/QuartzCore.h>
#import "AlertView.h"
#import "OnlinePay.h"
#import "OrderService.h"
#import "BankVO.h"
#import "OnlinePay.h"
#import "GroupBuyOrderDetail.h"
#import "RegexKitLite.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSNaviAnimation.h"
#import "OTSAlertView.h"
#import "OTSActionSheet.h"
#import "OTSOrderSubmitOKVC.h"
#import "GroupBuyProductDetail.h"
#import "DoTracking.h"


#define DARK_RED_COLOR  [UIColor colorWithRed:204.0/255.0 green:0.0 blue:1.0/255.0 alpha:1.0]

@interface GroupBuyCheckOrder ()
@property(retain)NSArray    *paymentMethods;
@end


@implementation GroupBuyCheckOrder

@synthesize m_GrouponId;
@synthesize m_SerialId;
@synthesize m_ProductName;
@synthesize m_SelectedStr;
@synthesize m_SinglePrice, paymentMethods, m_AreaId, m_ToDetailTag;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect newRect = [SharedDelegate screenRectHasTabBar:NO statusBar:YES];
    newRect.origin = CGPointZero;
    self.view.frame = newRect;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [m_ScrollView setBackgroundColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePaymentMethodLabel:) name:@"UpdatePaymentMethod" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGoodReceiver:) name:@"SaveGoodReceiverForGroupon" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCartAndRefresh:) name:OTS_NOTIFY_GOTO_CART_AND_REFRESH object:nil];
    
    m_ThreadIsRunning=NO;
    m_CurrentState=THREAD_STATUS_CREATE_ORDER;
    [self setUpThread];
}

-(void)gotoCartAndRefresh:(NSNotification *)notification
{
    [SharedDelegate enterCartWithUpdate:YES];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckOrderReleased" object:self];
}

-(IBAction)returnBtnClicked:(id)sender
{
    if (m_ToDetailTag == FROM_ROCKBUY_TO_DETAIL) {
        [self popSelfAnimated:YES];
    }else{
        [self removeSelf];
        [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductDetailReleased" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductDetailShowBottom" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckOrderReleased" object:self];
}

-(IBAction)orderBtnClicked:(id)sender
{
    [self submitOrder];
}


- (BOOL)isOrderFullyPayed
{
    return [m_NeedPayMoneyLabel.text isEqualToString:@"￥0.00"];
}


//初始化检查订单界面
-(void)updateOrder
{
    //顶部
    [m_TopView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [m_TopView setFrame:CGRectMake(0, 44, 320, 43)];
    [self.view addSubview:m_TopView];
    //总数量
    int minCount=1;
    if ([[m_OrderVO grouponVO] limitLower]!=nil) {
        minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
    }
    [m_TotalCountLabel setText:[NSString stringWithFormat:@"总数量：%d件",minCount]];
    //合计
    m_NeedPayMoney=minCount*[m_SinglePrice doubleValue];
    [m_TotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
    [m_TotalPriceLabel setTextColor:DARK_RED_COLOR];
    //红线
    [m_RedLine setBackgroundColor:DARK_RED_COLOR];
    
    double yValue=0;
    //订单详情
    NSString *string=[NSString stringWithFormat:@"商品名称：%@",m_ProductName];
    double width=280;
    double stringWidth=[string sizeWithFont:[UIFont systemFontOfSize:15.0]].width;
    NSInteger lineCount=stringWidth/width;
    if (stringWidth/width>lineCount) {
        lineCount++;
    }
    double height=88.0+20.0*lineCount+20.0+47.0;
    if (m_SerialId!=nil) {
        height+=44.0;
    }
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_ORDER_DETAIL_TABLEVIEW];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];
    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    //收货人信息
    yValue+=height;
    GoodReceiverVO *goodReceiverVO=[[m_OrderVO orderVO] goodReceiver];
    if (goodReceiverVO==nil) {
        height=91.0;
    } else {
        height=80.0+47.0;
        if ([goodReceiverVO receiverMobile]!=nil) {
            height+=20.0;
        }
        if ([goodReceiverVO receiverPhone]!=nil) {
            height+=20.0;
        }
    }
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_RECEIVER_TABLEVIEW];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];
    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    //付款方式
    yValue+=height;
    height=135.0;
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_PAYMENT_TABLEVIEW];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];
    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    //金额
    yValue+=height;
    height=144.0;
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
    [tableView setTag:TAG_MONEY_TABLEVIEW];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];
    [m_ScrollView addSubview:tableView];
    tableView.backgroundView=nil;
    [tableView release];
    //备注信息+备注提示信息
    NSString *promptStr=[[m_OrderVO grouponVO] remarkerPrompt];
    if (promptStr!=nil) {
        //备注信息
        yValue+=height;
        tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 91) style:UITableViewStyleGrouped];
        [tableView setTag:TAG_REMARK_TABLEVIEW];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setBackgroundView:nil];
        [tableView setScrollEnabled:NO];
        [m_ScrollView addSubview:tableView];
        tableView.backgroundView=nil;
        [tableView release];
        //备注信息的提示信息
        yValue+=91+5;
        double stringWidth=[promptStr sizeWithFont:[UIFont boldSystemFontOfSize:15.0]].width;
        NSInteger lineCount=stringWidth/282;
        if (stringWidth/282>lineCount) {
            lineCount++;
        }
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(19, yValue, 282, 19*lineCount)];
        [label setTag:TAG_REMARK_PROMPT_LABEL];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setText:promptStr];
        [label setNumberOfLines:lineCount];
        [m_ScrollView addSubview:label];
        [label release];
        yValue+=19*lineCount+5.0;
    } else {
        yValue+=height+20.0;
    }
    
    //提交订单按钮
	UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(25, yValue, 270, 40)];
    [button setTag:TAG_SUBMIT_ORDER_BUTTON];
	[button setTitle:@"提交订单" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[[button titleLabel] setFont:[UIFont boldSystemFontOfSize:17.0]];
	[button setBackgroundImage:[UIImage imageNamed:@"orange_btn.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [m_ScrollView addSubview:button];
    [button release];
    
    [m_ScrollView setContentSize:CGSizeMake(320, yValue+60)];
}

-(void)resetLocation
{
    double yValue=0;
    //订单详情
    NSString *string=[NSString stringWithFormat:@"商品名称：%@",m_ProductName];
    double width=280;
    double stringWidth=[string sizeWithFont:[UIFont systemFontOfSize:15.0]].width;
    NSInteger lineCount=stringWidth/width;
    if (stringWidth/width>lineCount) {
        lineCount++;
    }
    double height=88.0+20.0*lineCount+20.0+47.0;
    if (m_SerialId!=nil) {
        height+=44.0;
    }
    
    //收货人信息
    yValue+=height;
    GoodReceiverVO *goodReceiverVO=[[m_OrderVO orderVO] goodReceiver];
    if (goodReceiverVO==nil) {
        height=91.0;
    } else {
        height=80.0+47.0;
        if ([goodReceiverVO receiverMobile]!=nil) {
            height+=20.0;
        }
        if ([goodReceiverVO receiverPhone]!=nil) {
            height+=20.0;
        }
    }
    UITableView *tableView=(UITableView *)[m_ScrollView viewWithTag:TAG_RECEIVER_TABLEVIEW];
    [tableView setFrame:CGRectMake(0, yValue, 320, height)];
    
    //付款方式
    yValue+=height;
    height=135.0;
    tableView=(UITableView *)[m_ScrollView viewWithTag:TAG_PAYMENT_TABLEVIEW];
    [tableView setFrame:CGRectMake(0, yValue, 320, height)];
    
    //金额
    yValue+=height;
    height=144.0;
    tableView=(UITableView *)[m_ScrollView viewWithTag:TAG_MONEY_TABLEVIEW];
    [tableView setFrame:CGRectMake(0, yValue, 320, height)];
    
    //备注信息+备注提示信息
    NSString *promptStr=[[m_OrderVO grouponVO] remarkerPrompt];
    if (promptStr!=nil) {
        //备注信息
        yValue+=height;
        tableView=(UITableView *)[m_ScrollView viewWithTag:TAG_REMARK_TABLEVIEW];
        [tableView setFrame:CGRectMake(0, yValue, 320, 91)];
        //备注信息的提示信息
        yValue+=91+5;
        double stringWidth=[promptStr sizeWithFont:[UIFont boldSystemFontOfSize:15.0]].width;
        NSInteger lineCount=stringWidth/282;
        if (stringWidth/282>lineCount) {
            lineCount++;
        }
        UILabel *label=(UILabel *)[m_ScrollView viewWithTag:TAG_REMARK_PROMPT_LABEL];
        [label setFrame:CGRectMake(19, yValue, 282, 19*lineCount)];
        
        yValue+=19*lineCount+5.0;
    } else {
        yValue+=height+20.0;
    }
    
    //提交订单按钮
    UIButton *button=(UIButton *)[m_ScrollView viewWithTag:TAG_SUBMIT_ORDER_BUTTON];
    [button setFrame:CGRectMake(25, yValue, 270, 40)];
    
    [m_ScrollView setContentSize:CGSizeMake(320, yValue+60)];
}

//选择购买商品数量
-(void)setProductCount:(id)sender
{
    //点击进入地区选择
    m_ActionSheet = [[OTSActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                               delegate:self
                                      cancelButtonTitle:nil
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:nil];
    UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 320, 216)];
    [m_ActionSheet addSubview:tempButton];
    [tempButton release];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(18, 5, 50, 30)];//取消按钮
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
    [cancelBtn addTarget:self action:@selector(closeActionSheet) forControlEvents:1];
    [cancelBtn setTitle:@"取消" forState:0];
    [m_ActionSheet addSubview:cancelBtn];
    [cancelBtn release];
    
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(252, 5, 50, 30)];//完成按钮
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
    [finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:0];
    [m_ActionSheet addSubview:finishBtn];
    [finishBtn release];
    
    [m_PickerView setFrame:CGRectMake(0, 0, 320, 216)];
    [tempButton addSubview:m_PickerView];
    
    [m_ActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [UIView setAnimationsEnabled:NO];
    [m_ActionSheet release];
    [m_PickerView reloadAllComponents];
}

//取消
-(void)closeActionSheet
{
    [m_ActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

//完成
-(void)finishBtnClicked:(id)sender
{
    [m_ActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    //最少数量
    int minCount=1;
    if ([[m_OrderVO grouponVO] limitLower]!=nil) {
        minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
    }
    int selectedCount=m_SelectedIndex+minCount;
    //限购数量
    if (selectedCount<[[[m_OrderVO grouponVO] limitLower] intValue]) {
        [AlertView showAlertView:nil alertMsg:[NSString stringWithFormat:@"至少购买%@个商品",[[m_OrderVO grouponVO] limitLower]] buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        return;
    }
    if (selectedCount>[[[m_OrderVO grouponVO] limitUpper] intValue]) {
        [AlertView showAlertView:nil alertMsg:[NSString stringWithFormat:@"最多只能购买%@个商品",[[m_OrderVO grouponVO] limitUpper]] buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        return;
    }
    if (selectedCount<=[[[m_OrderVO grouponVO] limitLower] intValue]) {
        [m_MinusBtn setEnabled:NO];
    } else {
        [m_MinusBtn setEnabled:YES];
    }
    UIButton *button=(UIButton *)[m_ScrollView viewWithTag:TAG_PRODUCT_COUNT];
    [button setTitle:[NSString stringWithFormat:@"%d",selectedCount] forState:UIControlStateNormal];
    
    [m_TotalCountLabel setText:[NSString stringWithFormat:@"总数量：%d件",selectedCount]];
    m_NeedPayMoney=[m_SinglePrice doubleValue]*(m_SelectedIndex+minCount);
    [m_TotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
    [m_ProTotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
    //清空账户余额抵扣
    [m_NeedAccountPayLabel setText:@"否"];
    if (m_AccountPayMoney>0.0001 || m_AccountPayMoney<-0.0001) {
        m_AccountPayMoney=0.00;
        [m_AccountPayLabel setText:@"￥0.00"];
        m_CurrentState=THREAD_STATUS_CLEAR_ACCOUNT_PAY_MONEY;
        [self setUpThread];
    }
    [m_NeedPayMoneyLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
}
//结束text field编辑
-(void)textFieldEndEdit
{
    UITextField *textField=(UITextField *)[m_ScrollView viewWithTag:TAG_PAYMENT_TEXTFIELD];
    [textField resignFirstResponder];
    
    textField=(UITextField *)[m_ScrollView viewWithTag:TAG_REMARK_TEXTFIELD];
    [textField resignFirstResponder];
}

//选择银行
-(void)showChooseBankView
{
    [self removeSubControllerClass:[OnlinePay class]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OnlinePayReleased" object:nil];
    
    OnlinePay* onlinePayVC = [[[OnlinePay alloc] initWithNibName:@"OnlinePay" bundle:nil] autorelease];
//    m_OnlinePay.isFullScreen = YES;
    [onlinePayVC setIsFromGroupon:YES];
    [onlinePayVC setMethodID:methodID];
    [onlinePayVC setGatewayId:[NSNumber numberWithInt:gatewayType]];
    
    [self pushVC:onlinePayVC animated:YES fullScreen:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OnlinePayReleased" object:onlinePayVC];
    
}


//确认订单
-(void)submitOrder
{
    [self textFieldEndEdit];//关闭键盘
    
    UITextField *remarkTextField=(UITextField *)[m_ScrollView viewWithTag:TAG_REMARK_TEXTFIELD];
    NSString *grouponRemarker=[remarkTextField text];
    
    if ([[m_OrderVO orderVO] goodReceiver]==nil) 
    {
        [AlertView showAlertView:nil alertMsg:@"收货地址不能为空!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        return;
    } 
    
    else if (![self isOrderFullyPayed] 
               && [[m_PaymentLabel text] isEqualToString:@" "] 
               && !m_AddressNotSupport) 
    {
        [AlertView showAlertView:nil alertMsg:@"请选择付款方式!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        return;
    } 
    
    else if (![self isOrderFullyPayed] 
             && [[m_PaymentLabel text] isEqualToString:@" "] 
             && m_AddressNotSupport) 
    {
        [AlertView showAlertView:nil alertMsg:@"您目前的送货地址不支持任何支付方式,请先确认您的送货地址!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    } 
    
    else if ([[m_OrderVO grouponVO] remarkerPrompt]!=nil 
             && (grouponRemarker==nil||[grouponRemarker isEqualToString:@""])) 
    {
        [AlertView showAlertView:nil alertMsg:@"备注信息不能为空!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        return;
    } 
    
    else 
    {
        m_CurrentState=THREAD_STATUS_SUBMIT_ORDER;
        [self setUpThread];
    }
}

//刷新支付方式显示
-(void)updatePaymentMethodLabel:(NSNotification *)notification
{
    paymentType=1;
    BankVO *bankVO = [notification object];
    gatewayType=[bankVO.gateway intValue];
    [m_PaymentLabel setText:[NSString stringWithFormat:@"%@",bankVO.bankname]];
    
    if (bankVO.bankname && [bankVO.bankname length] > 0)
    {
        UIView* view = [m_PaymentLabel.superview viewWithTag:TAG_PAYMENT_CELL_LABEL];
        if (view && [view isKindOfClass:[UILabel class]])
        {
            ((UILabel*)view).textColor = [UIColor blackColor];
        }
    }
}

//刷新收获地址显示
-(void)updateGoodReceiver:(NSNotification *)notification
{
    GoodReceiverVO *goodReceiverVO=[notification object];
    int provinceId=[[[GlobalValue getGlobalValueInstance] provinceId] intValue];
    if ([[goodReceiverVO provinceId] intValue]!=provinceId) {
        [AlertView showAlertView:nil alertMsg:@"请选择与团购省份一致的收货地址" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        return;
    }
    OrderV2 *orderV2=[[OrderV2 alloc] init];
    [orderV2 setGoodReceiver:goodReceiverVO];
    [m_OrderVO setOrderVO:orderV2];
    [orderV2 release];
    [self resetLocation];
    //刷新收货地址
    UITableView *tableView=(UITableView *)[m_ScrollView viewWithTag:TAG_RECEIVER_TABLEVIEW];
    [tableView reloadData];
    //刷新支付方式
    tableView=(UITableView *)[m_ScrollView viewWithTag:TAG_PAYMENT_TABLEVIEW];
    [tableView reloadData];
}

-(void)toOnlinePay
{
    if (m_OrderSubmitResult==nil) 
    {//提交订单失败
        UIAlertView *alert = [[OTSAlertView alloc]initWithTitle:nil message:@"提交订单失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert setTag:TAG_COMMIT_ORDER_ALERTVIEW];
        [alert show];
        [alert release];
        alert=nil;
    } 
    
    else if ([[m_OrderSubmitResult hasError] isEqualToString:@"true"]) 
    {//有错误
        UIAlertView *alert = [[OTSAlertView alloc]initWithTitle:nil message:[m_OrderSubmitResult errorInfo] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert setTag:TAG_COMMIT_ORDER_ALERTVIEW];
        [alert show];
        [alert release];
        alert=nil;
    }
    
    else 
    {
        OTSOrderSubmitOKVC* submitOKVC = [[[OTSOrderSubmitOKVC alloc] initWithOrderId:[m_OrderSubmitResult.orderId longLongValue]] autorelease];
        [self pushVC:submitOKVC animated:YES fullScreen:YES];
    }
}

-(void)setOnlinePayNull:(NSNotification *)notification
{    
    [self removeSubControllerClass:[OnlinePay class]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OnlinePayReleased" object:nil];
}

-(void)checkOrderIsNull:(id)object
{
    NSString *errString=object;
    UIAlertView *alert = [[OTSAlertView alloc]initWithTitle:nil message:errString delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert setTag:TAG_CREATE_ORDER_ALERTVIEW];
    [alert show];
    [alert release];
    alert=nil;
}

-(void)submitGrouponOrderIsNull
{
    UIAlertView *alert = [[OTSAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络配置..." delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert setTag:TAG_COMMIT_ORDER_ALERTVIEW];
    [alert show];
    [alert release];
    alert=nil;
}

-(void)reduceProductCount:(id)sender
{
    //当前数量
    UIButton *button=(UIButton *)[m_ScrollView viewWithTag:TAG_PRODUCT_COUNT];
    int currentCount=[[button titleForState:UIControlStateNormal] intValue];
    
    //限购最低数量
    int minCount=1;
    if ([[m_OrderVO grouponVO] limitLower]!=nil) {
        minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
    }
    
    if (currentCount<=minCount) {
        [m_MinusBtn setEnabled:NO];
    } else {
        currentCount--;
        [button setTitle:[NSString stringWithFormat:@"%d",currentCount] forState:UIControlStateNormal];
        if (currentCount<=minCount) {
            [m_MinusBtn setEnabled:NO];
        } else {
            [m_MinusBtn setEnabled:YES];
        }
    }
    [m_TotalCountLabel setText:[NSString stringWithFormat:@"总数量：%d件",currentCount]];
    m_NeedPayMoney=currentCount*[m_SinglePrice doubleValue];
    [m_TotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
    [m_ProTotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
    //清空账户余额抵扣
    [m_NeedAccountPayLabel setText:@"否"];
    if (m_AccountPayMoney>0.0001 || m_AccountPayMoney<-0.0001) {
        m_AccountPayMoney=0.00;
        [m_AccountPayLabel setText:@"￥0.00"];
        m_CurrentState=THREAD_STATUS_CLEAR_ACCOUNT_PAY_MONEY;
        [self setUpThread];
    }
    [m_NeedPayMoneyLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
}

-(void)addProductCount:(id)sender
{
    //当前数量
    UIButton *button=(UIButton *)[m_ScrollView viewWithTag:TAG_PRODUCT_COUNT];
    int currentCount=[[button titleForState:UIControlStateNormal] intValue];
    currentCount++;
    
    //限购最低数量
    int minCount=1;
    if ([[m_OrderVO grouponVO] limitLower]!=nil) {
        minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
    }
    
    [button setTitle:[NSString stringWithFormat:@"%d",currentCount] forState:UIControlStateNormal];
    if (currentCount<=minCount) {
        [m_MinusBtn setEnabled:NO];
    } else {
        [m_MinusBtn setEnabled:YES];
    }
    [m_TotalCountLabel setText:[NSString stringWithFormat:@"总数量：%d件",currentCount]];
    m_NeedPayMoney=currentCount*[m_SinglePrice doubleValue];
    [m_TotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
    [m_ProTotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
    //清空账户余额抵扣
    [m_NeedAccountPayLabel setText:@"否"];
    if (m_AccountPayMoney>0.0001 || m_AccountPayMoney<-0.0001) {
        m_AccountPayMoney=0.00;
        [m_AccountPayLabel setText:@"￥0.00"];
        m_CurrentState=THREAD_STATUS_CLEAR_ACCOUNT_PAY_MONEY;
        [self setUpThread];
    }
    [m_NeedPayMoneyLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
}

-(void)showAccountPayMoney:(NSNumber *)payMoney
{
    m_AccountPayMoney=[payMoney doubleValue];
    //限购最低数量
//    int minCount=1;
//    if ([[m_OrderVO grouponVO] limitLower]!=nil) {
//        minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
//    }
    
    if (m_AccountPayMoney>-0.0001 && m_AccountPayMoney<0.0001) {
        [m_NeedAccountPayLabel setText:@"否"];
        [m_AccountPayLabel setText:[NSString stringWithFormat:@"￥0.00"]];
        [m_NeedPayMoneyLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney]];
    } else {
        m_AccountPayMoney=[payMoney doubleValue];
        [m_NeedAccountPayLabel setText:[NSString stringWithFormat:@"￥%.2f",m_AccountPayMoney]];
        [m_AccountPayLabel setText:[NSString stringWithFormat:@"￥%.2f",m_AccountPayMoney]];
        [m_NeedPayMoneyLabel setText:[NSString stringWithFormat:@"￥%.2f",m_NeedPayMoney-m_AccountPayMoney]];
    }
}

//使用余额支付
-(void)enterAccountBalancePay
{
    //限购最低数量
//    int minCount=1;
//    if ([[m_OrderVO grouponVO] limitLower]!=nil) {
//        minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
//    }
    
    double accountBalance=[[[m_OrderVO userVO] availableAmount] doubleValue];
    double frozenMoney=[[[m_OrderVO userVO] frozenAmount] doubleValue];
    NSMutableDictionary *balancPayInfoDic=[NSMutableDictionary dictionary];
    [balancPayInfoDic setObject:[NSNumber numberWithDouble:accountBalance] forKey:@"AccountBalance"];
    [balancPayInfoDic setObject:[NSNumber numberWithDouble:frozenMoney] forKey:@"FrozenMoney"];
    [balancPayInfoDic setObject:[NSNumber numberWithDouble:m_NeedPayMoney] forKey:@"NeedPayMoney"];
    [balancPayInfoDic setObject:[NSNumber numberWithBool:NO] forKey:@"ShowBalanceDetail"];
    
    AccountBalance* accountBalanceVC = [[[AccountBalance alloc] initWithNibName:@"AccountBalance" bundle:nil] autorelease];
    [accountBalanceVC setM_InputDictionay:balancPayInfoDic];
    [accountBalanceVC setTaget:self finishSelector:@selector(showAccountPayMoney:) type:2];
    
    [self pushVC:accountBalanceVC animated:YES fullScreen:YES];
}

#pragma mark 线程相关部分
//建立线程
-(void)setUpThread {
	if (!m_ThreadIsRunning) {
		m_ThreadIsRunning = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GrouponShowLoading" object:[NSNumber numberWithBool:YES]];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
        [[OTSGlobalLoadingView sharedInstance] showInView:self.view];
	}
}

//开启线程
-(void)startThread {
	while (m_ThreadIsRunning) {
		@synchronized(self) {
            switch (m_CurrentState)
            {
                    
                case THREAD_STATUS_CREATE_ORDER: 
                {//团购创建订单
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    if (m_Service!=nil) 
                    {
                        [m_Service release];
                    }
                    m_Service=[[GroupBuyService alloc] init];
                    
                    GrouponOrderVO *tempVO=nil;
                    
                    @try {
						tempVO=[m_Service createGrouponOrder:[GlobalValue getGlobalValueInstance].token
                                                   grouponId:m_GrouponId
                                                    serialId:m_SerialId
                                                      areaId:[NSNumber numberWithInt:m_AreaId]];
                        //[[m_OrderVO grouponVO] setRemarkerPrompt:@"现有红色，白色，黑色，蓝色4种颜色可选择，尺寸有M,L,XL可选择"];
                    } 
                    
                    @catch (NSException * e) 
                    {
                    } 
                    
                    @finally 
                    {
                        if (m_OrderVO!=nil) 
                        {
                            [m_OrderVO release];
                        }
                        
                        if (tempVO==nil || [tempVO isKindOfClass:[NSNull class]]) {
                            m_OrderVO=nil;
                        } 
                        else 
                        {
                            m_OrderVO=[tempVO retain];
                        }
                        
                        if (m_OrderVO==nil) 
                        {
                            NSString *errString=@"网络异常，请检查网络配置...";
                            [self performSelectorOnMainThread:@selector(checkOrderIsNull:) withObject:errString waitUntilDone:NO];
                        } 
                        else if ([[m_OrderVO hasError] isEqualToString:@"true"]) 
                        {
                            [self performSelectorOnMainThread:@selector(checkOrderIsNull:) withObject:[m_OrderVO errorInfo] waitUntilDone:NO];
                        } 
                        else 
                        {
//                            // paymentMethods cant be retrieved by getPaymentMethodsForSessionOrder: for group buy order
//                            OrderService* orderServ = [[[OrderService alloc] init] autorelease];
//                            self.paymentMethods = [orderServ getPaymentMethodsForSessionOrder:[GlobalValue getGlobalValueInstance].token];

                            
                            [self performSelectorOnMainThread:@selector(updateOrder) withObject:nil waitUntilDone:NO];
                            
                            // 需传入额外的areaId，grouponId,serialId
                            JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CreatGroupOrder extraPrama:[NSNumber numberWithInt:m_AreaId], m_GrouponId, m_SerialId, nil]autorelease];
                            [DoTracking doJsTrackingWithParma:prama];
                        }
                        
                        [self stopThread];
                    }
                    [pool drain];
                    break;
                }
                    
                case THREAD_STATUS_SUBMIT_ORDER: {
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    if (m_Service!=nil) {
                        [m_Service release];
                    }
                    m_Service=[[GroupBuyService alloc] init];
                    GrouponOrderSubmitResult *tempResult=nil;
                    UIButton *button=(UIButton *)[m_ScrollView viewWithTag:TAG_PRODUCT_COUNT];
                    NSNumber *quantity=[NSNumber numberWithInt:[[[button titleLabel] text] intValue]];
                    NSString *grouponRemarker=nil;
                    NSNumber *gatewayId=[NSNumber numberWithInt:gatewayType];
                    @try {
                        
                        UITextField *textField=(UITextField *)[m_ScrollView viewWithTag:TAG_REMARK_TEXTFIELD];
                        if (textField!=nil) {
                            grouponRemarker=[textField text];
                        }
                        if (grouponRemarker==nil) {
                            grouponRemarker=@"";
                        }

                        DebugLog(@"groupon id========%@",m_GrouponId);
                        DebugLog(@"serial id========%@",m_SerialId);
                        DebugLog(@"quantity=====%@",quantity);
                        DebugLog(@"receiver id======%@",[[[m_OrderVO orderVO] goodReceiver] nid]);
                        DebugLog(@"grouponRemarker====%@",grouponRemarker);
                        
                        
                        NSNumber *serialId=m_SerialId;
                        if (m_SerialId==nil) {
                            serialId=[NSNumber numberWithInt:0];
                        }
                        
						tempResult=[m_Service submitGrouponOrder:[GlobalValue getGlobalValueInstance].token grouponId:m_GrouponId serialId:serialId quantity:quantity receiverId:[[[m_OrderVO orderVO] goodReceiver] nid] payByAccount:[NSNumber numberWithFloat:0.0] grouponRemarker:grouponRemarker areaId:[NSNumber numberWithInt:m_AreaId] gatewayId:gatewayId];
                        
                        // 需设置orderCode,传入额外的areaId，grouponId,serialId，grouponId，quantity，receiverId，payByAccount，grouponRemarke，gateWayId。
                        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SubmitGroupOrder extraPrama:[NSNumber numberWithInt:m_AreaId], m_GrouponId, serialId, quantity, [[[m_OrderVO orderVO] goodReceiver] nid], [NSNumber numberWithFloat:m_AccountPayMoney], grouponRemarker, gatewayId, nil]autorelease];
                        [prama setOrderCode:[m_OrderVO orderVO].orderCode];
                        [DoTracking doJsTrackingWithParma:prama];
                    } @catch (NSException * e) {
                    } @finally {
                        if (m_OrderSubmitResult!=nil) {
                            [m_OrderSubmitResult release];
                        }
                        if (tempResult==nil || [tempResult isKindOfClass:[NSNull class]]) {
                            m_OrderSubmitResult=nil;
                        } else {
                            m_OrderSubmitResult=[tempResult retain];
                        }
                        if (m_OrderSubmitResult==nil) {
                            [self performSelectorOnMainThread:@selector(submitGrouponOrderIsNull) withObject:nil waitUntilDone:NO];
                        } else {
                            [self performSelectorOnMainThread:@selector(toOnlinePay) withObject:nil waitUntilDone:NO];
                        }
                        [self stopThread];
                    }
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_CLEAR_ACCOUNT_PAY_MONEY: {//清空账户支付金额
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
					PayService *pServ=[[PayService alloc] init];
                    SavePayByAccountResult *tempResult;
                    @try {
						tempResult=[pServ savePayByAccount:[GlobalValue getGlobalValueInstance].token payByAccount:[NSNumber numberWithFloat:0.0] validCode:@"" type:[NSNumber numberWithInt:2]];
                    } @catch (NSException * e) {
                    } @finally {
                        if (tempResult!=nil && ![tempResult isKindOfClass:[NSNull class]]) {
                            int result=[[tempResult resultCode] intValue];
                            if (result==1) {//成功
                                //[self performSelectorOnMainThread:@selector(saveAccountPayMoneySuccess) withObject:self waitUntilDone:NO];
                            } else {
                                [self performSelectorOnMainThread:@selector(showError:) withObject:[tempResult errorInfo] waitUntilDone:NO];
                            }
                        } else {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..."waitUntilDone:NO];
                        }
						[pServ release];
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
	m_ThreadIsRunning = NO;
	m_CurrentState = -1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GrouponHideLoading" object:nil];
    [[OTSGlobalLoadingView sharedInstance] hide];
}

#pragma mark alertView相关delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case TAG_COMMIT_ORDER_ALERTVIEW: {
            [self returnBtnClicked:nil];
            break;
        }
        case TAG_CREATE_ORDER_ALERTVIEW: {
            [self returnBtnClicked:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    [self textFieldEndEdit];//关闭键盘
    switch ([tableView tag]) {
		case TAG_RECEIVER_TABLEVIEW: 
        {
            [self removeSubControllerClass:[GoodReceiver class]];
            GoodReceiver* goodReceiverVC = [[[GoodReceiver alloc]initWithNibName:@"GoodReceiver" bundle:nil] autorelease];
            goodReceiverVC.isFullScreen = YES;
            [goodReceiverVC setIsFromGroupon:YES];
            [goodReceiverVC setM_DefaultReceiverId:[[[m_OrderVO orderVO] goodReceiver] nid]];
            
            [self pushVC:goodReceiverVC animated:YES fullScreen:YES];
            
			break;
        }
		case TAG_PAYMENT_TABLEVIEW: 
        {
            if ([indexPath row] == 1) 
            {
                if ([[m_PaymentLabel text] isEqualToString:@" "] && [[m_OrderVO orderVO] goodReceiver]==nil) 
                {
                    [AlertView showAlertView:nil alertMsg:@"您目前没有选择送货地址,请先选择您的送货地址!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
                } 
                else if ([[m_PaymentLabel text] isEqualToString:@" "] && m_AddressNotSupport) 
                {
                    [AlertView showAlertView:nil alertMsg:@"您目前的送货地址不支持任何支付方式,请先确认您的送货地址!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
                } 
                else 
                {
                    [self enterAccountBalancePay];
                }
            } 
            else if ([indexPath row] == 0) 
            {
                if ([[m_PaymentLabel text] isEqualToString:@" "] && [[m_OrderVO orderVO] goodReceiver]==nil) 
                {
                    [AlertView showAlertView:nil alertMsg:@"您目前没有选择送货地址,请先选择您的送货地址!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
                } 
                else if ([[m_PaymentLabel text] isEqualToString:@" "] && m_AddressNotSupport) 
                {
                    [AlertView showAlertView:nil alertMsg:@"您目前的送货地址不支持任何支付方式,请先确认您的送货地址!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
                } 
                else 
                {
                    [self showChooseBankView];
                }
            }
			break;
        }
		case TAG_REMARK_TABLEVIEW:
			break;
		default:
			break;
	}
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ([tableView tag]) {
		case TAG_ORDER_DETAIL_TABLEVIEW: {
			return 4;
			break;
        }
		case TAG_RECEIVER_TABLEVIEW:
			return 1;
			break;
		case TAG_PAYMENT_TABLEVIEW:
			return 2;
			break;
        case TAG_MONEY_TABLEVIEW:
            return 2;
            break;
		case TAG_REMARK_TABLEVIEW:
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
	NSUInteger index=[indexPath row];
    switch ([tableView tag]) {
    case TAG_ORDER_DETAIL_TABLEVIEW: {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIColor *darkRed=[UIColor colorWithRed:203.0/255.0 green:0.0 blue:0.0 alpha:1];
        //限购最低数量
        int minCount=1;
        if ([[m_OrderVO grouponVO] limitLower]!=nil) {
            minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
        }
        if (index==0) {//商品名称
            double yValue=10.0;
            //商品名称label
            NSString *string=[NSString stringWithFormat:@"商品名称：%@",m_ProductName];
            double width=280;
            double stringWidth=[string sizeWithFont:[UIFont systemFontOfSize:15.0]].width;
            NSInteger lineCount=stringWidth/width;
            if (stringWidth/width>lineCount) {
                lineCount++;
            }
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, yValue, 280, 20*lineCount)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:string];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [label setNumberOfLines:lineCount];
            [cell addSubview:label];
            [label release];
        } else if (index==1) {//您选择了
            if (m_SerialId!=nil) {
                //"您选择了:"label
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 24)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:@"您选择了: "];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                //选择的尺码和颜色
                label=[[UILabel alloc] initWithFrame:CGRectMake(100, 10, 210, 24)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:m_SelectedStr];
                [label setFont:[UIFont boldSystemFontOfSize:15.0]];
                [label setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
                [cell addSubview:label];
                [label release];
            }
        } else if (index==2) {//单件价格
            //"单件价格:"label
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 24)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:@"单价价格: "];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
            //单价label
            label=[[UILabel alloc] initWithFrame:CGRectMake(100, 10, 210, 24)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:[NSString stringWithFormat:@"￥%.2f",[m_SinglePrice doubleValue]]];
            [label setFont:[UIFont boldSystemFontOfSize:15.0]];
            [label setTextColor:darkRed];
            [cell addSubview:label];
            [label release];
        } else if (index==3) {//购买数量
            //"购买数量:"label
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 24)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:@"购买数量: "];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
            //减号
            m_MinusBtn=[[UIButton alloc] initWithFrame:CGRectMake(100, 7, 30, 30)];
            [m_MinusBtn setBackgroundColor:[UIColor clearColor]];
            [m_MinusBtn setImage:[UIImage imageNamed:@"minus_enable.png"] forState:UIControlStateNormal];
            [m_MinusBtn addTarget:self action:@selector(reduceProductCount:) forControlEvents:UIControlEventTouchDown];
            [cell addSubview:m_MinusBtn];
            [m_MinusBtn release];
            [m_MinusBtn setEnabled:NO];
            
            //购买数量
            UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(140, 7, 44, 30)];
            [button setTag:TAG_PRODUCT_COUNT];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setBackgroundImage:[UIImage imageNamed:@"groupBuy_order_gray_rect.png"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%d",minCount] forState:UIControlStateNormal];
            [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:15.0]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(setProductCount:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            [button release];
            
            //加号
            m_AddBtn=[[UIButton alloc] initWithFrame:CGRectMake(194, 7, 30, 30)];
            [m_AddBtn setBackgroundColor:[UIColor clearColor]];
            [m_AddBtn setImage:[UIImage imageNamed:@"add_enable.png"] forState:UIControlStateNormal];
            [m_AddBtn addTarget:self action:@selector(addProductCount:) forControlEvents:UIControlEventTouchDown];
            [cell addSubview:m_AddBtn];
            [m_AddBtn release];
            
            label=[[UILabel alloc] initWithFrame:CGRectMake(230, 10, 70, 24)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:[NSString stringWithFormat:@"%d件起售",minCount]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [label setTextAlignment:NSTextAlignmentRight];
            [cell addSubview:label];
            [label release];
        }
        break;
    }
    case TAG_RECEIVER_TABLEVIEW: 
        {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        GoodReceiverVO *goodReceiverVO = [[m_OrderVO orderVO] goodReceiver];
        if (goodReceiverVO == nil)
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280, 24)];
            // 请选择收货地址
            [label setText:@"请选择收货地址"];
            label.textColor = DARK_RED_COLOR;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
        } 
        else 
        {
            double yValue=10.0;
            //收货人
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, yValue, 280, 20)];
            [label setTag:TAG_RECEIVER_PERSON_LABEL];
            [label setText:[goodReceiverVO receiveName]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
            yValue+=20.0;
            //送货地址
            label=[[UILabel alloc]initWithFrame:CGRectMake(20, yValue, 280, 20)];
            [label setTag:TAG_RECEIVER_ADDRESS_LABEL];
            [label setText:[goodReceiverVO address1]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
            yValue+=20.0;
            //省份、城市、地区
            label=[[UILabel alloc]initWithFrame:CGRectMake(20, yValue, 280, 20)];
            [label setTag:TAG_RECEIVER_CITY_LABEL];
            if ([goodReceiverVO.provinceName isEqualToString:@"上海"]) {//上海只显示两级区域
                [label setText:[NSString stringWithFormat:@"%@ %@",goodReceiverVO.provinceName,goodReceiverVO.cityName]];
            } else {
                [label setText:[NSString stringWithFormat:@"%@ %@ %@",goodReceiverVO.provinceName, goodReceiverVO.cityName,goodReceiverVO.countyName]];
            }
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
            yValue+=20.0;
            //手机
            if (goodReceiverVO.receiverMobile != nil) {
                label=[[UILabel alloc]initWithFrame:CGRectMake(20, yValue, 280, 20)];
                [label setTag:TAG_RECEIVER_MOBIL_LABEL];
                [label setText:goodReceiverVO.receiverMobile];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor blackColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                yValue+=20.0;
            }
            //电话
            if (goodReceiverVO.receiverPhone != nil) {
                label=[[UILabel alloc]initWithFrame:CGRectMake(20, yValue, 280, 20)];
                [label setTag:TAG_RECEIVER_MOBIL_LABEL];
                [label setText:goodReceiverVO.receiverPhone];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor blackColor]];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [cell addSubview:label];
                [label release];
                //yValue+=20.0;
            }
        }
        break;
    }
    case TAG_PAYMENT_TABLEVIEW: 
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
        if ([indexPath row] == 1) 
        {
            //"使用账户余额支付"label
            [[cell textLabel] setText:@"使用账户余额支付"];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            
            //账户余额支付
            m_NeedAccountPayLabel=[cell detailTextLabel];
            [m_NeedAccountPayLabel setFont:[UIFont systemFontOfSize:15.0]];
            if (m_AccountPayMoney>0.0) {
                [m_NeedAccountPayLabel setText:[NSString stringWithFormat:@"￥%.2f",m_AccountPayMoney]];
            } else {
                [m_NeedAccountPayLabel setText:@"否"];
            }
        } 
        else if ([indexPath row] == 0) 
        {
            // "请选择付款方式"label
            [[cell textLabel] setText:@"请选择付款方式"];
            cell.textLabel.textColor = DARK_RED_COLOR;
            cell.textLabel.tag = TAG_PAYMENT_CELL_LABEL;
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            //付款方式
            m_PaymentLabel=[cell detailTextLabel];
            [m_PaymentLabel setFont:[UIFont systemFontOfSize:15.0]];
            
            GoodReceiverVO *goodReceiverVO = [[m_OrderVO orderVO] goodReceiver];
            
            if (goodReceiverVO == nil) 
            {
                [m_PaymentLabel setText:@" "];
                //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //cell.accessoryType = UITableViewCellAccessoryNone;
            } 
            else 
            {
                NSArray *paymentModes=[m_OrderVO pmVOList];
                //NSArray *paymentModes = self.paymentMethods;
                if (paymentModes==nil || [paymentModes count]==0) {
                    [[cell detailTextLabel] setText:@" "];
                    if (paymentModes!=nil && [paymentModes count]==0) {
                        m_AddressNotSupport=YES;
                    } else {
                        m_AddressNotSupport=NO;
                    }
                } else {
                    m_AddressNotSupport=NO;
                    NSString *payModeStr;
                    bool hasDefaultPaymentMethod=NO;
                    PaymentMethodVO *paymentMethod=nil;
                    for (paymentMethod in paymentModes) {
                        NSString *isDefaultPaymentMethod=[paymentMethod isDefaultPaymentMethod];
                        if ([[isDefaultPaymentMethod description] isEqualToString:@"true"]) {//有默认的付款方式
                            hasDefaultPaymentMethod=YES;
                            methodID=[[paymentMethod methodId] intValue];
                            paymentType=[[paymentMethod paymentType] intValue];
                            payModeStr = [paymentMethod methodName];
                            if ([paymentMethod gatewayId]!=nil) {
                                gatewayType=[[paymentMethod gatewayId] intValue];
                            }
                            break;
                        }
                    }
                    if (!hasDefaultPaymentMethod) {
                        payModeStr=@" ";
                    }
                    
                    [[cell detailTextLabel] setText:payModeStr];
                    
                    cell.textLabel.textColor = [payModeStr isEqualToString:@" "] ? DARK_RED_COLOR : [UIColor blackColor];
                }
            }
        }
        break;
    }
            
    case TAG_MONEY_TABLEVIEW: {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        int minCount=1;
        if ([[m_OrderVO grouponVO] limitLower]!=nil) {
            minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
        }
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
            m_ProTotalPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 5, 120, 23)];
            [m_ProTotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[m_SinglePrice doubleValue]*(m_SelectedIndex+minCount)]];
            [m_ProTotalPriceLabel setBackgroundColor:[UIColor clearColor]];
            [m_ProTotalPriceLabel setFont:[UIFont systemFontOfSize:15.0]];
            [m_ProTotalPriceLabel setTextAlignment:NSTextAlignmentRight];
            [cell addSubview:m_ProTotalPriceLabel];
            [m_ProTotalPriceLabel release];
            //"运费"label
            label=[[UILabel alloc] initWithFrame:CGRectMake(20, 28, 150, 23)];
            [label setText:@"运费(免运费)："];
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
            [label setText:@"￥0.00"];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [label setTextAlignment:NSTextAlignmentRight];
            [cell addSubview:label];
            [label release];
            //"账户余额抵扣"label
            label=[[UILabel alloc] initWithFrame:CGRectMake(20, 51, 150, 23)];
            [label setText:@"账户余额抵扣："];
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
        } else if (index==1) {
            //"还需支付"label
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 44)];
            [label setText:@"还需支付："];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [cell addSubview:label];
            [label release];
            //应付总金额label
            double needPayMoney=[m_SinglePrice doubleValue]*(m_SelectedIndex+minCount)-m_AccountPayMoney;
            m_NeedPayMoneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 120, 44)];
            [m_NeedPayMoneyLabel setText:[NSString stringWithFormat:@"￥%.2f",needPayMoney]];
            [m_NeedPayMoneyLabel setTextColor:[UIColor redColor]];
            [m_NeedPayMoneyLabel setBackgroundColor:[UIColor clearColor]];
            [m_NeedPayMoneyLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [m_NeedPayMoneyLabel setTextAlignment:NSTextAlignmentRight];
            [cell addSubview:m_NeedPayMoneyLabel];
            [m_NeedPayMoneyLabel release];
        }
        break;
    }
    case TAG_REMARK_TABLEVIEW: {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, 280, 24)];
        [textField setTag:TAG_REMARK_TEXTFIELD];
        [textField setDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remarkTextFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        [cell addSubview:textField];
        [textField release];
        break;
    }
    default:
        break;
	}
	
	return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch ([tableView tag]) {
		case TAG_ORDER_DETAIL_TABLEVIEW:
			return @"订单详情";
			break;
		case TAG_RECEIVER_TABLEVIEW:
			return @"收货人信息";
			break;
		case TAG_PAYMENT_TABLEVIEW:
			return @"付款方式";
			break;
		case TAG_REMARK_TABLEVIEW:
			return @"备注信息";
			break;
		default:
			return nil;
			break;
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([tableView tag]) {
		case TAG_ORDER_DETAIL_TABLEVIEW: {
            if ([indexPath row]==0) {
                NSString *string=[NSString stringWithFormat:@"商品名称：%@",m_ProductName];
                double width=280;
                double stringWidth=[string sizeWithFont:[UIFont boldSystemFontOfSize:15.0]].width;
                NSInteger lineCount=stringWidth/width;
                if (stringWidth/width>lineCount) {
                    lineCount++;
                }
                return 20.0*lineCount+20.0;
            } else if ([indexPath row]==1) {
                if (m_SerialId!=nil) {
                    return 44.0;
                } else {
                    return 0;
                }
            } else if ([indexPath row]==2) {
                return 44.0;
            } else if ([indexPath row]==3) {
                return 44.0;
            } else {
                return 0.0;
            }
			break;
        }
		case TAG_RECEIVER_TABLEVIEW: {
            double height;
            GoodReceiverVO *goodReceiverVO=[[m_OrderVO orderVO] goodReceiver];
            if (goodReceiverVO==nil) {
                height=44.0;
            } else {
                height=80.0;
                if ([goodReceiverVO receiverMobile]!=nil) {
                    height+=20.0;
                }
                if ([goodReceiverVO receiverPhone]!=nil) {
                    height+=20.0;
                }
            }
            return height;
			break;
        }
		case TAG_PAYMENT_TABLEVIEW:
			return 44.0;
			break;
        case TAG_MONEY_TABLEVIEW: {
            if ([indexPath row]==0) {
                return 80.0;
            } else if ([indexPath row]==1) {
                return 44.0;
            } else {
                return 0.0;
            }
            break;
        }
		case TAG_REMARK_TABLEVIEW:
			return 44.0;
			break;
		default:
			return 0;
			break;
	}
}

//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark textField相关delegate和notification
-(void)textFieldTextDidChanged:(NSNotification *)notification
{
    UITextField *textField=[notification object];
    if (![textField isEditing]) {
        return;
    }
    NSString *textFieldStr=[textField text];
    if (textFieldStr==nil || [textFieldStr isEqualToString:@""]) {
        return;
    }
    
    BOOL matched=NO;
    if ([textFieldStr isMatchedByRegex:@"^0$"]) {
        matched=YES;
    } else if ([textFieldStr isMatchedByRegex:@"^[1-9][0-9]*$"]) {
        matched=YES;
    } else if ([textFieldStr isMatchedByRegex:@"^[1-9][0-9]*.[0-9]?[0-9]?$"]) {
        matched=YES;
    } else if ([textFieldStr isMatchedByRegex:@"^0.[0-9]?[0-9]?$"]) {
        matched=YES;
    } else {
        matched=NO;
    }
    
    if (matched) {
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * payNumber = [formatter numberFromString:textFieldStr];
        double amount=[[[m_OrderVO userVO] availableAmount] doubleValue];
        UIButton *button=(UIButton *)[m_ScrollView viewWithTag:TAG_PRODUCT_COUNT];
        int productCount=[[[button titleLabel] text] intValue];
        double productPrice=[m_SinglePrice doubleValue]*productCount;
        if ([payNumber doubleValue]>amount) {
            [textField resignFirstResponder];
            [AlertView showAlertView:nil alertMsg:@"您的账户支付余额不足" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
            [textField setText:@""];
        } else if ([payNumber doubleValue]-productPrice>=0.01) {
            [textField resignFirstResponder];
            [AlertView showAlertView:nil alertMsg:@"您的支付金额超过商品价格" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
            [textField setText:[NSString stringWithFormat:@"%.2f",productPrice]];
        }else {
            //do nothing
        }
        [formatter release];
    } else {
        [textField resignFirstResponder];
        [AlertView showAlertView:nil alertMsg:@"账户支付格式不正确" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        [textField setText:@""];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch ([textField tag]) {
        case TAG_PAYMENT_TEXTFIELD: {
            [m_ScrollView setFrame:CGRectMake(0, -100, 320, 367)];
            break;
        }
        case TAG_REMARK_TEXTFIELD: {
            [m_ScrollView setFrame:CGRectMake(0, -150, 320, 367)];
            break;
        }
        default:
            break;
    }
    
    [self.view sendSubviewToBack:m_ScrollView];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [m_ScrollView setFrame:CGRectMake(0, 44, 320, 367)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [m_ScrollView setFrame:CGRectMake(0, 44, 320, 367)];
    return YES;
}

-(void)remarkTextFieldTextDidChange:(NSNotification *)notification{
    UITextField *textField=[notification object];
    if (![textField isEditing]) {
        return;
    }
}

#pragma mark pickerView相关delegate和datasource
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //限购最低数量
    int minCount=1;
    if ([[m_OrderVO grouponVO] limitLower]!=nil) {
        minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
    }
    return [NSString stringWithFormat:@"%d", row+minCount];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //限购最低数量
    int minCount=1;
    if ([[m_OrderVO grouponVO] limitLower]!=nil) {
        minCount=[[[m_OrderVO grouponVO] limitLower] intValue];
    }
    return 100-minCount;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
	return 90;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m_SelectedIndex=row;
}



#pragma mark -
-(void)releaseMyResoures
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OnlinePayReleased" object:nil];
    
    OTS_SAFE_RELEASE(m_GrouponId);
    OTS_SAFE_RELEASE(m_SerialId);
    OTS_SAFE_RELEASE(m_ProductName);
    OTS_SAFE_RELEASE(m_SelectedStr);
    OTS_SAFE_RELEASE(m_SinglePrice);
    OTS_SAFE_RELEASE(m_OrderVO);
    OTS_SAFE_RELEASE(m_OrderSubmitResult);
    OTS_SAFE_RELEASE(m_Service);
    
    // release outlet
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_PickerView);
    OTS_SAFE_RELEASE(m_TopView);
    OTS_SAFE_RELEASE(m_TotalCountLabel);
    OTS_SAFE_RELEASE(m_TotalPriceLabel);
    OTS_SAFE_RELEASE(m_RedLine);
    OTS_SAFE_RELEASE(paymentMethods);
    
	// remove vc
    [self removeSelf];
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
