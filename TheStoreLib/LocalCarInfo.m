//
//  LocalCarInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-23.
//
//  本地购物车

#import "LocalCarInfo.h"

@implementation LocalCarInfo

- (id)initWithProductId:(NSString *)aProductId
          shoppingCount:(NSString *)count
               imageUrl:(NSString *)imgurl
                  price:(NSString *)aPrice
             provinceId:(NSString *)aProvinceId
                    uid:(NSString *)aUid
              productNO:(NSString *)aProductNO
                 itemId:(NSString *)aItemId
{
    self = [super init];
    if (self)
    {
        _productId = [aProductId copy];
        _num = [count copy];
        _imageUrlStr = [imgurl copy];
        _price = [aPrice copy];
        _provinceId = [aProvinceId copy];
        _uid = [aUid copy];
        _productNO = [aProductNO copy];
        _itemId = [aItemId copy];
    }
    
    return self;
}



- (void)dealloc
{
    [_productId release];
    [_imageUrlStr release];
    [_uid release];
    [_num release];
    [_provinceId release];
    [_price release];
    [_productNO release];
    [_itemId release];
    [super dealloc];
}



@end
