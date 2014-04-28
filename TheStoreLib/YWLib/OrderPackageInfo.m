//
//  OrderPackageInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-13.
//
//

#import "OrderPackageInfo.h"


@implementation OrderProductDetail

- (void)dealloc
{
    [_productId release];     //商品
    [_productStatus release]; //商品状态 0正常 1正常 2取消
    [_productCount release];  //商品数量
    [_goodsId release];       //可能是itemid，tmd，傻逼啊，各种id
    [_productNo release];     //cnm,不知道是什么了，哪来这么多编号
    [_weight release];        //商品的重量
    [_productName release];
    [_brandName release];     //品牌名字
    [_catelogName release];   //分类名字
    [_price release];         //价格
    [_catelogId release];     //分类id
    [_backMoney release];
    [_userName release];
    [_userId release];
    [_productMarque release]; //产品型号
    [_brandId release];
    [_venderId release];     //商品卖家id
    [_splitLogs release];
    
    [super dealloc];
}

- (BOOL)isOTC
{
    if (_goodsType == 16)
    {
        return YES;
    }
    return NO;
}


@end





@implementation OrderPackageInfo
- (void)dealloc
{
    [_venderId release]; //卖家Id
    [_weight release];
    [_allGoodsMoney release];
    [_name release];
    [_packageId release];
    [_packageProductArr release]; //包裹中商品数组
    [_splitLogArr release];
    
    [super dealloc];
}

- (CGFloat)getRedeceMoneyByPromotion
{
    CGFloat reduceMoney = 0.0;
    for (OrderProductDetail *product in _packageProductArr)
    {
        reduceMoney += product.promotionAmount;
    }
    return reduceMoney;
}


@end
