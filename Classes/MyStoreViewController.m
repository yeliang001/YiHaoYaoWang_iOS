//
//  MyStoreViewController.m
//  TheStoreApp
//
//  Created by jiming huang on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define THREAD_STATUS_GET_USER_INFO 1
#define THREAD_STATUS_GET_ORDER_COUNT   2
#define ALERTVIEW_LOGOUT_TAG    1

#import "MyStoreViewController.h"
#import "AlertView.h"
#import "AccountBalance.h"
#import "OTSNaviAnimation.h"
#import "OTSAlertView.h"
#import "TheStoreAppAppDelegate.h"
#import "OrderDone.h"
#import "OrderCountVO.h"
#import "BalanceDetailedUse.h"
#import "OTSBadgeView.h"
#import "OTSOnlinePayNotifier.h"
#import "GTMBase64.h"
#import "UserInfo.h"
#import "YWUserService.h"

@interface MyStoreViewController ()
@end



@implementation MyStoreViewController
@synthesize m_UserVO,m_NameLabel,m_BalanceLabel,m_IntegralLabel,m_BalanceDetailBtn;

-(void)selectAndRefreshMe
{
    [self updateMyStore];
    [SharedDelegate enterMyStoreWithUpdate:NO];
}

-(void)setBadge:(NSString*)aBadgeValue
{
    self.tabBarItem.badgeValue = aBadgeValue;
}

-(void)logout
{
    [[OTSUserLoginHelper sharedInstance] logout];
    
    [[GlobalValue getGlobalValueInstance] setNickName:nil];
    [[GlobalValue getGlobalValueInstance] setUserImg:nil];
    [[GlobalValue getGlobalValueInstance] setIsUnionLogin:NO];
    [[GlobalValue getGlobalValueInstance] setUserName:nil];
    [[GlobalValue getGlobalValueInstance] setUserInfo:nil];
    //yaowang logout
    [[GlobalValue getGlobalValueInstance] setYwToken:nil];
    
    [SharedDelegate clearCartNum];
    [OTSOnlinePayNotifier sharedInstance].appBadgeNumber = 0;
    self.tabBarItem.badgeValue = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setLoingBtnIcon" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutSina" object:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OTS_USER_LOG_OUT object:nil];
}

-(void)handleNotifyMyStoreBadgeChanged:(NSNotification*)aNotification
{
    //[self performSelectorOnMainThread:@selector(updateMyStoreOnly) withObject:nil waitUntilDone:NO];
    [m_tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iphone5适配 - dym
    CGRect rc = m_ScrollView.frame;
    rc.size.height = self.view.frame.size.height -  OTS_IPHONE_NAVI_BAR_HEIGHT;
    m_ScrollView.frame = rc;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifyMyStoreBadgeChanged:) name:OTS_NOTIFY_MY_ORDER_BADGE_CHANGED object:nil];
    
    [self initMyStore];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyStore:) name:@"RefreshMyStore" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyStore:) name:NOTIFY_NAME_USER_TYPE_SWITCHED object:nil];
    
}

-(void)refreshMyStore:(NSNotification *)notification
{
    m_ThreadStatus=THREAD_STATUS_GET_USER_INFO;
//    [self updateBindMobileStatus];
//	[self setUpThread];
    [self updateMyStoreView];
}

//初始化
-(void)initMyStore
{
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [m_ScrollView setBackgroundColor:[UIColor clearColor]];
    [m_IntegralLabel setText:@""];
    [m_BalanceLabel setText:@""];
    
    m_NameLabel.text = [GlobalValue getGlobalValueInstance].userInfo.uid;
    
    
    CGFloat yValue=40.0;
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, 365) style:UITableViewStyleGrouped];
    [m_tableView setDelegate:self];
    [m_tableView setDataSource:self];
    [m_tableView setBackgroundColor:[UIColor clearColor]];
    [m_tableView setBackgroundView:nil];
    [m_tableView setScrollEnabled:NO];
    //为了适配ios7
    if (ISIOS7)
    {
        m_tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,m_tableView.bounds.size.width, 10.f)] autorelease];
    }

    [m_ScrollView addSubview:m_tableView];
    yValue+=365;
    
    //让scrollview可以滑动
    [m_ScrollView setContentSize:CGSizeMake(320, yValue)];
    m_ScrollView.alwaysBounceVertical = YES;
	[m_ScrollView setScrollsToTop:NO];
    
//    if ([GlobalValue getGlobalValueInstance].token!=nil) {
//        m_ThreadStatus=THREAD_STATUS_GET_USER_INFO;
//        [self setUpThread];
//    }
    DebugLog(@"自动登录完成，订单查询消息发送!!!");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteRecived" object:self];
    
}

