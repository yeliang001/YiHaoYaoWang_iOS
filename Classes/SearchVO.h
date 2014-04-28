//
//  SearchVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchVO : NSObject {
@private
	NSString * keyword;
	NSNumber * minPrice;
	NSNumber * searchCount;
}
@property(retain,nonatomic)NSString * keyword;
@property(retain,nonatomic)NSNumber * minPrice;
@property(retain,nonatomic)NSNumber * searchCount;
@end
