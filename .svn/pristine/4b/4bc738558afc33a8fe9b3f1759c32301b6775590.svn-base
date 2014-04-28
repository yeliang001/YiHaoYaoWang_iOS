//
//  AdvertisingPromotion.m
//  TheStoreApp
//
//  Created by jiming huang on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdvertisingPromotion.h"
#import "AdvertisingPromotionVO.h"

@implementation AdvertisingPromotion

@synthesize advertisingPromotionVOList,isUpdate,updateTag;

-(void)dealloc
{
    if (advertisingPromotionVOList!=nil) {
        [advertisingPromotionVOList release];
        advertisingPromotionVOList=nil;
    }
    if (isUpdate!=nil) {
        [isUpdate release];
        isUpdate=nil;
    }
    if (updateTag!=nil) {
        [updateTag release];
        updateTag=nil;
    }
    [super dealloc];
}

-(NSMutableDictionary *)dictionaryFromVO
{
    NSMutableDictionary *mDictionary=[[[NSMutableDictionary alloc] init] autorelease];
    //advertisingPromotionVOList
    if (advertisingPromotionVOList!=nil && [advertisingPromotionVOList count]>0) {
        NSMutableArray *mArray=[[[NSMutableArray alloc] init] autorelease];
        for (AdvertisingPromotionVO *adPromotionVO in advertisingPromotionVOList) {
            [mArray addObject:[adPromotionVO dictionaryFromVO]];
        }
        [mDictionary setObject:mArray forKey:@"advertisingPromotionVOList"];
    }
    //isUpdate
    if (isUpdate!=nil) {
        [mDictionary setObject:isUpdate forKey:@"isUpdate"];
    }
    //updateTag
    if (updateTag!=nil) {
        [mDictionary setObject:updateTag forKey:@"updateTag"];
    }
    return mDictionary;
}

+(id)voFromDictionary:(NSMutableDictionary *)mDictionary
{
    AdvertisingPromotion *vo=[[AdvertisingPromotion alloc] autorelease];
    id object=[mDictionary objectForKey:@"advertisingPromotionVOList"];
    if (object!=nil) {
        NSMutableArray *theArray=[[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<[object count]; i++) {
            [theArray addObject:[AdvertisingPromotionVO voFromDictionary:[object objectAtIndex:i]]];
        }
        vo.advertisingPromotionVOList=theArray;
    }
    object=[mDictionary objectForKey:@"isUpdate"];
    if (object!=nil) {
        vo.isUpdate=object;
    }
    object=[mDictionary objectForKey:@"updateTag"];
    if (object!=nil) {
        vo.updateTag=object;
    }
    return vo;
}
@end
