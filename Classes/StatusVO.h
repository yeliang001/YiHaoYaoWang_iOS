//
//  StatusVO.h
//  TheStoreApp
//
//  Created by linyy on 11-7-30.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StatusVO : NSObject {
	
@private NSMutableArray * list;
@private NSString * times;
	
}

@property(nonatomic,retain)NSMutableArray * list;
@property(nonatomic,retain)NSString * times;

@end
