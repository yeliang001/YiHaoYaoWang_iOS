//
//  InvoiceInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-22.
//
//  订单详细中发票信息

#import <Foundation/Foundation.h>
#import "YWConst.h"
@interface InvoiceInfo : NSObject

@property (copy, nonatomic) NSString *openBank; //开户银行
@property (copy, nonatomic) NSString *receivePerson; //发票收件人
@property (copy, nonatomic) NSString *taxpayerNo; //纳税人识别号
@property (copy, nonatomic) NSString *contact; //联系方式

@property (copy, nonatomic) NSString *corpName;  //单位名称
@property (copy, nonatomic) NSString *bankAccount;//银行账户
@property (assign, nonatomic) NSInteger invoiceTypeId;// 发票类型 0普通 1增值税
@property (copy, nonatomic) NSString *invoiceConentId; //发票内容id 还没有。。。
@property (copy, nonatomic) NSString *regAddress; //注册地址
@property (copy, nonatomic) NSString *regTel;
@property (copy, nonatomic) NSString *address;//发票地址

@property (copy, nonatomic) NSString *invoiceHead;//发票抬头
@property (copy, nonatomic) NSString *invoiceContent; //内容
@property (assign, nonatomic) kYaoInvoiceHeadType invoiceHeadTypeId;


@end
