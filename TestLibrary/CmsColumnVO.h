//
//  CmsColumnVO.h
//  TheStoreApp
//
//  Created by yiming dong on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CmsColumnVO : NSObject
@property(retain)NSNumber           *nid;
@property(copy)NSString             *name;
@property(retain)NSMutableArray     *productList;
@end
