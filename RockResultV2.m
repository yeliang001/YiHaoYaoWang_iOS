//
//  RockResultV2.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import "RockResultV2.h"

@implementation RockResultV2
@synthesize resultType = _resultType;
@synthesize couponVOList = _couponVOList;
@synthesize rockProductV2List = _rockProductV2List;
@synthesize productVOList = _productVOList;
@synthesize prizeProductVOList = _prizeProductVOList;
@synthesize grouponVOList = _grouponVOList;

- (void)dealloc
{
    [_resultType release];
    [_couponVOList release];
    [_productVOList release];
    [_rockProductV2List release];
    
    [super dealloc];
}

-(OTSRockResultType)getResultType
{
    return [self.resultType intValue];
}

-(BOOL)isValid
{
    OTSRockResultType resultType = [self getResultType];
    BOOL isValid = YES;
    
    switch (resultType)
    {
        case kRockResultPromotion:
        {
            isValid = self.rockProductV2List.count > 0;
        }
            break;
            
        case kRockResultNormal:
        {
            isValid = self.productVOList.count > 0;
        }
            break;
            
        case kRockResultTicket:
        {
            isValid = self.couponVOList.count > 0;
        }
            break;
            
        default:
            break;
    }
    
    return isValid;
}


-(NSString*)description
{
    NSMutableString *des = [NSMutableString string];
    
    [des appendFormat:@"\n<%s : 0X%lx>\n", class_getName([self class]), (unsigned long)self];
    
    [des appendFormat:@"_resultType : %@\n", _resultType];
    [des appendFormat:@"_couponVOList : %@\n", _couponVOList];
    [des appendFormat:@"_productVOList : %@\n", _productVOList];
    [des appendFormat:@"_rockProductV2List : %@\n", _rockProductV2List];
    
    return des;
}

@end
