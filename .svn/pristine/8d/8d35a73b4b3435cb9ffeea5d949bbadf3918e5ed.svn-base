//
//  RockGameFlowVO.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-2.
//
//

#import <Foundation/Foundation.h>

@class CommonRockResultVO;


typedef enum {
    kWrGameFlowNotFinished = 0      // 0-未完成
    , kWrGameFlowFinished           // 1-已完成
}OTSWrGameFlowStatus;

@interface RockGameFlowVO : NSObject
@property (retain)  NSNumber    *nid;               // （不设置）
@property (retain)  NSNumber    *userId;            // 用户ID （必须设置，RockGameVO对象的userID）
@property (retain)  NSNumber    *rockGameId;        // 游戏ID （必须设置，RockGameVO对象的ID）
@property (retain)  NSNumber    *provinceId;        // 用户当前省份ID （必须设置，当前用户登录的省份ID）
@property (copy)    NSString    *inviteePhone;      // 被邀请者的电话
@property (copy)    NSString    *inviteeName;       // 被邀请者的名称
@property (retain)  NSNumber    *presentId;         // 赠送游戏礼品的ID（必须设置，RockGameProductVO对象的ID）
@property (copy)    NSString    *audioUrl;          // 音频上传的路径 （必须设置，RockGameProductVO对象的ID）
@property (retain)  NSNumber    *flowStatus;        // 流程状态：1-已完成；0-未完成 (不设置，创建默认状态为0）
@property (retain)  NSNumber    *couponId;          // 获取抵用券的ID：一个用户最多只能获取4个 （必须设置，RockGameProductVO对象的couponId）
@property (retain)  NSDate      *createTime;        // 创建时间（不设置）
@property (retain)  NSDate      *updateTime;        // 修改时间（不设置）

// commonRockResultVO 什么类型？？？
-(NSString*)toXml;
@property (retain)  CommonRockResultVO          *commonRockResultVO; // 通用的错误编码（不设置）
@end


//Id（不设置）
//
///**
// * 用户ID
// */
//userId（必须设置，RockGameVO对象的userID）
//
///**
// * 游戏ID
// */
//rockGameId（必须设置，RockGameVO对象的ID）
///**
// * 用户当前省份ID
// */
//provinceId（必须设置，当前用户登录的省份ID）
//
///**
// * 被邀请者的电话
// */
//inviteePhone（选填）
//
///**
// * 被邀请者的名称
// */
//inviteeName（选填）
//
///**
// * 赠送游戏礼品的ID
// */
//private Long presentId（必须设置，RockGameProductVO对象的ID）
//
///**
// * 音频上传的路径
// */
//audioUrl（必须设置）
//
///**
// * 流程状态：1-已完成；0-未完成
// */
//flowStatus（不设置，创建默认状态为0）
//
///**
// * 获取抵用券的ID：一个用户最多只能获取4个
// */
//couponId（必须设置，RockGameProductVO对象的couponId）
//
///**
// * 创建时间
// */
//createTime（不设置）
///**
// * 修改时间
// */
//updateTime（不设置）
///**
// * 通用的错误编码
// */
//commonRockResultVO（不设置）
