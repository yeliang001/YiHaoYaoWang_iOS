//
//  MyListViewController.m
//  yhd
//
//  Created by dev dev on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyListViewController.h"
#import "OtspOrderConfirmVC.h"
#import "GoodReceiverVO.h"
#import "UserVO.h"
#import "FavoriteVO.h"
#import "OrderV2.h"
#import "Page.h"
#import "CustomAddressCell.h"
#import "CustomFavouriteCell.h"
#import "CustomOrderCell.h"
#import "OrderTypeCell.h"
#import "OrderItemVO.h"
#import "TopView.h"
#import "NewAddressView.h"
#import <QuartzCore/QuartzCore.h>
#import "CityVO.h"
#import "CountyVO.h"
#import "ProvinceVO.h"
#import "ProductVO.h"
#import "OnlinePayViewController.h"
#import "OrderTrackViewController.h"
#import "ProductListViewController.h"
#import "OTSChangePayButton.h"
#import "OTSUtility.h"
#import "BankVO.h"
#import "PayInWebView.h"
#import "SaveGateWayToOrderResult.h"
#import "GTMBase64.h"
#import "UIView+LoadFromNib.h"
#import "OTSPadTicketListView.h"
#import "UIView+LoadFromNib.h"
#import "CouponVO.h"
#import "OTSPadTicketListCell.h"
#import "OTSPadTicketRuleView.h"
#import "AlixPay.h"
#define pagesize 10
//#define kUserInformation [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]
#define knewview 105
#define knewaddressview 103
#define CONTENT_OFFSET_X 260
#define CONTENT_WIDTH 770

#define ORDER_TYPE_PROCESSING 4
#define ORDER_TYPE_COMPLETED 2
#define ORDER_TYPE_CANCELLED 3


@interface MyListViewController ()
{
    OTSMyStoreListType  _currentSelectedType;
    BOOL isChangePaymentViewShowing;
}
@property(retain)               NSMutableArray          *theOrders;
@property                       BOOL                    needUpdateMyStore;
@property(nonatomic, retain)    OTSChangePayButton       *changePayBtn; // 切换支付方式按钮
@property(retain)               NSArray                 *bankList;
//@property(retain)OrderV2        *payChangingOrder;  // 正在修改payment的order
@property                       NSUInteger              payChangeOrderIndex;

@property           OTSTicketTabType        ticketType;
@property (retain)  Page                    *ticketPage;
@property (retain)  NSMutableArray          *tickets;
@property (retain)  Page                    *orderPage;

-(NSUInteger)requestPage;
-(NSUInteger)currentPage;

@end

@implementation MyListViewController
@synthesize mIsLoadingFavourite;//传入参数
@synthesize theOrders = _theOrders;
@synthesize needUpdateMyStore = _needUpdateMyStore;
@synthesize changePayBtn = _changePayBtn;
@synthesize bankList = _bankList;
@synthesize payChangeOrderIndex;
@synthesize _currentCheckOrderID;
@synthesize ticketType = _ticketType;
@synthesize ticketPage = _ticketPage;
@synthesize tickets = _tickets;
@synthesize orderPage = _orderPage;
@synthesize temppayView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _needUpdateMyStore = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [mTopView setCartCount:dataHandler.cart.totalquantity.intValue];
    
    [self updateMyStore];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _needUpdateMyStore = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popPayInWebView:) name:@"popPayInWebView" object:nil];
    
    self.theOrders = [NSMutableArray arrayWithCapacity:10];
    self.tickets = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FavouriteListRefresh:) name:@"kRefreshFavourite" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddressListRefresh:) name:@"kRefreshAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeNewAddressView:) name:@"popthnewaddressview" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PopUpUIpickerview:) name:@"kPopUpUIpickerview" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popNewAddressView:) name:@"newaddresssucceed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddressEditSucceed:) name:@"editaddresssucceed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(EditAddress:) name:@"kEditAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openOrderTrack:) name:@"kGetOrderTrack" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newThreadGetSessionUser) name:NOTIFY_NAME_USER_TYPE_SWITCHED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifyShowTicketRule:) name:PAD_NOTIFY_SHOW_TICKET_RULE object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(needUpdateMyStoreforCheckOrderStatusHD:) name:@"needUpdateMyStoreforCheckOrderStatusHD" object:nil];
    
    
    
    labelsArray = [[NSMutableArray alloc] initWithObjects:
                   mUserBackLabel
                   , mFavouriteLabel
                   , m1mallLabel
                   , mReceiverLabel
                   , mServiceProtocolLabel
                   , self.listTicketLabel
                   , nil];
    
    buttonBgArray = [[NSMutableArray alloc] initWithObjects:
                     mUserBackImageView
                     , mFavouriteImageView
                     , m1mallImageview
                     , mReceiverImageView
                     , mServiceProtocolImageView
                     , self.listTicketBgIV
                     , nil];
    
    arrowsArray = [[NSMutableArray alloc] initWithObjects:
                   mUserBackArrowImageView
                   , mFavouriteArrowImageView
                   , m1mallArrowImageview
                   , mReceiverArrowImageView
                   , mServiceProtocolArrowImageView
                   , self.listTicketArrowIV
                   , nil];
    
    // OTSPadTicketListView
    CGRect ticketRc = self.ticketListView.frame;
    UIView *superView = self.ticketListView.superview;
    [self.ticketListView removeFromSuperview];
    self.ticketListView = [OTSPadTicketListView viewFromNibWithOwner:self];
    self.ticketListView.frame = ticketRc;
    self.ticketListView.delegate = self;
    self.ticketListView.tableView.delegate = self;
    self.ticketListView.tableView.dataSource = self;
    self.ticketListView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [superView addSubview:self.ticketListView];
    
    [self initMyStore];
}

-(void)handleNotifyShowTicketRule:(NSNotification*)aNote
{
    CouponVO *vo = aNote.object;
    if (vo)
    {
        OTSPadTicketRuleView *ruleView = [[[OTSPadTicketRuleView alloc] initWithFrame:self.view.bounds] autorelease];
        [self.view addSubview:ruleView];
        [ruleView showWithVO:vo];
    }
}

-(void)needUpdateMyStoreforCheckOrderStatusHD:(NSNotification*)aNote
{
    [self checkOrderStatusHD2:^()
    {
        _needUpdateMyStore = YES;
        [self updateMyStore];
    }];
}

-(void)initMyStore
{
    [mIndicator startAnimating];
    mOrderTypeArray = [[NSArray alloc] initWithObjects:@"正在处理的订单",@"已完成的订单",@"已取消的订单", nil];
    mordertypeTableView.scrollEnabled=NO;
    mcurrentOrderType=1;
    mfavouriteCurrentPage=1;
    //morderCurrentPage=1;
    self.orderPage = nil;
    
    mTopView=[[TopView alloc]initWithFrame:CGRectMake(0, 0, 1024, 55)];
    [self.view addSubview:mTopView];
    
    [self updateMyStore];
}

-(void)updateMyStore
{
    if (!_needUpdateMyStore)
    {
        return;
    }
    
    _needUpdateMyStore = NO;
    mloadingView.hidden = NO;
    
    //获取用户信息
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetSessionUser) toTarget:self withObject:nil];
    
    if (!mIsLoadingFavourite)
    {//获取我的订单
        [_theOrders removeAllObjects];
        mcurrentOrderType=4;
        //morderCurrentPage=1;
        self.orderPage = nil;
        [mListView bringSubviewToFront:morderlistTableView];
        [self changeselected:kMyStoreListMyOrder];
        [self performSelector:@selector(getMyOrderList) withObject:nil];
        NSIndexPath *first=[NSIndexPath indexPathForRow:0 inSection:0];
        
        [mordertypeTableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
    } else {//获取我的收藏
        [mordertypeTableView reloadData];
        [self changeselected:kMyStoreListMyFav];
        mfavouriteCurrentPage = 1;
        [self performSelector:@selector(getMyFavoriteList) withObject:nil];
    }
}

