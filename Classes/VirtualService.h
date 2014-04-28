//
//  VirtualService.h
//  TheStoreApp
//
//  Created by zhengchen on 11-12-2.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Page.h"
#import "DownloadVO.h"
#import "ProductVO.h"
@interface VirtualService : NSObject

+(Page *) getHomeHotPointList;
+(DownloadVO*) getClientApplicationDownloadUrl;
+(NSString*) login;
+(ProductVO*) getProductDetailComment;
+(Page*) getUserInterestedProducts;
@end
