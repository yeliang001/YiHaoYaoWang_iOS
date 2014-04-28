//
//  OrderStatusTrackVO.m
//  TheStoreApp
//
//  Created by zhengchen on 11-12-6.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import "OrderStatusTrackVO.h"

@implementation OrderStatusTrackVO
@synthesize nid;
@synthesize  oprNum;
@synthesize  oprAttr;
@synthesize oprCreatetime;
@synthesize  oprUpdatetime;
@synthesize  oprContent;
@synthesize  oprOperator;
@synthesize  oprPreEvent;
@synthesize  oprEvent;
@synthesize  oprRemark;
@synthesize  orderId;
@synthesize  orderCode;
@synthesize  orderCreateTime;
@synthesize  orderPreStatus;
@synthesize  orderCurrentStatus;

- (NSString *)description
{
    NSMutableString* des = [NSMutableString string];
    [des appendFormat:@"<OrderStatusTrackVO 0x%llx>\n", (long long)self];
    [des appendFormat:@"nid:%@\n", nid];
    [des appendFormat:@"oprNum:%@\n", oprNum];
    [des appendFormat:@"oprAttr:%@\n", oprAttr];
    [des appendFormat:@"oprCreatetime:%@\n", oprCreatetime];
    [des appendFormat:@"oprUpdatetime:%@\n", oprUpdatetime];
    [des appendFormat:@"oprContent:%@\n", oprContent];
    [des appendFormat:@"oprOperator:%@\n", oprOperator];
    [des appendFormat:@"oprPreEvent:%@\n", oprPreEvent];
    [des appendFormat:@"oprRemark:%@\n", oprRemark];
    [des appendFormat:@"orderId:%@\n", orderId];
    [des appendFormat:@"orderCode:%@\n", orderCode];
    [des appendFormat:@"orderCreateTime:%@\n", orderCreateTime];
    [des appendFormat:@"orderPreStatus:%@\n", orderPreStatus];
    [des appendFormat:@"orderCurrentStatus:%@\n", orderCurrentStatus];
    
    return des;
}
-(NSString*)clonedOprCreatetime{
    NSString* strDateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* strDate = oprCreatetime;
    NSDate *createDate = nil;
    if (strDate && [strDate length] >= [strDateFormat length])
    {
        strDate = [strDate substringToIndex:[strDateFormat length]];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:strDateFormat];
        createDate = [dateFormatter dateFromString:strDate];
    }
    NSTimeZone* zone=[NSTimeZone localTimeZone];
    int offset=[zone secondsFromGMTForDate:createDate];
    NSDate* localDate=[createDate dateByAddingTimeInterval:offset];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:localDate];
    
    [dateFormatter release];
    
    // 非常奇怪，某些情况下直接取oprCreateTime会返回nil，在此创建新串以解决此问题 -- dym 12.7.17.
    return [NSString stringWithFormat:@"%@", destDateString];
}
-(NSString*)clonedCreateTime
{
    NSString* strDateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* strDate = orderCreateTime;
    NSDate *createDate = nil;
    if (strDate && [strDate length] >= [strDateFormat length])
    {
        strDate = [strDate substringToIndex:[strDateFormat length]];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:strDateFormat];
        createDate = [dateFormatter dateFromString:strDate];
    }
    NSTimeZone* zone=[NSTimeZone localTimeZone];
    int offset=[zone secondsFromGMTForDate:createDate];
    NSDate* localDate=[createDate dateByAddingTimeInterval:offset];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:localDate];
    
    [dateFormatter release];

    // 非常奇怪，某些情况下直接取oprCreateTime会返回nil，在此创建新串以解决此问题 -- dym 12.7.17.
    return [NSString stringWithFormat:@"%@", destDateString];
}

-(OrderStatusTrackVO*)clone
{
    OrderStatusTrackVO* clone = [[[OrderStatusTrackVO alloc] init] autorelease];
    clone.nid = nid;
    clone.oprNum = oprNum;
    clone.oprAttr = oprAttr;
    clone.oprCreatetime = oprCreatetime;
    clone.oprUpdatetime = oprUpdatetime;
    clone.oprContent = oprContent;
    clone.oprOperator = oprOperator;
    clone.oprPreEvent = oprPreEvent;
    clone.oprEvent = oprEvent;
    clone.oprRemark = oprRemark;
    clone.orderId = orderId;
    clone.orderCode = orderCode;
    clone.orderCreateTime = orderCreateTime;
    clone.orderPreStatus = orderPreStatus;
    clone.orderCurrentStatus = orderCurrentStatus;
    
    return clone;
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(nid);
    OTS_SAFE_RELEASE(oprNum);
    OTS_SAFE_RELEASE(oprAttr);
    OTS_SAFE_RELEASE(oprCreatetime);
    OTS_SAFE_RELEASE(oprUpdatetime);
    OTS_SAFE_RELEASE(oprContent);
    OTS_SAFE_RELEASE(oprOperator);
    OTS_SAFE_RELEASE(oprPreEvent);
    OTS_SAFE_RELEASE(oprEvent);
    OTS_SAFE_RELEASE(oprRemark);
    OTS_SAFE_RELEASE(orderId);
    OTS_SAFE_RELEASE(orderCode);
    OTS_SAFE_RELEASE(orderCreateTime);
    OTS_SAFE_RELEASE(orderPreStatus);
    OTS_SAFE_RELEASE(orderCurrentStatus);
    
    [super dealloc];
}
@end
