//
//  HotPointNewVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HotPointNewVO.h"
#import "ProductVO.h"
#import "GrouponVO.h"

@implementation HotPointNewVO
@synthesize nid;//热销活动id
@synthesize title;//热销活动名称
@synthesize subtitle;//活动副标题
@synthesize detailUrl;//热销活动地址
@synthesize type;////热销活动类型：0-热销商品；1- 热销活动 ；2- 市场活动规则；3-绑定团购；4新热销活动；5-热门促销(n元N件等促销活动)；6-热门促销(赠品、满减等促销活动
@synthesize promotionId;//促销活动Id
@synthesize promotionLevelId;// 促销级别Id
@synthesize picUrl;//轮播图片
@synthesize logoPicUrl;//活动logo图片
@synthesize topicId;//活动topicId
@synthesize productVOList;//商品列表(若为热销商品时返回)List<ProductVO>
@synthesize grouponVOList;//团购列表(若为绑定团购时返回)List<GrouponVO>
@synthesize ipadPicType;//ipad轮播图类型 0-长形图，1-方形图

-(void)dealloc
{
    if (nid!=nil) {
        [nid release];
        nid=nil;
    }
    if (title!=nil) {
        [title release];
        title=nil;
    }
    if (subtitle!=nil) {
        [subtitle release];
        subtitle =nil;
    }
    if (detailUrl!=nil) {
        [detailUrl release];
        detailUrl=nil;
    }
    if (type!=nil) {
        [type release];
        type=nil;
    }
    if (promotionId!=nil) {
        [promotionId release];
        promotionId = nil;
    }
    if (promotionLevelId!=nil) {
        [promotionLevelId release];
        promotionLevelId = nil;
    }
    if (picUrl!=nil) {
        [picUrl release];
        picUrl=nil;
    }
    if (logoPicUrl!=nil) {
        [logoPicUrl release];
        logoPicUrl=nil;
    }
    if (topicId!=nil) {
        [topicId release];
        topicId=nil;
    }
    if (productVOList!=nil) {
        [productVOList release];
        productVOList=nil;
    }
    if (grouponVOList!=nil) {
        [grouponVOList release];
        grouponVOList=nil;
    }
    if (ipadPicType!=nil) {
        [ipadPicType release];
        ipadPicType = nil;
    }
    [super dealloc];
}

-(NSMutableDictionary *)dictionaryFromVO
{
    NSMutableDictionary *mDictionary=[[[NSMutableDictionary alloc] init] autorelease];
    if (nid!=nil) {
        [mDictionary setObject:nid forKey:@"nid"];
    }
    if (title!=nil) {
        [mDictionary setObject:title forKey:@"title"];
    }
    if (subtitle!=nil) {
        [mDictionary setObject:subtitle forKey:@"subtitle"];
    }
    if (detailUrl!=nil) {
        [mDictionary setObject:detailUrl forKey:@"detailUrl"];
    }
    if (type!=nil) {
        [mDictionary setObject:type forKey:@"type"];
    }
    if (promotionId!=nil) {
        [mDictionary setObject:promotionId forKey:@"promotionId"];
    }
    if (promotionLevelId!=nil) {
        [mDictionary setObject:promotionLevelId forKey:@"promotionLevelId"];
    }
    if (picUrl!=nil) {
        [mDictionary setObject:picUrl forKey:@"picUrl"];
    }
    if (logoPicUrl!=nil) {
        [mDictionary setObject:logoPicUrl forKey:@"logoPicUrl"];
    }
    if (topicId!=nil) {
        [mDictionary setObject:topicId forKey:@"topicId"];
    }
    if (productVOList!=nil && [productVOList count]>0) {
        NSMutableArray *mArray=[[[NSMutableArray alloc] init] autorelease];
        for (ProductVO *productVO in productVOList) {
            [mArray addObject:[productVO dictionaryFromVO]];
        }
        [mDictionary setObject:mArray forKey:@"productVOList"];
    }
    if (grouponVOList!=nil && [grouponVOList count]>0) {
        NSMutableArray *mArray=[[[NSMutableArray alloc] init] autorelease];
        for (GrouponVO *grouponVO in grouponVOList) {
            [mArray addObject:[grouponVO dictionaryFromVO]];
        }
        [mDictionary setObject:grouponVOList forKey:@"grouponVOList"];
    }
    if (ipadPicType!=nil) {
        [mDictionary setObject:ipadPicType forKey:@"ipadPicType"];
    }
    return mDictionary;
}

