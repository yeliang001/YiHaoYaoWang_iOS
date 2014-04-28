//
//  CategoryVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "CategoryVO.h"


@implementation CategoryVO

@synthesize categoryName;
@synthesize nid;//分类Id
@synthesize fatherId;
@synthesize advCode;
@synthesize categoryPicUrl;
@synthesize childCategoryVOList;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:categoryName forKey:@"categoryName"];
    [aCoder encodeObject:nid forKey:@"nid"];
    [aCoder encodeObject:fatherId forKey:@"fatherId"];
    [aCoder encodeObject:advCode forKey:@"advCode"];
    [aCoder encodeObject:categoryPicUrl forKey:@"categoryPicUrl"];
    [aCoder encodeObject:childCategoryVOList forKey:@"childCategoryVOList"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
    self.nid = [aDecoder decodeObjectForKey:@"nid"];
    self.childCategoryVOList = [aDecoder decodeObjectForKey:@"childCategoryVOList"];
    self.categoryPicUrl = [aDecoder decodeObjectForKey:@"categoryPicUrl"];
    self.advCode = [aDecoder decodeObjectForKey:@"advCode"];
    self.fatherId = [aDecoder decodeObjectForKey:@"fatherId"];
    return self;
}

-(void)dealloc{
    if(categoryName!=nil){
        [categoryName release];
    }
    if(nid!=nil){
        [nid release];
    }
    OTS_SAFE_RELEASE(fatherId);
    OTS_SAFE_RELEASE(categoryPicUrl);
    OTS_SAFE_RELEASE(childCategoryVOList);
    OTS_SAFE_RELEASE(advCode);
    
    [super dealloc];
}

@end
