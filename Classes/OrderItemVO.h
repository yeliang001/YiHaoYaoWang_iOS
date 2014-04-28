//
//  OrderItemVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductVO;

@interface OrderItemVO : NSObject {
@private
	NSNumber * buyQuantity;//购买数量
	ProductVO * product;//产品
}
@property(retain,nonatomic)NSNumber * buyQuantity;//购买数量
@property(retain,nonatomic)ProductVO * product;//产品
@end
