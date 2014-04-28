//
//  SplitLogInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-28.
//
//  物流信息

#import <Foundation/Foundation.h>

@interface SplitLogInfo : NSObject

@property (assign, nonatomic) NSInteger sid;
@property (copy, nonatomic) NSString *logTime;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *operatorUser;
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *status;


@end
