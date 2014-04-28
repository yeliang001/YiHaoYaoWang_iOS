//
//  CityVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CityVO : NSObject {
@private
	NSString * cityName;
	NSNumber * nid;//市/区县Id
}
@property(retain,nonatomic)NSString * cityName;
@property(retain,nonatomic)NSNumber * nid;//市/区县Id
@end
