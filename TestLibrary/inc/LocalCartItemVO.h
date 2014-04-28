//
//  LocalCartItemVO.h
//  TheStoreApp
//
//  Created by linyy on 11-7-6.
//  Copyright 2011年 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductVO;

@interface LocalCartItemVO : NSObject {
@private NSString * productId;					// 商品Id	
@private NSString * cnName;						// 商品名
@private NSString * price;						// 商品价格
@private NSString * shoppingCount;				// 商品起购数量
@private NSString * miniDefaultProductUrl;		// 商品图片url
@private NSString * merchantId;					// 商户Id
@private NSString * quantity;					// 商品数量
@private NSString * promotionId;
@private NSString * promotionPrice;
@private NSString * hasGift;
@private NSString * mobileProductType;
}

@property(retain,nonatomic) NSString * productId;
@property(retain,nonatomic) NSString * cnName;
@property(retain,nonatomic) NSString * price;
@property(retain,nonatomic) NSString * shoppingCount;
@property(retain,nonatomic) NSString * miniDefaultProductUrl;
@property(retain,nonatomic) NSString * merchantId;
@property(retain,nonatomic) NSString * quantity;
@property(retain,nonatomic) NSString * promotionId;
@property(retain,nonatomic) NSString * promotionPrice;
@property(retain,nonatomic) NSString * hasGift;
@property(copy,nonatomic) NSString * mobileProductType;
-(id)initWithProductVO:(ProductVO *)aProductVO quantity:(NSString *)quantityStr;	// 初始化本地购物车商品
-(ProductVO *)changeToProductVO;
-(int)productCount;
@end
