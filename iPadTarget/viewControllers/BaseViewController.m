//
//  BaseViewController.m
//  JieYinPay
//
//  Created by mxy on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "AddProductResult.h"
#import "ProvinceVO.h"
#import "UserManageTool.h"
#import "LocalCartItemVO.h"
#import "LoginResult.h"
#import "LoginViewController.h"
#import "CouponCheckResult.h"

@interface BaseViewController ()
@property(nonatomic, retain)    NSMutableDictionary     *operationIDS;


@end

@implementation BaseViewController
@synthesize receivedData;
@synthesize operationIDS = _operationIDS;
@synthesize dataHandler;
@synthesize semiTransBgView = _semiTransBgView;
@synthesize loginVC = _loginVC;

#pragma mark - memory
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    MCRelease(receivedData);
    
    [_operationIDS release];
    [_semiTransBgView release];
    [_loginVC release];
    
    [super dealloc];
}




#pragma mark - 根据key找到operation id
-(int)doAction:(SEL)aSelector withObject:(id)anObject forKey:(NSString*)anOperKey
{
    int operID = [[OTSOperationEngine sharedInstance] doOperationForSelector:aSelector target:self object:anObject caller:self];
    
    if (operID != OTS_INVALID_OPERATION_ID)
    {
        [_operationIDS setObject:[NSNumber numberWithInt:operID] forKey:anOperKey];
    }
    
    return operID;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _operationIDS = [[NSMutableDictionary alloc] initWithCapacity:10];
    dataHandler= [DataHandler sharedDataHandler];
    
    self.receivedData=[NSMutableData dataWithCapacity:512];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    m_ThreadRunning=NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 新线程
//提交订单
-(void)newThreadSubmitOrderWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    NSNumber *goodReceiverId=[object objectForKey:@"GoodReceiverId"];
    NSNumber *methodId=[object objectForKey:@"MethodId"];
    NSNumber *gateWayId=[object objectForKey:@"GateWayId"];
    NSString *invoiceTitle=[object objectForKey:@"InvoiceTitle"];
    NSString *invoiceContent=[object objectForKey:@"InvoiceContent"];
    NSNumber *invoiceAmount=[object objectForKey:@"InvoiceAmount"];
    NSString *couponNumber=[object objectForKey:@"CouponNumber"];
    //保存收货地址到订单
    long long int result=[service saveGoodReceiverToSessionOrder:[GlobalValue getGlobalValueInstance].token goodReceiverId:goodReceiverId];
    if (result==1) {
        //保存支付方式到订单
        result=[service savePaymentToSessionOrder:[GlobalValue getGlobalValueInstance].token methodid:methodId gatewayid:gateWayId];
        
        // 需传入额外的methodID, gatewayId
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SavePayment extraPrama:methodId, gateWayId, nil]autorelease];
        [DoTracking doJsTrackingWithParma:prama];
        
        if (result==1) {
            if (![invoiceTitle isEqualToString:@""] && ![invoiceContent isEqualToString:@""] && invoiceAmount!=0) {
                //保存发票到订单
                result=[service saveInvoiceToSessionOrder:[GlobalValue getGlobalValueInstance].token invoiceTitle:invoiceTitle invoiceContent:invoiceContent invoiceAmount:invoiceAmount];
                
                JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveInvoice extraPrama:invoiceTitle, invoiceContent, invoiceAmount, nil]autorelease];
                [DoTracking doJsTrackingWithParma:prama];
                
                if (result==1) {
                    //保存抵用卷
                    if (couponNumber!=nil && ![couponNumber isEqualToString:@""]) {//需要保存抵用卷
                        //调接口
                        CouponCheckResult *couponCheckResult=[service saveCouponToSessionOrderV2:[GlobalValue getGlobalValueInstance].token couponNumber:couponNumber];
                        
                        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveCoupon extraPrama:couponNumber, nil]autorelease];
                        [DoTracking doJsTrackingWithParma:prama];
                        if (couponCheckResult!=nil) {
                            //提交订单
                            result=[service submitOrderEx:[GlobalValue getGlobalValueInstance].token];
                            if (result>0) {
                                [self performSelectorOnMainThread:selector withObject:[NSNumber numberWithLongLong:result] waitUntilDone:NO];
                                
                                // 需设置orderCode
                                JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SubmitOrder extraPramaDic:nil] autorelease];
                                [prama setOrderCode:[NSString stringWithFormat:@"%lld",result]];
                                [DoTracking doJsTrackingWithParma:prama];
                            } else {
                                [self performSelectorOnMainThread:@selector(showError:) withObject:@"提交订单失败" waitUntilDone:NO];
                            }
                        } else {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"保存抵用券失败" waitUntilDone:NO];
                        }
                    } else {//不需要保存抵用卷
                        //提交订单
                        result=[service submitOrderEx:[GlobalValue getGlobalValueInstance].token];
                        if (result>0) {
                            [self performSelectorOnMainThread:selector withObject:[NSNumber numberWithLongLong:result] waitUntilDone:NO];
                            
                            // 需设置orderCode
                            JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SubmitOrder extraPramaDic:nil] autorelease];
                            [prama setOrderCode:[NSString stringWithFormat:@"%lld",result]];
                            [DoTracking doJsTrackingWithParma:prama];
                        } else {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"提交订单失败" waitUntilDone:NO];
                        }
                    }
                } else {
                    [self performSelectorOnMainThread:@selector(showError:) withObject:@"保存发票失败" waitUntilDone:NO];
                }
            } else {
                //保存抵用卷
                if (couponNumber!=nil && ![couponNumber isEqualToString:@""]) {
                    //调接口
                    CouponCheckResult *couponCheckResult=[service saveCouponToSessionOrderV2:[GlobalValue getGlobalValueInstance].token couponNumber:couponNumber];
                    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveCoupon extraPrama:couponNumber, nil]autorelease];
                    [DoTracking doJsTrackingWithParma:prama];
                    if (couponCheckResult!=nil) {
                        //提交订单
                        result=[service submitOrderEx:[GlobalValue getGlobalValueInstance].token];
                        if (result>0) {
                            [self performSelectorOnMainThread:selector withObject:[NSNumber numberWithLongLong:result] waitUntilDone:NO];
                            
                            // 需设置orderCode
                            JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SubmitOrder extraPramaDic:nil] autorelease];
                            [prama setOrderCode:[NSString stringWithFormat:@"%lld",result]];
                            [DoTracking doJsTrackingWithParma:prama];
                        } else {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"提交订单失败" waitUntilDone:NO];
                        }
                    } else {
                        [self performSelectorOnMainThread:@selector(showError:) withObject:@"保存抵用券失败" waitUntilDone:NO];
                    }
                } else {
                    //提交订单
                    //SubmitOrderResult * resultObj = [service submitOrderV2:[GlobalValue getGlobalValueInstance].token];
                    result=[service submitOrderEx:[GlobalValue getGlobalValueInstance].token];
                    
                    DebugLog(@"-----> submit order result:%lli", result);
                    if (result>0) {
                        [self performSelectorOnMainThread:selector withObject:[NSNumber numberWithLongLong:result] waitUntilDone:NO];
                        
                        // 需设置orderCode
                        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SubmitOrder extraPramaDic:nil] autorelease];
                        [prama setOrderCode:[NSString stringWithFormat:@"%lld",result]];
                        [DoTracking doJsTrackingWithParma:prama];
                    } else {
                        [self performSelectorOnMainThread:@selector(showError:) withObject:@"提交订单失败" waitUntilDone:NO];
                    }
                }
            }
        } else {
            [self performSelectorOnMainThread:@selector(showError:) withObject:@"保存支付方式失败" waitUntilDone:NO];
        }
    } else {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"保存收货地址失败" waitUntilDone:NO];
    }
    [pool drain];
}

