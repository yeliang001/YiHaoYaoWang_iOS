//
//  AdvertisementVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdvertisementVO.h"

@implementation AdvertisementVO
@synthesize nid;//广告id
@synthesize name;//广告标题
@synthesize banner;//广告banner
@synthesize type;//1.广告标题 2.广告banner
@synthesize content;//广告内容（预留字段，适用于广告内容从数据库读取）
@synthesize clientLinkUrl;//客户端公告链接
@synthesize wapLinkUrl;//wap公告链接

-(void)dealloc
{
    if (nid!=nil) {
        [nid release];
        nid=nil;
    }
    if (name!=nil) {
        [name release];
        name=nil;
    }
    if (banner!=nil) {
        [banner release];
        banner=nil;
    }
    if (type!=nil) {
        [type release];
        type=nil;
    }
    if (content!=nil) {
        [content release];
        content=nil;
    }
    if (clientLinkUrl!=nil) {
        [clientLinkUrl release];
        clientLinkUrl=nil;
    }
    if (wapLinkUrl!=nil) {
        [wapLinkUrl release];
        wapLinkUrl=nil;
    }
    [super dealloc];
}
@end
