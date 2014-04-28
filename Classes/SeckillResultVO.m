//
//  SeckillResultVO.m
//  TheStoreApp
//
//  Created by towne on 13-4-26.
//
//
//参数为： resultCode(0 失败；1 没有商品，2 你已经秒杀过了 3  成功)，其他参数无用
#import "SeckillResultVO.h"

@implementation SeckillResultVO
@synthesize provinceId;
@synthesize promotionId;
@synthesize productId;
@synthesize quantity;
@synthesize resultCode;
@synthesize seckillPrice;
@synthesize price;

-(void)dealloc
{
    if (provinceId!=nil) {
        [provinceId release];
        provinceId=nil;
    }
    if (promotionId!=nil) {
        [promotionId release];
        promotionId=nil;
    }
    if (productId!=nil) {
        [productId release];
        productId=nil;
    }
    if (quantity!=nil) {
        [quantity release];
        quantity=nil;
    }
    if (resultCode!=nil) {
        [resultCode release];
        resultCode=nil;
    }
    if (seckillPrice!=nil) {
        [seckillPrice release];
        seckillPrice=nil;
    }
    if (price!=nil) {
        [price release];
        price=nil;
    }
    [super dealloc];
}
@end
