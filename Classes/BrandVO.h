//
//  BrandVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BrandVO : NSObject{
@private
	NSString * brandName;
	NSNumber * nid;//品牌Id
}
@property(retain,nonatomic)NSString * brandName;
@property(retain,nonatomic)NSNumber * nid;//品牌Id
@end