#pragma mark - 获取用户信息
-(void)newThreadGetSessionUser
{
    [self newThreadGetSessionUserWithObject:nil finishSelector:@selector(getCurrentUserHandle:)];
}

-(void)getCurrentUserHandle:(UserVO *)userVO
{
    if ([GlobalValue getGlobalValueInstance].nickName!=nil) {
        mcurrentUserLabel.text=[GlobalValue getGlobalValueInstance].nickName;
    }
    else if (userVO.userRealName)
    {
        mcurrentUserLabel.text = userVO.userRealName;
    }
    else
    {
        mcurrentUserLabel.text=userVO.username;
    }
    
    mcurrentUserLabel.text = [NSString stringWithFormat:@"当前用户：%@", mcurrentUserLabel.text];
    
    [mcurrentUserLabel sizeToFit];
    CGRect newRc = mcurrentUserLabel.frame;
    float rightX = CGRectGetMaxX(newRc);
    float maxX = mcurrentUserLabel.superview.frame.size.width - 120;
    float offsetX = maxX - rightX;
    
    newRc.origin.x += offsetX;
    mcurrentUserLabel.frame = newRc;
    
}

#pragma mark - 获取我的订单
-(void)newThreadGetMyOrderList
{
    NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
    [mDictionary setObject:[NSNumber numberWithInt:mcurrentOrderType] forKey:@"Type"];
    [mDictionary setObject:[NSNumber numberWithInt:self.requestPage] forKey:@"CurrentPage"];
    [self newThreadGetMyOrderWithObject:mDictionary finishSelector:@selector(getMyOrderListHandle:)];
    [mDictionary release];
    
    [self performInThreadBlock:^(){
        self.bankList = [OTSUtility requestBanks];
    } completionInMainBlock:^() {
        [morderlistTableView reloadData];
    }];
    
}

-(void)getMyOrderList
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetMyOrderList) toTarget:self withObject:nil];
}

-(NSUInteger)currentPage
{
    return [self.orderPage.currentPage intValue];
}

-(NSUInteger)requestPage
{
    return self.currentPage + 1;
}

-(void)getMyOrderListHandle:(Page *)page
{
    NSNumber *orderType = [page.userInfo objectForKey:PAGE_USER_INFO_ORDER_TYPE];
    if (orderType.intValue != mcurrentOrderType)
    {
        return;
    }
    
    self.orderPage = page;
    if (page && ![page isKindOfClass:[NSNull class]] && page.objList)
    {
        if (self.currentPage == 1)
        {
            self.theOrders = [NSMutableArray arrayWithArray:page.objList];
        }
        else
        {
            [self.theOrders addObjectsFromArray:page.objList];
        }
    }
    else
    {
        [self.theOrders removeAllObjects];
    }
    
    if (_theOrders == nil || [_theOrders count] <= 0)
    {
        //        if ([self.view viewWithTag:1001]&&[self.view viewWithTag:1001].superview) {
        //            [[self.view viewWithTag:1001]removeFromSuperview];
        //        }
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MyListEmptyView" owner:self options:nil];
        MyListEmptyView *mEmptyView = [nib objectAtIndex:0];
        mEmptyView.frame = CGRectMake(CONTENT_OFFSET_X, 133, CONTENT_WIDTH, 600);
        mEmptyView.tag = 1001;
        int emptytype;
        switch (mcurrentOrderType) {
            case 4:
                emptytype = 1;
                break;
            case 2:
                emptytype = 2;
                break;
            case 3:
                emptytype = 3;
                break;
            case 5:
                emptytype = 4;
                break;
            default:
                break;
        }
        mEmptyView.type = [NSNumber numberWithInt:emptytype];
        [mEmptyView refreshEmptyView];
        
        [self.view addSubview:mEmptyView];
        
        //        if (_currentSelectedType == kMyStoreListMyTicket)
        //        {
        //            [self.ticketListView.superview bringSubviewToFront:self.ticketListView];
        //        }
        
    }
    //    else
    //    {
    //        [[self.view viewWithTag:1001] removeFromSuperview];
    //    }
    
    //morderCurrentPage++;
    m_OrderTotalCount=[[page totalSize] intValue];
    [morderlistTableView reloadData];
    mloadingView.hidden=YES;
    mIsLoading=NO;
    morderlistTableView.tableFooterView=nil;
}

#pragma mark - 取消订单
-(void)cancelOrder:(OrderV2 *)orderV2
{
    NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
    [mDictionary setObject:orderV2.orderId forKey:@"OrderId"];
    [self setUpThreadWithStatus:THREAD_STATUS_CANCEL_ORDER showLoading:YES withObject:mDictionary finishSelector:@selector(cancelOrderHandle:)];
    [mDictionary release];
}

-(void)cancelOrderHandle:(NSNumber *)result
{
    if ([result intValue]==1) {
        mloadingView.hidden=NO;
        //morderCurrentPage=1;
        self.orderPage = nil;
        [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetMyOrderList) toTarget:self withObject:nil];
    } else {
        [self showError:@"取消订单失败"];
    }
}

#pragma mark - 获取我的收藏
-(void)newThreadGetMyFavorite
{
    NSMutableDictionary *mDictioanry=[[NSMutableDictionary alloc] init];
    [mDictioanry setObject:[NSNumber numberWithInt:mfavouriteCurrentPage] forKey:@"CurrentPage"];
    [self newThreadGetMyFavoriteWithObject:mDictioanry finishSelector:@selector(getMyFavoriteHandle:)];
    [mDictioanry release];
}

-(void)getMyFavoriteList
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetMyFavorite) toTarget:self withObject:nil];
}

-(void)getMyFavoriteHandle:(Page *)page
{
    if (page!=nil && ![page isKindOfClass:[NSNull class]] && page.objList!=nil) {
        if (mfavouriteCurrentPage==1) {
            if (mfavouriteListArray!=nil) {
                [mfavouriteListArray release];
            }
            mfavouriteListArray=[[NSMutableArray alloc] initWithArray:page.objList];
        } else {
            [mfavouriteListArray addObjectsFromArray:page.objList];
        }
    } else {
        if (mfavouriteListArray!=nil) {
            [mfavouriteListArray release];
        }
        mfavouriteListArray=nil;
    }
    mIsLoading=NO;
    mfavouriteTableView.tableFooterView = nil;
    
    if (mfavouriteListArray==nil || [mfavouriteListArray count]==0)
    {
        //[[mfavouriteTableView viewWithTag:1001] removeFromSuperview];
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"MyListEmptyView" owner:self options:nil];
        MyListEmptyView *mEmptyView = [nib objectAtIndex:0];
        mEmptyView.frame = CGRectMake(CONTENT_OFFSET_X, 133, CONTENT_WIDTH, 600);
        mEmptyView.tag = 1001;
        mEmptyView.type = [NSNumber numberWithInt:5];
        [mEmptyView refreshEmptyView];
        [self.view addSubview:mEmptyView];
    }
    //    else {
    //        [[self.view viewWithTag:1001]removeFromSuperview];
    //    }
    
    mfavouriteCurrentPage++;
    m_FavoriteTotalCount=[[page totalSize] intValue];
    [mfavouriteTableView reloadData];
    mloadingView.hidden = YES;
}

