//
//  RockProductV2.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import "RockProductV2.h"


@implementation RockProductV2
@synthesize prodcutVO = _prodcutVO;
@synthesize productAging = _productAging;
@synthesize rockProductType = _rockProductType;
@synthesize expireDate = _expireDate;

- (void)dealloc
{
    [_prodcutVO release];
    [_productAging release];
    [_rockProductType release];
    [_expireDate release];
    
    [super dealloc];
}


-(OTSRockProductStatus)getStatus
{
    return [self.rockProductType intValue];
}

-(NSString*)description
{
    NSMutableString *des = [NSMutableString string];
    
    [des appendFormat:@"\n<%s : 0X%lx>\n", class_getName([self class]), (unsigned long)self];
    
    [des appendFormat:@"_prodcutVO : %@\n", _prodcutVO];
    [des appendFormat:@"_productAging : %@\n", _productAging];
    [des appendFormat:@"_rockProductType : %@\n", _rockProductType];
    
    return des;
}

-(void)updateMyExpTime
{
    if (self.expireDate == nil)
    {
        int interval = [self.productAging longLongValue] / 1000.f; //000.0f;  // 毫秒---》秒
        
        self.expireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    }
}

@end
