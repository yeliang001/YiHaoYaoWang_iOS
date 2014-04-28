//
//  MessageService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "InnerMessageVO.h"
#import "Page.h"

@interface MessageService:TheStoreService{
}

//根据消息ID删除全部消息
-(int)deleteMessageById:(NSString *)token messageId:(NSNumber *)messageId;
//获取消息详细信息
-(InnerMessageVO *)getMessageDetailById:(NSString *)token messageId:(NSNumber *)messageId;
//获取消息列表
-(Page *)getMessageList:(NSString *)token messageType:(NSNumber *)messageType currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;
//获取未读消息数量
-(int)getUnreadMessageCount:(NSString *)token;
@end
