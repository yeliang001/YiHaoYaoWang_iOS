//
//  GroupBuyCheckOrder.h
//  TheStoreApp
//
//  Created by jiming huang on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GrouponOrderVO.h"
#import "GrouponOrderSubmitResult.h"
#import "BankVO.h"
#import "GroupBuyService.h"
#import "OnlinePay.h"
#import "AccountBalance.h"
#import "OTSGlobalNavigationController.h"

@interface GroupBuyCheckOrder : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate> {
    IBOutlet UIScrollView *m_ScrollView;//
    UIActionSheet *m_ActionSheet;
    IBOutlet UIPickerView *m_PickerView;//
    UIButton *m_MinusBtn;
    UIButton *m_AddBtn;
    IBOutlet UIView *m_TopView;//
    IBOutlet UILabel *m_TotalCountLabel;//
    IBOutlet UILabel *m_TotalPriceLabel;//
    IBOutlet UIView *m_RedLine;//
    UILabel *m_PaymentLabel;
    UILabel *m_ProTotalPriceLabel;
    
    bool m_ThreadIsRunning;
    NSInteger m_CurrentState;
    
    NSNumber *m_GrouponId;//传入参数，团购id
    NSNumber *m_SerialId;//传入参数，序列商品id
    NSString *m_ProductName;//传入参数，商品名称
    NSString *m_SelectedStr;//传入参数，系列商品选择的尺码颜色
    NSNumber *m_SinglePrice;//传入参数，单价
    int m_AreaId;//传入参数，地区id
    
    int methodID;
    int paymentType;
    int gatewayType;
    
    NSInteger m_SelectedIndex;
    BOOL m_AddressNotSupport;
    
    GrouponOrderVO *m_OrderVO;//团购订单VO
        
    GrouponOrderSubmitResult *m_OrderSubmitResult;
    
    GroupBuyService *m_Service;
    //OnlinePay *m_OnlinePay;
    //GoodReceiver *goodReceiver;
    //余额支付
    UILabel *m_NeedAccountPayLabel;
    UILabel *m_AccountPayLabel;
    UILabel *m_NeedPayMoneyLabel;
    double m_AccountPayMoney;
    double m_NeedPayMoney;
    //AccountBalance *m_AccountBalance;
    int m_ToDetailTag;//传入参数，标志从哪里进入团购详情
}

@property(nonatomic,retain) NSNumber *m_GrouponId;
@property(nonatomic,retain) NSNumber *m_SerialId;
@property(nonatomic,retain) NSString *m_ProductName;
@property(nonatomic,retain) NSString *m_SelectedStr;
@property(nonatomic,retain) NSNumber *m_SinglePrice;
@property int m_AreaId;
@property int m_ToDetailTag;//传入参数，标志从哪里进入团购详情
//@property(nonatomic,retain) GoodReceiver *goodReceiver;

-(IBAction)returnBtnClicked:(id)sender;
-(IBAction)orderBtnClicked:(id)sender;
-(void)submitOrder;

-(void)setUpThread;
-(void)stopThread;
@end
