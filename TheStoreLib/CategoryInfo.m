//
//  CategoryInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-7-24.
//
//

#import "CategoryInfo.h"

@implementation CategoryInfo


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cid forKey:@"cid"];
    [aCoder encodeObject:_parentId forKey:@"parentId"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_imageUrl forKey:@"imageUrl"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.cid = [aDecoder decodeObjectForKey:@"cid"];
    self.parentId = [aDecoder decodeObjectForKey:@"parentId"];
    self.type = [aDecoder decodeObjectForKey:@"type"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
    return self;
}

- (void)dealloc
{
    [_cid release];
    [_parentId release];
    [_type release];
    [_name release];
    [_imageUrl release];
    [super dealloc];
}

@end
