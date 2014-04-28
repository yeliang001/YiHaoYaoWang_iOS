//
//  RockCouponVO.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-2.
//
//

#import "RockCouponVO.h"

@implementation RockCouponVO
@synthesize couponVO = _couponVO;
@synthesize activityId = _activityId;
@synthesize isReceived = _isReceived;

- (void)dealloc
{
    [_couponVO release];
    [_activityId release];
    [_isReceived release];
    
    [super dealloc];
}


-(OTSRockTicketStatus)getStatus
{
    return [self.isReceived intValue];
}

-(NSString*)description
{
    NSMutableString *des = [NSMutableString string];
    
    [des appendFormat:@"\n<%s : 0X%lx>\n", class_getName([self class]), (unsigned long)self];
    
    [des appendFormat:@"_couponVO : %@\n", _couponVO];
    [des appendFormat:@"_activityId : %@\n", _activityId];
    [des appendFormat:@"_isReceived : %@\n", _isReceived];
    
    return des;
}

@end
