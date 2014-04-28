//
//  OTSServiceHelper.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSServiceHelper.h"

#import "CentralMobileFacadeService.h"
#import "UserService.h"
#import "MicroBlogService.h"
#import "LocalCartService.h"
#import "AddressService.h"
#import "ProductService.h"
#import "SearchService.h"
#import "SystemService.h"
#import "FeedbackService.h"
#import "CartService.h"
#import "FavoriteService.h"
#import "CouponService.h"
#import "MessageService.h"
#import "OrderService.h"
#import "PayService.h"
#import "GroupBuyService.h"
#import "AdvertisementServer.h"
#import "PromotionService.h"
#import <objc/runtime.h>

//// 服务类型
//typedef enum EOTSServiceType
//{
//    KOTSServiceCentralMobileFacade = 0
//    , KOTSServiceUser
//    , KOTSServiceMicroBlog
//    , KOTSServiceLocalCart
//    , KOTSServiceAddress
//    , KOTSServiceProduct
//    , KOTSServiceSearch
//    , KOTSServiceSystem
//    , KOTSServiceFeedback
//    , KOTSServiceCart
//    , KOTSServiceFavorite
//    , KOTSServiceCoupon
//    , KOTSServiceMessage
//    , KOTSServiceOrder
//    , KOTSServicePay
//    , KOTSServiceGroupBuy
//    , KOTSServiceAdvertisement
//}EOTSServiceType;
//
//
//@interface OTSServiceInvoker : NSObject
//{
//    id      target;
//}
//
//- (id)initWithType:(EOTSServiceType)aServiceType;
//@end
//
//@implementation OTSServiceInvoker
//
//+(id)serviceWithType:(EOTSServiceType)aServiceType
//{
//    id service = nil;
//    
//    switch (aServiceType) 
//    {
//        case KOTSServiceCentralMobileFacade:
//        {
//            service = [[[CentralMobileFacadeService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceUser:
//        {
//            service = [[[UserService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceMicroBlog:
//        {
//            service = [[[MicroBlogService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceLocalCart:
//        {
//            service = [[[CartService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceAddress:
//        {
//            service = [[[AddressService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceProduct:
//        {
//            service = [[[ProductService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceSearch:
//        {
//            service = [[[SearchService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceSystem:
//        {
//            service = [[[SystemService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceFeedback:
//        {
//            service = [[[FeedbackService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceCart:
//        {
//            service = [[[CartService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceFavorite:
//        {
//            service = [[[FavoriteService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceCoupon:
//        {
//            service = [[[CouponService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceMessage:
//        {
//            service = [[[MessageService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceOrder:
//        {
//            service = [[[OrderService alloc] init] autorelease]; 
//        }
//            break;
//            
//        case KOTSServicePay:
//        {
//            service = [[[PayService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceGroupBuy:
//        {
//            service = [[[GroupBuyService alloc] init] autorelease];
//        }
//            break;
//            
//        case KOTSServiceAdvertisement:
//        {
//            service = [[[AdvertisementServer alloc] init] autorelease];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    return service;
//}
//
//
//- (void)forwardInvocation:(NSInvocation *)invocation
//{
//    SEL aSelector = [invocation selector];
//    
//    if ([target respondsToSelector:aSelector])
//    {
//        [invocation invokeWithTarget:target];
//    }
//    else
//    {
//        [self doesNotRecognizeSelector:aSelector];
//    }
//}
//
//- (id)initWithType:(EOTSServiceType)aServiceType
//{
//    self = [super init];
//    if (self) 
//    {
//        target = [[OTSServiceInvoker serviceWithType:aServiceType] retain];
//    }
//    return self;
//}
//
//-(void)dealloc
//{
//    [target release];
//    [super dealloc];
//}
//
//@end

@implementation OTSServiceHelper


