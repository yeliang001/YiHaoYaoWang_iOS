//
//  CmsPageVO.m
//  TheStoreApp
//
//  Created by yiming dong on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CmsPageVO.h"

@implementation CmsPageVO
@synthesize nid, logoPicUrl, name, type;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:nid forKey:@"nid"];
    [aCoder encodeObject:logoPicUrl forKey:@"logoPicUrl"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:type forKey:@"type"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.nid = [aDecoder decodeObjectForKey:@"nid"];
    self.logoPicUrl = [aDecoder decodeObjectForKey:@"logoPicUrl"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.type = [aDecoder decodeObjectForKey:@"type"];
    return self;
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(nid);
    OTS_SAFE_RELEASE(logoPicUrl);
    OTS_SAFE_RELEASE(name);
    OTS_SAFE_RELEASE(type);
    
    [super dealloc];
}
@end
