//
//  SeckillResultVO.h
//  TheStoreApp
//
//  Created by towne on 13-4-26.
//
//

#import <Foundation/Foundation.h>

@interface SeckillResultVO : NSObject{
@private
    NSNumber * provinceId;
    NSString * promotionId;
    NSNumber * productId;
    NSNumber * quantity;   //数量
    NSNumber * resultCode; //(0 失败；1 没有商品，2 你已经秒杀过了 3成功)
    NSNumber * seckillPrice;//秒杀价格
    NSNumber * price;//普通价格
}

@property(nonatomic,retain) NSNumber *provinceId;
@property(nonatomic,retain) NSString *promotionId;
@property(nonatomic,retain) NSNumber *productId;
@property(nonatomic,retain) NSNumber *quantity;
@property(nonatomic,retain) NSNumber *resultCode;
@property(nonatomic,retain) NSNumber *seckillPrice;
@property(nonatomic,retain) NSNumber *price;

@end
