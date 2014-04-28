//
//  YWOrderService.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-12.
//
//
 
#import "YWOrderService.h"
#import "ResponseInfo.h"
#import "OrderResultInfo.h"

#import "GoodReceiverVO.h"
#import "OrderInfo.h"
#import "FareInfo.h"
#import "OrderPackageInfo.h"
#import "MyOrderInfo.h"
#import "ResultInfo.h"
#import "GlobalValue.h"
#import "UserInfo.h"
#import "OrderDetailInfo.h"
#import "OrderPackageInfo.h"
#import "SplitLogInfo.h"

@implementation YWOrderService

- (OrderResultInfo *)checkOrder:(NSDictionary *)dic
{
    ResponseInfo *response = [self startRequestWithMethod:@"sale.precreate" param:dic];
    
    OrderResultInfo *resultInfo = [[OrderResultInfo alloc] init];
    NSDictionary *dataDic = response.data;
    
    resultInfo.responseCode = response.statusCode;
    resultInfo.bRequestStatus = response.isSuccessful;
    resultInfo.resultCode = [dataDic[@"result"] intValue];
    if (response.isSuccessful /*&& response.statusCode == 200*/)
    {
        
        DebugLog(@"checkOrder %@",dataDic);
        
        OrderInfo *orderInfo = [[OrderInfo alloc] init];
        
        //地址信息
        NSDictionary *addressInfo = dataDic[@"addressinfo"];
        if (addressInfo.count > 0)
        {
            GoodReceiverVO *goodReceiverVO = [[GoodReceiverVO alloc]init];
            
            goodReceiverVO.cityId = addressInfo[@"city"];
            goodReceiverVO.countyName = addressInfo[@"countyName"];
            goodReceiverVO.postCode = addressInfo[@"postCode"];
            goodReceiverVO.nid = addressInfo[@"id"];
            goodReceiverVO.countyId = addressInfo[@"county"];
            goodReceiverVO.cityName = addressInfo[@"cityName"];
            goodReceiverVO.provinceId = addressInfo[@"province"];
            goodReceiverVO.provinceName = addressInfo[@"provinceName"];
            goodReceiverVO.address1 = addressInfo[@"address"];
            goodReceiverVO.receiveName = addressInfo[@"realName"];
            goodReceiverVO.receiverEmail = addressInfo[@"emall"];
            goodReceiverVO.receiverPhone = addressInfo[@"tel"];
            goodReceiverVO.receiverMobile = addressInfo[@"mobile"];
            goodReceiverVO.invoiceInfo = addressInfo[@"invoiceInfo"];
            goodReceiverVO.invoiceTitle = addressInfo[@"invoiceTitle"];
            goodReceiverVO.invoiceType = addressInfo[@"invoceType"];
            
            orderInfo.goodReceiver = goodReceiverVO;
            [goodReceiverVO release];
        }
        
        //运费
        orderInfo.fare = dataDic[@"fare"];
        
        NSMutableArray *fareResultArr = [[NSMutableArray alloc] init];
        NSArray *fareInfoArr = dataDic[@"fareinfo"];
        for (NSDictionary *dic in fareInfoArr)
        {
            FareInfo *fare = [[FareInfo alloc] init];
            fare.totalReturnMoney = dic[@"totalReturnMoney"];
            fare.totalCount = dic[@"totalCount"];
            fare.totalMoney = dic[@"totalMoney"];
            fare.goodsId = dic[@"goodsId"];
            fare.isCod = [dic[@"isCOD"] intValue] == 1 ? YES : NO;
            fare.isPos = [dic[@"isPos"] intValue] == 1? YES : NO;
            
            [fareResultArr addObject:fare];
            [fare release];
        }
        orderInfo.fareInfoArr = fareResultArr;
        [fareResultArr release];
        
        //是否必须发票
        orderInfo.isMustInvoice = [dataDic[@"ismustinvoice"] intValue] == 0 || [dataDic[@"ismustinvoice"] intValue] == 2 ? YES : NO; //0是必须开发票 1不是必须开发票
        //是不是医疗器械
        orderInfo.isMedicalInstrument = [dataDic[@"ismustinvoice"] intValue] == 2 ? YES : NO;
        //是否包含第三方商品，如果有不能货到付款
        orderInfo.isContainOtherProduct = [dataDic[@"iscontaindsfsp"] intValue]==1? YES : NO;
        //是否包含体检类商品，如果有，那么发票信息必须是 服务类
        orderInfo.isContainTJProduct = [dataDic[@"iscontaintjsp"] intValue]==1?YES:NO;
        
        //包裹列表
        NSMutableArray *resultOrderPackage = [[NSMutableArray alloc] init];
        NSArray *orderPackageArr = dataDic[@"orderpackages"];
        for (NSDictionary *dic in orderPackageArr)
        {
            OrderPackageInfo *orderPackage = [[OrderPackageInfo alloc] init];
            orderPackage.venderId = dic[@"venderId"];
            orderPackage.weight = dic[@"weight"];
            orderPackage.allGoodsMoney = dic[@"allGoodsMoney"];
            orderPackage.name = dic[@"name"];
            orderPackage.packageId = dic[@"packageId"];
          
            //包裹中的商品
            NSMutableArray *resultProductArr = [[NSMutableArray alloc] init];
            NSArray *productArr = dic[@"pDetail"];
            for (NSDictionary *productDic in productArr )
            {
                OrderProductDetail *productDetail = [[OrderProductDetail alloc] init];
                productDetail.productId = [productDic[@"pId"] stringValue] ;
                productDetail.productStatus = productDic[@"goodsStatus"];
                productDetail.productCount = [productDic[@"productCount"] stringValue];
                productDetail.goodsId = productDic[@"goodsId"];
                productDetail.productNo = productDic[@"productNo"];
                productDetail.weight = [productDic[@"weight"] stringValue];
                productDetail.productName = productDic[@"goodsName"];
                productDetail.brandName = productDic[@"brandName"];
                productDetail.catelogName = productDic[@"catName"];
                productDetail.price = [productDic[@"productPrice"] stringValue];
                productDetail.catelogId = [productDic[@"catalogId"] stringValue];
                productDetail.backMoney = productDic[@"backMoney"];
                productDetail.userName = productDic[@"userName"];
                productDetail.userId = productDic[@"userId"];
                productDetail.productMarque = productDic[@"productMarque"];
                productDetail.brandId = productDic[@"brandId"];
                productDetail.venderId = productDic[@"venderId"];
                
                [resultProductArr addObject:productDetail];
                [productDetail release];
            }
            
            orderPackage.packageProductArr = resultProductArr;
            [resultProductArr release];
            
            [resultOrderPackage addObject:orderPackage];
            [orderPackage release];
        }
        orderInfo.orderPackageArr = resultOrderPackage;
        [resultOrderPackage release];
        
        resultInfo.orderInfo  = orderInfo;
        [orderInfo release];
    }
    
    return [resultInfo autorelease];
}
//是不是很狗屎，屎一样的，看看下面服务器的返回数据，你就清楚了
/*
{
    "issuccessful": "true",
    "statuscode": "200",
    "description": "",
    "userid": "null",
    "data": {
        "addressinfo": {
            "city": "310000",
            "countyName": "卢湾区",
            "isDefaultOfQuickOrderInfo": 0,
            "addressType": 0,
            "isDefault": 0,
            "postCode": "",
            "id": 34417,
            "county": "310103",
            "cityName": "上海市",
            "payName": null,
            "invoiceTitle": null,
            "payBankName": null,
            "paytype": -1,
            "payBankUrl": null,
            "userId": 133870419,
            "username": "test003",
            "siteId": null,
            "invoiceType": null,
            "mobile": "13255554444",
            "invoiceInfo": null,
            "deliverType": null,
            "tel": "0",
            "email": "",
            "realName": "ww",
            "quickOrderName": null,
            "address": "e",
            "payBankCode": null,
            "province": "310000",
            "provinceName": "上海市"
        },
        "fare": 0,
        "fareinfo": [
                     {
                         "totalReturnMoney": 0,
                         "warehouseId": "",
                         "totalCount": 0,
                         "totalMoney": 0,
                         "id": 0,
                         "freightPrice": 0,
                         "isArrive": "1",
                         "countyLevel": 0,
                         "goodsId": "P3050243",
                         "count": 1,
                         "goodsPattern": "",
                         "ruleId": 1,
                         "useTrans": "1000025",
                         "returnMoney": 0,
                         "goodsName": "",
                         "enableSelfGet": "",
                         "logisticsId": 0,
                         "money": 180.2,
                         "catId": "1905",
                         "refuseOrderTime": "18:00:00",
                         "comeTime": "09-14",
                         "freightCatId": 3,
                         "isCOD": "1", //
                         "isStationOrDoor": "",
                         "arriveDate": "2013-09-14 00:00:00",
                         "isPos": "1"
                     }
                     ],
        "ismustinvoice": 0,  //是否必须发票
        "iscontaindsfsp": 0,  //是否包含第三方商品，如果有不能货到付款
        "iscontaintjsp": 0, //是否包含体检类商品，如果有，那么发票信息必须是 服务类
        "orderpackages": [
                          {
                              "venderId": "2011102716210000",
                              "weight": 3.200000047683716,
                              "allGoodsMoney": 180.2,
                              "name": "包裹1",
                              "packageId": null,
                              "orderSplit": null,
                              "splitLogs": null,
                              "pDetail": [
                                          {
                                              "orderDetailId": null,
                                              "orderId": null,
                                              "pId": 3050243,
                                              "goodsVoucherMoney": 0,
                                              "goodsStatus": 0,
                                              "productCount": 1,
                                              "goodsId": "P3050243",
                                              "weight": 3.200000047683716,
                                              "goodsName": "张博测试21",
                                              "brandName": "北京同仁堂",
                                              "catName": "测试血糖仪",
                                              "productPrice": 180.2,
                                              "catalogId": 1905,
                                              "mainId": "null",
                                              "orderClass": 2,
                                              "goodsType": null,
                                              "backMoney": 0,
                                              "productScore": 0,
                                              "taoCanId": 0,
                                              "useCouponValue": null,
                                              "userName": "test003",
                                              "userId": 133870419,
                                              "productMarque": "张博测试2",
                                              "brandId": 4,
                                              "userIp": "192.168.96.60",
                                              "venderId": "2011102716210000",
                                              "orderDate": null,
                                              "catId": "1905",
                                              "productNo": "110010101010",
                                              "lineNum": 0,
                                              "specialStatus": 32,
                                              "status": 8,
                                              "selltype": "1",
                                              "cityid": 0,
                                              "warehouseId": null,
                                              "isArrive": null,
                                              "isCOD": null,
                                              "isPos": null,
                                              "stockStatus": null,
                                              "splitOrderId": null,
                                              "promotionAmount": 0,
                                              "promotionId": null,
                                              "category": "",
                                              "isCommented": null,
                                              "goodsAmountTotal": null,
                                              "outGoodsId": null,
                                              "siteId": null,
                                              "skuId": null,
                                              "outGoodsVoucherMoney": null,
                                              "promotionCutId": 0,
                                              "promotionReturnId": 0,
                                              "promotionSendId": 0,
                                              "promotionSendAmount": 0,
                                              "itemPrice": 180.2,
                                              "useBalance": null,
                                              "useRebateBalance": null,
                                              "goodsStatusUpdateTime": null,
                                              "theFei": 0,
                                              "voucherMoney": 0,
                                              "voucherNo": null,
                                              "payMethodId": null,
                                              "orderStatus": null,
                                              "payStatus": null,
                                              "orderPriceCount": null
                                          }
                                          ],
                              "coupon": null,
                              "theFei": null,
                              "promotionAmount": null,
                              "useBalance": null,
                              "useRebateBalance": null,
                              "reciveMoney": null
                          }
                          ],
        "result": 1
    }
}
*/


