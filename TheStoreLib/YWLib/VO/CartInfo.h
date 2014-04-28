//
//  CartInfo.h
//  TheStoreApp
//
//  Created by LinPan on 14-1-21.
//
//

#import <Foundation/Foundation.h>
//购物车里获取到所有商品、赠品、促销等信息
@interface CartInfo : NSObject
//运费
@property (assign, nonatomic) CGFloat fare;
//总价
@property (assign, nonatomic) CGFloat money;
//重量
@property (assign, nonatomic) CGFloat weight;
//购物车的商品列表
@property (retain, nonatomic) NSMutableArray *productList;
//促销信息
@property (retain, nonatomic) NSMutableArray *promotionList;

//购物车中的商品是不是有赠品可以选
- (BOOL)hasGift;

//获取购物车商品中的满减的促销
- (NSMutableArray *)getPromotionOfReduce;
//获取购物车商品中的满赠的促销
- (NSMutableArray *)getPromotionOfGift;

@end