//取消订单
-(void)newThreadCancelOrderWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *server=[OTSServiceHelper sharedInstance];
    NSNumber *orderId=[object objectForKey:@"OrderId"];
    int result=[server cancelOrder:[GlobalValue getGlobalValueInstance].token orderId:orderId];
    if (result==1) {
        [self performSelectorOnMainThread:selector withObject:[NSNumber numberWithInt:result] waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"取消订单失败" waitUntilDone:NO];
    }
    [pool drain];
}

//获取我的订单
-(void)newThreadGetMyOrderWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    NSNumber *type=[object objectForKey:@"Type"];
    NSNumber *currentPage=[object objectForKey:@"CurrentPage"];
    Page *page = [service getMyOrderListByToken:[GlobalValue getGlobalValueInstance].token type:type currentPage:currentPage pageSize:[NSNumber numberWithInt:10]];
    
    if (page==nil || [page isKindOfClass:[NSNull class]])
    {
        [[OtsErrorHandler sharedInstance] alertNilObject];
    }
    else
    {
        if (type)
        {
            [page.userInfo setObject:type forKey:PAGE_USER_INFO_ORDER_TYPE];
        }
        
        [self performSelectorOnMainThread:selector withObject:page waitUntilDone:NO];
    }
    [pool drain];
}

