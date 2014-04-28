//
//  AdvertisingPromotionVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdvertisingPromotionVO.h"
#import "HotPointNewVO.h"

@implementation AdvertisingPromotionVO
@synthesize title,keywordList,advertisingType,hotPointNewVOList;

-(void)dealloc
{
    if (title!=nil) {
        [title release];
        title = nil;
    }
    if (keywordList!=nil) {
        [keywordList release];
        keywordList=nil;
    }
    if (advertisingType!=nil) {
        [advertisingType release];
        advertisingType=nil;
    }
    if (hotPointNewVOList!=nil) {
        [hotPointNewVOList release];
        hotPointNewVOList=nil;
    }
    [super dealloc];
}

-(NSMutableDictionary *)dictionaryFromVO
{
    NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
    if (title!=nil) {
        [mDictionary setObject:title forKey:@"title"];
    }
    //keywordList
    if (keywordList!=nil && [keywordList count]>0) {
        [mDictionary setObject:keywordList forKey:@"keywordList"];
    }
    //adType
    if (advertisingType!=nil) {
        [mDictionary setObject:advertisingType forKey:@"advertisingType"];
    }
    //hotPointNewVOList
    if (hotPointNewVOList!=nil && [hotPointNewVOList count]>0) {
        NSMutableArray *mArray=[[[NSMutableArray alloc] init] autorelease];
        for (HotPointNewVO *hotPointNewVO in hotPointNewVOList) {
            [mArray addObject:[hotPointNewVO dictionaryFromVO]];
        }
        [mDictionary setObject:mArray forKey:@"hotPointNewVOList"];
    }
    return [mDictionary autorelease];
}

+(id)voFromDictionary:(NSMutableDictionary *)mDictionary
{
    AdvertisingPromotionVO *vo=[[AdvertisingPromotionVO alloc] autorelease];
    id object = [mDictionary objectForKey:@"title"];
    if (object!=nil) {
        vo.title = object;
    }
    object=[mDictionary objectForKey:@"keywordList"];
    if (object!=nil) {
        vo.keywordList=object;
    }
    object=[mDictionary objectForKey:@"advertisingType"];
    if (object!=nil) {
        vo.advertisingType=object;
    }
    object=[mDictionary objectForKey:@"hotPointNewVOList"];
    if (object!=nil) {
        NSMutableArray *theArray=[[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<[object count]; i++) {
            [theArray addObject:[HotPointNewVO voFromDictionary:[object objectAtIndex:i]]];
        }
        vo.hotPointNewVOList=theArray;
    }
    return vo;
}
@end
