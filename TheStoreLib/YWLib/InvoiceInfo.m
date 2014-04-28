//
//  InvoiceInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-22.
//
//

#import "InvoiceInfo.h"

@implementation InvoiceInfo

- (void)dealloc
{
    [_openBank release]; //开户银行
    [_receivePerson release]; //发票收件人
    [_taxpayerNo release]; //纳税人识别号
    [_contact release]; //联系方式
    [_invoiceHead release];//发票抬头
    [_corpName release];  //单位名称
    [_bankAccount release];//银行账户
//    [_invoiceTypeId release];// 发票类型 0普通 1增值税
    [_invoiceConentId release]; //发票内容id 还没有。。。
    [_regAddress release]; //注册地址
    [_regTel release];
    [_address release];//发票地址
    [_invoiceContent release];
    [super dealloc];
}


@end