#pragma mark - 获取收货地址
-(void)newThreadGetGoodReceiver
{
    [self newThreadGetGoodReceiverWithObject:nil finishSelector:@selector(getGoodReceiverHandle:)];
}

-(void)getGoodReceiver
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetGoodReceiver) toTarget:self withObject:nil];
}

-(void)getGoodReceiverHandle:(NSArray *)array
{
    if (mreceiveListArray!=nil) {
        [mreceiveListArray release];
    }
    mreceiveListArray=[array retain];
    
    [[self.view viewWithTag:1001] removeFromSuperview];
    
    if ([mreceiveListArray count]==0)
    {
        //[[self.view viewWithTag:1001] removeFromSuperview];
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"MyListEmptyView" owner:self options:nil];
        MyListEmptyView *mEmptyView = [nib objectAtIndex:0];
        mEmptyView.delegate = self;
        mEmptyView.frame = CGRectMake(CONTENT_OFFSET_X, 133, CONTENT_WIDTH, 600);
        mEmptyView.tag = 1001;
        mEmptyView.type = [NSNumber numberWithInt:6];
        [mEmptyView refreshEmptyView];
        [self.view addSubview:mEmptyView];
        //count == 0 隐藏 addnewaddr
        UIButton *_addnewaddr = (UIButton*)[self.view viewWithTag:520];
        [_addnewaddr setHidden:YES];
    }
    else if([mreceiveListArray count]==10) {
        
        UIButton *_addnewaddr = (UIButton*)[self.view viewWithTag:520];
        [_addnewaddr setHidden:NO];
        [UIView animateWithDuration:0.2 animations:^{
            _addnewaddr.alpha = 1.0;
        } completion:^(BOOL finished)
         {
         }];
        
        [[self.view viewWithTag:1001] removeFromSuperview];
    }
    else {
        UIButton *_addnewaddr = (UIButton*)[self.view viewWithTag:520];
        [_addnewaddr setHidden:NO];
        [UIView animateWithDuration:0.2 animations:^{
            _addnewaddr.alpha = 1.0;
        } completion:^(BOOL finished)
         {
         }];
        [[self.view viewWithTag:1001] removeFromSuperview];
    }
    mloadingView.hidden = YES;
    [mreceiverTableView reloadData];
    
    [self otsDetatchMemorySafeNewThreadSelector:@selector(PaymentType) toTarget:self withObject:nil];//just text
}

#pragma mark - 退出登录
-(void)newThreadLogout
{
    [self newThreadLogoutWithObject:nil finishSelector:@selector(logoutHandle:)];
}

-(void)logoutHandle:(NSNumber *)result
{
    if ([result intValue]==1) {
        //[GlobalValue getGlobalValueInstance].storeToken = nil;
        [OTSUserSwitcher sharedInstance].currentToken = nil;
        [GlobalValue getGlobalValueInstance].nickName=nil;
        [[UserManageTool sharedInstance] UpdateFiled:KEY
                                        withFiledKey:KEY_AUTOLOGSTATUS
                                           withValue:@"0"
                                      withNeedToSave:YES];
        
        [DataHandler sharedDataHandler].cart = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self showError:@"退出登录失败"];
    }
}

