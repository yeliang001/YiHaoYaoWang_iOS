//
//  YWUserLoginHelper.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-15.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    kYWLoginNone = 0,
    kYWLoginAlipay = 1,
    kYWLoginQQ = 2,
    kYWLoginStore,        //     1号药网登录
    kYWLoginUnion         // 联合登录
}YWLoginType;

@class LoginResultInfo;

@interface YWUserLoginHelper : NSObject
@property (retain, nonatomic) LoginResultInfo *loginResult;

+ (YWUserLoginHelper *)sharedInstance;
- (BOOL)isLoginSuccess;
- (BOOL)isNilResult;
- (BOOL)isResultHasError;



- (BOOL)loginWithType:(YWLoginType)aLoginType param:(NSDictionary *)aParam;


@end
