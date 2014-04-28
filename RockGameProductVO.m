//
//  RockGameProductVO.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import "RockGameProductVO.h"

@implementation RockGameProductVO
@synthesize nid = _nid;
@synthesize merchantId = _merchantId;
@synthesize productCode = _productCode;
@synthesize landingPageId = _landingPageId;
@synthesize couponId = _couponId;
@synthesize rightCode = _rightCode;
@synthesize wrongCode = _wrongCode;
@synthesize startTime = _startTime;
//@synthesize endTime = _endTime;
@synthesize rockProductV2=_rockProductV2;
@synthesize pictureUnpicked=_pictureUnpicked;
@synthesize picturePicked=_picturePicked;
@synthesize isSended = _isSended;

- (void)dealloc
{
    [_picturePicked release];
    [_rockProductV2 release];
    [_nid release];
    [_merchantId release];
    [_productCode release];
    [_landingPageId release];
    [_couponId release];
    [_rightCode release];
    [_wrongCode release];
    [_startTime release];
//    [_endTime release];
    [_isSended release];
    
    [super dealloc];
}

-(NSString*)description
{
    NSMutableString *des = [NSMutableString string];
    
    [des appendFormat:@"\n<%s : 0X%lx>\n", class_getName([self class]), (unsigned long)self];
    [des appendFormat:@"_nid : %@\n", _nid];
    [des appendFormat:@"_merchantId : %@\n", _merchantId];
    [des appendFormat:@"_productCode : %@\n", _productCode];
    [des appendFormat:@"_landingPageId : %@\n", _landingPageId];
    [des appendFormat:@"_ticketId : %@\n", _couponId];
    [des appendFormat:@"_rightCode : %@\n", _rightCode];
    [des appendFormat:@"_wrongCode : %@\n", _wrongCode];
    [des appendFormat:@"_startTime : %@\n", _startTime];
//    [des appendFormat:@"_endTime : %@\n", _endTime];
    [des appendFormat:@"_isSended : %@\n", _isSended];
    
    return des;
}

-(BOOL)isGiftSent
{
    if ([self.isSended isEqualToString:@"true"]) {
        return YES;
    }
    return NO;
}

@end