-(void)showHideViewsByListType:(OTSMyStoreListType)aListType
{
    morderlistTableView.hidden = YES;
    mfavouriteTableView.hidden = YES;
    mreceiverTableView.hidden = YES;
    mUserBackView.hidden = YES;
    mServiceView.hidden = YES;
    order1MallWeb.view.hidden = YES;
    self.ticketListView.hidden = YES;
    
    [[self.view viewWithTag:1001]removeFromSuperview];
    
    switch (aListType)
    {
        case kMyStoreListMyOrder:
        {
            morderlistTableView.hidden = NO;
        }
            break;
            
        case kMyStoreListMyFav:
        {
            mfavouriteTableView.hidden = NO;
        }
            break;
            
        case kMyStoreListMyAddress:
        {
            mreceiverTableView.hidden = NO;
        }
            break;
            
        case kMyStoreListFeedback:
        {
            mUserBackView.hidden = NO;
        }
            break;
            
        case kMyStoreListProtocol:
        {
            mServiceView.hidden = NO;
        }
            break;
            
        case kMyStoreListMallOrder:
        {
            order1MallWeb.view.hidden = NO;
        }
            break;
            
        case kMyStoreListMyTicket:
        {
            self.ticketListView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

-(void)changeselected:(NSInteger)type
{
    _currentSelectedType = type;
    
    if (type == kMyStoreListMyFav) {
        [MobClick beginLogPageView:@"account_fav"];
    } else {
        [MobClick endLogPageView:@"account_fav"];
    }
    
    [self showHideViewsByListType:type];
    
    if (type == kMyStoreListMyOrder) {//我的订单
        for (UIImageView*imv in buttonBgArray) {
            imv.image=nil;
        }
        for (UILabel*label in labelsArray) {
            label.textColor=[UIColor blackColor];
        }
        for (UIImageView* arrow in arrowsArray) {
            arrow.image=[UIImage imageNamed:@"arrowinusercenterunselected.png"];
        }
        order1MallWeb.view.hidden=YES;
        if (mServiceView) {
            [mServiceView removeFromSuperview];
            mServiceView = nil;
        }
        if (mUserBackView) {
            [mUserBackView removeFromSuperview];
            mUserBackView = nil;
        }
    }
    
    else if(type == kMyStoreListMyFav) {//我的收藏
        [mordertypeTableView reloadData];
        order1MallWeb.view.hidden=YES;
        for (UIImageView*imv in buttonBgArray) {
            if (imv==mFavouriteImageView)
                imv.image=[UIImage imageNamed:@"redbackgroundinusercenter.png"];
            else
                imv.image=nil;
        }
        for (UILabel*label in labelsArray) {
            if (label==mFavouriteLabel)
                label.textColor=[UIColor whiteColor];
            else
                label.textColor=[UIColor blackColor];
        }
        for (UIImageView* arrow in arrowsArray) {
            if (arrow==mFavouriteArrowImageView)
                arrow.image=[UIImage imageNamed:@"arrowinusercenterselected.png"];
            else
                arrow.image=[UIImage imageNamed:@"arrowinusercenterunselected.png"];
        }
        
        
        if (mServiceView) {
            [mServiceView removeFromSuperview];
            mServiceView = nil;
        }
        if (mUserBackView) {
            [mUserBackView removeFromSuperview];
            mUserBackView = nil;
        }
        [mListView bringSubviewToFront:mfavouriteTableView];
    }
    
    else if (type == kMyStoreListMyAddress) {//收货地址
        [mordertypeTableView reloadData];
        order1MallWeb.view.hidden=YES;
        for (UIImageView*imv in buttonBgArray) {
            if (imv==mReceiverImageView)
                imv.image=[UIImage imageNamed:@"redbackgroundinusercenter.png"];
            else
                imv.image=nil;
        }
        for (UILabel*label in labelsArray) {
            if (label==mReceiverLabel)
                label.textColor=[UIColor whiteColor];
            else
                label.textColor=[UIColor blackColor];
        }
        for (UIImageView* arrow in arrowsArray) {
            if (arrow==mReceiverArrowImageView)
                arrow.image=[UIImage imageNamed:@"arrowinusercenterselected.png"];
            else
                arrow.image=[UIImage imageNamed:@"arrowinusercenterunselected.png"];
        }
        
        if (mServiceView) {
            [mServiceView removeFromSuperview];
            mServiceView = nil;
        }
        if (mUserBackView) {
            [mUserBackView removeFromSuperview];
            mUserBackView = nil;
        }
        [mListView bringSubviewToFront:mreceiverTableView];
    }
    
    else if (type == kMyStoreListFeedback) {//用户反馈
        [mordertypeTableView reloadData];
        order1MallWeb.view.hidden=YES;
        for (UIImageView*imv in buttonBgArray) {
            if (imv==mUserBackImageView)
                imv.image=[UIImage imageNamed:@"redbackgroundinusercenter.png"];
            else
                imv.image=nil;
        }
        for (UILabel*label in labelsArray) {
            if (label==mUserBackLabel)
                label.textColor=[UIColor whiteColor];
            else
                label.textColor=[UIColor blackColor];
        }
        for (UIImageView* arrow in arrowsArray) {
            if (arrow==mUserBackArrowImageView)
                arrow.image=[UIImage imageNamed:@"arrowinusercenterselected.png"];
            else
                arrow.image=[UIImage imageNamed:@"arrowinusercenterunselected.png"];
        }
        
        if (mServiceView) {
            [mServiceView removeFromSuperview];
            mServiceView = nil;
        }
    }
    
    else if (type == kMyStoreListProtocol) {//服务协议
        [mordertypeTableView reloadData];
        order1MallWeb.view.hidden=YES;
        for (UIImageView*imv in buttonBgArray) {
            if (imv==mServiceProtocolImageView)
                imv.image=[UIImage imageNamed:@"redbackgroundinusercenter.png"];
            else
                imv.image=nil;
        }
        for (UILabel*label in labelsArray) {
            if (label==mServiceProtocolLabel)
                label.textColor=[UIColor whiteColor];
            else
                label.textColor=[UIColor blackColor];
        }
        for (UIImageView* arrow in arrowsArray) {
            if (arrow==mServiceProtocolArrowImageView)
                arrow.image=[UIImage imageNamed:@"arrowinusercenterselected.png"];
            else
                arrow.image=[UIImage imageNamed:@"arrowinusercenterunselected.png"];
        }
        
        if (mUserBackView) {
            [mUserBackView removeFromSuperview];
            mUserBackView = nil;
        }
    }
    
    else if (type == kMyStoreListMallOrder){//1mall商城订单
        [mordertypeTableView reloadData];
        order1MallWeb.view.hidden=NO;
        for (UIImageView*imv in buttonBgArray) {
            if (imv==m1mallImageview)
                imv.image=[UIImage imageNamed:@"redbackgroundinusercenter.png"];
            else
                imv.image=nil;
        }
        for (UILabel*label in labelsArray) {
            if (label==m1mallLabel)
                label.textColor=[UIColor whiteColor];
            else
                label.textColor=[UIColor blackColor];
        }
        for (UIImageView* arrow in arrowsArray) {
            if (arrow==m1mallArrowImageview)
                arrow.image=[UIImage imageNamed:@"arrowinusercenterselected.png"];
            else
                arrow.image=[UIImage imageNamed:@"arrowinusercenterunselected.png"];
        }
        if (mServiceView) {
            [mServiceView removeFromSuperview];
            mServiceView = nil;
        }
        if (mUserBackView) {
            [mUserBackView removeFromSuperview];
            mUserBackView = nil;
        }
    }
    
    else if (type == kMyStoreListMyTicket){ // 我的抵用券
        
        for (UIImageView* imv in buttonBgArray)
        {
            imv.image = (imv == self.listTicketBgIV) ? [UIImage imageNamed:@"redbackgroundinusercenter.png"] : nil;
        }
        
        for (UILabel*label in labelsArray)
        {
            label.textColor = (label == self.listTicketLabel) ? [UIColor whiteColor] : [UIColor blackColor];
        }
        
        for (UIImageView* arrow in arrowsArray)
        {
            arrow.image = (arrow == self.listTicketArrowIV) ? [UIImage imageNamed:@"arrowinusercenterselected.png"] : [UIImage imageNamed:@"arrowinusercenterunselected.png"];
        }
        
        [mordertypeTableView reloadData];
        order1MallWeb.view.hidden=YES;
        
        if (mUserBackView) {
            [mUserBackView removeFromSuperview];
            mUserBackView = nil;
        }
        
        [self.ticketListView.superview bringSubviewToFront:self.ticketListView];
        [self.ticketListView.superview.superview bringSubviewToFront:self.ticketListView.superview];
    }
}

#pragma mark - 加入购物车
-(void)addProductsToCart
{
    NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
    NSMutableArray *productIds=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *merchantIds=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *quantitys=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *promotionIds=[NSMutableArray arrayWithCapacity:0];
    
    for (int i=0; i<[mAddtoCartAgainOrder.orderItemList count]; i++)
    {
        OrderItemVO *orderItemVO=[mAddtoCartAgainOrder.orderItemList objectAtIndex:i];
        [productIds addObject:orderItemVO.product.productId];
        [merchantIds addObject:orderItemVO.product.merchantId];
        [quantitys addObject:orderItemVO.buyQuantity];
        [promotionIds addObject:orderItemVO.product.realPromotionID];
    }
    
    [mDictionary setObject:productIds forKey:@"ProductIds"];
    [mDictionary setObject:merchantIds forKey:@"MerchantIds"];
    [mDictionary setObject:quantitys forKey:@"Quantitys"];
    [mDictionary setObject:promotionIds forKey:@"PromotionIds"];
    [self setUpThreadWithStatus:THREAD_STATUS_ADD_PRODUCTS_TO_CART showLoading:YES withObject:mDictionary finishSelector:@selector(addProductsToCartHandle:)];
    [mDictionary release];
}

#pragma mark - 重新购买
-(void) rebuyOrder{
    NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
    [mDictionary setObject:mAddtoCartAgainOrder.orderId forKey:@"OrderId"];
    [self setUpThreadWithStatus:THREAD_STATUS_REBUY_TO_CART showLoading:YES withObject:mDictionary finishSelector:@selector(addProductsToCartHandle:)];
    [mDictionary release];
}

-(void)addProductsToCartHandle:(NSArray *)array
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetSessionCart) toTarget:self withObject:nil];
}

#pragma mark - 获取购物车
-(void)newThreadGetSessionCart
{
    [self newThreadGetSessionCartWithObject:nil finishSelector:@selector(getSessionCartHandle:)];
}

-(void)getSessionCartHandle:(CartVO *)cartVO
{
    [[DataHandler sharedDataHandler] setCart:cartVO];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifyCartChange object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartCacheChange object:nil];
}

#pragma mark - Notification
//刷新收藏列表
-(void)FavouriteListRefresh:(NSNotification*)notification
{
    mfavouriteCurrentPage=1;
    [mloadingView setHidden:NO];
    [self performSelector:@selector(getMyFavoriteList) withObject:nil afterDelay:1];
}

//刷新收货地址
-(void)AddressListRefresh:(NSNotification*)notification
{
    [self performSelector:@selector(getGoodReceiver) withObject:nil afterDelay:1];
}

-(void)closeNewAddressView:(NSNotification*)notification
{
    [self moveToRightSide:[self.view viewWithTag:knewaddressview]];
}

- (void)moveToRightSide:(UIView *)view{
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(240, 768, 545, 533);
    }
                     completion:^(BOOL finished)
     {
         
         [[self _grayMaskView] removeFromSuperview];
         [view removeFromSuperview];
     }];
}

