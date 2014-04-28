//
//  ConditionInfo.h
//  TheStoreApp
//
//  Created by LinPan on 14-1-8.
//
//

#import <Foundation/Foundation.h>
#import "YWConst.h"
//促销的条件信息  eg:“满100减99”
@interface ConditionInfo : NSObject

@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger promotionId;
@property (assign, nonatomic) NSInteger requirement;  //促销需要满足的条件
@property (assign, nonatomic) NSInteger reward;  // 满足之后的奖励
@property (assign, nonatomic) NSInteger conditionId;//梯度的id 对应json中的“id”  用于删选赠品


- (NSString *)promotionStringByPromotionType:(kYaoPromotionType)type;
- (NSString *)promotionFlagByPromotionType:(kYaoPromotionType)type;
@end
