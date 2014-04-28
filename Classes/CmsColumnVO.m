//
//  CmsColumnVO.m
//  TheStoreApp
//
//  Created by yiming dong on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CmsColumnVO.h"

@implementation CmsColumnVO
@synthesize nid, name, productList;


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:nid forKey:@"nid"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:productList forKey:@"productList"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.nid = [aDecoder decodeObjectForKey:@"nid"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.productList = [aDecoder decodeObjectForKey:@"productList"];
    return self;
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(nid);
    OTS_SAFE_RELEASE(name);
    OTS_SAFE_RELEASE(productList);
    
    [super dealloc];
}

@end
