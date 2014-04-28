//
//  UIDevice+Common.h
//  HappyShare
//
//  Created by Lin Pan on 13-3-14.
//  Copyright (c) 2013年 Lin Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kNetWorkNone,
    kNetWorkWifi,
    kNetWork3G,
} kNetWorkType;

@interface UIDevice (Common)

/**
 *	@brief	判断是否为iPhone5
 *
 *	@return	YES：是，NO：否
 */
- (BOOL)isPhone5;

/**
 *	@brief	获取系统越狱标识
 *
 *	@return	YES表示已经越狱，否则没有越狱。
 */
- (BOOL)isJailBroken;

/**
 *	@brief	取得网卡的物理地址
 *
 *	@return	网卡物理地址
 */
- (NSString *)macAddress;

/**
 *	@brief	获取设备型号
 *
 *	@return	设备型号：设备型号对照如下：
 *  iPhone1,1 ->    iPhone 1G
 *  iPhone1,2 ->    iPhone 3G
 *  iPhone2,1 ->    iPhone 3GS
 *  iPhone3,1 ->    iPhone 4
 *
 *  iPod1,1   -> iPod touch 1G
 *  iPod2,1   -> iPod touch 2G
 *  iPod2,2   -> iPod touch 2.5G
 *  iPod3,1   -> iPod touch 3G
 *  iPod4,1   -> iPod touch 4
 *
 *  iPad1,1   -> iPad 1G, WiFi
 */
- (NSString *)deviceModel;

/**
 *	@brief	判断是否为iPad设备
 *
 *	@return	YES：是，NO：否
 */
- (BOOL)isPad;

/**
 * @brief 判读网络类型
 * 
 * @return 
 * noNet -> kNoNet
 * wifi -> kWifi
 * 3G -> k3G
 */
- (kNetWorkType)judgeNet;


@end
