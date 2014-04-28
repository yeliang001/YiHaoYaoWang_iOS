//
//  OrderV2.h
//  TheStoreApp
//
//  Created by yangxd on 11-6-13.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderVO.h"

@interface OrderV2 : OrderVO {
	NSNumber * gateway;
}
@property(nonatomic, retain)NSNumber * gateway;

-(id)initWithOrderVO:(OrderVO*)anOrderVO;

@end
