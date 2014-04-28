//
//  OnlinePay.h
//  TheStoreApp
//
//  Created by yangxd on 11-8-3.
//  Copyright 2011 vsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderService.h"
#import "PayService.h"
#import "CartService.h"
#import "LTInterface.h"
#import "OrderService.h"
#import "MethodBody.h"
#import "OrderDetail.h"
#import "OTSGlobalNavigationController.h"
#import "OTSServiceHelper.h"
#import "WEPopoverController.h"
#import "PaymentMethodVO.h"
#import "OTSOrderSubmitOKVC.h"

@class ASIHTTPRequest;
@class MyOrder;
@class BankVO;
@class GroupBuyService;


@class OrderInfo; //从检查订单中传入， 这是检查订单中的订单

@protocol UnionPayDelegate <NSObject>
-(void)unionPaytoOrderDetail:(NSNumber *)onlineOrderId;
-(void)unionPaytoGroupBuyOrderDetail:(NSNumber *)onlineOrderId isFromMall:(BOOL) isfrommall;
-(void)unionPaytoOrderList;
-(void)unionPaytoOrderDone:(NSNumber *)onlineOrderId;
@end

@interface OnlinePay : OTSBaseViewController 
<UITableViewDataSource
, UITableViewDelegate
, WEPopoverControllerDelegate
, UIWebViewDelegate
, UINavigationControllerDelegate
#if !TARGET_IPHONE_SIMULATOR
,LTInterfaceDelegate
#endif
>
{
	
	IBOutlet UIView * onlinePayView;//
	UIButton * payBtn;
	UITableView * bankTableView;
    UITableView * payMentTableView;
	UIWebView * onlineWebView;
	UILabel * loadingMsgLabel;
	NSMutableDictionary * cachedImage;
	NSOperationQueue * queue;
	
	//NSArray * bankArray;
	NSIndexPath * lastIndexPath;
	NSNumber * selectedGatewayid;
	NSNumber * gatewayId;//传入参数，网上支付方式的唯一标识
	NSNumber * onlineOrderId;
	NSNumber * orderId;//传入参数
    NSArray * payMentWayArr; // 传入参数，付款方式, 仅在普通商品检查订单页面传值
    NSString * payMethodStr; // 传入参数，付款方式名称
    NSMutableArray * payMentWayExceptOnlinePayArr;
   
	
	BOOL isSelectedBank;
	BOOL isStop;
	BOOL running;
	BOOL isFromOrder;//传入参数
    BOOL isFromMyOrder;//传入参数
    BOOL isSubmitOrder;//传入参数
    BOOL isFromGroupon;//传入参数
    BOOL isFromMyGroupon;//传入参数
	BOOL isFromOrderDetail;//传入参数
    BOOL isFromCheckOrder;//传入参数
    BOOL isFromOrderSuccess;//传入参数
    BOOL isFromWap;
    BOOL isUseOnlinePay; // 是否采用网上支付，仅在从普通商品检查订单页面过来时使用
	int currentState;
	int methodID;
	int gatewayType;
	int selectedIndex;
	
	MyOrder * myOrderView;
    BankVO *m_BankVO;
    OrderService * m_OrderServ;
    PayService * m_PayServ;
    CartService * m_CartServ;
    GroupBuyService * m_GroupBuyServ;
    id<UnionPayDelegate> m_delegate;
    WEPopoverController * m_PopOverController;    // 弹出窗控制器
    PaymentMethodVO* payMentWayOnlineVO;   // 网上支付的VO,仅在从普通商品检查订单页面过来时使用
    PaymentMethodVO* m_payWayVO;             // 非网上支付，选中的payway的VO
       
    //ASIHTTPRequest *picRequest;
    NSMutableArray* picRequests;
    UIImageView* checkMarkView;
    bool done;
    NSString *packets;     //服务器取回的银联报文
    bool _orderdone;        //订单完成标记
}
@property(nonatomic)BOOL isFromOrder;
@property(nonatomic)BOOL isFromMyOrder;//传入参数
@property(nonatomic)BOOL isSubmitOrder;
@property(nonatomic)BOOL isFromGroupon;
@property(nonatomic)BOOL isFromMyGroupon;//传入参数
@property(nonatomic)BOOL isFromOrderDetail;
@property(nonatomic)BOOL isFromWap;
@property(nonatomic)BOOL isFromCheckOrder;
@property(nonatomic)BOOL isFromOrderSuccess;
@property(nonatomic, retain) NSNumber     *orderId;
@property(nonatomic, retain) NSNumber     *gatewayId;
@property(nonatomic, retain) NSIndexPath  *lastIndexPath;
@property(nonatomic, retain) NSArray* payMentWayArr;
@property(nonatomic, retain) NSString* payMethodStr;
@property(nonatomic)int methodID;
@property(nonatomic, assign) id<UnionPayDelegate> m_delegate;
@property(nonatomic, retain)WEPopoverController * m_PopOverController;      // 弹出窗控制器

@property(nonatomic)BOOL                    onlyUsedForBankChosen;  // 仅用于选择银行
@property(nonatomic, assign)id              chooseBankCaller;       // 选择银行的调用者
@property(retain) NSArray * bankArray;

//Yaowang
//从检查订单中传入， 这是检查订单中的订单
@property(retain, nonatomic) OrderInfo *checkingOrder; 


-(void)chooseBankCaller:(id)aCaller;    // 选择银行


@end
