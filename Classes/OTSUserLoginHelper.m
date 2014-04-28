//
//  OTSUserLoginHelper.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-21.
//
//

#import "OTSUserLoginHelper.h"
#import "OTSServiceHelper.h"
#import "GlobalValue.h"
#import "UserManageTool.h"
#import "LoginResult.h"
#import "OTSOnlinePayNotifier.h"
#import "OTSOnlinePayNotifier.h"
#import "OTSUserSwitcher.h"

@implementation OTSLgoinParam
@synthesize userName, password, realuserName, cocode,verifyCode,tempoToken;
-(void)dealloc
{
    [userName release];
    [password release];
    [realuserName release];
    [cocode release];
    [verifyCode release];
    [tempoToken release];
    [super dealloc];
}
@end





@interface OTSUserLoginHelper ()
@property(retain)LoginResult* loginResult;
@property (readwrite) BOOL  isLogging;
@end

@implementation OTSUserLoginHelper
@synthesize loginResult = _loginResult;
@synthesize isLogging = _isLogging;

- (BOOL)isLoginSuccess
{
    return self.loginResult && [self.loginResult.resultCode intValue] == 1;
}

- (BOOL)isNilResult
{
    return self.loginResult == nil || [self.loginResult isKindOfClass:[NSNull class]];
}

- (BOOL)isResultHasError
{
    return self.loginResult && self.loginResult.errorInfo;
}
- (BOOL)isNeedVerifyCode
{
    return (self.loginResult.resultCode.intValue == -7 || self.loginResult.resultCode.intValue == -8
            || self.loginResult.resultCode.intValue == -9 || self.loginResult.resultCode.intValue == -10
            || self.loginResult.resultCode.intValue == -11);
}

- (BOOL)loginWithParam:(OTSLgoinParam*)aParam
{
    return [self loginWithType:kLoginStore param:aParam];
}


- (BOOL)unionLoginWithParam:(OTSLgoinParam*)aParam
{
    return [self loginWithType:kLoginUnion param:aParam];
}

- (BOOL)autoLogin
{
    @synchronized(self) {
        
        
        EOTSLoginType loginType = [self loginTypeWithString:[UserManageTool sharedInstance].GetUnionLogin];
        
        OTSLgoinParam* param = [[[OTSLgoinParam alloc] init] autorelease];
        param.userName = [UserManageTool sharedInstance].GetUserName;
        param.password = [UserManageTool sharedInstance].GetUserPass;
        param.realuserName = [UserManageTool sharedInstance].GetNickName;
        param.cocode = [UserManageTool sharedInstance].GetCocode;
        
        return [self loginWithType:loginType param:param];
    }
}

-(void)showInfo:(NSString *)info
{
    UIAlertView *alerView=[[UIAlertView  alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alerView show];
    [alerView release];
}

- (BOOL)loginWithType:(EOTSLoginType)aLoginType param:(OTSLgoinParam*)aParam
{
    @synchronized(self)
    {
        // 初始化
        self.loginResult = nil;
        
        // 接口调用
        switch (aLoginType)
        {
            case kLoginStore:
            {
                self.loginResult = [[OTSServiceHelper sharedInstance]
                                    loginV3:[GlobalValue getGlobalValueInstance].trader
                                    provinceId:[GlobalValue getGlobalValueInstance].provinceId
                                    username:aParam.userName password:aParam.password loginSiteType:[NSNumber numberWithInt:1]
                                    verifycode:aParam.verifyCode tempoToken:aParam.tempoToken deviceToken:[GlobalValue getGlobalValueInstance].deviceToken];
                
            
                _isLogging = YES;
            }
                break;
                
            case kLoginUnion:
            {
                NSString *resultStr = [[OTSServiceHelper sharedInstance]
                                       unionLogin:[GlobalValue getGlobalValueInstance].trader
                                       provinceId:[GlobalValue getGlobalValueInstance].provinceId
                                       userName:aParam.userName
                                       realUserName:aParam.realuserName
                                       cocode:aParam.cocode];
                
                // 模拟LoginResult
                if (resultStr)
                {
                    self.loginResult = [[[LoginResult alloc] init] autorelease];
                    
                    if ([resultStr isEqualToString:@"-1"] || [resultStr isEqualToString:@"-2"])
                    {
                        int resultInt = [resultStr intValue];
                        self.loginResult.resultCode = [NSNumber numberWithInt:resultInt];
                        
                        if (resultInt == -1)
                        {
                            self.loginResult.errorInfo = @"用户名不正确";
                        }
                        else if (resultInt == -2)
                        {
                            self.loginResult.errorInfo = @"密码不正确";
                        }
                        
                    }
                    else
                    {
                        self.loginResult.token = resultStr;
                        self.loginResult.resultCode = [NSNumber numberWithInt:1];
                    }
                }
            }
                break;
                
            default:
                break;
        }
        
        // 结果处理
        if (self.isLoginSuccess)
        {
            {
                [[OTSUserSwitcher sharedInstance] justSwitchToStoreUserWithToken:self.loginResult.token];
                [self performSelectorOnMainThread:@selector(loginSuccessNotification) withObject:nil waitUntilDone:NO];
            }
            
            [[OTSOnlinePayNotifier sharedInstance] retrieveOrders];
        }
        else
        {
            [GlobalValue getGlobalValueInstance].storeToken = nil;
        }
        
        _isLogging = NO;
        
        return [self isLoginSuccess];
    }
}
-(void)loginSuccessNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOGIN_SUCCESS object:nil];
}
- (BOOL)logout
{
    [OTSUserSwitcher sharedInstance].currentToken = nil;
    [[OTSOnlinePayNotifier sharedInstance] reset];
    
    [self performInMainBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOG_OUT object:nil];
    }];
    
    return YES;
}

-(NSString*)stringFroLoginType:(EOTSLoginType)aLoginType
{
    switch (aLoginType)
    {
        case kLoginStore:
        {
            return LOGIN_TYPE_STORE_STR;
        }
            break;
            
            
        case kLoginUnion:
        {
            return LOGIN_TYPE_UNION_STR;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (EOTSLoginType)loginTypeWithString:(NSString*)aLoginTypeString
{
    if ([aLoginTypeString isEqualToString:LOGIN_TYPE_STORE_STR])
    {
        return kLoginStore;
    }
    
    if ([aLoginTypeString isEqualToString:LOGIN_TYPE_UNION_STR])
    {
        return kLoginUnion;
    }
    
    return kLoginNone;
}


#pragma mark - singleton methods
static OTSUserLoginHelper *sharedInstance = nil;

+ (OTSUserLoginHelper *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
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