-(void)popNewAddressView:(NSNotification*)notification
{
    [self moveToRightSide:[self.view viewWithTag:knewaddressview]];
    [self AddressListRefresh:nil];
}

-(void)EditAddress:(NSNotification*)notification
{
    //    UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    //    [newview setBackgroundColor:[UIColor grayColor]];
    //    [newview setAlpha:0.5];
    //    [newview setTag:knewview];
    //    [self.view addSubview:newview];
    //    [newview release];
    
    [[self _grayMaskView] removeFromSuperview];
    [self.view addSubview:[self _grayMaskView]];
    
    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"NewAddressView" owner:self options:nil];
    NewAddressView *mnewAddressView = [nib objectAtIndex:0];
    [mnewAddressView setFrame:CGRectMake(240, 768, mnewAddressView.frame.size.width, mnewAddressView.frame.size.height)];
    [mnewAddressView setTag:knewaddressview];
    [mnewAddressView setIsnewAddress:NO];
    [mnewAddressView setIsFromeMyStore:YES];
    [mnewAddressView setMnewgoodreceive:((CustomAddressCell*)notification.object).mGoodReceiver];
    [mnewAddressView.mcloseButton setFrame:CGRectMake(34, 16, mnewAddressView.mcloseButton.frame.size.width, mnewAddressView.mcloseButton.frame.size.height)];
    [mnewAddressView showgoodreceive];
    [self.view addSubview:mnewAddressView];
    [self moveToLeftSide:mnewAddressView];
}

-(void)AddressEditSucceed:(NSNotification*)notification
{
    [self moveToRightSide:[self.view viewWithTag:knewaddressview]];
    [self performSelector:@selector(getGoodReceiver) withObject:nil afterDelay:1];
}

#pragma mark - UserAction
//1mall订单
-(IBAction)goto1Mall:(id)sender{
    [self changeselected:kMyStoreListMallOrder];
    [self removeProtocolWebView];
    NSData *b64TokenData=[GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *b64TokenStr=[[[NSString alloc] initWithData:b64TokenData encoding:NSUTF8StringEncoding] autorelease];
    

    NSString* urlStr=[NSString stringWithFormat:@"http://m.1mall.com/mw/grporderlist/1/%@/40/0/2/2",b64TokenStr];
    urlStr=[urlStr stringByAppendingFormat:@"?provinceId=%@",[GlobalValue getGlobalValueInstance].provinceId];
    if (order1MallWeb==nil) {
        order1MallWeb=[[WebViewController alloc] initWithFrame:CGRectMake(256, 133, 768, 615) WapType:0 URL:urlStr];
        [self.view addSubview:order1MallWeb.view];
    } else {
        order1MallWeb.m_UrlString=urlStr;
        order1MallWeb.isNeededShowUrl=YES;
        [order1MallWeb loadURL];
    }
    [mListView sendSubviewToBack:morderlistTableView];
    [self.view bringSubviewToFront:order1MallWeb.view];
    
}

//点击收货地址
-(IBAction)receiverList:(id)sender
{
    [self removeProtocolWebView];
    
    mloadingView.hidden=NO;
    [self changeselected:kMyStoreListMyAddress];
    [self getGoodReceiver];
}

//点击我的收藏
-(IBAction)favouriteList:(id)sender
{
    [self removeProtocolWebView];
    
//    JSTrackingPrama* prama = [[JSTrackingPrama alloc]initWithJSType:EJStracking_FavouriteList extraPrama:nil];
//    [DoTracking doJsTrackingWithParma:prama];
    
    mloadingView.hidden=NO;
    mfavouriteCurrentPage=1;
    [self changeselected:kMyStoreListMyFav];
    [self getMyFavoriteList];
}

-(IBAction)ticketAction:(id)sender
{
    LOG_THE_METHORD;
    [self removeProtocolWebView];
    
    [self changeselected:kMyStoreListMyTicket];
    [self.ticketListView btnSelected:self.ticketListView.btnUnused];
}

-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 2.3;"];
    //    NSString *jsCommand = [NSString stringWithFormat:@"document.body.clientWidth = 100;window.screen.availWidth = 100;window.screen.width = 100;alert('aaa');document.body.bgColor = 'yellow';"];
    //    [webView stringByEvaluatingJavaScriptFromString:jsCommand];
    //webView.frame = CGRectMake(310, 133, 693, 590);
}

//点击服务协议
-(IBAction)ServiceProtocol:(id)sender
{
    //    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"ServiceProtocolView" owner:self options:nil];
    //    mServiceView = [nib objectAtIndex:0];
    //    mServiceView.tag = 1002;
    //    mServiceView.frame = CGRectMake(CONTENT_OFFSET_X, 133, CONTENT_WIDTH, 600);
    //    [self.view addSubview:mServiceView];
    
    
    //CGRectMake(310, 133, 693, 590);
    [self removeProtocolWebView];
    UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(257, 133, 768, 600)] autorelease];
    webView.backgroundColor = [UIColor whiteColor];
    webView.tag = 1002;
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    
    [self.view addSubview:webView];
    //[self loadDocument:@"yhd_user_protocol_v2.html" inView:webView];
    
    // @"http://m.yihaodian.com/helpmore/10"
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.yihaodian.com/helpmore/10"]]];
    
    [self changeselected:kMyStoreListProtocol];
}

//点击退出登录
-(IBAction)logout:(id)sender
{
    UIAlertView * mAlert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    mAlert.tag=3;
    [mAlert show];
    [mAlert release];
}

//点击新建地址
-(IBAction)newaddressClicked:(id)sender
{
    if ([mreceiveListArray count]==10) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"您的收货地址不能超过10个" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else
    {
        //        UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        //        [newview setBackgroundColor:[UIColor grayColor]];
        //        [newview setAlpha:0.5];
        //        [newview setTag:knewview];
        //        [self.view addSubview:newview];
        //        [newview release];
        
        [[self _grayMaskView] removeFromSuperview];
        [self.view addSubview:[self _grayMaskView]];
        
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"NewAddressView" owner:self options:nil];
        NewAddressView *mnewAddressView = [nib objectAtIndex:0];
        [mnewAddressView setFrame:CGRectMake(240, 768, mnewAddressView.frame.size.width, mnewAddressView.frame.size.height)];
        [mnewAddressView setTag:knewaddressview];
        [mnewAddressView setIsnewAddress:YES];
        [mnewAddressView setIsNotLimited:YES];
        [mnewAddressView setIsFromeMyStore:YES];
        [mnewAddressView.mcloseButton setFrame:CGRectMake(34, 16, mnewAddressView.mcloseButton.frame.size.width, mnewAddressView.mcloseButton.frame.size.height)];
        [self.view addSubview:mnewAddressView];
        [self moveToLeftSide:mnewAddressView];
    }
}

- (void)moveToLeftSide:(UIView *)view{
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(240, 80, 545, 533);
    }
                     completion:^(BOOL finished)
     {
         
     }];
}

//点击用户反馈
-(IBAction)UserBackClicked:(id)sender
{
    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"UserBackView" owner:self options:nil];
    mUserBackView = [nib objectAtIndex:0];
    mUserBackView.tag = 1003;
    mUserBackView.frame = CGRectMake(256, 133, 768, 600);
    [self.view addSubview:mUserBackView];
    [self changeselected:kMyStoreListFeedback];
}