//-(id)invokeTarget:(id)aTarget selector:(SEL)aSelector signature:(NSMethodSignature*)aSignature
//{
//    //NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
//    
//    //NSMethodSignature *sig= [[aTarget class] instanceMethodSignatureForSelector:aSelector];
//    NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:aSignature];
//    
//    [invocation setTarget:aTarget];
//    [invocation setSelector:aSelector];
//    
//    //设置参数
////    if (aParams && [aParams count] > 0)
////    {
////        int paramCount = [aParams count];
////        for (int i = 0; i < paramCount; i++)
////        {
////            id parameter = [aParams objectAtIndex:i];
////            
////            [invocation setArgument:&parameter atIndex:i + 2];
////        }
////    }
//    
//    [invocation retainArguments];
//    
//    [invocation invoke];
//    
//    //返回值处理
//    
//    const char *returnType = aSignature.methodReturnType;
//    //声明返回值变量
//    id returnValue = nil;
//    //如果没有返回值，也就是消息声明为void，那么returnValue=nil
//    if( !strcmp(returnType, @encode(void)) )
//    {
//        returnValue =  nil;
//    }
//    
//    //如果返回值为对象，那么为变量赋值
//    else if( !strcmp(returnType, @encode(id)) )
//    {
//        [invocation getReturnValue:&returnValue];
//    }
//    else
//    {
//        //如果返回值为普通类型NSInteger  BOOL
//        
//        //返回值长度
//        NSUInteger length = [aSignature methodReturnLength];
//        //根据长度申请内存
//        void *buffer = (void *)malloc(length);
//        //为变量赋值
//        [invocation getReturnValue:buffer];
//        
//        //以下代码为参考:具体地址我忘记了，等我找到后补上，(很对不起原作者)
//        if(!strcmp(returnType, @encode(BOOL)) ) 
//        {
//            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
//        }
//        else if(!strcmp(returnType, @encode(NSInteger)) )
//        {
//            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
//        }
//        
//        returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
//    }
//    
//    return returnValue;
//}







- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL aSelector = [invocation selector];
    
    if (theRespondClass)
    {
        id service = [[[theRespondClass alloc] init] autorelease];
        if ([service respondsToSelector:aSelector])
        {
            [invocation invokeWithTarget:service];
        }
    }
    else
    {
        [self doesNotRecognizeSelector:aSelector];
    }
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector 
{
    for (Class cls in serviceClasses)
    {
        DebugLog(@"class name:%@", [cls description]);
        
        if (class_respondsToSelector(cls, aSelector))
        {
            NSMethodSignature *sig = [cls instanceMethodSignatureForSelector:aSelector];
            
            if (sig)
            {
                theRespondClass = cls;
                return sig;
            }
        }
        
    }
    
    theRespondClass = NULL;
    return nil;
}


//---------------------------------------------------------------------

#pragma mark - singleton methods
static OTSServiceHelper *sharedInstance = nil;

+ (OTSServiceHelper *)sharedInstance
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [[self alloc] init]; 
            sharedInstance->serviceClasses = [[NSArray alloc] initWithObjects:[CentralMobileFacadeService class]
                                              , [UserService class]
                                              , [MicroBlogService class]
                                              , [LocalCartService class]
                                              , [AddressService class]
                                              , [ProductService class]
                                              , [SearchService class]
                                              , [SystemService class]
                                              , [FeedbackService class]
                                              , [CartService class]
                                              , [FavoriteService class]
                                              , [CouponService class]
                                              , [MessageService class]
                                              , [OrderService class]
                                              , [PayService class]
                                              , [GroupBuyService class]
                                              , [AdvertisementServer class]
                                              , [PromotionService class]
                                              , nil];
        } 
    } 
    
    return sharedInstance; 
} 

+ (id)allocWithZone:(NSZone *)zone 
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [super allocWithZone:zone]; 
            return sharedInstance; 
        } 
    } 
    
    return nil; 
} 

- (id)copyWithZone:(NSZone *)zone 
{ 
    return self; 
} 

- (id)retain 
{ 
    return self; 
} 

- (NSUInteger)retainCount 
{ 
    return NSUIntegerMax; 
} 

- (oneway void)release
{ 
} 

- (id)autorelease 
{ 
    return self; 
}
@end

