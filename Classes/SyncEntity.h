//
//  SyncEntity.h
//  TheStoreApp
//
//  Created by yangxd on 11-7-14.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncEntity : NSObject {
@private
	NSString * canSet;
	NSString * icon;
	NSString * isSet;
	NSString * name;
	NSString * target;
	NSString * url;
}
@property(nonatomic, retain)NSString * canSet;
@property(nonatomic, retain)NSString * icon;
@property(nonatomic, retain)NSString * isSet;
@property(nonatomic, retain)NSString * name;
@property(nonatomic, retain)NSString * target;
@property(nonatomic, retain)NSString * url;
@end
