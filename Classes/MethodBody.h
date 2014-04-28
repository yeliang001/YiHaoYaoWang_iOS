//
//  MethodBody.h
//  TheStoreApp
//
//  Created by zhengchen on 11-11-23.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodReceiverVO.h"
#import "SearchParameterVO.h"

@interface MethodBody : NSObject{
    NSString *data;
    NSString *token;
}

@property(readonly,nonatomic) NSString *token;

-(void)clear;
-(void)addObject:(NSString *)obj;
-(void)addInteger:(NSNumber *)obj;
-(void)addDouble:(NSNumber *)obj;
-(void)addLong:(NSNumber *)obj;
-(void)addLongLong:(NSNumber *)obj;
-(void)addString:(NSString *)obj;
-(void)addToken:(NSString *)obj;
-(void)addArrayForLong:(NSArray *)array;
-(void)addArrayForInt:(NSArray *)array;
-(void)addArrayForDouble:(NSArray *)array;
-(void)addArrayForString:(NSArray *)array;
-(void)addGoodReceiverVO:(GoodReceiverVO *)goodReceiverVO;
-(void)addSearchParameterVO:(SearchParameterVO *)searchParameterVO;
-(void)addBool:(BOOL)boolValue;
-(NSString*)toXml;
-(NSString*)data;
-(void)setData:(NSString *)obj;
@end