//获取订单详情
-(void)newThreadGetOrderDetailWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    NSNumber *orderId=[object objectForKey:@"OrderId"];
    OrderV2 *orderV2=[service getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:orderId];
    if (orderV2==nil || [orderV2 isKindOfClass:[NSNull class]]) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:selector withObject:orderV2 waitUntilDone:NO];
    }
    [pool drain];
}

//获取我的收藏
-(void)newThreadGetMyFavoriteWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    NSNumber *currentPage=[object objectForKey:@"CurrentPage"];
    Page *page=[service getMyFavoriteList:[GlobalValue getGlobalValueInstance].token tag:nil currentPage:currentPage pageSize:[NSNumber numberWithInt:10]];
    if (page==nil || [page isKindOfClass:[NSNull class]]) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:selector withObject:page waitUntilDone:NO];
    }
    [pool drain];
}

//获取用户信息
-(void)newThreadGetSessionUserWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    //UserVO *userVO=[service getSessionUser:[GlobalValue getGlobalValueInstance].token];
    UserVO *userVO = [service getMyYihaodianSessionUser:[GlobalValue getGlobalValueInstance].token];
    if (userVO==nil || [userVO isKindOfClass:[NSNull class]]) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:selector withObject:userVO waitUntilDone:NO];
    }
    [pool drain];
}

//获取收货地址
-(void)newThreadGetGoodReceiverWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    NSArray *array=[service getGoodReceiverListByToken:[GlobalValue getGlobalValueInstance].token];
    if (array==nil || [array isKindOfClass:[NSNull class]]) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:selector withObject:array waitUntilDone:NO];
    }
    [pool drain];
}

//退出登录
-(void)newThreadLogoutWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    int result=[service logout:[GlobalValue getGlobalValueInstance].token];
    if (result!=1) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"退出登录失败" waitUntilDone:NO];
    } else {
        NSMutableDictionary* tempUserInfo=[[UserManageTool sharedInstance].m_dicUserManager objectForKey:KEY];
        [tempUserInfo setObject:@"0" forKey:KEY_AUTOLOGSTATUS];
        [[UserManageTool sharedInstance] AddOrUpdate:KEY withName:[tempUserInfo valueForKey:KEY_USER_NAME] withTheOneStoreAccount:[tempUserInfo valueForKey:KEY_THEONESTOREACCOUNT] withPass:[tempUserInfo valueForKey:KEY_USER_PASS] withRememberme:[tempUserInfo valueForKey:KEY_REMEMBER] withCocode:[tempUserInfo valueForKey:KEY_COCODE] withUnionlogin:[tempUserInfo valueForKey:KEY_UNIONLOGIN] withNickname:[tempUserInfo valueForKey:KEY_NICKNAME] withUserimg:[tempUserInfo valueForKey:KEY_USERIMG] withAutoLoginStatus:[tempUserInfo valueForKey:KEY_AUTOLOGSTATUS] withNeedToSave:YES];

        [self performSelectorOnMainThread:selector withObject:[NSNumber numberWithInt:result] waitUntilDone:NO];
    }
    [pool drain];
}

