//
//  CategoryVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryVO : NSObject {
@private
	NSString * categoryName;
	NSNumber * nid;//分类Id
}
@property(retain,nonatomic)NSString * categoryName;
@property(retain,nonatomic)NSNumber * nid;//分类Id
@end