-(void)openOrderTrack:(NSNotification*)notification
{
    mloadingView.hidden=NO;
    OrderV2 *orderV2=[notification object];
    NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
    [mDictionary setObject:orderV2.orderId forKey:@"OrderId"];
    [self setUpThreadWithStatus:THREAD_STATUS_GET_ORDER_DETAIL showLoading:YES withObject:mDictionary finishSelector:@selector(enterOrderTrack:)];
    [mDictionary release];
}

-(void)enterOrderTrack:(OrderV2 *)orderV2
{
    CATransition *transition = [CATransition animation];
    transition.duration = OTSP_TRANS_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    OrderTrackViewController *myController = [[OrderTrackViewController alloc]initWithNibName:nil bundle:nil] ;
    myController.orderDetail=orderV2;
    
    [self.navigationController pushViewController:myController animated:NO];
    [myController release];
    mloadingView.hidden=YES;
}

-(UIView *)_grayMaskView
{
    static UIView *grayMaskView = nil;
    if (grayMaskView == nil)
    {
        grayMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [grayMaskView setBackgroundColor:[UIColor grayColor]];
        [grayMaskView setAlpha:0.6];
        [grayMaskView setTag:knewview];
    }
    
    return grayMaskView;
}

#pragma mark - change payment
-(void)changePaymentAction:(id)sender
{
    [[self _grayMaskView] removeFromSuperview];
    [self.view addSubview:[self _grayMaskView]];
    
    //[[self.view viewWithTag:knewview] removeFromSuperview];
    //    UIView * popBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    //    [self.view addSubview:popBgView];
    //    [popBgView release];
    //    [popBgView setBackgroundColor:[UIColor grayColor]];
    //    [popBgView setAlpha:0.6];
    //    [popBgView setTag:knewview];
    
    UIButton* theBtn = (UIButton*)sender;
    payChangeOrderIndex = theBtn.superview.tag;
    [self pushChangePaymentView];
}

-(void)pushChangePaymentView
{
    if (!isChangePaymentViewShowing)
    {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"PayInWebView" owner:self options:nil];
        self.temppayView = [nib objectAtIndex:0];
        temppayView.mBankArray = self.bankList;
        temppayView.tag = 102;
        [self.view addSubview:temppayView];
        [temppayView setFrame:CGRectMake(240, 768, 545, 533)];
        [self moveToLeftSide:temppayView];
        
        isChangePaymentViewShowing = YES;
    }
}


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
                [morderlistTableView reloadData];
                [self moveToRightSide:temppayView];
            }];
        }
        else {
            [self moveToRightSide:temppayView];
        }
        
        isChangePaymentViewShowing = NO;
    }
}


