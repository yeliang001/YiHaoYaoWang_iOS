//
//  OTSOrderSubmitOKVC.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  描述：此类为订单完成的view controller

#import <UIKit/UIKit.h>
#import "OTSTableViewDelegate.h"
#import "YWConst.h"

@class OrderV2;
@class OrderInfo;

@interface OTSOrderSubmitOKVC : OTSBaseViewController <OTSTableViewDelegate>
{
    long long int               orderId;
//    OrderV2                     *order;
    
    BOOL                        isOrderDetailOK;
    BOOL                        isBankListOK;
}

@property (retain, nonatomic) OrderInfo *order;
@property (assign, nonatomic) kYaoPaymentType paymentType;
@property (assign, nonatomic) int packageCount;
@property (assign, nonatomic) int productCount;

-(id)initWithOrderId:(long long int)aOrderId;
-(void)toHomePageAction;
@end
