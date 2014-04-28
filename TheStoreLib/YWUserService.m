//
//  YWUserService.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-14.
//
//

#import "YWUserService.h"
#import "LoginResultInfo.h"
#import "ResponseInfo.h"
#import "UserInfo.h"
#import "RegistResultInfo.h"

@implementation YWUserService

- (LoginResultInfo *)login:(NSDictionary *)paramDic
{
    
    DebugLog(@"test520 自动登陆 YWUserService login");
    ResponseInfo *response = [self startRequestWithMethod:@"customer.login" param:paramDic];
    LoginResultInfo *loginInfo = [[LoginResultInfo alloc] init];
    loginInfo.responseCode = response.statusCode;
    loginInfo.bRequestStatus = response.isSuccessful;
    loginInfo.errorInfo = response.desc;
   
    if (loginInfo.responseCode != -100)  //response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        if (dataDic)
        {
            loginInfo.resultCode = [dataDic[@"result"] intValue];
            
            NSDictionary *userDic = dataDic[@"user"];
            if (userDic)
            {
                
                int resultCode = [userDic[@"result"] intValue];
                NSString *token = userDic[@"token"];
                NSString *security = userDic[@"security"];
                loginInfo.resultCode = resultCode;
                loginInfo.token = token;
                loginInfo.security = security;
                
                NSDictionary *customerDic = userDic[@"customer"];
                UserInfo *userInfo = [[UserInfo alloc] init];
                userInfo.telephone = customerDic[@"telephone"];
                userInfo.name = customerDic[@"name"];
                userInfo.uid = customerDic[@"id"]; //ctm.....什么id居然是用户名，。。。这是什么破系统啊。。。。cao 
                userInfo.type = customerDic[@"type"];
                userInfo.loginMobile = customerDic[@"loginMobile"];
                userInfo.partnerType = customerDic[@"partnerType"];
                userInfo.cellphone = customerDic[@"cellphone"];
                userInfo.partnerName = customerDic[@"partnerName"];
                userInfo.salt = customerDic[@"salt"];
                userInfo.loginEmail = customerDic[@"loginEmail"];
                userInfo.isDeleted = customerDic[@"isDeleted"];
                userInfo.createDate = customerDic[@"createDate"];
                userInfo.userLevelStartTime = customerDic[@"userLevelStartTime"];
                userInfo.userLevelId = customerDic[@"userLevelId"];
                userInfo.password = customerDic[@"password"];
                userInfo.email = customerDic[@"email"];
                
                userInfo.modifyDate = customerDic[@"modifyDate"];
                userInfo.income = customerDic[@"income"];
                userInfo.enterCount = customerDic[@"enterCount"];
                userInfo.openId = customerDic[@"openId"];
                userInfo.status = customerDic[@"status"];
                userInfo.ipAddress = customerDic[@"ipaddress"];
                userInfo.userScore = customerDic[@"userscore"];
                userInfo.lastLoginTime = customerDic[@"lastLoginTime"];
                userInfo.registerIP = customerDic[@"registerIP"];
                userInfo.nickName = customerDic[@"nickName"];
                userInfo.ecUserId = [customerDic[@"ecUserId"] stringValue];
                userInfo.birthDay = customerDic[@"birthDay"];
                userInfo.gender = customerDic[@"gender"];
                userInfo.userLevelEndTime = customerDic[@"userLevelEndTime"];
                userInfo.userId = customerDic[@"userId"];
                
                loginInfo.userInfo = userInfo;
                [userInfo release];
            }
        }
    }
    return [loginInfo autorelease];
}
- (RegistResultInfo *)regist:(NSDictionary *)paramDic
{
//    NSString * requestMethod = [NSString stringWithFormat:@"customer.reg%@",[self convertParam2String:paramDic]];
    ResponseInfo *response = [self startRequestWithMethod:@"customer.reg" param:paramDic];
    RegistResultInfo *loginInfo = [[RegistResultInfo alloc] init];
    loginInfo.responseCode = response.statusCode;
    loginInfo.bRequestStatus = response.isSuccessful;
    loginInfo.errorInfo = response.desc;
    if (response.statusCode != -100) //response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        if (dataDic)
        {
            
            NSString *result = dataDic[@"result"];
            loginInfo.resultCode = [result intValue];
            
            NSDictionary *userDic = dataDic[@"user"];
            if (userDic)
            {
                
                int resultCode = [userDic[@"result"] intValue];
                NSString *token = userDic[@"token"];
                NSString *security = userDic[@"security"];
                loginInfo.resultCode = resultCode;
                loginInfo.token = token;
                loginInfo.security = security;
                
                NSDictionary *customerDic = userDic[@"customer"];
                UserInfo *userInfo = [[UserInfo alloc] init];
                userInfo.telephone = customerDic[@"telephone"];
                userInfo.name = customerDic[@"name"];
                userInfo.type = customerDic[@"type"];
                userInfo.loginMobile = customerDic[@"loginMobile"];
                userInfo.partnerType = customerDic[@"partnerType"];
                userInfo.cellphone = customerDic[@"cellphone"];
                userInfo.partnerName = customerDic[@"partnerName"];
                userInfo.salt = customerDic[@"salt"];
                userInfo.loginEmail = customerDic[@"loginEmail"];
                userInfo.isDeleted = customerDic[@"isDeleted"];
                userInfo.createDate = customerDic[@"createDate"];
                userInfo.userLevelStartTime = customerDic[@"userLevelStartTime"];
                userInfo.userLevelId = customerDic[@"userLevelId"];
                userInfo.password = customerDic[@"password"];
                userInfo.email = customerDic[@"email"];
                userInfo.uid = customerDic[@"id"] ;
                userInfo.modifyDate = customerDic[@"modifyDate"];
                userInfo.income = customerDic[@"income"];
                userInfo.enterCount = customerDic[@"enterCount"];
                userInfo.openId = customerDic[@"openId"];
                userInfo.status = customerDic[@"status"];
                userInfo.ipAddress = customerDic[@"ipaddress"];
                userInfo.userScore = customerDic[@"userscore"];
                userInfo.lastLoginTime = customerDic[@"lastLoginTime"];
                userInfo.registerIP = customerDic[@"registerIP"];
                userInfo.nickName = customerDic[@"nickName"];
                userInfo.ecUserId = [customerDic[@"ecUserId"] stringValue];
                userInfo.birthDay = customerDic[@"birthDay"];
                userInfo.gender = customerDic[@"gender"];
                userInfo.userLevelEndTime = customerDic[@"userLevelEndTime"];
                userInfo.userId = customerDic[@"userId"];
                
                loginInfo.userInfo = userInfo;
                [userInfo release];
            }
        }
    }
    return [loginInfo autorelease];
}

