//
//  AdFloorInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-7-29.
//
//

#import "AdFloorInfo.h"

@implementation AdFloorInfo

- (void)dealloc
{
    [_title release];
    [_titleImgUrl release];
    [_productList release];
    [_keywordList release];
    [super dealloc];
}



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_titleImgUrl forKey:@"titleUrl"];
    [aCoder encodeObject:_productList forKey:@"productList"];
    [aCoder encodeObject:_keywordList forKey:@"keywordList"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.titleImgUrl = [aDecoder decodeObjectForKey:@"titleUrl"];
    self.productList = [aDecoder decodeObjectForKey:@"productList"];
    self.keywordList = [aDecoder decodeObjectForKey:@"keywordList"];
    return  self;
}

@end