//获取我的订单列表
- (ResultInfo *)getMyOrder:(NSDictionary *)dic
{
    ResponseInfo *response = [self startRequestWithMethod:@"order.orderlist" param:dic];
    NSDictionary *dataDic = response.data;
    DebugLog(@"getMyOrder %@",dataDic);
    
    
    ResultInfo *result = [[ResultInfo alloc] init];
    result.bRequestStatus = response.isSuccessful;
    result.responseCode = response.statusCode;
    result.resultCode = [dataDic[@"result"] intValue];
    if (response.isSuccessful && response.statusCode == 200)
    {
        result.recordCount = [dataDic[@"recordcount"] intValue];
        
        //解析结果 所有订单列表
        NSMutableArray *myOrderListResult = [[NSMutableArray alloc] init];
        
        
        NSArray *orderList = dataDic[@"orderlist"];
        for (NSDictionary *dic in orderList)
        {
            MyOrderInfo *myOrderInfo = [[MyOrderInfo alloc] init];
            
            //订单中商品信息数组
            NSMutableArray *resultProductInfoArr = [[NSMutableArray alloc] init];
            NSArray *productInfos = dic[@"productInfos"];
            for (NSDictionary *pDic in productInfos)
            {
                OrderProductInfo *orderProduct = [[OrderProductInfo alloc] init];
                orderProduct.productName = pDic[@"productName"];
                orderProduct.productId = [pDic[@"productId"] stringValue];
                orderProduct.orderId = pDic[@"orderId"];
                orderProduct.productPicture = pDic[@"productPicture"];
                orderProduct.packageId = pDic[@"packageId"];
                orderProduct.prescription  = [pDic[@"prescription"] intValue];
                [resultProductInfoArr addObject:orderProduct];
                [orderProduct release];
            }
            myOrderInfo.productInfoArr = resultProductInfoArr;
            [resultProductInfoArr release];
            
            
            //订单中的包裹信息
            //我的订单列表中没有用到，物流查询时用到
            NSArray *packageDicArr = dic[@"orderPackages"];
            NSMutableArray *resultPackageArr = [[[NSMutableArray alloc] init] autorelease];
            for (NSDictionary *packDic in packageDicArr)
            {
                OrderPackageInfo *package = [[OrderPackageInfo alloc] init];
                package.venderId = packDic[@"venderId"];
                package.weight = packDic[@"weight"];
                package.allGoodsMoney = packDic[@"allGoodsMoney"];
                package.name = packDic[@"name"];
                package.packageId = packDic[@"packageId"];
               
                [resultPackageArr addObject:package];
                [package release];
            }
            myOrderInfo.orderPackageArr = resultPackageArr;
            
            
            //每个订单中其他信息
            myOrderInfo.packageCount = [dic[@"packages"] intValue];
            myOrderInfo.orderDate = dic[@"orderDate"];
            myOrderInfo.orderId = dic[@"orderId"];
            myOrderInfo.payMethodId = [dic[@"payMethodId"] intValue];
            myOrderInfo.payStatus = [dic[@"payStatus"] intValue];
            myOrderInfo.orderStatus = [dic[@"orderStatus"] intValue];
            myOrderInfo.theAllMoney = [dic[@"theAllMoney"] floatValue];
            myOrderInfo.productNum = [dic[@"productNum"] intValue];
            myOrderInfo.payMethodName = dic[@"payMethodName"];
            
            [myOrderListResult addObject:myOrderInfo];
            [myOrderInfo release];
        }
        
        result.resultObject = myOrderListResult;
        [myOrderListResult release];
    }

    return [result autorelease];
}