- (UserInfo *)getUserInfo:(NSDictionary *)paramDic
{
    NSString * requestMethod = [NSString stringWithFormat:@"customer.getuserinfo%@",[self convertParam2String:paramDic]];
    ResponseInfo *response = [self startRequestWithMethod:requestMethod];

    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        if (dataDic)
        {
            NSDictionary *userDic = dataDic[@"user"];
            if (userDic)
            {
                UserInfo *userInfo = [[UserInfo alloc] init];
                userInfo.telephone = userDic[@"telephone"];
                userInfo.name = userDic[@"name"];
                userInfo.type = userDic[@"type"];
                userInfo.loginMobile = userDic[@"loginMobile"];
                userInfo.partnerType = userDic[@"partnerType"];
                userInfo.cellphone = userDic[@"cellphone"];
                userInfo.partnerName = userDic[@"partnerName"];
                userInfo.salt = userDic[@"salt"];
                userInfo.loginEmail = userDic[@"loginEmail"];
                userInfo.isDeleted = userDic[@"isDeleted"];
                userInfo.createDate = userDic[@"createDate"];
                userInfo.userLevelStartTime = userDic[@"userLevelStartTime"];
                userInfo.userLevelId = userDic[@"userLevelId"];
                userInfo.password = userDic[@"password"];
                userInfo.email = userDic[@"email"];
                userInfo.uid = userDic[@"id"];
                userInfo.modifyDate = userDic[@"modifyDate"];
                userInfo.income = userDic[@"income"];
                userInfo.enterCount = userDic[@"enterCount"];
                userInfo.openId = userDic[@"openId"];
                userInfo.status = userDic[@"status"];
                userInfo.ipAddress = userDic[@"ipaddress"];
                userInfo.userScore = userDic[@"userscore"];
                userInfo.lastLoginTime = userDic[@"lastLoginTime"];
                userInfo.registerIP = userDic[@"registerIP"];
                userInfo.nickName = userDic[@"nickName"];
                userInfo.ecUserId = [userDic[@"ecUserId"] stringValue];
                userInfo.birthDay = userDic[@"birthDay"];
                userInfo.gender = userDic[@"gender"];
                userInfo.userLevelEndTime = userDic[@"userLevelEndTime"];
                userInfo.userId = userDic[@"userId"];
                
                userInfo.userScore = userDic[@"userscore"];
                userInfo.imgUrl = userDic[@"imgUrl"];
                userInfo.levelName = userDic[@"levelStr"];
                

                return [userInfo autorelease];
            }
        }
    }
    return nil;
}

