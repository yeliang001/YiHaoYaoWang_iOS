//
//  FavoriteVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductVO;

@interface FavoriteVO : NSObject {
@private
	NSNumber * nid;//收藏产品Id
	NSNumber * mcsiteid;
	ProductVO * product;
}
@property(retain,nonatomic)NSNumber * nid;//收藏产品Id
@property(retain,nonatomic)NSNumber * mcsiteid;
@property(retain,nonatomic)ProductVO * product;
@end
