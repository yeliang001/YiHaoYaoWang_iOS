//
//  LoginResult.h
//  TheStoreApp
//
//  Created by jiming huang on 12-9-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginResult : NSObject {
/*  * 1：成功
    * 0：登录失败
    * -1：账号不存在
    * -2：账号与密码不匹配
    * -3：支付宝用户请通过支付宝联合登录1号店
    * -4：1号店用户没有授权1号商城
    * -5：短时间内登录次数过多，账号将被封24小时
    * -6：1号商城用户没有授权1号店
    * -7：验证码已失效，请重新获取
    * -8：验证码格式错误，请重新输入
    * -9：验证码输入错误3次，请重新获取验证码
    * -10：验证码错误，请重新输入
    * -11：24小时内连续3次登录失败，需要输入验证码
 */
    NSNumber *resultCode;
    NSString *errorInfo;
    NSString *token;
}
@property(nonatomic,retain) NSNumber *resultCode;
@property(nonatomic,retain) NSString *errorInfo;
@property(nonatomic,retain) NSString *token;
@end
