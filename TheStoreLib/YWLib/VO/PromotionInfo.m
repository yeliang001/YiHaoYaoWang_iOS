//
//  PromotionInfo.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-9.
//
//

#import "PromotionInfo.h"

@implementation PromotionInfo

- (id)init
{
    self = [super init];
    if (self)
    {
        _productArr = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_promotionName release];
    [_gifts release];
    [_conditions release];
    [_productItemIdArr release];
    [_promotionDesc release];
    [_promotionResult release];
    [_productArr release];
    [super dealloc];
}

@end
