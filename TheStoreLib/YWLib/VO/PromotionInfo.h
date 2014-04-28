//
//  PromotionInfo.h
//  TheStoreApp
//
//  Created by LinPan on 14-1-9.
//
//

#import <Foundation/Foundation.h>
#import "YWConst.h"

/**
 *促销信息
 *商品列表中的促销信息和购物车中的促销信息的数据结构不一致，但是为了统一 就用一个对象表示
 */
@interface PromotionInfo : NSObject

@property (assign, nonatomic) NSInteger promotionId;
@property (assign, nonatomic) kYaoPromotionType promotionType;     //满额减 满赠减  等具体类型
@property (assign, nonatomic) kYaoPromotionType promotionCategory; //促销的大分类 就两个:满减＝1 满赠＝3
@property (copy, nonatomic) NSString *promotionName;
//赠品数组 元素为GiftInfo
@property (retain, nonatomic) NSMutableArray *gifts;
/**
 *促销条件 
 *在商品列表中 一个商品有多个梯度 所以用数组
 *在购物车中只返回满足最高条件的梯度，所以只有一个值
 */
@property (retain, nonatomic) NSMutableArray *conditions;


//////下面的是为购物车的促销信息 加入的
//该促销对应的商品itemId数组
@property (retain, nonatomic) NSMutableArray *productItemIdArr;
@property (retain, nonatomic) NSMutableArray *productArr; //根据上米的productItemIdArr 的itemId招到对应的product  放在此数组里
//该促销可以领多少赠品
@property (assign, nonatomic) NSInteger giftCount;   // 本来是 已经告诉服务器已经选择了的赠品个数  但是好像没用
@property (copy, nonatomic) NSString *promotionDesc; // "活动商品已购满1件，可以享受满减优惠"
@property (copy, nonatomic) NSString *promotionResult; // eg"已减现金5.0元“

@property (assign, nonatomic) NSInteger selectedGiftCount; //该促销已经选中的赠品数量 ，本地记录
@property (assign, nonatomic) NSInteger satisfy; //当前购物车里得商品是不是满足该促销 0 ,1
@property (assign, nonatomic) NSInteger totalMoneyInPromotion; //该促销中的总价

@end