-(MyStoreViewController *)updateMyStore
{
    m_ThreadStatus = THREAD_STATUS_GET_USER_INFO;
//    [self updateBindMobileStatus];
//    [self removeAllMyVC];
//    [self setUpThread];
    return self;
}

-(void)updateBindMobileStatus
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        //--------判定手机绑定状态，然后再更新UI-----------
        BindMobileResult *__bmResult = [[OTSServiceHelper sharedInstance] isBindMobile:[GlobalValue getGlobalValueInstance].token];
        if ([[__bmResult resultCode] isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            isBindMobile = YES;
            bindMobileNum = [[__bmResult phoneNum] retain];
        }
        else
            isBindMobile = NO;
    }
}

-(void)updateMyStoreOnly
{
    m_ThreadStatus = THREAD_STATUS_GET_USER_INFO;
    [self setUpThread];
}

//刷新1号店视图
-(void)updateMyStoreView
{
    if ([GlobalValue getGlobalValueInstance].isUnionLogin)
    {
        //联合登录昵称
        [m_NameLabel setText:[GlobalValue getGlobalValueInstance].userInfo.nickName];
    }
    else
    {
        //用户
        m_NameLabel.text = [GlobalValue getGlobalValueInstance].userInfo.uid;
    }



    
    [m_IntegralLabel setText:[NSString stringWithFormat:@"%@",/*[m_UserVO enduserPoint]]*/ [GlobalValue getGlobalValueInstance].userInfo.userScore]];
    [m_BalanceLabel setText:[NSString stringWithFormat:@"￥%.2f",[[m_UserVO availableAmount] doubleValue]+[[m_UserVO availableCardAmount]doubleValue]]];
    [m_tableView reloadData];
}

