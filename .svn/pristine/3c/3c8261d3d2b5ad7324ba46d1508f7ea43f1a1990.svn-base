//
//  GrouponSerialVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GrouponSerialVO.h"

@implementation GrouponSerialVO
@synthesize nid;
@synthesize grouponId;
@synthesize mainProductId;
@synthesize subProductId;
@synthesize productColor;
@synthesize productSize;
@synthesize upperSaleNum;
@synthesize boughtNum;

-(void)dealloc
{
    if (nid!=nil) {
        [nid release];
    }
    if (grouponId!=nil) {
        [grouponId release];
    }
    if (mainProductId!=nil) {
        [mainProductId release];
    }
    if (subProductId!=nil) {
        [subProductId release];
    }
    if (productColor!=nil) {
        [productColor release];
    }
    if (productSize!=nil) {
        [productSize release];
    }
    if (upperSaleNum!=nil) {
        [upperSaleNum release];
    }
    if (boughtNum!=nil) {
        [boughtNum release];
    }
    [super dealloc];
}

-(NSMutableDictionary *)dictionaryFromVO
{
    NSMutableDictionary *mDictionary=[[[NSMutableDictionary alloc] init] autorelease];
    if (nid!=nil) {
        [mDictionary setObject:nid forKey:@"nid"];
    }
    if (grouponId!=nil) {
        [mDictionary setObject:grouponId forKey:@"grouponId"];
    }
    if (mainProductId!=nil) {
        [mDictionary setObject:mainProductId forKey:@"mainProductId"];
    }
    if (subProductId!=nil) {
        [mDictionary setObject:subProductId forKey:@"subProductId"];
    }
    if (productColor!=nil) {
        [mDictionary setObject:productColor forKey:@"productColor"];
    }
    if (productSize!=nil) {
        [mDictionary setObject:productSize forKey:@"productSize"];
    }
    if (upperSaleNum!=nil) {
        [mDictionary setObject:upperSaleNum forKey:@"upperSaleNum"];
    }
    if (boughtNum!=nil) {
        [mDictionary setObject:boughtNum forKey:@"boughtNum"];
    }
    return mDictionary;
}
+(id)voFromDictionary:(NSMutableDictionary *)mDictionary
{
    GrouponSerialVO *vo=[[GrouponSerialVO alloc] autorelease];
    id object=[mDictionary objectForKey:@"nid"];
    if (object!=nil) {
        vo.nid=object;
    }
    object=[mDictionary objectForKey:@"grouponId"];
    if (object!=nil) {
        vo.grouponId=object;
    }
    object=[mDictionary objectForKey:@"mainProductId"];
    if (object!=nil) {
        vo.mainProductId=object;
    }
    object=[mDictionary objectForKey:@"subProductId"];
    if (object!=nil) {
        vo.subProductId=object;
    }
    object=[mDictionary objectForKey:@"productColor"];
    if (object!=nil) {
        vo.productColor=object;
    }
    object=[mDictionary objectForKey:@"productSize"];
    if (object!=nil) {
        vo.productSize=object;
    }
    object=[mDictionary objectForKey:@"upperSaleNum"];
    if (object!=nil) {
        vo.upperSaleNum=object;
    }
    object=[mDictionary objectForKey:@"boughtNum"];
    if (object!=nil) {
        vo.boughtNum=object;
    }
    return vo;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:nid forKey:@"nid"];
    [aCoder encodeObject:grouponId forKey:@"grouponId"];
    [aCoder encodeObject:mainProductId forKey:@"mainProductId"];
    [aCoder encodeObject:subProductId forKey:@"subProductId"];
    [aCoder encodeObject:productColor forKey:@"productColor"];
    [aCoder encodeObject:productSize forKey:@"productSize"];
    [aCoder encodeObject:upperSaleNum forKey:@"upperSaleNum"];
    [aCoder encodeObject:boughtNum forKey:@"boughtNum"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self.nid = [aDecoder decodeObjectForKey:@"nid"];
    self.grouponId = [aDecoder decodeObjectForKey:@"grouponId"];
    self.mainProductId = [aDecoder decodeObjectForKey:@"mainProductId"];
    self.subProductId = [aDecoder decodeObjectForKey:@"subProductId"];
    self.productColor = [aDecoder decodeObjectForKey:@"productColor"];
    self.productSize = [aDecoder decodeObjectForKey:@"productSize"];
    self.upperSaleNum = [aDecoder decodeObjectForKey:@"upperSaleNum"];
    self.boughtNum = [aDecoder decodeObjectForKey:@"boughtNum"];
    return self;
}

@end
