//
//  StorageBoxVO.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-2.
//
//

#import "StorageBoxVO.h"

@implementation StorageBoxVO
@synthesize type = _type;
@synthesize rockCouponVO = _rockCouponVO;
@synthesize rockProductV2 = _rockProductV2;

- (void)dealloc
{
    [_type release];
    [_rockCouponVO release];
    [_rockProductV2 release];
    
    [super dealloc];
}

-(OTSRockBoxItemType)getItemType
{
    return [self.type intValue];
}

-(NSDate*)expireTime
{
    if (self.getItemType == kRockBoxItemProduct)
    {
        [self.rockProductV2 updateMyExpTime];
        return self.rockProductV2.expireDate;
    }
    else  if (self.getItemType == kRockBoxItemTicket)
    {
        return self.rockCouponVO.couponVO.expiredTime;
    }
    
    return nil;
}

-(BOOL)isTheSame:(StorageBoxVO*)aStorageBox
{
    if (aStorageBox)
    {
        if (aStorageBox.getItemType == self.getItemType)
        {
            if (aStorageBox.getItemType == kRockBoxItemProduct)
            {
                return aStorageBox.rockProductV2.prodcutVO.productId == self.rockProductV2.prodcutVO.productId;
            }
            else  if (self.getItemType == kRockBoxItemTicket)
            {
                return aStorageBox.rockCouponVO.couponVO.nid == self.rockCouponVO.couponVO.nid;
            }
        }
    }
    
    return NO;
}

-(NSString*)description
{
    NSMutableString *des = [NSMutableString string];
    
    [des appendFormat:@"\n<%s : 0X%lx>\n", class_getName([self class]), (unsigned long)self];
    
    [des appendFormat:@"_type : %@\n", _type];
    [des appendFormat:@"_rockCouponVO : %@\n", _rockCouponVO];
    [des appendFormat:@"_rockProductV2 : %@\n", _rockProductV2];
    
    return des;
}

@end
