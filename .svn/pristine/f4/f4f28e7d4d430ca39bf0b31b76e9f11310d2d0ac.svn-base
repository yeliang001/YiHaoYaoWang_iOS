//
//  OTSUserLoginHelper.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-21.
//
//

#import <Foundation/Foundation.h>

@class LoginResult;

typedef enum
{
    kLoginNone = 0
    , kLoginStore         // 1号店登录
    , kLoginUnion         // 联合登录
}EOTSLoginType;


@interface OTSLgoinParam : NSObject
@property(copy)NSString *userName;
@property(copy)NSString *password;
@property(copy)NSString *realuserName;
@property(copy)NSString *cocode;
@property(copy)NSString *verifyCode;
@property(copy)NSString *tempoToken;
@end

@interface OTSUserLoginHelper : NSObject
@property(retain, readonly)LoginResult* loginResult;
@property (readonly) BOOL  isLogging;

+ (OTSUserLoginHelper *)sharedInstance;


- (BOOL)isLoginSuccess;
- (BOOL)isNilResult;
- (BOOL)isResultHasError;
- (BOOL)isNeedVerifyCode;

- (BOOL)loginWithParam:(OTSLgoinParam*)aParam;
- (BOOL)unionLoginWithParam:(OTSLgoinParam*)aParam;
- (BOOL)autoLogin;
- (BOOL)loginWithType:(EOTSLoginType)aLoginType param:(OTSLgoinParam*)aParam;

- (BOOL)logout;

-(NSString*)stringFroLoginType:(EOTSLoginType)aLoginType;
- (EOTSLoginType)loginTypeWithString:(NSString*)aLoginTypeString;
@end

#define LOGIN_TYPE_UNION_STR    @"UNIONLOGIN"
#define LOGIN_TYPE_STORE_STR    @"LOGIN"
#define LOGIN_TYPE_MALL_STR    @"LOGIN_MALL"

#define NOTIFY_LOGIN_SUCCESS    @"NOTIFY_LOGIN_SUCCESS"
#define NOTIFY_LOG_OUT    @"NOTIFY_LOG_OUT"