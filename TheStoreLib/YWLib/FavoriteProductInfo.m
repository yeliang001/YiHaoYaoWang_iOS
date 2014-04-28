//
//  FavoriteProductInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-19.
//
//

#import "FavoriteProductInfo.h"

@implementation FavoriteProductInfo

- (void)dealloc
{
    [_addTime release];
    [_catId release];
    [_catalogId release];
    [_favorCatId release];
    [_flag release];
    [_goodsId release];
    [_favoriteId release];
    [_newUserNote release];
    [_nowPrice release];
    [_oldUserNote release];
    [_pid release];
    [_popularity release];
    [_price release];
    [_productImgUrl release];
    [_productName release];
    [_siteId release];
    [_userId release];
    [_userName release];
    [_userNote release];
    [_userTagName release];
    [_venderId release];
    [_venderName release];
    [_stockInfo release];
    [super dealloc];
}


- (BOOL)isOnSale
{
    return _status == 8;
}

- (NSInteger)currentStock
{
    if (_stockInfo && ![_stockInfo isKindOfClass:[NSNull class]])
    {
        NSArray *stockArr = [_stockInfo componentsSeparatedByString:@"_"];
        if (stockArr.count >= 3)
        {
            return [stockArr[2] intValue];
        }
    }
    
    return 0;
}


@end
