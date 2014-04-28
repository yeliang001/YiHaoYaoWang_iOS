//
//  CheckOrderViewController.h
//  CheckOrder
//
//  Created by yangxd on 11-02-15.
//  Updated by yangxd on 11-03-11  完善界面
//  Updated by yangxd on 11-07-20  添加在线支付功能
//  Copyright 2011 vsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWConst.h"
@class InvoiceVO;
@class OrderVO;
@class OrderItemVO;
@class OrderService;
@class Page;
@class CouponVO;
@class UserManage;
@class GoodReceiver;
@class CouponService;
@class MyOrder;
@class ShareToMicroBlog;
@class LocationVO;
@class OnlinePay;
@class ASIHTTPRequest;
@class Invoice;
@class EditGoodsReceiver;
@class AccountBalance;
@class OTSSecurityValidationVC;
@class NeedCheckResult;

@class OrderInfo;
@class InvoiceInfo;
@class OrderResultInfo;
@class CartInfo;

@protocol CheckOrderDelegate <NSObject>
-(void)checkOrderToOrderDone:(NSNumber *) OrderId;
@end

@interface CheckOrder : OTSBaseViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate,UIPickerViewDelegate> 
{
 @public
    IBOutlet UIScrollView *m_ScrollView;    //
    
 @private
    UITableView *m_ReceiverTableView;       // 收货人信息tv
    UITableView *m_ProductTableView;        // 商品信息tv
    UITableView *m_PaymentTableView;        // 支付信息tv
    UITableView *m_MoneyTableView;          // 金额信息tv
    UITableView *invoiceTV;                 // 发票tv
    
    
    UIButton *m_SubmitBtn;                  // 提交订单按钮
    UILabel *m_PaymentWayLbl;               // 选择付款方式label
    UILabel *m_PaymentWayDetailLbl;         // 付款方式 detail label
    UILabel *m_InvoiceLabel;                // 发票label
    UILabel *m_NeedAccountPayLabel;         // 余额支付label
    UILabel *m_AccountPayLabel;             // 账户余额抵扣label
    UILabel *m_GiftCardPayLabel;            // 礼品卡余额抵扣(金额统计处)
    UILabel *m_cardPayLabel;                // 礼品卡余额使用
    UILabel *m_FullDiscoun;                 // 促销活动立减
    UILabel *m_UseCouponLabel;              // 抵用卷余额抵扣label 
    UILabel *m_NeedPayMoneyLabel;           // 还需支付label
    
    OrderVO *m_CheckOrderVO;
    InvoiceVO *editInvoiceVO;  
    CouponVO *m_Mycoupon;//当前订单使用的抵用卷
    OrderService *m_OrderService;
    
    //yao wang
    OrderInfo *checkOrder;
    
	NSNumber* titleStyle;
    
    NSString * m_PayMethodStr;
    NSArray *m_PaymentMethods;
    NSArray *m_UserSelectedGiftArray;       //  传入参数，用户已选赠品，包含NSMutableDictionary
    
    BOOL m_ThreadRunning;
    int m_ThreadState;
    
    int methodID;         //付款方式  0货到付款 1支付宝 2 pos刷卡 －－－ YaoWang
    int paymentType;
	int gatewayType;                        //  网上支付方式的唯一标识
	int selectedIndex;
    int fromTag;                            //saveGoodReceiverToOrder 1 or saveCouponToOrder 2
//	BOOL isStop;
	BOOL isBankNull;
	BOOL isNeedInvoice;
    
    BOOL m_HasAddress;                      //  传入参数，是否有收获地址
    BOOL m_NowHasAddress;
    //BOOL m_ShowAllProduct;
    BOOL m_AddressNotSupport;
    
    
    double m_AccountPayMoney;               //  余额支付的金额
    double m_BalanceMoney;                  //  用户账户余额
    double m_FrozenMoney;                   //  账户冻结金额
    double m_UseCouponMoney;                //  抵用卷金额
    
    double m_GiftCardPayMoney;              //  礼品卡支付的金额
    double m_GiftCardBalance;               //  礼品卡余额
    double m_FrozenGiftCardBalance;         //  冻结礼品卡余额
    int numberOfGiftCard;                   //  礼品卡数量
    
    id<CheckOrderDelegate> m_delegate;      //  代理
    CGFloat currentProTabY;
    
    NSMutableArray * distributionArray; //保存不能配送的商品（只读）
    NSString * distributionError; //不能配送的商品时的提示信息
    
    
    //YaoWang
    //这个数组长度跟订单包裹数量一样，
    //每个元素对应每一个包裹，元素类型是BOOL,
    //YES表示这个包裹已经展开显示，否则表示未展开
    NSMutableArray *_packageIsExpandingArr;
    InvoiceInfo *_invoiceInfo; //保存发票信息
    
    OrderResultInfo * _checkedOrderResult;//检查订单之后返回的错误码
    
    

}

@property (nonatomic)BOOL isBankNull;
@property BOOL m_HasAddress;//传入参数，是否有收获地址
@property(nonatomic,retain) NSArray *m_UserSelectedGiftArray;//传入参数，用户已选赠品，包含NSMutableDictionary
@property(nonatomic, assign) id<CheckOrderDelegate> m_delegate;
@property(nonatomic, retain) CouponVO *m_Mycoupon;
@property(nonatomic, retain) Invoice *m_Invoice;
@property(nonatomic, copy)NSString * m_PayMethodStr;
@property(nonatomic, retain) NSMutableArray * distributionArray; //保存不能配送的商品（只读）
@property(nonatomic, retain) NSString * distributionError; //不能配送的商品时的提示信息
@property(nonatomic, retain) UITableView *m_MoneyTableView;          // 金额信息tv
@property(nonatomic, retain) UITableView *m_ProductTableView;        // 商品信息tv

//药店
@property(nonatomic, retain) NSMutableArray *orderProducts;//购物车中的商品 字典格式: product->selectCount
@property(nonatomic, retain) NSString *addressId; //订单的地址id
@property(assign, nonatomic) kYaoPaymentType paymentType;//骚年，这个是用来记录当前选择的付款方式，然后下单成功之后传到成功页面，因为传给成功页面的orderInfo中没有这些支付方式的信息，fuck。。。。。。。。。。。。。。。。。。
@property(retain, nonatomic) NSMutableArray *selectedGiftList;//在购物车中选中的赠品列表
@property(retain, nonatomic) CartInfo *cartInfo; //把购物车中得信息直接穿过来使用




-(IBAction)backBtnClicked:(id)sender;           // 退回到superView
-(IBAction)submitOrderBtnClicked:(id)sender;    // 提交订单
-(void)initCheckOrder;
#pragma mark 显示提交订单提示框
-(void)showSubmitOrderAlertView:(NSString *)result;
#pragma mark 显示提示框
-(void)showAlertView:(NSString *) alertTitle alertMsg:(NSString *)alertMsg alertTag:(int)tag;
#pragma mark 进入在线支付页面
-(void)enterOnlinePayWithOrderId:(NSNumber *)orderId;
#pragma mark 开启线程
-(void)setUpThread:(BOOL)showLoading;
#pragma mark 停止线程
-(void)stopThread;
-(void)enterGoodsReceiverList;
-(void)enterEditGoodsReceiver;
-(void)enterEditGoodsReceiverFromCart;
#pragma mark 过滤赠品
-(OrderVO*) filterGifts:(OrderVO *) ordervo;
-(void)showUseCouponMoney:(id)aObj;

@end
