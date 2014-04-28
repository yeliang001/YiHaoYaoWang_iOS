//
//  UserService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "UserVO.h"
#import "VerifyCodeVO.h"
#import "RegisterResult.h"
#import "LoginResult.h"
#import "CheckUserNameResult.h"
#import "SendValidCodeForPhoneRegisterResult.h"
#import "CheckValidCodeForPhoneRegisterResult.h"
#import "BindMobileResult.h"
#import "SendBindValidateCodeResult.h"

@interface UserService:TheStoreService{
}

//切换省份
-(int)changeProvince:(NSString *)token provinceId:(NSNumber *)provinceId;
//找回密码
-(int)findPasswordByEmail:(Trader *)trader emailname:(NSString *)emailname verifycode:(NSString *)verifycode tempToken:(NSString *)tempToken;
//获取我的1号店用户信息
-(UserVO *)getMyYihaodianSessionUser:(NSString *)token;
//获取用户信息
-(UserVO *)getSessionUser:(NSString *)token;
//返回一个验证码url
-(VerifyCodeVO *)getVerifyCodeUrl:(Trader *)trader;
//用户登录并返回用户信息
-(NSString *)login:(Trader *)trader provinceId:(NSNumber *)provinceId username:(NSString *)username password:(NSString *)password;
//用户登录新接口
-(LoginResult *)loginV2:(Trader *)trader provinceId:(NSNumber *)provinceId username:(NSString *)username password:(NSString *)password loginSiteType:(NSNumber *)loginSiteType;
-(LoginResult *)loginV3:(Trader *)trader provinceId:(NSNumber *)provinceId username:(NSString *)username password:(NSString *)password loginSiteType:(NSNumber *)loginSiteType verifycode:(NSString*)verifycode tempoToken:(NSString*)tempToken deviceToken:(NSString*)deviceToken;
//退出登录
-(int)logout:(NSString *)token;
//修改用户密码
-(int)modifyPassword:(NSString *)token username:(NSString *)username oldpassword:(NSString *)oldpassword newpassword:(NSString *)newpassword;
//用户注册
-(int)registerAct:(Trader *)trader username:(NSString *)username password:(NSString *)password verifycode:(NSString *)verifycode tempToken:(NSString *)tempToken;
//用户注册新接口
-(RegisterResult *)registerV2:(Trader *)trader email:(NSString *)email userName:(NSString *)userName password:(NSString *)password verifycode:(NSString *)verifycode tempToken:(NSString *)tempToken;


//V3用户注册接口－type 注册类型 1-邮箱注册；2-手机注册；3-快速购买手机注册
-(RegisterResult *)registerV3:(Trader *)trader email:(NSString *)email userName:(NSString *)userName password:(NSString *)password verifycode:(NSString *)verifycode tempToken:(NSString *)tempToken type:(NSNumber *)type;
//手机注册－检查用户是否已经注册过
-(CheckUserNameResult *)checkUserName:(Trader*) trader userName:(NSString *)userName;
//手机注册－发送验证码到手机
-(SendValidCodeForPhoneRegisterResult *)sendValidCodeForPhoneRegister:(Trader*) trader mobile:(NSString *)mobile;
//手机注册－验证码验证
-(CheckValidCodeForPhoneRegisterResult *)checkValidCodeForPhoneRegister:(Trader*) trader mobile:(NSString *)mobile validCode:(NSString *)validCode;
//手机绑定－是否已经绑定手机
-(BindMobileResult *)isBindMobile:(NSString *)token;
//手机绑定－发送绑定手机的验证码到手机
-(SendBindValidateCodeResult *)sendValidateCodeForBindMobile:(NSString *)token phone:(NSNumber *)phone;
//手机绑定－绑定手机
-(BindMobileResult *)bindMobileValidate:(NSString *)token phone:(NSNumber *)phone validateCode:(NSString *)validateCode;



-(NSString *)unionLogin:(Trader *)trader provinceId:(NSNumber *)provinceId userName:(NSString *)userName realUserName:(NSString *)realUserName cocode:(NSString *)cocode;
-(NSArray *)updateCartProductUnlogin:(Trader *)trader productIds:(NSArray *)productIds merchantIds:(NSArray *)merchantIds provinceId:(NSNumber *)provinceId;
-(NSNumber *)getUserSitetypeAndAuth:(NSString *)token;
@end
