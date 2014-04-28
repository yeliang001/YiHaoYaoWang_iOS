//
//  PayService.h
//  TheStoreApp
//
//  Created by yangxd on 11-7-25.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "BankVO.h"
#import "Page.h"

@class NeedCheckResult;
@class SendValidCodeResult;
@class CheckSmsResult;
@class SavePayByAccountResult;

@interface PayService:TheStoreService {
}

-(Page *)getBankVOList:(Trader *)trader name:(NSString *)name type:(NSNumber *)type currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;


#pragma mark - 余额支付

/**
 * 余额支付是否需要短信验证
 *
 * @param aPayByAccount 余额支付的金额
 * @return resultCode=1时，mobile首先取用户资料库手机号，没有则取收货地址手机号，再没有返回""表示需要用户手动输入手机号。
 * resultCode=2时，mobile为用户绑定的短信验证手机号
 */
-(NeedCheckResult *)needSmsCheck:(NSString *)aToken 
                    payByAccount:(NSNumber*)aPayByAccount;


/**
 * 发送余额验证的短信
 *
 * @param mobile 接收短信的手机号
 * @return resultCode=0时，errorInfo为失败信息。
 */
-(SendValidCodeResult *)sendValidCodeToUserBindMobile:(NSString *)aToken 
                                               mobile:(NSString *)aMobile;

/**
 * 发送余额验证的短信
 *
 * @param validCode 验证码
 * @return resultCode=0时，errorInfo为失败信息。
 */
-(CheckSmsResult *)checkSms:(NSString *)aToken 
                  validCode:(NSString *)aValidCode;

/**
 * 余额支付
 *
 * @param payByAccount      余额支付金额
 * @param validCode         验证码
 * @param type              type=1表示普通商品余额支付，type=2表示团购余额支付
 * @return resultCode=0时，errorInfo为失败信息。
 */
-(SavePayByAccountResult *)savePayByAccount:(NSString *)aToken 
                               payByAccount:(NSNumber*)aPayByAccount 
                                  validCode:(NSString*)aValidCode 
                                       type:(NSNumber*)aType;

/* <h2>余额支付——保存余额到订单</h2>
* <br/>
* 功能点：结算中心余额支付;<br/>
* 异常：服务器错误;Token错误;<br/>
* @param token
* @param payByAccount 余额支付金额
* @param validCode 验证码
* @param type 1——普通商品余额支付，2——团购余额支付
* @param accountType 1-现金余额支付；2-礼品卡余额支付
* @return
*/
-(SavePayByAccountResult *)savePayByAccount:(NSString *)aToken
                               payByAccount:(NSNumber*)aPayByAccount
                                  validCode:(NSString*)aValidCode
                                       type:(NSNumber*)aType
                                accountType:(NSNumber*)accountType;
/**
 * 余额使用明细
 * @param status  状态 目前传递-1
 * @param type 类型 目前传递-1
 * @param amountDirection 存支状态 -1表示全部，0表示支出，1表示存入
 */
-(Page*)getUserAcountLogList:(NSString*)token 
					  sattus:(NSNumber*)sattus 
						type:(NSNumber*)type
			 amountDirection:(NSNumber*)amountDirection 
				 currentPage:(NSNumber*)currentPage 
					pageSize:(NSNumber*)pageSize;
 
@end