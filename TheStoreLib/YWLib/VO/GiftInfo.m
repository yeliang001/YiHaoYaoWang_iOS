//
//  GiftInfo.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-8.
//
//

#import "GiftInfo.h"

@implementation GiftInfo


- (id)init
{
    self = [super init];
    if (self)
    {
        _selectedCount = 1;
    }
    
    return self;
}

- (void)dealloc
{
    [_giftId release];
    [_giftName release];
    [_detailProduct release];
    [super dealloc];
}


- (NSString *)giftImageStr
{
    NSString *baseUrl = @"http://p2.maiyaole.com/img/";
    baseUrl = [baseUrl stringByAppendingString:[NSString stringWithFormat:@"%d/%d/120_120.jpg",_itemId/1000,_itemId]];
    return baseUrl;
}


@end
