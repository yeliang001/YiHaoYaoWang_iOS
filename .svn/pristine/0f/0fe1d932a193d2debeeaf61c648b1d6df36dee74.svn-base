//
//  XStream.h
//  TheStoreApp
//
//  Created by zhengchen on 11-11-23.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XStream : NSObject<NSXMLParserDelegate>{
    NSObject *entity;
    NSMutableArray *entityList;
    NSString *content;
    BOOL hasContent;
    BOOL tokenTimeOut;
    NSString * currentMethodName;
    NSString * currentParamBody;
    NSString * currentElementName;
    //map类定义
    NSString * currentKey;
    NSString * CurrentValue;
    NSMutableDictionary * entityMap;
    BOOL hasInEntry,hasInMap;//正在解析entry内 的内容以及是在解析map返回类型 yj 13.5.7
}
@property BOOL tokenTimeOut;
@property (nonatomic,retain) NSString * currentMethodName;
@property (nonatomic,retain) NSString * currentParamBody;
@property (nonatomic,retain) NSString * currentElementName;
//map类 yj 13.5.7
@property (nonatomic,retain) NSString * currentKey;
@property (nonatomic,retain) NSString * CurrentValue;
@property (nonatomic,retain) NSMutableDictionary * entityMap;

+(XStream *)getInstance;

- (id)init;
- (NSObject *)fromXML:(NSData *)contentData;
- (NSString *)getPropertyType:(id) class property:(NSString *) property;
- (NSString *)getSetterString:(NSString *)value;


-(NSString*)getClassName:(NSString *)namespace ;
-(NSObject*)getBaseObject:(NSString*)type withData:(NSString*)content ;
-(BOOL)isBaseClass:(NSString *)className;
-(BOOL)tokenTimeOut;
@end