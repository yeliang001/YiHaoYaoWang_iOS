//
//  listDetailViewController.h
//  yhd
//
//  Created by dev dev on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OrderV2.h"
#import "NewAddressView.h"
#import "OtherAddressView.h"
#import "GoodReceiverVO.h"
#import "InvoiceViewController.h"
#import "InvoiceVO.h"
@class CityVO;
@class CountyVO;
@interface listDetailViewController :BaseViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIView * mtopbarView;
    
    
    IBOutlet UIView * mreceiverinfoView;
    IBOutlet UILabel * mreceivenameLabel;
    IBOutlet UILabel * maddressLabel;
    IBOutlet UILabel * mpostCodeLabel;
    
    
    IBOutlet UIView * msendmethodView;
    IBOutlet UIButton * msendDayChooseButton;
    IBOutlet UIImageView * msentmethodIndicaterImageView;
    
    
    IBOutlet UIView * mpaymentmethodView;
    IBOutlet UIButton * mpaymentchooseButton1;
    IBOutlet UIButton * mpaymentchooseButton2;
    IBOutlet UIButton * mpaymentchooseButton3;
    IBOutlet UIButton * mpaymentchooseButton4;
    IBOutlet UIImageView * mpaymentchooseIndicaterImageView;
    IBOutlet UILabel * mpaymentType0;
    IBOutlet UILabel * mpaymentType1;
    IBOutlet UILabel * mpaymentType2;
    IBOutlet UILabel * mpaymentType3;
    NSArray * mpaymentTypeArray;//PaymentMethodVO
    NSArray * mpaymentTypeLabels;
    NSArray * mpaymethodinwebTexts;
    int mpaymethodinwebindex;
    
    IBOutlet UIView * mhighchooseView;
    IBOutlet UIButton * musediscountButton;
    IBOutlet UIButton * musecouponButton;
    IBOutlet UIButton * mneedfapiao;
    IBOutlet UIButton * mthreeinonedayButton;

    
    IBOutlet UIView * mtotalinfoView;
    IBOutlet UILabel * mtotalCountLabel;
    IBOutlet UILabel * mtotalWeightLabel;
    IBOutlet UILabel * mproductAmount;
    IBOutlet UILabel * mdeliveryAmountLabel;
    IBOutlet UILabel * mcouponAmountLabel;
    IBOutlet UILabel * mpaymentAccountLabel;
    
    IBOutlet UILabel * mDeliverLabel;
    
    NSNumber * mOrderNumber;
    OrderVO * mCurrentOrder;
    int mpaymentMethod;
    NSNumber* mpaymentGatewwayID;
    
    NSMutableArray * mreceiveListArray;
    int mreceiveindex;
    NewAddressView * mnewAddressView;
    OtherAddressView * motherAddressView;
    
    
    NSNumber * mGateWayId;
    NSArray * mBankList;
    
    IBOutlet UIPickerView * mAddressChoosePickerView;
    
    NSArray * mprovince;//provicevo
    NSNumber * mProvinceId;
    NSArray * mcity;//CityVO
    NSNumber * mCityId;
    NSArray * mcounty;//CountyVO
    NSNumber * mCountyId;
    int mproviceselectedindex;
    int mcityselectedindex;
    int mcountyselectedindex;
    int mCurrentTypeForUIPickerView;//1 province 2city 3county
    
    NSMutableArray* mPaymentIds;//nsnumber menthodid for payment
    
    // 发票
    IBOutlet UILabel * m_InvoiceLabel;
    InvoiceVO * editInvoiceVO;
    InvoiceViewController * invoiceVC;
    
    IBOutlet UIButton * mSubmitButton;
}
@property(nonatomic,retain)NSArray * mpaymentTypeLabels;
@property(nonatomic,retain)NSNumber * mOrderNumber;
@property(nonatomic,retain)OrderVO * mCurrentOrder;
@property(nonatomic,retain)NSArray * mpaymentTypeArray;
@property(nonatomic,retain)NSMutableArray * mreceiveListArray;
@property(nonatomic,retain)NSArray* mpaymethodinwebTexts;
@property(nonatomic,retain)NSArray * mprovince;
@property(nonatomic,retain)NSArray * mcity;
@property(nonatomic,retain)NSArray * mcounty;
@property(nonatomic,retain)OtherAddressView * motherAddressView;
@property(nonatomic,retain)NSMutableArray* mPaymentIds;
-(IBAction)submitOrderClicked:(id)sender;
-(IBAction)savePaymentMethod:(id)sender;
-(IBAction)useCouponClicked:(id)sender;
-(IBAction)backClicked:(id)sender;
-(IBAction)threeinOnedayClicked:(id)sender;
-(IBAction)senddayClicked:(id)sender;
-(IBAction)newaddressClicked:(id)sender;
-(IBAction)editaddressClicked:(id)sender;
-(IBAction)otheraddressClicked:(id)sender;
-(IBAction)invoiceBtnClicked:(id)sender;
-(void)getprovince;
-(void)getcity:(NSNumber*)provinceid;
-(void)getcounty:(NSNumber*)cityid;
@end
