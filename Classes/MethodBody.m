//
//  MethodBody.m
//  TheStoreApp
//
//  Created by zhengchen on 11-11-23.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import "MethodBody.h"

#define STR_TOKEN_IS_NULL       @"tokenIsNull"

@implementation MethodBody

@synthesize token;

-(id)init {
    self=[super init];	// added by: dong yiming at: 2012.5.24. reason: to obey apple's guideline
    if (self!=nil) {
        data=[[NSString alloc] initWithString:@""];
    }
    return self;
}

-(void)clear {
    if (data!=nil) {
        [data release];
    }
    data=[[NSString alloc] initWithString:@""];
}

-(void)addObject:(NSString *)obj {
    NSString *oldData=[[NSString alloc] initWithString:data];
    if (data!=nil) {
        [data release];
    }
    data=[[NSString alloc] initWithFormat:@"%@%@",oldData,obj];
    [oldData release];
}

-(void)addInteger:(NSNumber *)obj {
    if(obj==nil) {
        [self addObject:@"<null />"];
    } else {
        [self addObject:[NSString stringWithFormat:@"<int>%d</int>",[obj intValue]]];
    }
}

-(void)addDouble:(NSNumber *)obj {
    if(obj==nil) {
        [self addObject:@"<double>0.0</double>"];
    } else {
        [self addObject:[NSString stringWithFormat:@"<double>%@</double>",obj]];
    }
}
-(void)addBool:(BOOL)boolValue{
    if (boolValue) {
        [self addObject:@"<boolean>true</boolean>"];
    }else{
        [self addObject:@"<boolean>false</boolean>"];
    }
}
-(void)addLong:(NSNumber *)obj {
    if(obj==nil) {
        [self addObject:@"<null />"];
    } else {
        [self addObject:[NSString stringWithFormat:@"<long>%li</long>",[obj longValue]]];
    }
}

-(void)addLongLong:(NSNumber *)obj {
    if(obj==nil) {
        [self addObject:@"<null />"];
    } else {
        NSString* str = [NSString stringWithFormat:@"<long>%lli</long>",[obj longLongValue]];
        //long int maxLong = LONG_MAX;
        [self addObject:str];
    }
}

-(void)addString:(NSString *)obj {
    if(obj==nil) {
        [self addObject:@"<string></string>"];
    } else {
        [self addObject:[NSString stringWithFormat:@"<string>%@</string>",obj]];
    }
}

-(void)addToken:(NSString *)obj {
    if (token!=nil) {
        [token release];
    }
    if(obj==nil) {
        token=[[NSString alloc] initWithString:STR_TOKEN_IS_NULL];
        [self addObject:@"<string></string>"];
    } else {
        token=[[NSString alloc] initWithString:obj];
        [self addObject:[NSString stringWithFormat:@"<string>%@</string>",obj]];
    }
}

-(void)addArrayForLong:(NSArray *)array
{
    [self addObject:@"<list>"];
    if (array!=nil && [array count]!=0) {
        int i;
        for (i=0; i<[array count]; i++) {
            NSNumber *number=[array objectAtIndex:i];
            [self addObject:[NSString stringWithFormat:@"<long>%@</long>",number]];
        }
    }
    [self addObject:@"</list>"];
}

-(void)addArrayForInt:(NSArray *)array
{
    [self addObject:@"<list>"];
    if (array!=nil && [array count]!=0) {
        int i;
        for (i=0; i<[array count]; i++) {
            NSNumber *number=[array objectAtIndex:i];
            [self addObject:[NSString stringWithFormat:@"<int>%@</int>",number]];
        }
    }
    [self addObject:@"</list>"];
}

-(void)addArrayForDouble:(NSArray *)array
{
    [self addObject:@"<list>"];
    if (array!=nil && [array count]!=0) {
        int i;
        for (i=0; i<[array count]; i++) {
            NSNumber *number=[array objectAtIndex:i];
            [self addObject:[NSString stringWithFormat:@"<double>%@</double>",number]];
        }
    }
    [self addObject:@"</list>"];
}

-(void)addArrayForString:(NSArray *)array
{
    [self addObject:@"<list>"];
    if (array!=nil && [array count]!=0) {
        int i;
        for (i=0; i<[array count]; i++) {
            NSString *string=[array objectAtIndex:i];
            [self addObject:[NSString stringWithFormat:@"<string>%@</string>",string]];
        }
    }
    [self addObject:@"</list>"];
}

-(void)addGoodReceiverVO:(GoodReceiverVO *)goodReceiverVO
{
    NSString *xml=[goodReceiverVO toXML];
    [self addObject:xml];
}

-(void)addSearchParameterVO:(SearchParameterVO *)searchParameterVO
{
    NSString *xml=[searchParameterVO toXML];
    [self addObject:xml];
}

-(NSString*)toXml {
    
    //return [NSString stringWithFormat:@"<object-array>%@</object-array>", data];
    
    NSMutableString *xmlStr = [[NSMutableString alloc] initWithFormat:@"<object-array>%@</object-array>", data];
    return [xmlStr autorelease];
    
//    NSString *ret=@"<object-array>";
//    ret=[ret stringByAppendingString:data];
//    ret=[ret stringByAppendingString:@"</object-array>"];
//    return ret;
}

-(NSString*)data
{
    return data;
}

-(void)setData:(NSString *)obj
{
    NSString *oldData=[[NSString alloc] initWithString:data];
    if (data!=nil) {
        [data release];
    }
    data=[[NSString alloc] initWithString:obj];
    [oldData release];
}

-(void)dealloc
{
    if (data!=nil) {
        [data release];
        data=nil;
    }
    if (token!=nil) {
        [token release];
        token=nil;
    }
    [super dealloc];
}

@end