//重新购买
-(void)newThreadRebuyWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];

    NSNumber *orderId=[object objectForKey:@"OrderId"];
    
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    
   int result = [service rebuyOrder:[GlobalValue getGlobalValueInstance].token orderId:orderId];

    if (result==1) {
        [self performSelectorOnMainThread:selector withObject:[NSNumber numberWithInt:result] waitUntilDone:NO];
    } else {
        [self performInMainBlock:^{
            
            //808080
            [self showError:@"重新购买失败" tag:808080];
            [self enterCart];
            //[SharedPadDelegate.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
    [pool drain];
}

//加入购物车
-(void)newThreadAddCartWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    NSMutableArray *productIds=[object objectForKey:@"ProductIds"];
    if (productIds == nil || productIds.count <= 0)
    {
        [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
        return; // no product need to be added
    }
    
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    
    NSMutableArray *merchantIds=[object objectForKey:@"MerchantIds"];
    NSMutableArray *quantitys=[object objectForKey:@"Quantitys"];
    NSMutableArray *promotionIds=[object objectForKey:@"PromotionIds"];
    
    NSMutableArray *lmerchantIds=[NSMutableArray array];
    NSMutableArray *lquantitys=[NSMutableArray array];
    NSMutableArray *lpromotionIds=[NSMutableArray array];
    NSMutableArray *lproductIds=[NSMutableArray array];

    for (int i=promotionIds.count;i>0;i--) {
        NSString*promotionId=[promotionIds objectAtIndex:i-1];
        NSNumber*merchantid=[merchantIds objectAtIndex:i-1];
        NSNumber*quantity=[quantitys objectAtIndex:i-1];
        NSNumber*productid=[productIds objectAtIndex:i-1];
        
        if (promotionId!=nil&&[promotionId rangeOfString:@"landingpage"].location!=NSNotFound) {
            [lmerchantIds addObject:merchantid];
            [lproductIds addObject:productid];
            [lpromotionIds addObject:promotionId];
            [lquantitys addObject:quantity];
            
            [productIds removeObjectAtIndex:i-1];
            [merchantIds removeObjectAtIndex:i-1];
            [quantitys removeObjectAtIndex:i-1];
        }
    }
    AddProductResult* result1=nil;
    AddProductResult* result=nil;
    if (productIds.count>0) {
        result=[service addNormalProducts:[GlobalValue getGlobalValueInstance].token productIds:productIds merchantIds:merchantIds quantitys:quantitys];
        if(result.resultCode.intValue!=1){
//            [[OtsErrorHandler sharedInstance] alertNilObject];
            [self showError:result.errorInfo tag:808080];
            return;

        }
        
    }
    if (lpromotionIds.count>0) {
         result1=[service addLandingpageProducts:[GlobalValue getGlobalValueInstance].token productIds:lproductIds merchantIds:lmerchantIds quantitys:lquantitys promotionids:lpromotionIds];
        if (result1!=nil&&result1.resultCode.intValue==0) {
//            [[OtsErrorHandler sharedInstance] alertNilObject];
            [self showError:result.errorInfo tag:808080];
            return;
        }
    }
    [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];

//    NSArray *array=[service addProductsV2:[GlobalValue getGlobalValueInstance].token productIds:productIds merchantIds:merchantIds quantitys:quantitys promotionids:promotionIds];
//    if(result.resultCode.intValue!=1)
//    if (array==nil || [array isKindOfClass:[NSNull class]])
//    {
//        [[OtsErrorHandler sharedInstance] alertNilObject];
//        [self performSelectorOnMainThread:@selector(showError:) withObject:[NSString stringWithString:@"网络异常，请检查网络配置..."] waitUntilDone:NO];
//    }
//    else
//    {
//        for (AddProductResult *result in array)
//        {
//            if ([[result resultCode] intValue]!=1)
//            {
//                [self performInMainBlock:^{
//                
//                    
//                    //808080 加入购物车失败
//                    [[DataHandler sharedDataHandler].cart.buyItemList removeAllObjects];
//                    [self showError:result.errorInfo tag:808080];
//                    [self enterCart];
//                    //[SharedPadDelegate.navigationController popToRootViewControllerAnimated:NO];
//                    
//                }];
//                
//                break;
//            }
//        }
//        [self performSelectorOnMainThread:selector withObject:array waitUntilDone:NO];
//        [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];

//    }
    
    [pool drain];
}

-(void)enterCart
{
    [SharedPadDelegate.navigationController popToRootViewControllerAnimated:NO];
    [SharedPadDelegate enterCart];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartCacheChange object:nil];
}

//获取购物车
-(void)newThreadGetSessionCartWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    CartVO *cartVO=[service getSessionCart:[GlobalValue getGlobalValueInstance].token];
    if (cartVO==nil || [cartVO isKindOfClass:[NSNull class]]) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:selector withObject:cartVO waitUntilDone:NO];
    }
    [pool drain];
}

