//
//  FeedbackService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "OTSBaseServiceResult.h"
@interface FeedbackService:TheStoreService{
}

//保存用户反馈
-(int)addFeedback:(NSString *)token feedbackcontext:(NSString *)feedbackContext;
/**
 * <h2>终端设置推送开关信息</h2>
 * <br/>
 * 功能点：终端推送开关设置;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：PushMappingResult<br/>
 * 1：成功
 * 0：设置失败
 * 必填参数：trader,deviceToken,isOpen,startHour,endHour<br/>
 * @param trader
 * @param deviceToken 设备标识
 * @param isOpen 推送开关
 * @param startHour 起始小时数
 * @param endHour 结束小时数
 * @return 返回终端设备推送绑定信息
public PushMappingResult enableDeviceForPushMsg(Trader trader, String deviceToken, Boolean isOpen,
                                                Integer startHour, Integer endHour);
 */
-(PushMappingResult*)enableDeviceForPushMsg:(Trader*)trader deviceToken:(NSString*)devicetoken isOpen:(BOOL)isopen startHour:(NSNumber*)startH endHour:(NSNumber*)endH;

@end
