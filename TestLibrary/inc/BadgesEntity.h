//
//  BadgesEntity.h
//  TheStoreApp
//
//  Created by linyy on 11-7-30.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BadgesEntity : NSObject {
	
@private NSString * nid;
@private NSString * img;
@private NSString * message;
@private NSString * name;
@private NSString * url;
	
}

@property(nonatomic,retain)NSString * nid;
@property(nonatomic,retain)NSString * img;
@property(nonatomic,retain)NSString * message;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * url;

@end