//登录
-(BOOL)newThreadLoginWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
//    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
//    NSNumber *provinceId=[object objectForKey:@"ProvinceId"];
    NSString *userName=[object objectForKey:@"UserName"];
    NSString *passWord=[object objectForKey:@"PassWord"];
//    NSString *result=[service login:[GlobalValue getGlobalValueInstance].trader provinceId:provinceId username:userName password:passWord];
    
    OTSLgoinParam *param = [[[OTSLgoinParam alloc] init] autorelease];
    param.userName = userName;
    param.password = passWord;
    param.verifyCode = [object objectForKey:@"VerifyCode"];
    param.tempoToken = [object objectForKey:@"TempToken"];
    
    [[OTSUserLoginHelper sharedInstance] loginWithParam:param];
    
    
//    if (result==nil || [result isKindOfClass:[NSNull class]])
//    {
//        [self performSelectorOnMainThread:@selector(showError:)
//                               withObject:@"网络异常，请检查网络配置..."
//                            waitUntilDone:NO];
//    }
//    else
//    {
//        if ([result isEqualToString:@"-1"])
//        {
//            [self performSelectorOnMainThread:@selector(showError:)
//                                   withObject:@"用户名不正确"
//                                waitUntilDone:NO];
//            
//        }
//        else if ([result isEqualToString:@"-2"])
//        {
//            [self performSelectorOnMainThread:@selector(showError:)
//                                   withObject:@"密码不正确"
//                                waitUntilDone:NO];
//        } else {
//            [self performSelectorOnMainThread:selector
//                                   withObject:result
//                                waitUntilDone:NO];
//        }
//    }
    
    if ([OTSUserLoginHelper sharedInstance].isNilResult)
    {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常,请稍候再试..." waitUntilDone:NO];
	}
    
    else if ([OTSUserLoginHelper sharedInstance].isResultHasError)
    {
                
        [self performSelectorOnMainThread:@selector(showError:) withObject:[OTSUserLoginHelper sharedInstance].loginResult.errorInfo waitUntilDone:NO];
    }
    
    else if ([OTSUserLoginHelper sharedInstance].isLoginSuccess)
    {
        [self performSelectorOnMainThread:selector
                               withObject:[OTSUserLoginHelper sharedInstance].loginResult.token
                            waitUntilDone:NO];
    }
    
    
    [pool drain];
    
    return [OTSUserLoginHelper sharedInstance].isLoginSuccess;
}

//联合登录
-(void)newThreadUnionLoginWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    
    //NSNumber *provinceId=[object objectForKey:@"ProvinceId"];
    NSString *userName=[object objectForKey:@"UserName"];
    NSString *realUserName=[object objectForKey:@"RealUserName"];
    NSString *cocode=[object objectForKey:@"Cocode"];
    
    OTSLgoinParam *param = [[[OTSLgoinParam alloc] init] autorelease];
    param.userName = userName;
    param.realuserName = realUserName;
    param.cocode = cocode;
    [[OTSUserLoginHelper sharedInstance] unionLoginWithParam:param];
    
    
    
    if ([OTSUserLoginHelper sharedInstance].isNilResult)
    {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常,请稍候再试..." waitUntilDone:NO];
	}
    else if ([OTSUserLoginHelper sharedInstance].isResultHasError)
    {
        [self performSelectorOnMainThread:@selector(showError:) withObject:[OTSUserLoginHelper sharedInstance].loginResult.errorInfo waitUntilDone:NO];
    }
    else if ([OTSUserLoginHelper sharedInstance].isLoginSuccess)
    {
        [[GlobalValue getGlobalValueInstance] setNickName:realUserName];
        [[GlobalValue getGlobalValueInstance] setIsUnionLogin:YES];
        
        [self performSelectorOnMainThread:selector
                               withObject:[OTSUserLoginHelper sharedInstance].loginResult.token
                            waitUntilDone:NO];
	}

    
    
    
