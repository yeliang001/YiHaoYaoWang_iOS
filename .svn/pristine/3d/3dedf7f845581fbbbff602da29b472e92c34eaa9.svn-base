//
//  AdvertisementServer.m
//  TheStoreApp
//
//  Created by jiming huang on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdvertisementServer.h"
#import "AdvertisingPromotionVO.h"
#import "HotPointNewVO.h"
#import "GrouponVO.h"
#import "ProductVO.h"
#import "OTSUtility.h"

@implementation AdvertisementServer

-(Page *)getAdvertisementList:(Trader *)trader provinceId:(NSNumber *)provinceId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[Page class]])
    {
        Page * po = (Page*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(AdvertisingPromotion *)getCmsAdvertisingPromotion:(Trader *)trader provinceId:(NSNumber *)provinceId updateTag:(NSString *)updateTag
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addString:updateTag];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[AdvertisingPromotion class]])
    {
        AdvertisingPromotion * po = (AdvertisingPromotion*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
    /*
    AdvertisingPromotion *adPromotion=[[[AdvertisingPromotion alloc] init] autorelease];
    
    NSMutableArray *mArray=[[NSMutableArray alloc] init];
    [adPromotion setAdvertisingPromotionVOList:mArray];
    [mArray release];
    //0
    AdvertisingPromotionVO *adVO=[[AdvertisingPromotionVO alloc] init];
    NSMutableArray *keywords=[[NSMutableArray alloc] initWithObjects:@"星巴克", @"麦当劳", @"肯德基", @"必胜客", nil];
    [adVO setKeywordList:keywords];
    [keywords release];
    [adVO setAdvertisingType:[NSNumber numberWithInt:1]];
    NSMutableArray *adLists=[[NSMutableArray alloc] init];
    int i;
    for (i=0; i<6; i++) {
        HotPointNewVO *hotVO=[[HotPointNewVO alloc] init];
        [hotVO setPicUrl:@"aaa"];
        [hotVO setLogoPicUrl:@"bbb"];
        [hotVO setTitle:@"厨卫清洁中心"];
        NSMutableArray *productArray=[[NSMutableArray alloc] init];
        
        ProductVO *productVO=[[ProductVO alloc] init];
        [productVO setCnName:@"相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜"];
        [productVO setPrice:[NSNumber numberWithFloat:12.90]];
        [productArray addObject:productVO];
        [productVO release];
        
        productVO=[[ProductVO alloc] init];
        [productVO setCnName:@"LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士"];
        [productVO setPrice:[NSNumber numberWithFloat:10.90]];
        [productArray addObject:productVO];
        [productVO release];
        
        [hotVO setProductVOList:productArray];
        [productArray release];
        [adLists addObject:hotVO];
        [hotVO release];
    }
    [adVO setHotPointNewVOList:adLists];
    [adLists release];
    [mArray addObject:adVO];
    [adVO release];
    //1
    adVO=[[AdvertisingPromotionVO alloc] init];
    keywords=[[NSMutableArray alloc] initWithObjects:@"星巴克", @"麦当劳", @"肯德基", @"必胜客", nil];
    [adVO setKeywordList:keywords];
    [keywords release];
    [adVO setAdvertisingType:[NSNumber numberWithInt:2]];
    adLists=[[NSMutableArray alloc] init];
    for (i=0; i<6; i++) {
        HotPointNewVO *hotVO=[[HotPointNewVO alloc] init];
        [hotVO setPicUrl:@"aaa"];
        [hotVO setLogoPicUrl:@"bbb"];
        [hotVO setTitle:@"厨卫清洁中心"];
        NSMutableArray *productArray=[[NSMutableArray alloc] init];
        
        ProductVO *productVO=[[ProductVO alloc] init];
        [productVO setCnName:@"相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜"];
        [productVO setPrice:[NSNumber numberWithFloat:12.90]];
        [productArray addObject:productVO];
        [productVO release];
        
        productVO=[[ProductVO alloc] init];
        [productVO setCnName:@"LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士"];
        [productVO setPrice:[NSNumber numberWithFloat:10.90]];
        [productArray addObject:productVO];
        [productVO release];
        
        [hotVO setProductVOList:productArray];
        [productArray release];
        [adLists addObject:hotVO];
        [hotVO release];
    }
    [adVO setHotPointNewVOList:adLists];
    [adLists release];
    [mArray addObject:adVO];
    [adVO release];
    //2
    adVO=[[AdvertisingPromotionVO alloc] init];
    keywords=[[NSMutableArray alloc] initWithObjects:@"星巴克", @"麦当劳", @"肯德基", @"必胜客", nil];
    [adVO setKeywordList:keywords];
    [keywords release];
    [adVO setAdvertisingType:[NSNumber numberWithInt:0]];
    adLists=[[NSMutableArray alloc] init];
    for (i=0; i<6; i++) {
        HotPointNewVO *hotVO=[[HotPointNewVO alloc] init];
        [hotVO setPicUrl:@"aaa"];
        [hotVO setLogoPicUrl:@"bbb"];
        [hotVO setTitle:@"厨卫清洁中心"];
        NSMutableArray *productArray=[[NSMutableArray alloc] init];
        
        GrouponVO *grouponVO=[[GrouponVO alloc] init];
        [grouponVO setName:@"相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜"];
        [grouponVO setPrice:[NSNumber numberWithFloat:12.90]];
        [productArray addObject:grouponVO];
        [grouponVO release];
        
        grouponVO=[[GrouponVO alloc] init];
        [grouponVO setName:@"LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士"];
        [grouponVO setPrice:[NSNumber numberWithFloat:10.90]];
        [productArray addObject:grouponVO];
        [grouponVO release];
        
        [hotVO setGrouponVOList:productArray];
        [productArray release];
        [adLists addObject:hotVO];
        [hotVO release];
    }
    [adVO setHotPointNewVOList:adLists];
    [adLists release];
    [mArray addObject:adVO];
    [adVO release];
    //3
    adVO=[[AdvertisingPromotionVO alloc] init];
    keywords=[[NSMutableArray alloc] initWithObjects:@"星巴克", @"麦当劳", @"肯德基", @"必胜客", nil];
    [adVO setKeywordList:keywords];
    [keywords release];
    [adVO setAdvertisingType:[NSNumber numberWithInt:0]];
    adLists=[[NSMutableArray alloc] init];
    for (i=0; i<6; i++) {
        HotPointNewVO *hotVO=[[HotPointNewVO alloc] init];
        [hotVO setPicUrl:@"aaa"];
        [hotVO setLogoPicUrl:@"bbb"];
        [hotVO setTitle:@"厨卫清洁中心"];
        NSMutableArray *productArray=[[NSMutableArray alloc] init];
        
        ProductVO *productVO=[[ProductVO alloc] init];
        [productVO setCnName:@"相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜"];
        [productVO setPrice:[NSNumber numberWithFloat:12.90]];
        [productArray addObject:productVO];
        [productVO release];
        
        productVO=[[ProductVO alloc] init];
        [productVO setCnName:@"LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士"];
        [productVO setPrice:[NSNumber numberWithFloat:10.90]];
        [productArray addObject:productVO];
        [productVO release];
        
        [hotVO setProductVOList:productArray];
        [productArray release];
        [adLists addObject:hotVO];
        [hotVO release];
    }
    [adVO setHotPointNewVOList:adLists];
    [adLists release];
    [mArray addObject:adVO];
    [adVO release];
    //4
    adVO=[[AdvertisingPromotionVO alloc] init];
    keywords=[[NSMutableArray alloc] initWithObjects:@"星巴克", @"麦当劳", @"肯德基", @"必胜客", nil];
    [adVO setKeywordList:keywords];
    [keywords release];
    [adVO setAdvertisingType:[NSNumber numberWithInt:0]];
    adLists=[[NSMutableArray alloc] init];
    for (i=0; i<6; i++) {
        HotPointNewVO *hotVO=[[HotPointNewVO alloc] init];
        [hotVO setPicUrl:@"aaa"];
        [hotVO setLogoPicUrl:@"bbb"];
        [hotVO setTitle:@"厨卫清洁中心"];
        NSMutableArray *productArray=[[NSMutableArray alloc] init];
        
        ProductVO *productVO=[[ProductVO alloc] init];
        [productVO setCnName:@"相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜相宜本草面膜"];
        [productVO setPrice:[NSNumber numberWithFloat:12.90]];
        [productArray addObject:productVO];
        [productVO release];
        
        productVO=[[ProductVO alloc] init];
        [productVO setCnName:@"LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士LOREAL男士"];
        [productVO setPrice:[NSNumber numberWithFloat:10.90]];
        [productArray addObject:productVO];
        [productVO release];
        
        [hotVO setProductVOList:productArray];
        [productArray release];
        [adLists addObject:hotVO];
        [hotVO release];
    }
    [adVO setHotPointNewVOList:adLists];
    [adLists release];
    [mArray addObject:adVO];
    [adVO release];
    
    [adPromotion setIsUpdate:[NSNumber numberWithInt:0]];
    [adPromotion setUpdateTag:@"123"];
    
    return adPromotion;*/
}

//* <h2>通过Type查询广告详情</h2>
-(Page *)getAdvertisingPromotionVOByType:(Trader *)trader provinceId:(NSNumber*)provinceId type:(NSNumber*)type currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addInteger:type];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[Page class]])
    {
        Page * po = (Page*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}
@end
