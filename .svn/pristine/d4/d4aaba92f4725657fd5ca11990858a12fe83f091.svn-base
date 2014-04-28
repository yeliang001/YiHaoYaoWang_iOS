//
//  PromotionService.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PromotionService.h"
#import "Page.h"
#import "Trader.h"
#import "MethodBody.h"
#import "OTSUtility.h"

@implementation PromotionService
-(Page*)getCmsPageList:(Trader *)aTrader 
            provinceId:(NSNumber*)aProvinceId 
            activityId:(NSNumber*)aActivityId 
           currentPage:(NSNumber*)aCurrentPage 
              pageSize:(NSNumber*)aPageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[aTrader toXml]];
    [body addLong:aProvinceId];
    [body addLongLong:aActivityId];
    [body addInteger:aCurrentPage];
    [body addInteger:aPageSize];
    
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    if (ret && [ret isKindOfClass:[Page class]]) 
    {
        Page *po = (Page *)ret;
        return po;
    }
    
    return nil;
}


-(Page*)getCmsColumnList:(Trader *)aTrader 
            provinceId:(NSNumber*)aProvinceId 
               cmsPageId:(NSNumber*)aCmsPageId 
                    type:(NSString*)aType
           currentPage:(NSNumber*)aCurrentPage 
              pageSize:(NSNumber*)aPageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[aTrader toXml]];
    
    [body addLong:aProvinceId];
    [body addLong:aCmsPageId];
    [body addString:aType];
    [body addInteger:aCurrentPage];
    [body addInteger:aPageSize];
    
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    if (ret && [ret isKindOfClass:[Page class]]) 
    {
        Page *po = (Page *)ret;
        return po;
    }
    
    return nil;
}



@end