- (LoginResultInfo *)loginUnion:(NSDictionary *)paramDic
{
    ResponseInfo *response = [self startRequestWithMethod:@"customer.joint.login" param:paramDic];
    LoginResultInfo *loginInfo = [[LoginResultInfo alloc] init];
    loginInfo.responseCode = response.statusCode;
    loginInfo.bRequestStatus = response.isSuccessful;
    loginInfo.errorInfo = response.desc;
    NSLog(@"------> %@",response.data);
    if (loginInfo.responseCode != -100)  //response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        if (dataDic)
        {
            loginInfo.resultCode = [dataDic[@"result"] intValue];
            
            NSDictionary *userDic = dataDic[@"user"];
            if (userDic)
            {
                
                int resultCode = [userDic[@"result"] intValue];
                NSString *token = userDic[@"token"];
                NSString *security = userDic[@"security"];
                loginInfo.resultCode = resultCode;
                loginInfo.token = token;
                loginInfo.security = security;
                
                NSDictionary *customerDic = userDic[@"customer"];
                UserInfo *userInfo = [[UserInfo alloc] init];
                userInfo.telephone = customerDic[@"telephone"];
                userInfo.name = customerDic[@"name"];
                userInfo.uid = customerDic[@"id"]; //ctm.....什么id居然是用户名，。。。这是什么破系统啊。。。。cao
                userInfo.type = customerDic[@"type"];
                userInfo.loginMobile = customerDic[@"loginMobile"];
                userInfo.partnerType = customerDic[@"partnerType"];
                userInfo.cellphone = customerDic[@"cellphone"];
                userInfo.partnerName = customerDic[@"partnerName"];
                userInfo.salt = customerDic[@"salt"];
                userInfo.loginEmail = customerDic[@"loginEmail"];
                userInfo.isDeleted = customerDic[@"isDeleted"];
                userInfo.createDate = customerDic[@"createDate"];
                userInfo.userLevelStartTime = customerDic[@"userLevelStartTime"];
                userInfo.userLevelId = customerDic[@"userLevelId"];
                userInfo.password = customerDic[@"password"];
                userInfo.email = customerDic[@"email"];
                
                userInfo.modifyDate = customerDic[@"modifyDate"];
                userInfo.income = customerDic[@"income"];
                userInfo.enterCount = customerDic[@"enterCount"];
                userInfo.openId = customerDic[@"openId"];
                userInfo.status = customerDic[@"status"];
                userInfo.ipAddress = customerDic[@"ipaddress"];
                userInfo.userScore = customerDic[@"userscore"];
                userInfo.lastLoginTime = customerDic[@"lastLoginTime"];
                userInfo.registerIP = customerDic[@"registerIP"];
                userInfo.nickName = customerDic[@"nickName"];
                userInfo.ecUserId = [customerDic[@"ecUserId"] stringValue];
                userInfo.birthDay = customerDic[@"birthDay"];
                userInfo.gender = customerDic[@"gender"];
                userInfo.userLevelEndTime = customerDic[@"userLevelEndTime"];
                userInfo.userId = customerDic[@"userId"];
                
                loginInfo.userInfo = userInfo;
                [userInfo release];
            }
        }
    }
    return [loginInfo autorelease];
}

@end
