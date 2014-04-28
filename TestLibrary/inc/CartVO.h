//
//  CartVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CartVO : NSObject {
@private
	NSMutableArray * buyItemList;
	NSMutableArray * gifItemtList;
	NSNumber * totalprice;
	NSNumber * totalquantity;
	NSNumber * totalsavedprice;
    NSNumber * totalWeight;
}
@property(retain,nonatomic)NSMutableArray * buyItemList;
@property(retain,nonatomic)NSMutableArray * gifItemtList;
@property(retain,nonatomic)NSNumber * totalprice;
@property(retain,nonatomic)NSNumber * totalquantity;
@property(retain,nonatomic)NSNumber * totalsavedprice;
@property(retain,nonatomic)NSNumber * totalWeight;
@end
