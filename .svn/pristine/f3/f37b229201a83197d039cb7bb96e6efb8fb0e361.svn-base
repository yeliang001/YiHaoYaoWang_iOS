//
//  CartBagVO.m
//  TheStoreApp
//
//  Created by xuexiang on 12-11-30.
//
//

#import "CartBagVO.h"

@implementation CartBagVO
@synthesize serialVersionUID;
@synthesize merchantId;
@synthesize merchantName;
@synthesize totalquantity;
@synthesize totalAmount;
@synthesize totalWeight;
@synthesize totalSaveMoney;
@synthesize totalDeliveryFee;
@synthesize freeDeliveryFeeRule;
@synthesize cartItemVOs;
@synthesize totalNeedPoint;
-(void)dealloc{
    if (serialVersionUID!=nil) {
        [serialVersionUID release];
    }
    if (merchantId!=nil) {
        [merchantId release];
    }
    if (merchantName!=nil) {
        [merchantName release];
    }
    if (totalquantity!=nil) {
        [totalquantity release];
    }
    if (totalAmount!=nil) {
        [totalAmount release];
    }
    if (totalWeight!=nil) {
        [totalWeight release];
    }
    if (totalSaveMoney!=nil) {
        [totalSaveMoney release];
    }
    if (totalDeliveryFee!=nil) {
        [totalDeliveryFee release];
    }
    if (freeDeliveryFeeRule!=nil) {
        [freeDeliveryFeeRule release];
    }
    if (cartItemVOs!=nil) {
        [cartItemVOs release];
    }
    OTS_SAFE_RELEASE(totalNeedPoint);
    [super dealloc];
}
@end
