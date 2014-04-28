//
//  BadgesEntity.m
//  TheStoreApp
//
//  Created by linyy on 11-7-30.
//  Copyright 2011 vsc. All rights reserved.
//

#import "BadgesEntity.h"


@implementation BadgesEntity

@synthesize nid;
@synthesize img;
@synthesize message;
@synthesize name;
@synthesize url;

-(void)dealloc{
	
	if(nid!=nil){
		[nid release];
	}
	if(img!=nil){
		[img release];
	}
	if(message!=nil){
		[message release];
	}
	if(name!=nil){
		[name release];
	}
	if(url!=nil){
		[url release];
	}
	[super dealloc];
}

@end