-(void)threadRequestSaveGateWay:(BankVO*)aBankVO
{
    BankVO *bankVO = [[aBankVO retain] autorelease];
    
    OrderV2 * order = [OTSUtility safeObjectAtIndex:payChangeOrderIndex inArray:self.theOrders];
    if (order)
    {
        //[self.loadingView showInView:self.view];
        
        if ([order isGroupBuyOrder])
        {
            // change group buy order bank
            //GroupBuyService* service = [[[GroupBuyService alloc] init] autorelease];
            
            int resultFlag = [[OTSServiceHelper sharedInstance] saveGateWayToGrouponOrder:[GlobalValue getGlobalValueInstance].token
                                                                                  orderId:order.orderId
                                                                                gatewayId:bankVO.gateway];
            if (resultFlag == 1)
            {
                DebugLog(@"gateway saved OK: %d, bankName:%@", [bankVO.gateway intValue], bankVO.bankname);
                order.gateway = bankVO.gateway;
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
                                                                                             orderId:order.orderId
                                                                                           gateWayId:bankVO.gateway];
            
            if (result && ![result isKindOfClass:[NSNull class]])
            {
                if ([result.resultCode intValue] == 1)
                {
                    DebugLog(@"gateway saved OK: %d, bankName:%@", [bankVO.gateway intValue], bankVO.bankname);
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberofrow;
    switch (tableView.tag) {
        case 1:
            numberofrow = self.theOrders.count;
            break;
        case 2:
        {
            numberofrow = [mfavouriteListArray count];
        }
            break;
        case 3:
        {
            numberofrow = [mreceiveListArray count];
        }   break;
        case 4:
        {
            numberofrow = 3;
        }
            break;
        default:
            break;
    }
    
    if (tableView == self.ticketListView.tableView)
    {
        numberofrow = self.tickets.count;
        //self.ticketListView.emptyView.hidden = (numberofrow > 0);
        if (numberofrow > 0)
        {
            [self.ticketListView.emptyView setHidden:YES];
            [self.ticketListView.emptyView.superview sendSubviewToBack:self.ticketListView.emptyView];
        }
        else
        {
            [self.ticketListView.emptyView setHidden:NO];
            [self.ticketListView.emptyView.superview bringSubviewToFront:self.ticketListView.emptyView];
        }
    }
    
    return numberofrow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 3)
    { // 地址
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        
        CustomAddressCell *cell = (CustomAddressCell*)[tableView dequeueReusableCellWithIdentifier:
                                                       SimpleTableIdentifier];
        if (cell == nil) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"AddressCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSLog(@"%i",[mreceiveListArray count]);
        if ([mreceiveListArray count]>0)
        {
            cell.mGoodReceiver = (GoodReceiverVO*)[mreceiveListArray objectAtIndex:indexPath.row];
            [cell showAddress];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [mListView bringSubviewToFront:mreceiverTableView];
        return cell;
    }
    else if(tableView.tag==2) // 收藏
    {
        static NSString *SimpleTableIdentifier = @"FavouriteTableIdentifier";
        
        CustomFavouriteCell *cell = (CustomFavouriteCell*)[tableView dequeueReusableCellWithIdentifier:
                                                           SimpleTableIdentifier];
        if (cell == nil) {
            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"CutomFavouriteCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.delegate = self;
        if ([mfavouriteListArray count]>0)
        {
            cell.mFavourite = (FavoriteVO*)[mfavouriteListArray objectAtIndex:indexPath.row];
        }
        [cell initview];
        [mListView bringSubviewToFront:mfavouriteTableView];
        return cell;
    }
    else if(tableView.tag==1)//我的订单
    {
        //static NSString *SimpleTableIdentifier=@"OrderTableIdentifier";
        
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomOrderCell" owner:self options:nil];
        CustomOrderCell *cell=[nib objectAtIndex:0];
        [cell setDelegate:self];
        
        OrderV2 *orderV2 = [OTSUtility safeObjectAtIndex:indexPath.row inArray:_theOrders];
        [cell reloadCellWithOrder:orderV2];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        // add change pay button
        for (UIView *view in cell.subviews)
        {
            if (view.tag == 22222)
            {
                [view removeFromSuperview];
            }
        }
        
        if (mcurrentOrderType == ORDER_TYPE_PROCESSING && [orderV2 needToPayedOnline])
        {
            cell.payButton.hidden = YES;
            
            CGRect topBtnRc = cell.payButton.frame;
            
            self.changePayBtn = [[[OTSChangePayButton alloc] initWithLongButton:NO] autorelease];
            _changePayBtn.frame = CGRectMake( topBtnRc.origin.x - 120
                                             , topBtnRc.origin.y
                                             , _changePayBtn.frame.size.width
                                             , _changePayBtn.frame.size.height);
            
            //CGRect changePayBtnRc = _changePayBtn.frame;
            [cell addSubview:_changePayBtn];
            _changePayBtn.tag = 22222;
            
            [self.changePayBtn.payButton addTarget:self action:@selector(gotoPayAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.changePayBtn.changePayButton addTarget:self action:@selector(changePaymentAction:) forControlEvents:UIControlEventTouchUpInside];
            self.changePayBtn.tag = indexPath.row;
            
            _changePayBtn.payButton.enabled = _changePayBtn.changePayButton.enabled = YES;
            
            NSString* bankStr = nil;
            
            for (BankVO* bank in self.bankList)
            {
                if ([bank.gateway intValue] == [orderV2.gateway intValue])
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
        }
        
        
        return cell;
    }
    else if (tableView.tag==4) // 订单类型
    {
        static NSString *SimpleTableIdentifier = @"OrderTypeTableIdentifier";
        OrderTypeCell * cell = (OrderTypeCell*)[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell ==nil) {
            cell = [OrderTypeCell viewFromNibWithOwner:self];
            //            NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"OrderTypeCell" owner:self options:nil];
            //            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.myTextLabel.text = [mOrderTypeArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    else if (tableView == self.ticketListView.tableView)
    {
        OTSPadTicketListCell *cell = [OTSPadTicketListCell viewFromNibWithOwner:self];
        
        CouponVO *couponVO = [self.tickets objectAtIndex:indexPath.row];
        [cell updateWithCouponVO:couponVO];
        
        return cell;
    }
    
    return nil;
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    switch (tableView.tag) {
        case 4:
            height=42;
            break;
        case 3:
            height = 117;
            break;
        case 2:
            height = 217;
            break;
        case 1:
            height = 250;
            break;
        default:
            height =100;
            break;
    }
    
    if (tableView == self.ticketListView.tableView)
    {
        return 153;
    }
    
    return height;
}

-(void)removeProtocolWebView
{
    UIView *view = nil;
    while ((view = [self.view viewWithTag:1002]))
    {
        [view removeFromSuperview];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeProtocolWebView];
    
    if (tableView.tag == 4)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                mcurrentOrderType = ORDER_TYPE_PROCESSING;  // 处理中
            }
                break;
            case 1:
                mcurrentOrderType = ORDER_TYPE_COMPLETED; // 完成
                break;
            case 2:
                mcurrentOrderType = ORDER_TYPE_CANCELLED; // cancel
                break;
            case 3:
                mcurrentOrderType = 5;
                break;
            default:
                break;
        }
        mloadingView.hidden = NO;
        //morderCurrentPage=1;
        self.orderPage = nil;
        [self getMyOrderList];
        [mListView bringSubviewToFront:morderlistTableView];
        NSLog(@"%i",indexPath.row);
        [self changeselected:kMyStoreListMyOrder];
    }
    
    if (tableView == self.ticketListView.tableView)
    {
        
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([tableView tag]) {
        case 1: {//我的订单
            if (indexPath.row== _theOrders.count - 1 && m_OrderTotalCount> _theOrders.count) {
                if (!mIsLoading) {
                    [tableView loadingMoreWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40) target:self selector:@selector(getMyOrderList) type:UITableViewLoadingMoreForeIpad];
                    mIsLoading = YES;
                }
            }
            break;
        }
        case 2: {//我的收藏
            if (indexPath.row==[mfavouriteListArray count]-1 && m_FavoriteTotalCount>[mfavouriteListArray count]) {
                if (!mIsLoading) {
                    [tableView loadingMoreWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40) target:self selector:@selector(getMyFavoriteList) type:UITableViewLoadingMoreForeIpad];
                    mIsLoading = YES;
                }
            }
            break;
        }
        default:
            break;
    }
    
    if (tableView == self.ticketListView.tableView)
    {
        
    }
}


-(void)gotoPayAction:(id)sender
{
    UIButton* theBtn = (UIButton*)sender;
    payChangeOrderIndex = theBtn.superview.tag;
    OrderV2* order = [OTSUtility safeObjectAtIndex:payChangeOrderIndex inArray:self.theOrders];
    _currentCheckOrderID = [[order orderId] copy];
    [self payclicked:order];
}



#pragma mark - CustomOrderCellDelegate
-(void)productViewClicked:(OrderV2*)order{
    ProductListViewController *myController =
    [[ProductListViewController alloc]initWithNibName:nil bundle:nil] ;
    myController.productListType=ListType_orderProducts;
    NSMutableArray* arr = [NSMutableArray array];
    for (OrderItemVO* orderITVO in order.orderItemList) {
        if (orderITVO.product) {
            [arr addObject:orderITVO.product];
        }
    }
    [myController setProductListData:arr];
    
    [self.navigationController pushViewController:myController animated:NO];
    [myController release];
}
-(void)payclicked:(OrderV2 *)order
{
    [self performInThreadBlock:^(){
        //-----------------获取支付网关的Dictionary----------------------
        NSString* rootPath = [[NSBundle mainBundle]resourcePath];
        NSString* path = [rootPath stringByAppendingPathComponent:@"gateway.plist"];
        NSDictionary *gateWay=[NSDictionary dictionaryWithContentsOfFile:path];
        _mallCup = [[gateWay objectForKey:@"1MALLCUP"] intValue];
        _storeCup = [[gateWay objectForKey:@"1STORECUP"] intValue];
        _storeAlix = [[gateWay objectForKey:@"1STOREALIX"] intValue];
    } completionInMainBlock:^(){
        if ([order.gateway isEqualToNumber:[NSNumber numberWithInt:_mallCup]]||[order.gateway isEqualToNumber:[NSNumber numberWithInt:_storeCup]]) {
            [self popTheUnionpayView:self.navigationController onlineOrderId:order.orderId];
        }
        else if([order.gateway isEqualToNumber:[NSNumber numberWithInt:_storeAlix]])
        {
            //检查是否安装了支付宝客户端
            if (![self checkalixpayClient]){
                [self showNoAlixsafepayment];
            }
            else {
                [self popTheAlixpayView:order.orderId];
            }
        }
        else
        {
            OnlinePayViewController *temppay=[[OnlinePayViewController alloc] init];
            [temppay setMOrderId:order.orderId];
            [temppay setMGateWayId:order.gateway];
            [self.navigationController pushViewController:temppay animated:YES];
            [temppay release];
        }
    }];
}

// 弹出银联插件
-(void)popTheUnionpayView:(UINavigationController*)aNavigate onlineOrderId:(NSNumber*)onlineOrderId
{
    NSString *packets= nil;     //服务器取回的银联报文
    
    packets = [OTSUtility requestSignature:onlineOrderId];
    
    UnionpayViewCtrl = [LTInterface getHomeViewControllerWithType:1 strOrder:packets andDelegate:self];
    
    [aNavigate pushViewController:UnionpayViewCtrl animated:YES];
}

// 弹出支付宝安全支付
-(void)popTheAlixpayView:(NSNumber *)aOnlineorderid
{
    NSString *appScheme = @"yhdhd";
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (aOnlineorderid != nil) {
        orderString = [OTSUtility requestAliPaySignature:aOnlineorderid];
        //全局记录状态
        [[GlobalValue getGlobalValueInstance] setAlixpayOrderId:[NSNumber numberWithLongLong:[aOnlineorderid longLongValue]]];
        
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        [alixpay pay:orderString applicationScheme:appScheme];
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


-(void)showNoAlixsafepayment
{
    UIAlertView * mAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未安装支付宝客户端，或版本过低。请下载或更新支付宝客户端（耗时较长）。" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"取消", nil];
    mAlert.tag=5;
    [mAlert show];
    [mAlert release];
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
        [[NSNotificationCenter defaultCenter]postNotificationName:@"needUpdateMyStoreforCheckOrderStatusHD" object:self userInfo:nil];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UnionpayViewCtrl release];
        UnionpayViewCtrl = nil;
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
        
        _needUpdateMyStore = YES;
        [self updateMyStore];
        [UnionpayViewCtrl release];
        UnionpayViewCtrl = nil;
    });
     */
}

//检查状态并回调
-(void)checkOrderStatusHD2:(void(^)(void))callback
{
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    OrderV2 * v2 =nil;
    int  timeout = 0;
    if (_currentCheckOrderID) {
        do {
            
            v2 = [service getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:_currentCheckOrderID];
            [NSThread sleepForTimeInterval:0.2];
            timeout++;
            
        } while ([v2.orderStatus intValue] == 3 && timeout<40);
    
        callback();
    }
}

-(void)checkOrderStatusHD:(NSDictionary *)object
{
    
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    
    OrderV2 * v2 =nil;
    
    int timeout = 0;
    if (_currentCheckOrderID) {
        do {
            v2 = [service getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:_currentCheckOrderID];
            [NSThread sleepForTimeInterval:0.2];
            timeout++;
        } while (![v2.orderStatus isEqualToNumber:[NSNumber numberWithInt:4]]&&timeout<20);
    }
    
    backreflushdone = YES;
}


-(void)addtoCart:(OrderV2 *)order
{
    if (mAddtoCartAgainOrder!=nil) {
        [mAddtoCartAgainOrder release];
    }
    mAddtoCartAgainOrder=[order retain];
    UIAlertView *mAlert=[[UIAlertView alloc]initWithTitle:@"购买确认" message:@"是否要再次购买该订单中的商品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    mAlert.tag=4;
    [mAlert show];
    [mAlert release];
}

#pragma mark - CustomAddressCell
-(void)deleteAddressByAddressId:(NSNumber *)deleteAddressId
{
    if (mDeleteAddressId!=nil) {
        [mDeleteAddressId release];
    }
    mDeleteAddressId=[deleteAddressId retain];
    UIAlertView * mAlert = [[UIAlertView alloc]initWithTitle:@"删除确认" message:@"是否要删除该地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    mAlert.tag=2;
    [mAlert show];
    [mAlert release];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1://addtocart from custom order
            if (buttonIndex==1) {
                [self addProductsToCart];
            }
            break;
        case 2://deleteaddress from custom address
            if (buttonIndex==1) {
                [self otsDetatchMemorySafeNewThreadSelector:@selector(DeleteAddress) toTarget:self withObject:mDeleteAddressId];
            }
            break;
        case 3: //logout clear local cart
            if (buttonIndex==1) {
                [[DataHandler sharedDataHandler] resetCart];
                //clear local cart end
                NSString * UserInforPath=[dataHandler dataFilePath:kUserFilename];
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]initWithContentsOfFile:UserInforPath];
                [dict setObject:@"0" forKey:@"IsLogIn"];
                [dict writeToFile:UserInforPath atomically:YES];
                [dict release];
                [self newThreadLogout];
            }
            
            break;
        case 4://rebuy order
            if (buttonIndex==1) {
                [self rebuyOrder];
            }
            break;
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

-(void)DeleteAddress
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    int result = [service deleteGoodReceiverByToken:[GlobalValue getGlobalValueInstance].token goodReceiverId:mDeleteAddressId];
    if (result ==1)
    {
        [self performSelectorOnMainThread:@selector(DeleteAddressAfter) withObject:nil waitUntilDone:YES];
    }
    [pool drain];
}
-(void)DeleteAddressAfter
{
    [self performSelector:@selector(getGoodReceiver) withObject:nil afterDelay:1];
}
#pragma mark - EmptyListDelegate
-(void)NewAddress
{
    [self newaddressClicked:nil];
}
#pragma mark - CustomFavouriteCellDelegate
-(void)addtocart:(FavoriteVO *)favourite
{
    [mTopView setCartCount:dataHandler.cart.totalquantity.intValue];
    
    [dataHandler addProductToCart:favourite.product buyCount:1];
}

-(void)releaseMyResource
{
    if (labelsArray!=nil) {
        [labelsArray release];
        labelsArray=nil;
    }
    if (buttonBgArray!=nil) {
        [buttonBgArray release];
        buttonBgArray=nil;
    }
    if (arrowsArray!=nil) {
        [arrowsArray release];
        arrowsArray=nil;
    }
    if (mreceiveListArray!=nil) {
        [mreceiveListArray release];
        mreceiveListArray=nil;
    }
    if (mfavouriteListArray!=nil) {
        [mfavouriteListArray release];
        mfavouriteListArray=nil;
    }
    
    if (mOrderTypeArray!=nil) {
        [mOrderTypeArray release];
        mOrderTypeArray=nil;
    }
    if (mTopView!=nil) {
        [mTopView release];
        mTopView=nil;
    }
    if (mDeleteAddressId!=nil) {
        [mDeleteAddressId release];
        mDeleteAddressId=nil;
    }
    if (mAddtoCartAgainOrder!=nil) {
        [mAddtoCartAgainOrder release];
        mAddtoCartAgainOrder=nil;
    }
    if (mServiceView!=nil) {
        mServiceView=nil;
    }
    if (mUserBackView!=nil) {
        mUserBackView=nil;
    }
    if (_currentCheckOrderID!=nil) {
        [_currentCheckOrderID release];
        _currentCheckOrderID = nil;
    }
    [_theOrders release];
    
    [_bankList release];
    OTS_SAFE_RELEASE(_changePayBtn);
}

- (void)viewDidUnload
{
    [self releaseMyResource];
    [self setListTicketLabel:nil];
    [self setListTicketBtn:nil];
    [self setListTicketArrowIV:nil];
    [self setListTicketBgIV:nil];
    [self setTicketListView:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self releaseMyResource];
    
    [_listTicketLabel release];
    [_listTicketBtn release];
    [_listTicketArrowIV release];
    [_listTicketBgIV release];
    [_ticketListView release];
    [_tickets release];
    [_ticketPage release];
    [_orderPage release];
    [temppayView release];
    
    [super dealloc];
}

#pragma mark -
-(void)ticketTabSelected:(OTSTicketTabType)aSelectedType
{
    if (aSelectedType != self.ticketType)
    {
        [self.tickets removeAllObjects];
        self.ticketPage = nil;
        
        self.ticketType = aSelectedType;
        [self requestTicket:self.ticketType];
    }
}

-(void)requestTicket:(OTSTicketTabType)aSelectedType
{
    mloadingView.hidden = NO;
    
    [self performInThreadBlock:^{
        
        int requestTicketPage = self.ticketPage.currentPage ? [self.ticketPage.currentPage intValue] : 0;
        requestTicketPage++;
        
        Page *resultPage = [[OTSServiceHelper sharedInstance]
                            getMyCouponList:[GlobalValue getGlobalValueInstance].token
                            type:self.ticketType
                            currentPage:[NSNumber numberWithInt:requestTicketPage]
                            pageSize:[NSNumber numberWithInt:100]];
        
        self.ticketPage = resultPage;
        
        NSLog(@"%@", self.ticketPage.objList);
        
    } completionInMainBlock:^{
        
        Page *resultPage = self.ticketPage;
        if (resultPage && resultPage.objList.count > 0)
        {
            [self.tickets addObjectsFromArray:resultPage.objList];
            
            if (aSelectedType == kTicketTabUsed)
            {
                for (CouponVO *vo in self.tickets)
                {
                    vo.isUsed = YES;
                }
            }
        }
        [self.ticketListView.tableView reloadData];
        
        mloadingView.hidden = YES;
    }];
}

@end