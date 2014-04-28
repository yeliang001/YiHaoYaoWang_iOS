//
//  RockGameProductVO.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import <Foundation/Foundation.h>
#import "RockProductV2.h"
@interface RockGameProductVO : NSObject
@property (retain) NSNumber         *nid;
@property (copy) NSString           *merchantId;            // 商家
@property (copy) NSString           *productCode;           // 商品编码
@property (retain) NSNumber         *landingPageId;         // landingPage ID
@property (retain) NSNumber         *couponId;              // 抵用券ID
@property (copy) NSString           *rightCode;             // 正确答案
@property (copy) NSString           *wrongCode;             // 错误答案：多个错误答案用逗号分开
@property (retain) NSDate           *startTime;             // 开始时间
@property (retain) NSDate           *x;               // 结束时间
@property (retain)RockProductV2      *rockProductV2;
@property (retain)NSString           *picturePicked;
@property (retain)NSString           *pictureUnpicked;
@property (retain)NSString          *isSended;


-(BOOL)isGiftSent;

@end
