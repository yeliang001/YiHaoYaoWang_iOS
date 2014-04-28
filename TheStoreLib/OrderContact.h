//
//  OrderContact.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-22.
//
//  订单详情中的联系人信息

#import <Foundation/Foundation.h>
#import "YWConst.h"

typedef enum{
    kYaoWantSendWordDay = 1,//工作日送
    kYaoWantSendAnyDay = 2, //任何时间送
    kYaoWantSendWeedend = 3 //假日送
}kYaoWantSendTimeType;

@interface OrderContact : NSObject

@property (assign, nonatomic) NSInteger orderContactId; //联系人id号
@property (copy, nonatomic) NSString *cancelOrderReasonType; //取消原因
@property (copy, nonatomic) NSString *cancelOrderReasonTypeId; //取消原因的id
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *addTime;
//地址
@property (copy, nonatomic) NSString *sendProvinceId; //收获省份Id
@property (copy, nonatomic) NSString *sendProvinceName; //收货省份
@property (copy, nonatomic) NSString *sendCityId;
@property (copy, nonatomic) NSString *sendCityName;
@property (copy, nonatomic) NSString *sendCountyId; //区
@property (copy, nonatomic) NSString *sendCountyName;
@property (copy, nonatomic) NSString *sendParticularAddress; //详细地址
@property (copy, nonatomic) NSString *sendPostCode;
//联系人
@property (copy, nonatomic) NSString *sendWantTime;  //希望送货时间段
@property (assign, nonatomic) kYaoWantSendTimeType sendWantTimeType; //希望送货时间type
@property (copy, nonatomic) NSString *sendReceivePeople;//收货人名
@property (copy, nonatomic) NSString *sendContactMobile;
@property (copy, nonatomic) NSString *sendEmail;
@property (copy, nonatomic) NSString *sendContactPhone;
@property (copy, nonatomic) NSString *oldChangeNewData;//节能补贴
//发票
@property (assign, nonatomic) kYaoInvoiceHeadType invoiceFee; //发票类型
@property (copy, nonatomic) NSString *invoiceData; //发票信息， xml 格式
@property (copy, nonatomic) NSString *invoiceHead;





@end
