//
//  OrderResultInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-12.
//
//

#import "ResultInfo.h"
@class OrderInfo;
@interface OrderResultInfo : ResultInfo

@property(retain,nonatomic) OrderInfo *orderInfo;

- (BOOL)isNoAddress;

@end