//获取我的订单的支付宝签证
- (NSString *)getOrderAlipaySign:(NSString *)orderId
{
    NSDictionary *dic = @{@"orderid" : orderId,
                          @"payversion":@"2", //表示新的支付宝sdk
                           @"userid" : [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                         @"username" : [GlobalValue getGlobalValueInstance].userInfo.uid, //uid是 用户名 ，草。。。。
                            @"token" : [GlobalValue getGlobalValueInstance].ywToken};
    ResponseInfo *response = [self startRequestWithMethod:@"sign.get" param:dic];
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        DebugLog(@"支付宝签名: %@",dataDic);
        NSString *signStr = dataDic[@"signinfo"];
        return signStr;
    }
    
    return nil;
}
//获取签名时服务器返回
/*
 {
 data =     {
 result = 1;
 signinfo = "partner=\"2088501903418573\"&seller=\"etao@111.com.cn\"&out_trade_no=\"20130921201610484407\"&subject=\"1\U53f7\U836f\U7f51\U8ba2\U5355\"&body=\"\U5f85\U7ed3\U7b97\"&total_fee=\"0.02\"&notify_url=\"http://203.110.175.178:30500/mobile-web/RSANotifyReceiver\"&sign_type=\"RSA\"&sign=\"mW9dgZmFxNNyO3dzUlgP4c4Emaib4pT3EkD2gsEXpXYY7uuqQ1feQZLx7N2wpxfs%2FuPmROO%2B5P%2FhmGT4HhQVswYDsMZapJ%2BB7NDwvWkGewel9m6ChTwKqGKvS3SuJJEisP5vPC0SeApV0zOcEJWOx66z1diCYzmXyWldJzphUtQ%3D\"";
 };
 description = "";
 issuccessful = true;
 statuscode = 200;
 userid = null;
 }*/


