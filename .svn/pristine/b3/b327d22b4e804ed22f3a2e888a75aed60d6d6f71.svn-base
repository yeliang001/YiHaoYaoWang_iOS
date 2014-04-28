//
//  MyListViewController.h
//  yhd
//
//  Created by dev dev on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomOrderCell.h"
#import "CustomAddressCell.h"
#import "CustomFavouriteCell.h"
#import "MyListEmptyView.h"
#import "ServiceProtocolView.h"
#import "UserBackView.h"
#import "LTInterface.h"
#import "WebViewController.h"
#import "UserManageTool.h"
#import "OTSPadTicketListView.h"

@class TopView;
@class NewAddressView;
@class PayInWebView;


typedef enum
{
    kMyStoreListMyOrder = 0     // 我的订单
    , kMyStoreListMyFav         // 我的收藏
    , kMyStoreListMyAddress     // 收货地址
    , kMyStoreListFeedback      // 用户反馈
    , kMyStoreListProtocol      // 服务协议
    , kMyStoreListMallOrder     // 1mall商城订单
    , kMyStoreListMyTicket      // 我的抵用券
}OTSMyStoreListType;



@interface MyListViewController : BaseViewController
< UITableViewDataSource
, UITableViewDelegate
, UIPickerViewDelegate
, UIPickerViewDataSource
, CustomOrderCellDelegate
, CustomAddressDelegate
, UIAlertViewDelegate
, MyListEmptyDelegate
, CustomFavouriteDelegate
, UIWebViewDelegate
, LTInterfaceDelegate
, OTSPadTicketListViewDelegate>
{
    NSArray * mreceiveListArray;
    NSMutableArray * mfavouriteListArray;
    //NSMutableArray * theOrders;
    NSArray * mOrderTypeArray;
    int mcurrentOrderType;
    //int morderCurrentPage;
    int m_OrderTotalCount;
    int mfavouriteCurrentPage;
    int m_FavoriteTotalCount;
    IBOutlet UILabel * mcurrentUserLabel;
    IBOutlet UITableView *mreceiverTableView;
    IBOutlet UITableView *mfavouriteTableView;
    IBOutlet UITableView *mordertypeTableView;
    IBOutlet UITableView *morderlistTableView;
    
    IBOutlet UIButton * mfavouriteButton;
    IBOutlet UIButton * maddressButton;
    BOOL mShowOrder;
    BOOL mIsLoading;
    
    IBOutlet UIImageView * mFavouriteImageView;
    IBOutlet UIImageView * mFavouriteArrowImageView;
    IBOutlet UILabel * mFavouriteLabel;
    
    IBOutlet UIImageView * mReceiverImageView;
    IBOutlet UIImageView * mReceiverArrowImageView;
    IBOutlet UILabel * mReceiverLabel;
    
    IBOutlet UIImageView * mUserBackImageView;
    IBOutlet UIImageView * mUserBackArrowImageView;
    IBOutlet UILabel * mUserBackLabel;
    
    IBOutlet UIImageView * mServiceProtocolImageView;
    IBOutlet UIImageView * mServiceProtocolArrowImageView;
    IBOutlet UILabel * mServiceProtocolLabel;
    
    IBOutlet UIImageView *m1mallImageview;
    IBOutlet UIImageView *m1mallArrowImageview;
    IBOutlet UILabel *m1mallLabel;
    
    IBOutlet UIView * mListView;
    NSMutableArray* labelsArray;
    NSMutableArray* buttonBgArray;
    NSMutableArray* arrowsArray;
    TopView * mTopView;
    
    int mIsRefreshFavourite;
    
    NSNumber * mDeleteAddressId;
    OrderV2 * mAddtoCartAgainOrder;
    
    BOOL mIsLoadingFavourite;//传入参数
    
    ServiceProtocolView* mServiceView;
    UserBackView * mUserBackView;
    WebViewController*order1MallWeb;
    IBOutlet UIView * mloadingView;
    IBOutlet UIActivityIndicatorView * mIndicator;
    int loadingtime;
    
    UIViewController *UnionpayViewCtrl;// 银联的内嵌容器
    int     _mallCup;
    int     _storeCup;
    int     _storeAlix; //一号店 支付宝安全支付网关
    bool    backreflushdone;
    NSNumber *_currentCheckOrderID;
    
    //支付方式弹出页面
    PayInWebView         *temppayView;
}
@property (retain, nonatomic) IBOutlet UILabel *listTicketLabel;
@property (retain, nonatomic) IBOutlet UIButton *listTicketBtn;
@property (retain, nonatomic) IBOutlet UIImageView *listTicketArrowIV;
@property (retain, nonatomic) IBOutlet UIImageView *listTicketBgIV;
@property (retain, nonatomic) IBOutlet OTSPadTicketListView *ticketListView;

@property(nonatomic,assign)BOOL mIsLoadingFavourite;//传入参数
@property(nonatomic,assign)NSNumber *_currentCheckOrderID;//检查当前操作的orderID
@property (retain,nonatomic)  PayInWebView            *temppayView;;

-(IBAction)receiverList:(id)sender;   // 收货地址
-(IBAction)favouriteList:(id)sender;
-(IBAction)ticketAction:(id)sender;
-(IBAction)logout:(id)sender;
-(IBAction)newaddressClicked:(id)sender;
-(IBAction)UserBackClicked:(id)sender;
-(IBAction)ServiceProtocol:(id)sender;      // 服务协议


//temp
-(void)getprovince;
-(void)getcity:(NSNumber*)provinceid;
-(void)getcounty:(NSNumber *)cityid;
-(void)changeselected:(NSInteger)type;
-(void)PushDownUIPickerView;
-(void)moveToLeftSide:(UIView *)view;
-(void)moveToRightSide:(UIView *)view;
-(void)initMyStore;
-(void)getMyOrderList;
-(void)getMyFavoriteList;
// 交易插件退出回调方法，需要商户客户端实现 strResult：交易结果，若为空则用户未进行交易。
- (void) returnWithResult:(NSString *)strResult;
// 弹出银联插件
-(void)popTheUnionpayView:(UINavigationController*)aNavigate onlineOrderId:(NSNumber*)onlineOrderId;
// 弹出支付宝安全支付
-(void)popTheAlixpayView:(NSNumber *)aOnlineorderid;
@end
