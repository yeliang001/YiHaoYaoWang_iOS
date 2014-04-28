//
//  CountyVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CountyVO : NSObject {
@private
	NSString * countyName;
	NSNumber * nid;
	NSString * postcode;
}
@property(retain,nonatomic)NSString * countyName;
@property(retain,nonatomic)NSNumber * nid;
@property(retain,nonatomic)NSString * postcode;
@end
