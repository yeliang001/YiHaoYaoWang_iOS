//
//  LocationEntity.m
//  TheStoreApp
//
//  Created by yangxd on 11-7-14.
//  Copyright 2011 vsc. All rights reserved.
//

#import "LocationEntity.h"

@implementation LocationEntity
@synthesize addr;
@synthesize guid;
@synthesize lon;
@synthesize lat;
@synthesize name;

-(void)dealloc {
	if (addr != nil) {
		[addr release];
	}
	if (guid != nil) {
		[guid release];
	}
	if (lon != nil) {
		[lon release];
	}
	if (lat != nil) {
		[lat release];
	}
	if (name != nil) {
		[name release];
	}
	[super dealloc];
}
@end
