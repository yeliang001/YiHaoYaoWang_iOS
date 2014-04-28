//
//  ProvinceVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-1-27.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProvinceVO : NSObject {
@private
	NSNumber * nid;//对应id属性
	NSString * provinceName;
}
@property(retain,nonatomic)NSNumber * nid;
@property(retain,nonatomic)NSString * provinceName;
@end
