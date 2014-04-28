//
//  PayService.m
//  TheStoreApp
//
//  Created by yangxd on 11-7-25.
//  Copyright 2011 vsc. All rights reserved.
//

#import "PayService.h"
#import "NeedCheckResult.h"
#import "SendValidCodeResult.h"
#import "CheckSmsResult.h"
#import "SavePayByAccountResult.h"
#import "GlobalValue.h"
#import "UserAccountLogVO.h"
#import "OTSUtility.h"

@implementation PayService

-(Page *)getBankVOList:(Trader *)trader name:(NSString *)name type:(NSNumber *)type currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setDictionary:[trader toParamDict]];
    if(name)
        [paramDict setObject:name forKey:@"name"];
    if(type)
        [paramDict setObject:type forKey:@"type"];
    if(currentPage)
        [paramDict setObject:currentPage forKey:@"currentPage"];
    if(pageSize)
        [paramDict setObject:pageSize forKey:@"pageSize"];
    
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd)
                         requestParameter:paramDict];
    [paramDict release];
    
    if (ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page *)ret;
        return po;
    } else {
        return nil;
    }
}


#pragma mark - 余额支付
-(NeedCheckResult *)needSmsCheck:(NSString *)aToken 
                    payByAccount:(NSNumber*)aPayByAccount
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addDouble:aPayByAccount];
    
    id ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    NeedCheckResult *po = nil;
    if(ret && [ret isKindOfClass:[NeedCheckResult class]]) 
    {
        po = (NeedCheckResult*) ret;
    }
    
    return po;
}

-(SendValidCodeResult *)sendValidCodeToUserBindMobile:(NSString *)aToken 
                                               mobile:(NSString *)aMobile
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addString:aMobile];
    
    id ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    SendValidCodeResult *po = nil;
    if(ret && [ret isKindOfClass:[SendValidCodeResult class]]) 
    {
        po = (SendValidCodeResult*) ret;
    }
    
    return po;
}

-(CheckSmsResult *)checkSms:(NSString *)aToken 
                  validCode:(NSString *)aValidCode
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addString:aValidCode];
    
    id ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    CheckSmsResult *po = nil;
    if(ret && [ret isKindOfClass:[CheckSmsResult class]]) 
    {
        po = (CheckSmsResult*) ret;
    }
    
    return po;
}

-(SavePayByAccountResult *)savePayByAccount:(NSString *)aToken 
                               payByAccount:(NSNumber*)aPayByAccount 
                                  validCode:(NSString*)aValidCode 
                                       type:(NSNumber*)aType
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addDouble:aPayByAccount];
    [body addString:aValidCode];
    [body addInteger:aType];
    
    id ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    SavePayByAccountResult *po = nil;
    if(ret && [ret isKindOfClass:[SavePayByAccountResult class]]) 
    {
        po = (SavePayByAccountResult*) ret;
    }
    
    return po;
}
-(SavePayByAccountResult *)savePayByAccount:(NSString *)aToken
                               payByAccount:(NSNumber*)aPayByAccount
                                  validCode:(NSString*)aValidCode
                                       type:(NSNumber*)aType
                                accountType:(NSNumber*)accountType{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:aToken];
    [body addDouble:aPayByAccount];
    [body addString:aValidCode];
    [body addInteger:aType];
    [body addInteger:accountType];
    
    id ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    SavePayByAccountResult *po = nil;
    if(ret && [ret isKindOfClass:[SavePayByAccountResult class]])
    {
        po = (SavePayByAccountResult*) ret;
    }
    
    return po;
}
-(Page*)getUserAcountLogList:(NSString*)token 
					  sattus:(NSNumber*)sattus 
						type:(NSNumber*)type
			 amountDirection:(NSNumber*)amountDirection 
				 currentPage:(NSNumber*)currentPage 
					pageSize:(NSNumber*)pageSize
{
	MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:sattus];
    [body addInteger:type];
    [body addInteger:amountDirection];
	[body addInteger:currentPage];
	[body addInteger:pageSize];
    
    id ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    Page *po = nil;
    if(ret && [ret isKindOfClass:[Page class]]) 
    {
        po = (Page*) ret;
    }
    
    return po;
}

@end
