//
//  UserService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import "UserService.h"
#import "OTSUtility.h"

@implementation UserService

//切换省份
-(int)changeProvince:(NSString *)token provinceId:(NSNumber *)provinceId
{
//    MethodBody *body=[[[MethodBody alloc] init] autorelease];
//    [body addToken:token];
//    [body addLong:provinceId];
//    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
//    if (ret!=nil && [ret isKindOfClass:[NSNumber class]])
//    {
//        NSNumber *po=(NSNumber*)ret;
//        return [po intValue];
//    } else {
//        return 0;
//    }
}
//找回密码
-(int)findPasswordByEmail:(Trader *)trader emailname:(NSString *)emailname verifycode:(NSString *)verifycode tempToken:(NSString *)tempToken
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:emailname];
    [body addString:verifycode];
    [body addString:tempToken];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//获取我的1号店用户信息
-(UserVO *)getMyYihaodianSessionUser:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[UserVO class]]) {
        UserVO *po=(UserVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取用户信息
-(UserVO *)getSessionUser:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[UserVO class]]) {
        UserVO *po=(UserVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//返回一个验证码url
-(VerifyCodeVO *)getVerifyCodeUrl:(Trader *)trader
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[VerifyCodeVO class]]) {
        VerifyCodeVO *po=(VerifyCodeVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//用户登录并返回用户信息
-(NSString *)login:(Trader *)trader provinceId:(NSNumber *)provinceId username:(NSString *)username password:(NSString *)password
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addString:username];
    [body addString:password];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[NSString class]]) {
        NSString *po=(NSString*)ret;
        return po;
    } else {
        return nil;
    }
}

//用户登录新接口
-(LoginResult *)loginV2:(Trader *)trader provinceId:(NSNumber *)provinceId username:(NSString *)username password:(NSString *)password loginSiteType:(NSNumber *)loginSiteType
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addString:username];
    [body addString:password];
    [body addInteger:loginSiteType];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[LoginResult class]]) {
        LoginResult *po=(LoginResult*)ret;
        return po;
    } else {
        return nil;
    }
}
-(LoginResult *)loginV3:(Trader *)trader provinceId:(NSNumber *)provinceId username:(NSString *)username password:(NSString *)password loginSiteType:(NSNumber *)loginSiteType verifycode:(NSString*)verifycode tempoToken:(NSString*)tempToken deviceToken:(NSString*)deviceToken{
    
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addString:username];
    [body addString:password];
    [body addInteger:loginSiteType];
    [body addString:verifycode];
    [body addString:tempToken];
    [body addString:deviceToken];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[LoginResult class]]) {
        LoginResult *po=(LoginResult*)ret;
        return po;
    } else {
        return nil;
    }
}

//退出登录
-(int)logout:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//修改用户密码
-(int)modifyPassword:(NSString *)token username:(NSString *)username oldpassword:(NSString *)oldpassword newpassword:(NSString *)newpassword
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:username];
    [body addString:oldpassword];
    [body addString:newpassword];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//用户注册
-(int)registerAct:(Trader *)trader username:(NSString *)username password:(NSString *)password verifycode:(NSString *)verifycode tempToken:(NSString *)tempToken
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:username];
    [body addString:password];
    [body addString:verifycode];
    [body addString:tempToken];
    NSObject *ret=[self getReturnObject:@"register" methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}

//用户注册新接口
-(RegisterResult *)registerV2:(Trader *)trader email:(NSString *)email userName:(NSString *)userName password:(NSString *)password verifycode:(NSString *)verifycode tempToken:(NSString *)tempToken
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:email];
    [body addString:userName];
    [body addString:password];
    [body addString:verifycode];
    [body addString:tempToken];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[RegisterResult class]]) {
        RegisterResult *po=(RegisterResult*)ret;
        return po;
    } else {
        return nil;
    }
}

-(NSString *)unionLogin:(Trader *)trader provinceId:(NSNumber *)provinceId userName:(NSString *)userName realUserName:(NSString *)realUserName cocode:(NSString *)cocode
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addString:userName];
    [body addString:realUserName];
    [body addString:cocode];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[NSString class]]) {
        NSString * po = (NSString*)ret;
        return po;
    } else {
        return nil;
    }
}
-(NSArray *)updateCartProductUnlogin:(Trader *)trader productIds:(NSArray *)productIds merchantIds:(NSArray *)merchantIds provinceId:(NSNumber *)provinceId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addArrayForLong:productIds];
    [body addArrayForLong:merchantIds];
    [body addLong:provinceId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray * po = (NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

-(NSNumber *)getUserSitetypeAndAuth:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber * po = (NSNumber*)ret;
        return po;
    } else {
        return nil;
    }
}

//手机注册 和 手机绑定
-(RegisterResult *)registerV3:(Trader *)trader email:(NSString *)email userName:(NSString *)userName password:(NSString *)password verifycode:(NSString *)verifycode tempToken:(NSString *)tempToken type:(NSNumber *)type
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:email];
    [body addString:userName];
    [body addString:password];
    [body addString:verifycode];
    [body addString:tempToken];
    [body addInteger:type];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[RegisterResult class]]) {
        RegisterResult *po=(RegisterResult*)ret;
        return po;
    } else {
        return nil;
    }
}

-(CheckUserNameResult *)checkUserName:(Trader*) trader userName:(NSString *)userName
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:userName];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[CheckUserNameResult class]]) {
        CheckUserNameResult *po=(CheckUserNameResult*)ret;
        return po;
    } else {
        return nil;
    }
}

-(SendValidCodeForPhoneRegisterResult *)sendValidCodeForPhoneRegister:(Trader*) trader mobile:(NSString *)mobile
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:mobile];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[SendValidCodeForPhoneRegisterResult class]]) {
        SendValidCodeForPhoneRegisterResult *po=(SendValidCodeForPhoneRegisterResult*)ret;
        return po;
    } else {
        return nil;
    }
}

-(CheckValidCodeForPhoneRegisterResult *)checkValidCodeForPhoneRegister:(Trader*) trader mobile:(NSString *)mobile validCode:(NSString *)validCode
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:mobile];
    [body addString:validCode];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[CheckValidCodeForPhoneRegisterResult class]]) {
        CheckValidCodeForPhoneRegisterResult *po=(CheckValidCodeForPhoneRegisterResult*)ret;
        return po;
    } else {
        return nil;
    }
}

-(BindMobileResult *)isBindMobile:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[BindMobileResult class]]) {
        BindMobileResult *po=(BindMobileResult*)ret;
        return po;
    } else {
        return nil;
    }
}

-(SendBindValidateCodeResult *)sendValidateCodeForBindMobile:(NSString *)token phone:(NSNumber *)phone
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:phone];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[SendBindValidateCodeResult class]]) {
        SendBindValidateCodeResult *po=(SendBindValidateCodeResult*)ret;
        return po;
    } else {
        return nil;
    }
}

-(BindMobileResult *)bindMobileValidate:(NSString *)token phone:(NSNumber *)phone validateCode:(NSString *)validateCode
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:phone];
    [body addString:validateCode];
    
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[BindMobileResult class]]) {
        BindMobileResult *po=(BindMobileResult*)ret;
        return po;
    } else {
        return nil;
    }
}

@end
