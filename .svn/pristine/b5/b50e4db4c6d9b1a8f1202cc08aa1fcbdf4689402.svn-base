//
//  FeedbackService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import "FeedbackService.h"
#import "OTSUtility.h"

@implementation FeedbackService

#pragma mark 保存用户反馈
-(int)addFeedback:(NSString *)token feedbackcontext:(NSString *)feedbackContext{
	MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:feedbackContext];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]])
    {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
-(PushMappingResult*)enableDeviceForPushMsg:(Trader*)trader deviceToken:(NSString*)devicetoken isOpen:(BOOL)isopen startHour:(NSNumber*)startH endHour:(NSNumber*)endH{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:devicetoken];
    [body addBool:isopen];
    [body addInteger:startH];
    [body addInteger:endH];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    PushMappingResult*po=(PushMappingResult*)ret;
    return po;
}
@end
