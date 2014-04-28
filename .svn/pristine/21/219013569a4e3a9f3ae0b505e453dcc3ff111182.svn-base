//
//  NdChannelLib.h
//  NdChannelLib
//
//  Created by xujianye on 10-12-28.
//  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NdChannelLib : NSObject {

}

/*!
 上传渠道id。
 配置渠道id可以通过增加配置文件NdChannelId.plist, 设置chl字段（string)为自定义渠道id。
 该配置文件需要放在当前应用程序app目录下。
 如果找不到自定义渠道值,使用默认值为0,表示该应用为网龙公司内部产品
 @param nAppId 应用产品Id，需要申请
 @param delegate 回调对象,回调接口参见NdUploadChannelIdDidFinished
 */
+ (int)NdUploadChannelId:(int)nAppId delegate:(id)delegate;

/*!
 获取设备标识
 适配iOS5系统，如果获取不到UDID，使用WIFI地址值(base64加密)；如果以上两者都失败，会创建CFUUID(存入NSUserDefaults)。
 */
+ (NSString*)NdGetDeviceId;

@end

@protocol NdChannelLibProtocol

/*!
 登录到用户中心
 @param userName 用户帐号
 @param password 用户密码
 @param bSavePassword 用户是否勾选记住密码
 @param bAutoLogin 用户是否勾选自动登录
 @param delegate 回调对象
 @result 登录返回的错误码，成功为正数
 */
- (void)NdUploadChannelIdDidFinished:(int)resultCode  sessionId:(NSString*)session errorDescription:(NSString*)description;

@end