//    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
//    NSString *result=[service unionLogin:[GlobalValue getGlobalValueInstance].trader provinceId:provinceId userName:userName realUserName:realUserName cocode:cocode];
//    if (result==nil || [result isKindOfClass:[NSNull class]]) {
//        [self performSelectorOnMainThread:@selector(showError:) withObject:[NSString stringWithString:@"网络异常，请检查网络配置..."] waitUntilDone:NO];
//    } else {
//        if ([result isEqualToString:@"-1"]) {
//            [self performSelectorOnMainThread:@selector(showError:) withObject:[NSString stringWithString:@"用户名不正确"] waitUntilDone:NO];
//        } else if ([result isEqualToString:@"-2"]) {
//            [self performSelectorOnMainThread:@selector(showError:) withObject:[NSString stringWithString:@"密码不正确"] waitUntilDone:NO];
//        } else {
//            [self performSelectorOnMainThread:selector withObject:result waitUntilDone:NO];
//        }
//    }
    
    [pool drain];
}

//自动登录
-(void)initLocalCart
{
    if ([GlobalValue getGlobalValueInstance].token==nil) {
        //读取本地购物车
        NSArray *array=[[OTSServiceHelper sharedInstance] getLocalCartArrayWithFilePath:[[DataHandler sharedDataHandler] dataFilePath:kLocalCartFilename]];
        int totalCount=0;
        double totalPrice=0.0;
        
        [[DataHandler sharedDataHandler].cart.buyItemList removeAllObjects];
        [[DataHandler sharedDataHandler].cart.gifItemtList removeAllObjects];
        [[DataHandler sharedDataHandler].cart.redemptionItemList removeAllObjects];
        
        for (LocalCartItemVO *localCartItem in array) {
            CartItemVO *cartItem=[localCartItem changeToCartItemVO];
            [[DataHandler sharedDataHandler].cart.buyItemList addObject:cartItem];
            
            totalCount+=[localCartItem productCount];
            if ([cartItem.product.promotionPrice doubleValue]>0.0001) {
                totalPrice+=[cartItem.product.promotionPrice doubleValue]*[cartItem.buyQuantity intValue];
            } else {
                totalPrice+=[cartItem.product.price doubleValue]*[cartItem.buyQuantity intValue];
            }
        }
        
        [DataHandler sharedDataHandler].cart.totalquantity=[NSNumber numberWithInt:totalCount];
        [DataHandler sharedDataHandler].cart.totalprice=[NSNumber numberWithDouble:totalPrice];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
    }
}