+(id)voFromDictionary:(NSMutableDictionary *)mDictionary
{
    HotPointNewVO *vo=[[HotPointNewVO alloc] autorelease];
    id object=[mDictionary objectForKey:@"nid"];
    if (object!=nil) {
        vo.nid=object;
    }
    object=[mDictionary objectForKey:@"title"];
    if (object!=nil) {
        vo.title=object;
    }
    object = [mDictionary objectForKey:@"subtitle"];
    if (object!=nil) {
        vo.subtitle=object;
    }
    object=[mDictionary objectForKey:@"detailUrl"];
    if (object!=nil) {
        vo.detailUrl=object;
    }
    object=[mDictionary objectForKey:@"type"];
    if (object!=nil) {
        vo.type=object;
    }
    object=[mDictionary objectForKey:@"promotionId"];
    if (object!=nil) {
        vo.promotionId=object;
    }
    object=[mDictionary objectForKey:@"promotionLevelId"];
    if (object!=nil) {
        vo.promotionLevelId=object;
    }
    object=[mDictionary objectForKey:@"picUrl"];
    if (object!=nil) {
        vo.picUrl=object;
    }
    object=[mDictionary objectForKey:@"logoPicUrl"];
    if (object!=nil) {
        vo.logoPicUrl=object;
    }
    object=[mDictionary objectForKey:@"topicId"];
    if (object!=nil) {
        vo.topicId=object;
    }
    object=[mDictionary objectForKey:@"productVOList"];
    if (object!=nil) {
        NSMutableArray *theArray=[[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<[object count]; i++) {
            [theArray addObject:[ProductVO voFromDictionary:[object objectAtIndex:i]]];
        }
        vo.productVOList=theArray;
    }
    object=[mDictionary objectForKey:@"grouponVOList"];
    if (object!=nil) {
        NSMutableArray *theArray=[[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<[object count]; i++) {
            [theArray addObject:[GrouponVO voFromDictionary:[object objectAtIndex:i]]];
        }
        vo.grouponVOList=theArray;
    }
    object=[mDictionary objectForKey:@"ipadPicType"];
    if (object!=nil) {
        vo.ipadPicType=object;
    }
    return vo;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:nid forKey:@"nid"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:subtitle forKey:@"subtitle"];
    [aCoder encodeObject:detailUrl forKey:@"detailUrl"];
    [aCoder encodeObject:type forKey:@"type"];
    [aCoder encodeObject:promotionId forKey:@"promotionId"];
    [aCoder encodeObject:promotionLevelId forKey:@"promotionLevelId"];
    [aCoder encodeObject:picUrl forKey:@"picUrl"];
    [aCoder encodeObject:logoPicUrl forKey:@"logoPicUrl"];
    [aCoder encodeObject:topicId forKey:@"topicId"];
    [aCoder encodeObject:productVOList forKey:@"productVOList"];
    [aCoder encodeObject:grouponVOList forKey:@"grouponVOList"];
    [aCoder encodeObject:ipadPicType forKey:@"ipadPicType"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.nid = [aDecoder decodeObjectForKey:@"nid"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
    self.detailUrl = [aDecoder decodeObjectForKey:@"detailUrl"];
    self.type = [aDecoder decodeObjectForKey:@"type"];
    self.promotionId = [aDecoder decodeObjectForKey:@"promotionId"];
    self.promotionLevelId = [aDecoder decodeObjectForKey:@"promotionLevelId"];
    self.picUrl = [aDecoder decodeObjectForKey:@"picUrl"];
    self.logoPicUrl = [aDecoder decodeObjectForKey:@"logoPicUrl"];
    self.topicId = [aDecoder decodeObjectForKey:@"topicId"];
    self.productVOList = [aDecoder decodeObjectForKey:@"productVOList"];
    self.grouponVOList = [aDecoder decodeObjectForKey:@"grouponVOList"];
    self.ipadPicType = [aDecoder decodeObjectForKey:@"ipadPicType"];
    return self;
}
@end
