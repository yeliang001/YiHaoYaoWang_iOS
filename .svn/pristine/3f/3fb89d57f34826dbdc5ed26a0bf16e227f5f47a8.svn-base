//
//  MessageService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import "MessageService.h"
#import "GlobalValue.h"
#import "OTSUtility.h"

@implementation MessageService

//根据消息ID删除全部消息
-(int)deleteMessageById:(NSString *)token messageId:(NSNumber *)messageId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:messageId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//获取消息详细信息
-(InnerMessageVO *)getMessageDetailById:(NSString *)token messageId:(NSNumber *)messageId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:messageId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[InnerMessageVO class]]) {
        InnerMessageVO *po=(InnerMessageVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取消息列表
-(Page *)getMessageList:(NSString *)token messageType:(NSNumber *)messageType currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:messageType];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取未读消息数量
-(int)getUnreadMessageCount:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}

@end