-(void)newThreadAutoLoginWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    NSString *loginResult;
    if ([[[UserManageTool sharedInstance] GetUnionLogin] isEqualToString:@"LOGIN"]) {
        loginResult=[service login:[GlobalValue getGlobalValueInstance].trader provinceId:[GlobalValue getGlobalValueInstance].provinceId username:[[UserManageTool sharedInstance] GetUserName] password:[[UserManageTool sharedInstance] GetUserPass]];
    } else if ([[[UserManageTool sharedInstance] GetUnionLogin] isEqualToString:@"UNIONLOGIN"]) {
        loginResult=[service unionLogin:[GlobalValue getGlobalValueInstance].trader provinceId:[GlobalValue getGlobalValueInstance].provinceId userName:[[UserManageTool sharedInstance] GetUserName] realUserName:[[UserManageTool sharedInstance] GetNickName] cocode:[[UserManageTool sharedInstance] GetCocode]];
    } else {
        loginResult=nil;
    }
    
    if (!(loginResult==nil || [loginResult isKindOfClass:[NSNull class]] || [loginResult isEqualToString:@"-1"] || [loginResult isEqualToString:@"-2"])) {//登录成功

        [GlobalValue getGlobalValueInstance].storeToken = loginResult;
        if ([[[UserManageTool sharedInstance] GetUnionLogin] isEqualToString:@"UNIONLOGIN"]) {
            [[GlobalValue getGlobalValueInstance] setNickName:[[UserManageTool sharedInstance] GetNickName]];
            [[GlobalValue getGlobalValueInstance] setUserImg:[[UserManageTool sharedInstance] GetUserImg]];
            [[GlobalValue getGlobalValueInstance] setIsUnionLogin:YES];
        }
        [self newThreadGetSessionCartWithObject:nil finishSelector:selector];
    } else {//登录失败
        [GlobalValue getGlobalValueInstance].storeToken = nil;
        
        if ([[[UserManageTool sharedInstance] GetUnionLogin] isEqualToString:@"UNIONLOGIN"]) {
            [[GlobalValue getGlobalValueInstance] setNickName:nil];
            [[GlobalValue getGlobalValueInstance] setUserImg:nil];
            [[GlobalValue getGlobalValueInstance] setIsUnionLogin:NO];
        }
        [self performSelectorOnMainThread:@selector(initLocalCart) withObject:nil waitUntilDone:NO];
    }
    [service release];
	[pool drain];
}

//获取验证码
-(void)newThreadGetVerifyCodeWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    VerifyCodeVO *verifyCodeVO=[service getVerifyCodeUrl:[GlobalValue getGlobalValueInstance].trader];
    if (verifyCodeVO==nil || [verifyCodeVO isKindOfClass:[NSNull class]]) {
        DebugLog(@"网络异常，注册验证码获取失败...");
        // 这里将alert关掉
        //[self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:selector withObject:verifyCodeVO waitUntilDone:NO];
    }
    [pool drain];
}

//注册
-(void)newThreadRegisteWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    OTSServiceHelper *service=[OTSServiceHelper sharedInstance];
    NSString *userName=[object objectForKey:@"UserName"];
    NSString *passWord=[object objectForKey:@"PassWord"];
    NSString *verifyCode=[object objectForKey:@"VerifyCode"];
    NSString *tempToken=[object objectForKey:@"TempToken"];
    int result=[service registerAct:[GlobalValue getGlobalValueInstance].trader username:userName password:passWord verifycode:verifyCode tempToken:tempToken];
    if (result==1) {
        [self performSelectorOnMainThread:selector withObject:[NSNumber numberWithInt:result] waitUntilDone:NO];
    } else if (result==0) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"注册失败" waitUntilDone:NO];
    } else if (result==-1) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"用户名格式错误" waitUntilDone:NO];
    } else if (result==-2) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"密码格式错误" waitUntilDone:NO];
    } else if (result==-3) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"用户已经存在" waitUntilDone:NO];
    } else if (result==-4) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"验证码错误" waitUntilDone:NO];
    } else if (result==-5) {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"注册用户太多" waitUntilDone:NO];
    }
    [pool drain];
}

