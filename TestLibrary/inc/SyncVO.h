//
//  SyncVO.h
//  TheStoreApp
//
//  Created by yangxd on 11-7-14.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SyncVO : NSObject {
@private
	NSMutableArray * list;
	NSString * numItems;
}
@property(nonatomic, retain)NSMutableArray * list;
@property(nonatomic, retain)NSString * numItems;
@end
