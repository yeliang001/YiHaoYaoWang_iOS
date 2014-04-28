//
//  OrderContact.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-22.
//
//  订单中的联系人信息

#import "OrderContact.h"

@implementation OrderContact


- (void)dealloc
{
    [_cancelOrderReasonType release]; //取消原因
    [_cancelOrderReasonTypeId release]; //取消原因的id
    [_orderId release];
    [_addTime release];
    [_sendProvinceId release]; //收获省份Id
    [_sendProvinceName release]; //收货省份
    [_sendCityId release];
    [_sendCityName release];
    [_sendCountyId release]; //区
    [_sendCountyName release];
    [_sendParticularAddress release]; //详细地址
    [_sendPostCode release];
    [_sendWantTime release];  //希望送货时间段
    [_sendReceivePeople release];//收货人名
    [_sendContactMobile release];
    [_sendEmail release];
    [_sendContactPhone release];
    [_oldChangeNewData release];//节能补贴
    [_invoiceData release]; //发票信息， xml 格式
    [_invoiceHead release];
    
    [super dealloc];
}

@end