//显示错误
-(void)showError:(NSString *)error
{
    [AlertView showAlertView:nil alertMsg:error buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}



//余额使用明细按钮
-(IBAction)toBalanceDetail{
	[self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
	BalanceDetailedUse *balanceDetail = [[BalanceDetailedUse alloc]init];
    [balanceDetail setAmount:m_UserVO.amount];
	[balanceDetail setFrozenAmount:m_UserVO.frozenAmount];
	[balanceDetail setAvailableAmount:m_UserVO.availableAmount];
    [balanceDetail setAvalablaeCardFee:m_UserVO.availableCardAmount];
    [balanceDetail setFrozenCardFee:m_UserVO.frozenCardAmount];
	[self.view addSubview:balanceDetail.view];
    [balanceDetail release];
}

//退出登录
-(IBAction)logoutAccount:(id)sender
{
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
	UIAlertView *alertView=[[OTSAlertView alloc] initWithTitle:@"提示" message:@"确定退出帐号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
	[alertView setTag:ALERTVIEW_LOGOUT_TAG];
	[alertView show];
	[alertView release];
}

#pragma mark    新线程相关
-(void)setUpThread {
	if (!m_ThreadRunning) {
		m_ThreadRunning=YES;
        [self showLoading:YES];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

//开启线程
-(void)startThread {
	while (m_ThreadRunning) {
		@synchronized(self) {
            switch (m_ThreadStatus)
            {
                case THREAD_STATUS_GET_USER_INFO:
                {//获取用户信息
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    
                    
                    
                    YWUserService *userSer = [[[YWUserService alloc] init] autorelease];
                    NSDictionary *dic = @{@"ecuserid":[GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                                             @"id":[GlobalValue getGlobalValueInstance].userInfo.uid,
                                        @"userid" : [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                                      @"username" : [GlobalValue getGlobalValueInstance].userInfo.uid, //uid是 用户名 ，草。。。。
                                         @"token" : [GlobalValue getGlobalValueInstance].ywToken};
                    UserInfo *userInfo = [userSer getUserInfo:dic];
                    
                    if (userInfo == nil)
                    {
                        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                    }
                    else
                    {
                        [self performSelectorOnMainThread:@selector(updateMyStoreView) withObject:nil waitUntilDone:NO];
                        [GlobalValue getGlobalValueInstance].userInfo = userInfo;
                    }
                    
                    [self stopThread];
                    
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
}

#pragma mark    银联支付的delegate
-(void)unionPaytoOrderDetail:(NSNumber *)onlineOrderId
{
    [self selectAndRefreshMe];
    
    [self removeSubControllerClass:[OrderDetail class]];
    OrderDetail *orderDetail=[[[OrderDetail alloc]initWithNibName:@"OrderDetail" bundle:nil] autorelease];
    [orderDetail setM_OrderId:onlineOrderId];
    [self.view addSubview:orderDetail.view];
}

-(void)unionPaytoGroupBuyOrderDetail:(NSNumber *)onlineOrderId isFromMall:(BOOL)isfrommall
{
    [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
    //------------------商城团购回来不用加载自身的页面，而本身团购需要团购详情-----------------------
    if(!isfrommall)
    {
        [self removeSubControllerClass:[GroupBuyOrderDetail class]];
        GroupBuyOrderDetail *orderDetail=[[[GroupBuyOrderDetail alloc]initWithNibName:@"GroupBuyOrderDetail" bundle:nil] autorelease];
        [orderDetail setM_OrderId:onlineOrderId];
        [self.view addSubview:orderDetail.view];
    }
}

-(void)unionPaytoOrderList
{
    [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationFade]];
    [self selectAndRefreshMe];
    [self removeSubControllerClass:[MyOrder class]];
    MyOrder *myOrder=[[[MyOrder alloc]initWithNibName:@"MyOrder" bundle:nil] autorelease];
    NSNumber *number=[[NSNumber alloc] initWithInt:0];
    [[GlobalValue getGlobalValueInstance] setToOrderFromPage:number];
    [number release];
    [self.view addSubview:myOrder.view];
}

-(void)unionPaytoOrderDone:(NSNumber *)onlineOrderId
{
    [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
    [self selectAndRefreshMe];
}

#pragma mark    orderDone的delegate
-(void)orderDoneToOrderDetail:(NSNumber *)onlineOrderId {
    [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
    [self selectAndRefreshMe];
}

#pragma mark    checkOrder的delegate
-(void)checkOrderToOrderDone:(NSNumber *)OrderId
{
    
    [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
    [self selectAndRefreshMe];
}

-(void)enterCoupon{
    [self removeSubControllerClass:[MyCoupon class]];
    MyCoupon *myCoupon=[[[MyCoupon alloc]initWithNibName:@"MyCoupon" bundle:nil] autorelease];
    [self.view addSubview:myCoupon.view];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    
}

-(void)enterOrder{

    [self removeSubControllerClass:[MyOrder class]];
    MyOrder *myOrder=[[[MyOrder alloc]initWithNibName:@"MyOrder" bundle:nil] autorelease];
    [self pushVC:myOrder animated:YES fullScreen:self.isFullScreen];
}

-(void)enterOrderSubmitOKVC:(NSString *)onlineOrderId
{
//    [SharedDelegate.tabBarController removeViewControllerWithAnimation:nil];
//    [self removeSubControllerClass:[OTSOrderSubmitOKVC class]];
//    OTSOrderSubmitOKVC* submitOKVC = [[[OTSOrderSubmitOKVC alloc] initWithOrderId:[onlineOrderId longLongValue]] autorelease];
//    submitOKVC.order = [GlobalValue getGlobalValueInstance].alipayingOrder;
//    [self.view addSubview:submitOKVC.view];
    
    [SharedDelegate.tabBarController removeViewControllerWithAnimation:nil];
    [self removeSubControllerClass:[OTSOrderSubmitOKVC class]];
    OrderDetail *orderDetail=[[[OrderDetail alloc]initWithNibName:@"OrderDetail" bundle:nil] autorelease];
    [orderDetail setM_OrderId:onlineOrderId];
    //    [self pushVC:orderDetail animated:NO fullScreen:NO];
    [self.view addSubview:orderDetail.view];
}

-(void)enterOrderDetail:(NSString *)onlineOrderId
{
    [SharedDelegate.tabBarController removeViewControllerWithAnimation:nil];
    [self removeSubControllerClass:[OrderDetail class]];
    OrderDetail *orderDetail=[[[OrderDetail alloc]initWithNibName:@"OrderDetail" bundle:nil] autorelease];
    [orderDetail setM_OrderId:onlineOrderId];
//    [self pushVC:orderDetail animated:NO fullScreen:NO];
    [self.view addSubview:orderDetail.view];
}

-(void)enterOrderDone:(NSString *)onlineOrderId
{
    [self removeSubControllerClass:[OrderDone class]];
    OrderDone *od = [[[OrderDone alloc] init] autorelease];
    od.onlineOrderId = onlineOrderId;
    [self pushVC:od animated:NO fullScreen:NO];
}

-(void)enter1mallOrder{
    NSData *b64TokenData=[GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *b64TokenStr=[[[NSString alloc] initWithData:b64TokenData encoding:NSUTF8StringEncoding] autorelease];
    NSString* urlStr=[NSString stringWithFormat:@"http://m.1mall.com/mw/grporderlist/1/%@/30/0/2/2",b64TokenStr];
    urlStr=[urlStr stringByAppendingFormat:@"?provinceId=%@",[GlobalValue getGlobalValueInstance].provinceId];
    [SharedDelegate enterWap:0 invokeUrl:urlStr isClearCookie:YES];
}
#pragma mark    tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row==0)
            {//1号店订单
                [self enterOrder];
            }
            else if (indexPath.row==1)
            {//1号商城订单
                [self enter1mallOrder];
            }
            break;
        }
        case 1:
        {
//            if (indexPath.row == 0)
//            {
//                [self toBalanceDetail];
//            }
//            else if (indexPath.row==1)
//                {//我的抵用券
//                    [self enterCoupon];
//                }
//                else
                    if (indexPath.row==0)
                {//我的收藏
                    [self removeSubControllerClass:[MyFavorite class]];
                    MyFavorite *myFavorite=[[[MyFavorite alloc]initWithNibName:@"MyFavorite" bundle:nil] autorelease];
                    [self.view addSubview:myFavorite.view];
                    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
                }
                else if (indexPath.row==1)
                {//地址管理
                    [self removeSubControllerClass:[GoodReceiver class]];
                    GoodReceiver *receriver=[[[GoodReceiver alloc] initWithNibName:@"GoodReceiver" bundle:nil] autorelease];
                    [receriver setM_FromTag:FROM_MY_STORE];
                    [receriver setM_DefaultReceiverId:nil];
                    [self.view addSubview:receriver.view];
                    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
                }
            break;
        }
        case 2:
        {
  
            [self removeSubControllerClass:[BindViewController class]];
            BindViewController *phonebindVC=[[[BindViewController alloc]initWithNibName:@"BindViewController" bundle:nil] autorelease];
            [phonebindVC setIsBindMobile:isBindMobile];
            [phonebindVC setBindMobileNum:bindMobileNum];
            phonebindVC.isFullScreen = YES;
            [SharedDelegate.tabBarController addViewController:phonebindVC withAnimation:[OTSNaviAnimation animationPushFromRight]];
        }
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    int row = [indexPath row];
    int section = [indexPath section];
    
    switch (section)
    {
        case 0:
        {
            if (row == 0)
            {
                UIImageView *logo=[[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 16, 16)];
                [logo setImage:[UIImage imageNamed:@"mystore_store.png"]];
                [cell addSubview:logo];
                [logo release];
                
                [[cell textLabel] setText:@"     我的订单"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
                
                int newOrderCount = [OTSOnlinePayNotifier sharedInstance].storeOrderCount;
                if (newOrderCount > 0)
                {
                    OTSGrayBadgeView* myOrderBadgeView = [[[OTSGrayBadgeView alloc] initWithPosition:CGPointMake(260, 13) badgeNumber:newOrderCount] autorelease];
                    [cell addSubview:myOrderBadgeView];
                }
            }
            else if(row == 1)
            {
                UIImageView *logo=[[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 16, 16)];
                [logo setImage:[UIImage imageNamed:@"mystore_mall.png"]];
                [cell addSubview:logo];
                [logo release];
                
                [[cell textLabel] setText:@"     1号商城订单"];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
                
                int newOrderCount = [OTSOnlinePayNotifier sharedInstance].mallOrderCount;
                if (newOrderCount > 0)
                {
                    OTSRedBadgeView* myOrderBadgeView = [[[OTSRedBadgeView alloc] initWithPosition:CGPointMake(260, 13) badgeNumber:newOrderCount] autorelease];
                    [cell addSubview:myOrderBadgeView];
                }
            }
        }
            break;
        case 1:
        {
//            if (row == 0)
//            {
//                [[cell textLabel] setText:@"我的账户余额"];
//                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
//            }else
//                if (row == 1)
//                {
//                    [[cell textLabel] setText:@"我的抵用券"];
//                    [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
//                } else
                    if (row == 0) {
                    [[cell textLabel] setText:@"我的收藏"];
                    [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
                    
                } else if (row == 1) {
                    [[cell textLabel] setText:@"地址管理"];
                    [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
                }
        }
            break;
        case 2:
        {
            [[cell textLabel] setText:@"手机绑定"];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
            //--------------获取手机绑定的状态---------------------
            if (isBindMobile)
            {
                [[cell detailTextLabel] setText:@"已绑定"];
            }
            else
            {
                [[cell detailTextLabel] setText:@"未绑定"];
            }
            [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:15.0]];
            [[cell detailTextLabel] setTextColor:[UIColor grayColor]];
        }
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
#pragma mark    alertview相关
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) // 退出登录
    {
        [self logout];
        [self removeSelf];
        
        [SharedDelegate enterHomePageRoot];
        
        
        [[UserManageTool sharedInstance] UpdateFiled:KEY
                                        withFiledKey:KEY_AUTOLOGSTATUS
                                           withValue:@"0"
                                      withNeedToSave:YES];
    }
}

-(void)releaseResource
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    OTS_SAFE_RELEASE(m_UserVO);
    // release outlet
    OTS_SAFE_RELEASE(m_NameLabel);
    OTS_SAFE_RELEASE(m_IntegralLabel);
    OTS_SAFE_RELEASE(m_BalanceLabel);
    OTS_SAFE_RELEASE(m_BalanceDetailBtn);
    OTS_SAFE_RELEASE(m_tableView);
    OTS_SAFE_RELEASE(bindMobileNum);
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
