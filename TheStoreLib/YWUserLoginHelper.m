//
//  YWUserLoginHelper.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-15.
//
//

#import "YWUserLoginHelper.h"
#import "YWUserService.h"
#import "LoginResultInfo.h"
#import "GlobalValue.h"
#import "YWConst.h"
@implementation YWUserLoginHelper

+ (YWUserLoginHelper *)sharedInstance
{
    static YWUserLoginHelper *sharedInstance = nil;
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}



- (void)dealloc
{
    [_loginResult release];
    [super dealloc];
}


- (BOOL)isLoginSuccess
{
    return self.loginResult.responseCode == 200 && self.loginResult.resultCode == 1;
}

- (BOOL)isNilResult
{
    return self.loginResult.userInfo == nil;
}

- (BOOL)isResultHasError
{
//    return self.loginResult.responseCode!=200 || self.loginResult.bRequestStatus == NO;
    return self.loginResult.responseCode == -100;
}



- (BOOL)loginWithType:(YWLoginType)aLoginType param:(NSDictionary *)aParam
{
    DebugLog(@"test520 自动登陆 loginWithType");
    @synchronized(self)
    {
        // 初始化
        self.loginResult = nil;
        
        // 接口调用
        switch (aLoginType)
        {
            case kYWLoginStore:
            {
                YWUserService *userSer = [[[YWUserService alloc] init] autorelease];
                self.loginResult = [userSer login:aParam];
//                [userSer release];
            }
            break;
                
            case kYWLoginQQ:case kYWLoginAlipay:
            {
                
                
                YWUserService *userSer = [[[YWUserService alloc] init] autorelease];
                self.loginResult = [userSer loginUnion:aParam];
                
            }
                break;
                
            default:
                break;
        }
        
        // 结果处理
        if (self.isLoginSuccess)
        {
            {
                //linpan 加入
                [GlobalValue getGlobalValueInstance].ywToken = self.loginResult.token;
                [GlobalValue getGlobalValueInstance].userInfo = self.loginResult.userInfo;
                if (aLoginType == kYWLoginStore)
                {
                    [GlobalValue getGlobalValueInstance].isUnionLogin = NO;
                }
                else
                {
                    [GlobalValue getGlobalValueInstance].isUnionLogin = YES;
                }
                
                [[OTSUserSwitcher sharedInstance] justSwitchToStoreUserWithToken:self.loginResult.token];
                [self performSelectorOnMainThread:@selector(loginSuccessNotification) withObject:nil waitUntilDone:NO];
            }
//            [[OTSOnlinePayNotifier sharedInstance] retrieveOrders];
        }
        else
        {
            [GlobalValue getGlobalValueInstance].storeToken = nil;
        }

        
        return [self isLoginSuccess];
    }
}

- (void)loginSuccessNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOGIN_SUCCESS object:nil];
}

@end