//获取订单的详细内容
- (OrderDetailInfo *)getOrderDetail:(NSString *)orderId
{
    NSDictionary *dic = @{@"orderid" : orderId,
                          @"userid" : [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                          @"username" : [GlobalValue getGlobalValueInstance].userInfo.uid, //uid是 用户名 ，草。。。。
                          @"token" : [GlobalValue getGlobalValueInstance].ywToken};
    ResponseInfo *response = [self startRequestWithMethod:@"order.detail" param:dic];
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        DebugLog(@"获取订单详细内容: %@",dataDic);
        
        NSDictionary *orderDic = dataDic[@"order"];
        OrderDetailInfo *orderDetail = [[OrderDetailInfo alloc] init];
        
         orderDetail.orderCancelTime = orderDic[@"orderCancelTime"];
         orderDetail.splitOrderInfo = orderDic[@"splitOrderInfo"];
         orderDetail.userName = orderDic[@"userName"];
         orderDetail.confirmPayTime = orderDic[@"confirmPayTime"];
         orderDetail.theFei = [orderDic[@"theFei"] floatValue];
         orderDetail.shipMethodId = orderDic[@"shipMethodId"];
         orderDetail.payMethodId = [orderDic[@"payMethodId"] intValue];
         orderDetail.orderStatus = [orderDic[@"orderStatus"] intValue];
//         orderDetail.orderPriceCount = [orderDic[@"orderPriceCount"] floatValue];
         orderDetail.payMethodName = orderDic[@"payMethodName"];
         orderDetail.theAllMoney = [orderDic[@"theAllMoney"] floatValue];
         orderDetail.useBalance = [orderDic[@"useBalance"] floatValue];
         orderDetail.orderDate = orderDic[@"orderDate"];
         orderDetail.orderFinishTime = orderDic[@"orderFinishTime"];
         orderDetail.venderId = orderDic[@"venderId"];
         orderDetail.orderId = orderDic[@"orderId"];
         orderDetail.shipMethodName = orderDic[@"shipMethodName"];
         orderDetail.payStatus = [orderDic[@"payStatus"] intValue];
         orderDetail.userId = orderDic[@"userId"];

        //订单中的包裹数组
        NSArray *packageArr = dataDic[@"orderpackages"];
        NSMutableArray *resultOrderPackageArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in packageArr)
        {
            OrderPackageInfo *packInfo = [[OrderPackageInfo alloc] init];
            packInfo.venderId = dic[@"venderId"];
            packInfo.weight = dic[@"weight"];
            packInfo.allGoodsMoney = dic[@"allGoodsMoney"];
            packInfo.name = dic[@"name"];
            packInfo.packageId = dic[@"packageId"];
            
            //包裹中的商品
            NSArray *orderProductArr = dic[@"pDetail"];
            NSMutableArray *resultOrderProductArr = [[NSMutableArray alloc] init];
            for (NSDictionary *pDic in orderProductArr)
            {
                OrderProductDetail *orderProduct = [[OrderProductDetail alloc] init];
                orderProduct.productId = [pDic[@"pId"] stringValue];
                orderProduct.productCount = pDic[@"productCount"];
                orderProduct.goodsId = pDic[@"goodsId"];
                orderProduct.productName = pDic[@"goodsName"];
                orderProduct.price = pDic[@"productPrice"];
                orderProduct.promotionAmount = [pDic[@"promotionAmount"] floatValue];
                orderProduct.goodsType = [ ValidValue(pDic[@"goodsType"]) integerValue];
                [resultOrderProductArr addObject:orderProduct];
                [orderProduct release];
            }
            packInfo.packageProductArr = resultOrderProductArr;
            [resultOrderProductArr release];
            
            //物流日志
            NSMutableArray *resultSplitArr = [[NSMutableArray alloc] init];
            for (NSDictionary *splitDic in dic[@"splitLogs"])
            {
                SplitLogInfo *splitLog = [[SplitLogInfo alloc] init];
                id sid = splitDic[@"id"];
                
                splitLog.sid =  [sid isKindOfClass:[NSNull class]]? 0 :[sid intValue];
                splitLog.logTime = ValidValue(splitDic[@"logTime"]);
                splitLog.note = ValidValue(splitDic[@"note"]);
                splitLog.operatorUser = ValidValue(splitDic[@"operator"]);
                splitLog.orderId = ValidValue(splitDic[@"orderId"]);
                splitLog.status = ValidValue(splitDic[@"status"]);
                
                [resultSplitArr addObject:splitLog];
                [splitLog release];
            }
            packInfo.splitLogArr = resultSplitArr;
            [resultSplitArr release];
            
            
            [resultOrderPackageArr addObject:packInfo];
            [packInfo release];
        }
        orderDetail.orderPackageArr = resultOrderPackageArr;
        [resultOrderPackageArr release];
        
        //订单联系人信息
        NSDictionary *contactDic = dataDic[@"ordercontact"];
        OrderContact *contact = [[OrderContact alloc] init];
        contact.orderContactId = [contactDic[@"orderContactId"] intValue];
        contact.cancelOrderReasonType = contactDic[@"cancelOrderReasonType"];
        contact.cancelOrderReasonTypeId = contactDic[@"cancelOrderReasonTypeId"];
        contact.orderId = contactDic[@"orderId"];
        contact.addTime = contactDic[@"addTime"];
        contact.sendProvinceId = contactDic[@"send_Province"];
        contact.sendProvinceName = contactDic[@"send_ProvinceName"];
        contact.sendCityId = contactDic[@"send_City"];
        contact.sendCityName = contactDic[@"send_CityName"];
        contact.sendCountyId = contactDic[@"send_County"];
        contact.sendCountyName = contactDic[@"send_CountyName"];
        contact.sendParticularAddress = contactDic[@"send_ParticularAddress"];
        contact.sendPostCode = contactDic[@"send_PostCode"];
        contact.sendWantTime = contactDic[@"send_WantTime"];
        contact.sendWantTimeType = [contactDic[@"send_WantTimeNo"] intValue];
        contact.sendReceivePeople = contactDic[@"send_ReceivePeople"];
    
        contact.sendContactMobile =  contactDic[@"send_ContactMobile"];
        contact.sendContactPhone = ValidValue(contactDic[@"send_ContactPhone"]);
        contact.sendEmail = contactDic[@"send_Email"];
        contact.invoiceFee = [contactDic[@"invoiceFee"] intValue];
        contact.invoiceData = contactDic[@"invoiceData"];
        contact.invoiceHead = contactDic[@"invoiceHeader"];
        
        orderDetail.orderContact = contact;
        [contact release];
        
        //发票信息
        NSDictionary *invoiceDic = dataDic[@"invoiceinfo"];
        InvoiceInfo *invoice = [[InvoiceInfo alloc] init];
        invoice.openBank = invoiceDic[@"openBank"];
        invoice.receivePerson = invoiceDic[@"receivePerson"];
        invoice.taxpayerNo = invoiceDic[@"taxpayerNo"];
        invoice.contact = invoiceDic[@"contact"];
        invoice.invoiceHead = invoiceDic[@"invoiceHead"];
        invoice.corpName = invoiceDic[@"corpName"];
        invoice.bankAccount = invoiceDic[@"bankAccount"];
        invoice.invoiceTypeId = [invoiceDic[@"invoiceTypeId"] intValue];
        invoice.invoiceConentId = invoiceDic[@"invoiceConentId"];
        invoice.regAddress = invoiceDic[@"regAddress"];
        invoice.regTel = invoiceDic[@"regTel"];
        invoice.invoiceHeadTypeId = [invoiceDic[@"invoiceHeadTypeId"] intValue];
        invoice.address = invoiceDic[@"address"];
        invoice.invoiceContent = invoiceDic[@"invoiceConent"];
        
        
        orderDetail.invoiceInfo = invoice;
        [invoice release];
        
        return [orderDetail autorelease];
    }

    return nil;
}

