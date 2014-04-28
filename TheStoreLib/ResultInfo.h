//
//  ResultInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-6.
//
//

#import <Foundation/Foundation.h>

@interface ResultInfo : NSObject

@property (assign, nonatomic) int responseCode; //服务器返回码
@property (assign, nonatomic) BOOL bRequestStatus; //请求状态 YES NO

@property (assign, nonatomic) int resultCode;  //接口调用状态
@property (retain, nonatomic) id  resultObject;
@property (assign, nonatomic) int recordCount; //记录总数


- (NSString *)errorStr;

@end
