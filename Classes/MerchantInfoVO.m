//
//  MerchantInfoVO.m
//  TheStoreApp
//
//  Created by xuexiang on 12-11-30.
//
//

#import "MerchantInfoVO.h"
#import "ProductVO.h"

@implementation MerchantInfoVO

@synthesize serialVersionUID;
@synthesize MerchantName;
@synthesize freightInformation;
@synthesize shippingMethod;
@synthesize paymentMethod;

-(MerchantInfoVO*)clone
{
    MerchantInfoVO *clone = [[[MerchantInfoVO alloc] init] autorelease];
    
    clone.serialVersionUID = self.serialVersionUID;
    clone.MerchantName = self.MerchantName;
    clone.freightInformation = self.freightInformation;
    clone.shippingMethod = self.shippingMethod;
    clone.paymentMethod = self.paymentMethod;
    
    return clone;
}

-(NSMutableDictionary *)dictionaryFromVO
{
    NSMutableDictionary *mDictionary=[[[NSMutableDictionary alloc] init] autorelease];
    if (serialVersionUID!=nil) {
        [mDictionary setObject:serialVersionUID forKey:@"serialVersionUID"];
    }
    if (MerchantName!=nil) {
        [mDictionary setObject:MerchantName forKey:@"MerchantName"];
    }
    if (freightInformation!=nil) {
        [mDictionary setObject:freightInformation forKey:@"freightInformation"];
    }
    if (shippingMethod!=nil) {
        [mDictionary setObject:shippingMethod forKey:@"shippingMethod"];
    }
    if (paymentMethod!=nil) {
        [mDictionary setObject:paymentMethod forKey:@"paymentMethod"];
    }
    return mDictionary;
}
+(id)voFromDictionary:(NSMutableDictionary *)mDictionary
{
    MerchantInfoVO *vo=[[MerchantInfoVO alloc] autorelease];
    id object=[mDictionary objectForKey:@"serialVersionUID"];
    if (object!=nil) {
        vo.serialVersionUID=object;
    
    }
    object=[mDictionary objectForKey:@"MerchantName"];
    if (object!=nil) {
        vo.MerchantName=object;
        
    }
    object=[mDictionary objectForKey:@"freightInformation"];
    if (object!=nil) {
        vo.freightInformation=object;
        
    }
    object=[mDictionary objectForKey:@"shippingMethod"];
    if (object!=nil) {
        vo.shippingMethod=object;
        
    }
    object=[mDictionary objectForKey:@"paymentMethod"];
    if (object!=nil) {
        vo.paymentMethod=object;
        
    }
    return vo;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:serialVersionUID forKey:@"serialVersionUID"];
    
    [aCoder encodeObject:MerchantName forKey:@"MerchantName"];
    
    [aCoder encodeObject:freightInformation forKey:@"freightInformation"];
    
    [aCoder encodeObject:shippingMethod forKey:@"shippingMethod"];
    
    [aCoder encodeObject:paymentMethod forKey:@"paymentMethod"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.serialVersionUID=[aDecoder decodeObjectForKey:@"serialVersionUID"];
    
    self.MerchantName=[aDecoder decodeObjectForKey:@"MerchantName"];
    
    self.freightInformation=[aDecoder decodeObjectForKey:@"freightInformation"];
    
    self.shippingMethod=[aDecoder decodeObjectForKey:@"shippingMethod"];
    
    self.paymentMethod=[aDecoder decodeObjectForKey:@"paymentMethod"];
    return self;
}

-(void)dealloc{
    if (serialVersionUID != nil) {
        [serialVersionUID release];
    }
    if (MerchantName != nil) {
        [MerchantName release];
    }
    if (freightInformation != nil) {
        [freightInformation release];
    }
    if (shippingMethod != nil) {
        [shippingMethod release];
    }
    if (paymentMethod != nil) {
        [paymentMethod release];
    }
    [super dealloc];
}

@end