//取消订单
- (BOOL)cancelOrder:(NSString *)orderId orderStatus:(NSString *)aOrderStaus
{
    NSDictionary *dic = @{@"orderid" : orderId,
                      @"orderstatus" : aOrderStaus,
                           @"userid" : [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                         @"username" : [GlobalValue getGlobalValueInstance].userInfo.uid, //uid是 用户名 ，草。。。。
                            @"token" : [GlobalValue getGlobalValueInstance].ywToken};
    
    ResponseInfo *response = [self startRequestWithMethod:@"order.cancel" param:dic];
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        if ([dataDic[@"result"] intValue] == 1)
        {
            return YES;
        }
    }
    return NO;
}


//提交订单
- (ResultInfo *)submitOrder:(NSDictionary *)paramDic
{
    ResponseInfo *response = [self startRequestWithMethod:@"sale.create" param:paramDic];
    NSDictionary *dataDic = response.data;
    DebugLog(@"submitOrder %@",dataDic);
    
    ResultInfo *result = [[ResultInfo alloc] init];
    result.bRequestStatus = response.isSuccessful;
    result.responseCode = response.statusCode;
    result.resultCode = [dataDic[@"result"] intValue];
    if (response.isSuccessful && response.statusCode == 200)
    {
        OrderInfo *orderInfo = [[OrderInfo alloc] init];
        
        
        //支付宝签名信息
        orderInfo.signInfo = dataDic[@"signinfo"];
        orderInfo.orderId = dataDic[@"orderid"];
        //地址信息
        NSDictionary *addressInfo = dataDic[@"addressinfo"];
        if (addressInfo.count > 0)
        {
            GoodReceiverVO *goodReceiverVO = [[GoodReceiverVO alloc]init];
            
            goodReceiverVO.cityId = addressInfo[@"city"];
            goodReceiverVO.countyName = addressInfo[@"countyName"];
            goodReceiverVO.postCode = addressInfo[@"postCode"];
            goodReceiverVO.nid = addressInfo[@"id"];
            goodReceiverVO.countyId = addressInfo[@"county"];
            goodReceiverVO.cityName = addressInfo[@"cityName"];
            goodReceiverVO.provinceId = addressInfo[@"province"];
            goodReceiverVO.provinceName = addressInfo[@"provinceName"];
            goodReceiverVO.address1 = addressInfo[@"address"];
            goodReceiverVO.receiveName = addressInfo[@"realName"];
            goodReceiverVO.receiverEmail = addressInfo[@"emall"];
            goodReceiverVO.receiverPhone = addressInfo[@"tel"];
            goodReceiverVO.receiverMobile = addressInfo[@"mobile"];
            goodReceiverVO.invoiceInfo = addressInfo[@"invoiceInfo"];
            goodReceiverVO.invoiceTitle = addressInfo[@"invoiceTitle"];
            goodReceiverVO.invoiceType = addressInfo[@"invoceType"];
            
            orderInfo.goodReceiver = goodReceiverVO;
            [goodReceiverVO release];
        }
        
        //运费
        orderInfo.fare = dataDic[@"fare"];
        
        NSMutableArray *fareResultArr = [[NSMutableArray alloc] init];
        NSArray *fareInfoArr = dataDic[@"fareinfo"];
        for (NSDictionary *dic in fareInfoArr)
        {
            FareInfo *fare = [[FareInfo alloc] init];
            fare.totalReturnMoney = dic[@"totalReturnMoney"];
            fare.totalCount = dic[@"totalCount"];
            fare.totalMoney = dic[@"totalMoney"];
            fare.goodsId = dic[@"goodsId"];
            fare.isCod = [dic[@"isCOD"] intValue] == 1 ? YES : NO;
            fare.isPos = [dic[@"isPos"] intValue] == 1? YES : NO;
            
            [fareResultArr addObject:fare];
            [fare release];
        }
        orderInfo.fareInfoArr = fareResultArr;
        [fareResultArr release];
        
        //是否必须发票
        orderInfo.isMustInvoice = [dataDic[@"ismustinvoice"] intValue] == 1? YES : NO;
        //是否包含第三方商品，如果有不能货到付款
        orderInfo.isContainOtherProduct = [dataDic[@"iscontaindsfsp"] intValue]==1? YES : NO;
        //是否包含体检类商品，如果有，那么发票信息必须是 服务类
        orderInfo.isContainTJProduct = [dataDic[@"iscontaintjsp"] intValue]==1?YES:NO;
        
        //包裹列表
        NSMutableArray *resultOrderPackage = [[NSMutableArray alloc] init];
        NSArray *orderPackageArr = dataDic[@"orderpackages"];
        for (NSDictionary *dic in orderPackageArr)
        {
            OrderPackageInfo *orderPackage = [[OrderPackageInfo alloc] init];
            orderPackage.venderId = dic[@"venderId"];
            orderPackage.weight = dic[@"weight"];
            orderPackage.allGoodsMoney = dic[@"allGoodsMoney"];
            orderPackage.name = dic[@"name"];
            orderPackage.packageId = dic[@"packageId"];
            
            //包裹中的商品
            NSMutableArray *resultProductArr = [[NSMutableArray alloc] init];
            NSArray *productArr = dic[@"pDetail"];
            for (NSDictionary *productDic in productArr )
            {
                OrderProductDetail *productDetail = [[OrderProductDetail alloc] init];
                productDetail.productId = productDic[@"productId"];
                productDetail.productStatus = productDic[@"goodsStatus"];
                productDetail.productCount = productDic[@"productCount"];
                productDetail.goodsId = productDic[@"goodsId"];
                productDetail.productNo = productDic[@"productNo"];
                productDetail.weight = productDic[@"weight"];
                productDetail.productName = productDic[@"goodsName"];
                productDetail.brandName = productDic[@"brandName"];
                productDetail.catelogName = productDic[@"catName"];
                productDetail.price = productDic[@"productPrice"];
                productDetail.catelogId = productDic[@"catalogId"];
                productDetail.backMoney = productDic[@"backMoney"];
                productDetail.userName = productDic[@"userName"];
                productDetail.userId = productDic[@"userId"];
                productDetail.productMarque = productDic[@"productMarque"];
                productDetail.brandId = productDic[@"brandId"];
                productDetail.venderId = productDic[@"venderId"];
                productDetail.promotionAmount = [productDic[@"promotionAmount"] floatValue];
                [resultProductArr addObject:productDetail];
                [productDetail release];
            }
            
            orderPackage.packageProductArr = resultProductArr;
            [resultProductArr release];
            
            [resultOrderPackage addObject:orderPackage];
            [orderPackage release];
        }
        orderInfo.orderPackageArr = resultOrderPackage;
        [resultOrderPackage release];
        
        result.resultObject = orderInfo;
        [orderInfo release];
        
       
    }

     return [result autorelease];
}


@end
