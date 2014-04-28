//
//  OTSWeRockService.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import "OTSWeRockService.h"
#import "MethodBody.h"
#import "RockGameVO.h"
#import "RockGameProductVO.h"
#import "RockResultV2.h"
#import "OTSBaseServiceResult.h"
#import "OTSUtility.h"
#import "Page.h"
#import "AwardsResult.h"    
#import "UpdateStroageBoxResult.h"

@implementation OTSWeRockService

+(OTSWeRockService*)myInstance
{
    return [[[OTSWeRockService alloc] init] autorelease];
}

-(id)getFinalObjectWithMethodName:(NSString *)aMethodName methodBody:(MethodBody *)aBody ofClass:(Class)aClass
{
    id resultObj = [self getReturnObject:aMethodName methodBody:aBody];
    if(resultObj && [resultObj isKindOfClass:aClass])
    {
        return resultObj;
    }
    
    return nil;
}

-(int)createRockGame:(NSString*)aToken
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    
    return [[self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                    methodBody:body
                                       ofClass:[NSNumber class]] intValue];
}

-(RockGameVO*)getRockGameByToken:(NSString*)aToken type:(NSNumber*)aType
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addInteger:aType];
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[RockGameVO class]];
}

-(NSArray*)getPresentsByToken:(NSString*)aToken
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[NSArray class]];
}

-(long)createRockGameFlow:(NSString*)aToken rockGameFlowVO:(RockGameFlowVO*)rockGameFlowVO
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addObject:[rockGameFlowVO toXml]];
    return [[self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[NSNumber class]] longValue];
}

-(RockGameProductVO*)getRockGameProductVO:(NSNumber*)rockGameFlowID
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addLongLong:rockGameFlowID];
    
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[RockGameProductVO class]];
}

-(int)processGameFlow:(NSString*)aToken rockGameFlowID:(NSNumber*)rockGameFlowID
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addLongLong:rockGameFlowID];
    
    
    return [[self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[NSNumber class]] intValue];
}
-(InviteeResult*)isCanInviteeUser:(Trader*)atrader PhoneNum:(NSString*)phoneNum{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[atrader toXml]];
    [body addString:phoneNum];
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[InviteeResult class]];   
}

-(RockResultV2*)getRockResultV2:(Trader*)aTrader
                     provinceId:(NSNumber*)provinceId
                          token:(NSString*)aToken
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    
    if (aToken && [aToken length] > 0)  // 有token传token
    {
        [body addToken:aToken];     
    }
    else    // 没有则传trader和province id
    {
        [body addObject:[aTrader toXml]];
        [body addLongLong:provinceId];
    }
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[RockResultV2 class]];
}
-(RockResultV2*)getRockResultV3:(Trader*)trader provinceId:(NSNumber*)provinceId lng:(NSNumber*)lng lat:(NSNumber*)lat{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    
    [body addObject:[trader toXml]];
    [body addLongLong:provinceId];
    [body addDouble:lng];
    [body addDouble:lat];
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[RockResultV2 class]];
}
-(RockResultV2*)getRockResultV3:(NSString*)token lng:(NSNumber*)lng lat:(NSNumber*)lat{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    
    [body addToken:token];
    [body addDouble:lng];
    [body addDouble:lat];
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[RockResultV2 class]];
}

-(AwardsResult*)getAwardsResults:(Trader*)trader{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[AwardsResult class]];
}

-(Page*)getMyStorageBoxList:(NSString*)aToken
                          type:(NSNumber*)type
                   currentPage:(NSNumber*)currentPage
                      pageSize:(NSNumber*)pageSize
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addInteger:type];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[Page class]];
}


-(AddStorageBoxResult*)addStorageBox:(NSString*)aToken
                           productId:(NSNumber*)productId
                         promotionId:(NSString*)promotionId
                        couponNumber:(NSString*)couponNumber
                                type:(NSNumber*)type
                      couponActiveId:(NSNumber *)couponActiveId
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addLongLong:productId];
    [body addString:promotionId];
    [body addString:couponNumber];
    [body addInteger:type];
    [body addLongLong:couponActiveId];
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[AddStorageBoxResult class]];
}

-(AddCouponByActivityIdResult*)addCouponByActivityId:(NSString*)aToken
                                          activityId:(NSNumber*)activityId
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addLongLong:activityId];
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[AddCouponByActivityIdResult class]];
}


-(CheckRockResultResult*)checkRockResult:(NSString*)aToken
                               productId:(NSNumber*)productId
                             promotionId:(NSString*)promotionId
                                    type:(NSNumber*)type
                          couponActiveId:(NSNumber*)couponActiveId
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addLongLong:productId];
    [body addString:promotionId];
    [body addInteger:type];
    [body addLongLong:couponActiveId];
    
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[CheckRockResultResult class]];
}

-(UpdateStroageBoxResult*)updateStroageBoxProductType:(NSString*)token promotionIdList:(NSMutableArray*)promotionIdList productIdList:(NSMutableArray*)productIdList productStatus:(NSNumber*)productStatus{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForString:promotionIdList];
    [body addArrayForLong:productIdList];
    [body addInteger:productStatus];
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[UpdateStroageBoxResult class]];
}

-(UpdateStroageBoxResult*)updateStroageBoxProductForDelAll:(NSString*)token type:(NSNumber*)type{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:type];
    
    return [self getFinalObjectWithMethodName:CURRENT_METHOD_NAME(_cmd)
                                   methodBody:body
                                      ofClass:[UpdateStroageBoxResult class]];
}

@end
