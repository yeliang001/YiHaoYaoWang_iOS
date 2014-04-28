//
//  SearchParameterVO.m
//  TheStoreApp
//
//  Created by towne on 12-11-27.
//
//

#import "SearchParameterVO.h"

@implementation SearchParameterVO

@synthesize keyword;
@synthesize categoryId;
@synthesize brandId;
@synthesize attributes;
@synthesize priceRange;
@synthesize filter;
@synthesize sortType;
@synthesize promotionId;
@synthesize promotionLevelId;

-(NSString *)toXML
{
    NSMutableString *string=[[[NSMutableString alloc] initWithString:@"<com.yihaodian.mobile.vo.search.SearchParameterVO>"] autorelease];
    if ([self keyword]!=nil) {
        [string appendFormat:@"<keyword>%@</keyword>",[self keyword]];
    }
    if ([self categoryId]!=nil) {
        [string appendFormat:@"<categoryId>%@</categoryId>",[self categoryId]];
    }
    if ([self brandId]!=nil) {
        [string appendFormat:@"<brandId>%@</brandId>",[self brandId]];
    }
    if ([self attributes]!=nil) {
        [string appendFormat:@"<attributes>%@</attributes>",[self attributes]];
    }
    if ([self priceRange]!=nil) {
        [string appendFormat:@"<priceRange>%@</priceRange>",[self priceRange]];
    }
    if ([self filter]!=nil) {
        [string appendFormat:@"<filter>%@</filter>",[self filter]];
    }
    if ([self sortType]!=nil) {
        [string appendFormat:@"<sortType>%@</sortType>",[self sortType]];
    }
    if ([self promotionId]!=nil) {
        [string appendFormat:@"<promotionId>%@</promotionId>",[self promotionId]];
    }
    if ([self promotionLevelId]!=nil) {
        [string appendFormat:@"<promotionLevelId>%@</promotionLevelId>",[self promotionLevelId]];
    }
    [string appendString:@"</com.yihaodian.mobile.vo.search.SearchParameterVO>"];
    return string;
}

-(void)dealloc{
    OTS_SAFE_RELEASE(keyword);
    OTS_SAFE_RELEASE(categoryId);
    OTS_SAFE_RELEASE(brandId);
    OTS_SAFE_RELEASE(attributes);
    OTS_SAFE_RELEASE(priceRange);
    OTS_SAFE_RELEASE(filter);
    OTS_SAFE_RELEASE(sortType);
    OTS_SAFE_RELEASE(promotionId);
    OTS_SAFE_RELEASE(promotionLevelId);
    [super dealloc];
}
@end
