//
//  CartBagVO.h
//  TheStoreApp
//
//  Created by xuexiang on 12-11-30.
//
//

#import <Foundation/Foundation.h>

@interface CartBagVO : NSObject{
    NSNumber* serialVersionUID;
    
	NSNumber* merchantId;       // 商家Id
    
	NSString* merchantName;     // 商家名称
	NSNumber* totalquantity;    // 总数量
	NSNumber* totalAmount;      // 总金额
	NSNumber* totalWeight;      // 总重量
	NSNumber* totalSaveMoney;   // 总节省金额
	NSNumber* totalDeliveryFee; // 这个包裹的总运费
	NSString* freeDeliveryFeeRule;//免运费规则信息
	NSArray* cartItemVOs;       //购买产品列表 ,对象为CartItemVO
    NSNumber* totalNeedPoint ;////需要的积分数量 long
}
@property(nonatomic, retain)NSNumber* serialVersionUID;
@property(nonatomic, retain)NSNumber* merchantId;
@property(nonatomic, retain)NSString* merchantName;
@property(nonatomic, retain)NSNumber* totalquantity;
@property(nonatomic, retain)NSNumber* totalAmount;
@property(nonatomic, retain)NSNumber* totalWeight;
@property(nonatomic, retain)NSNumber* totalSaveMoney;
@property(nonatomic, retain)NSNumber* totalDeliveryFee;
@property(nonatomic, retain)NSString* freeDeliveryFeeRule;
@property(nonatomic, retain)NSArray* cartItemVOs;
@property(nonatomic, retain)NSNumber* totalNeedPoint;
@end
