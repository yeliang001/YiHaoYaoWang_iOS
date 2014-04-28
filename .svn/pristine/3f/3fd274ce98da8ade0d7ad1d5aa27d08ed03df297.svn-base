//
//  CartItemVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductVO;

@interface CartItemVO : NSObject {
@private
	NSNumber * buyQuantity;
	ProductVO * product;
	NSNumber * updateType;
    NSString * cashPromotionName; /*满减活动名称 */
    NSString * cashPromotionAmount;/*满减活动金额*/
    NSNumber * needPoint ;//需要的积分数量
}
@property(copy)NSNumber     * buyQuantity;
@property(retain,nonatomic)ProductVO    * product;
@property(retain,nonatomic)NSNumber     * updateType;
@property(retain,nonatomic)NSNumber     * grossWeight;
@property(retain,nonatomic)NSString     * cashPromotionName;
@property(retain,nonatomic)NSString     * cashPromotionAmount;
// extra properties
@property(copy)NSNumber     * buyQuantityCopy;
@property(nonatomic,retain)NSNumber * needPoint;
-(NSString *)toXML;
@end