#pragma mark - 线程
-(void)setUpThreadWithStatus:(int)status showLoading:(BOOL)showLoading withObject:(NSMutableDictionary *)object finishSelector:(SEL)selector
{
    if (!m_ThreadRunning) {
        m_ThreadRunning=YES;
        m_ThreadStatus=status;
        if (m_Dictionary!=nil) {
            [m_Dictionary release];
        }
        m_Dictionary=[object retain];
        m_FinishSEL=selector;
        [self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
    }
}

-(void)startThread
{
    while (m_ThreadRunning) {
        @synchronized(self) {
            switch (m_ThreadStatus) {
                case THREAD_STATUS_SUBMIT_ORDER: {//提交订单
                    [self newThreadSubmitOrderWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_CANCEL_ORDER: {//取消订单
                    [self newThreadCancelOrderWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_GET_MY_ORDER: {//获取我的订单
                    [self newThreadGetMyOrderWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_GET_ORDER_DETAIL: {//获取订单详情
                    [self newThreadGetOrderDetailWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_GET_MY_FAVORITE: {//获取我的收藏
                    [self newThreadGetMyFavoriteWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_GET_SESSION_USER: {//获取用户信息
                    [self newThreadGetSessionUserWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_GET_GOOD_RECEIVER: {//获取收货地址
                    [self newThreadGetGoodReceiverWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_LOGOUT: {//退出登录
                    [self newThreadLogoutWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_ADD_PRODUCTS_TO_CART: {//加入购物车
                    [self newThreadAddCartWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_REBUY_TO_CART://重新加入购物车
                {
                    [self newThreadRebuyWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_GET_SESSION_CART: {//获取购物车
                    [self newThreadGetSessionCartWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_LOGIN: {//登录
                    [self newThreadLoginWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_UNION_LOGIN: {//联合登录
                    [self newThreadUnionLoginWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_GET_VERIFY_CODE: {//获取验证码
                    [self newThreadGetVerifyCodeWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                case THREAD_STATUS_REGISTE: {//注册
                    [self newThreadRegisteWithObject:m_Dictionary finishSelector:m_FinishSEL];
                    break;
                }
                default:
                    break;
            }
            [self stopThread];
        }
    }
}

-(void)stopThread
{
    m_ThreadRunning=NO;
    m_ThreadStatus=-1;
}

-(void)showError:(NSString *)error
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


-(void)showError:(NSString *)error tag:(int)aTag
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertView.tag = aTag;
    [alertView show];
    [alertView release];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

#pragma mark - hover in and out
-(void)moveHoverView:(UIView*)aView inOrOut:(BOOL)aInOrOut
{
    [self moveHoverView:aView inOrOut:aInOrOut offsetY:0];
}

-(void)moveHoverView:(UIView*)aView inOrOut:(BOOL)aInOrOut offsetY:(int)aOffsetY
{
    [self moveHoverView:aView inOrOut:aInOrOut offsetX:kCateDetailViewX offsetY:aOffsetY];
}

-(void)moveHoverView:(UIView*)aView inOrOut:(BOOL)aInOrOut offsetX:(int)aOffsetX offsetY:(int)aOffsetY
{
    if (self.semiTransBgView == nil)
    {
        self.semiTransBgView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
        self.semiTransBgView.backgroundColor = [UIColor grayColor];
        self.semiTransBgView.layer.opacity = .5f;
    }
    
    
    if (aView)
    {
        CGRect viewRC = CGRectOffset(aView.frame, 0, aOffsetY);
        aView.frame = viewRC;
        CGRect bgRc = CGRectOffset(self.view.bounds, 0, aOffsetY);
        self.semiTransBgView.frame = bgRc;
        
        float posX = aInOrOut ? aOffsetX : dataHandler.screenWidth;
        CGRect destRc = aView.frame;
        destRc.origin.x = posX;
        
        if (aInOrOut)   // 划入
        {
            [self.semiTransBgView removeFromSuperview];
            [self.view addSubview:self.semiTransBgView];
            [self.view addSubview:aView];
            
            CGRect viewRc = aView.frame;
            viewRc.origin.x = dataHandler.screenWidth;
            aView.frame = viewRc;
        }
        
        [UIView animateWithDuration:kShowCateDetailDuration animations:^{
            
            aView.frame = destRc;
            
        } completion:^(BOOL completed){
            
            if (!aInOrOut)
            {
                [self.semiTransBgView removeFromSuperview];
                [aView removeFromSuperview];
            }
            
            [self moveActionCompleted:aInOrOut view:aView];
            
        }];
    }
}

-(void)moveActionCompleted:(BOOL)isMoveIn view:(UIView*)aView
{
    
}

-(BOOL)loginIfNeeded
{
    if ([GlobalValue getGlobalValueInstance].token == nil)
    {
        self.loginVC = [[[LoginViewController alloc] init] autorelease];
        [self.loginVC setMcart:[DataHandler sharedDataHandler].cart];
        if (self.loginVC.mcart.totalquantity != 0)
        {
            [self.loginVC setMneedToAddInCart:YES];
        }
        
        [self moveHoverView:self.loginVC.view inOrOut:YES];
        
        return NO;
    }

    return YES;
}

-(void)popLoginView
{
    [self moveHoverView:self.loginVC.view inOrOut:NO];
}

@end
