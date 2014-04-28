//
//  LocationEntity.h
//  TheStoreApp
//
//  Created by yangxd on 11-7-14.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocationEntity : NSObject {
@private
	NSString * addr;
	NSString * guid;
	NSString * lon;
	NSString * lat;
	NSString * name;
}
@property(nonatomic, retain)NSString * addr;
@property(nonatomic, retain)NSString * guid;
@property(nonatomic, retain)NSString * lon;
@property(nonatomic, retain)NSString * lat;
@property(nonatomic, retain)NSString * name;
@end
