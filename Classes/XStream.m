//
//  XStream.m
//  TheStoreApp
//
//  Created by zhengchen on 11-11-23.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import <objc/runtime.h>
#import "XStream.h"
#import "OTSDataChecker.h"
#import "ProductVO.h"
#import "TheStoreAppAppDelegate.h"

@implementation XStream
@synthesize tokenTimeOut;
@synthesize currentMethodName;
@synthesize currentParamBody;
@synthesize currentElementName;
@synthesize currentKey,CurrentValue,entityMap;
+(XStream *)getInstance {
    XStream *stream=[[XStream alloc] init];
    return [stream autorelease];
}

-(id)init {
    self=[super init];
    if (self!=nil) {
        entity=nil;
        entityList=nil;
        entityMap=nil;
    }    
    return self;
}


-(NSObject *)fromXML:(NSData *)contentData {

//    DebugLog(@"fromXML");

    tokenTimeOut=NO;
    if (contentData==nil) {
        return nil;
    }
    NSMutableData *serilizeData=nil;
    @try {
        serilizeData=[[NSMutableData alloc] initWithData:contentData];
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
    }
    
    entityList=[NSMutableArray array];
    
    if (serilizeData!=nil) {
		NSString *result=[[NSString alloc] initWithData:serilizeData encoding:NSUTF8StringEncoding];

//        DebugLog(@"%@",result);

        //特殊情况处理，返回nil
        if([result rangeOfString:@"<"].length==0 || [result isEqualToString:@"<null/>"]){
            [serilizeData release];
            [result release];
			return nil;
		}
        NSString *prefix=@"<html>";
        if ([prefix length]<=[result length]) {
            NSString *substr=[result substringToIndex:[prefix length]];
            if([substr isEqualToString:prefix]) {
                [serilizeData release];
                [result release];
                return nil;
            }
        }
        prefix=@"<error>";
        if ([prefix length]<=[result length]) {
            NSString *substr=[result substringToIndex:[prefix length]];
            if ([substr isEqualToString:prefix]) {
                //--------------2.接口异常做记录收集,GCD异步操作----------------------
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableString *mutableresult = [NSMutableString stringWithString:result];
                    [self replaceString:@"<" withString:@"＜" forString:mutableresult];
                    [self replaceString:@">" withString:@"＞" forString:mutableresult];
                    //xml 转义
                    NSMutableString *mutabxml = [NSMutableString stringWithString:currentParamBody];
                    [self replaceString:@"<" withString:@"＜" forString:mutabxml];
                    [self replaceString:@">" withString:@"＞" forString:mutabxml];
                    [SharedDelegate insertAppErrorLog:[NSString stringWithFormat:@"%@%@",mutableresult,mutabxml] methodName:currentMethodName];
                });
                //用户token过期
                NSString *str=@"<error>用户Token过期,请重新登录</error>";
                if ([str length]<=[result length]) {
                    NSString *subStr=[result substringToIndex:[str length]];
                    if ([subStr isEqualToString:str])
                    {
                        tokenTimeOut=YES;
                    }
                }
                [serilizeData release];
                [result release];
                return nil;
            }
        }
        
		NSXMLParser *parser=[[NSXMLParser alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding]];//设置需要解析的XML
		[parser setDelegate:self];										//设置响应NSXMLParser的类，为本类
		//[parser setShouldProcessNamespaces:YES];						//是否解析名字空间，这里设置为是
       
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		[parser parse];													//XML解析開始
        [pool drain];
        
		[parser release];												//XML解析结束
        [serilizeData release];
        [result release];
        return [entity autorelease];
    }
    return nil;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {

//    DebugLog(@"start:%@",elementName);
//    map类型处理  yj 13.5.7
    if ([elementName isEqualToString:@"map"]) {
        entityMap=[NSMutableDictionary dictionary];
        hasContent=NO;
        hasInMap=YES;
        return;
    }
    if ([elementName isEqualToString:@"entry"]) {
        hasInEntry=YES;
        hasContent=NO;
        return;
    }
//
    
    NSString *entityClass=[self getClassName:elementName];
    self.currentElementName = elementName;
    
    if (entityClass!=nil) {
        Class tmpClass=NSClassFromString(entityClass);
        NSObject *obj=[[tmpClass alloc] init];
        [entityList addObject:obj];
        [obj release];
    } else if ([entityList count]>0) {
        int count=[entityList count]-1;
        NSObject *obj=[entityList objectAtIndex:count];
        NSString *property=[self getPropertyType:obj property:elementName];
        
        if(property!=nil && [self isBaseClass:property]==NO)
        {//非基础类
            if (entityClass!=nil) {//实体类
                Class tmpClass=NSClassFromString(entityClass);   
                NSObject *obj=[[tmpClass new] init];
                [entityList addObject:obj];
                [obj release];
            } else if ([property isEqualToString:@"NSMutableArray"]) {//数组
                NSObject *obj=[[NSMutableArray alloc] init];
                [entityList addObject:obj];
                [obj release];
            } else {
                Class tmpClass=NSClassFromString(property);
                NSObject *obj=[[tmpClass new] init];
                [entityList addObject:obj];
                [obj release];
            }
        }
        
        else
        {//基础类
            [entityList addObject:[NSNull null]];
        }
        
    } else if([self isBaseClass:elementName]) {
        [entityList addObject:[ NSNull null]]; 
    }
    if (content!=nil) {
        [content release];
    }
    content=[[NSString alloc] initWithString:@""];
    hasContent=NO;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//map解析，规定entry第一个为key，第二个为value，且entry只有2个字段
    if (hasInEntry) {
        if ([string hasPrefix:@"\n"]) {
            return;
        }
        if (CurrentValue!=nil) {
            OTS_SAFE_RELEASE(CurrentValue);
            OTS_SAFE_RELEASE(currentKey);
        }
        if (currentKey==nil) {
            currentKey=[[NSString alloc] initWithString:string];
        }else{
            CurrentValue=[[NSString alloc] initWithString:string];
        }
        return;
    }
    if (hasInMap) {
        return;
    }
    
    //    map类型处理  yj 13.5.7
    
    hasContent=YES;
    NSString *oldStr=[[NSString alloc] initWithString:content];
    if (content!=nil) {
        [content release];
    }
    if ([currentElementName isEqualToString:@"detailDescription"]) { //12-12-7 xuexiang,支持抵用券的规则
        content = [[NSString alloc] initWithFormat:@"%@%@",oldStr,string];
    }else{
        content=[[NSString alloc] initWithFormat:@"%@%@",oldStr,[string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    }

    [oldStr release];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName {
//map
    if ([elementName isEqualToString:@"entry"]) {
        [entityMap setValue:CurrentValue forKey:currentKey];
        hasInEntry=NO;
        return;
    }
    if ([elementName isEqualToString:@"map"]) {
        entity=[entityMap retain];
        hasInMap=NO;
        return;
    }
//    
//    map类型处理  yj 13.5.7
    
    if (entityList == nil || [entityList count] <= 0)
    {
        return;
    }
    
    id thisObject=[entityList objectAtIndex:[entityList count]-1];
    NSString *className=NSStringFromClass([thisObject class]);
    
    if ([thisObject isKindOfClass:[NSNull class]]) {//当前为简单类
        
        if ([entityList count]==1) {//返回结果为基础类
            NSObject *obj=[self getBaseObject:elementName withData:content];
            entity=[obj retain];
        } else {
            NSObject *parentObject=[entityList objectAtIndex:[entityList count]-2];
            if ([parentObject isKindOfClass:[NSMutableArray class]]) {//父类为数组
                NSMutableArray *list=(NSMutableArray*)parentObject;
                if ([self isBaseClass:elementName]) {
                    NSObject *obj=[self getBaseObject:elementName withData:content];
                    [list addObject:obj];
                    [entityList removeObjectAtIndex:[entityList count]-1];
                } else {
                }
            } else {
                NSString *property=[self getPropertyType:parentObject property:elementName]; 
                SEL methodSelector;
                methodSelector=NSSelectorFromString([self getSetterString:elementName]);
                if ([parentObject respondsToSelector:methodSelector]) {
                    [parentObject performSelector:methodSelector withObject:[self getBaseObject:property withData:content]];
                }
                [entityList removeObjectAtIndex:[entityList count]-1];
            }
        }
        
    } else {
        
        // process data checking..
        if ([thisObject isKindOfClass:[ProductVO class]])
        {
            [[OTSDataChecker sharedInstance] checkProductVO:thisObject methodName:self.currentMethodName];
        }
        
        if ([entityList count]==1) {
            
            if ([className isEqualToString:[self getClassName:elementName]]) {//类结束
                
                entity=[[entityList objectAtIndex:0] retain];
                
            } else if ([className isEqualToString:@"__NSArrayM"] && [@"NSMutableArray" isEqualToString:[self getClassName:elementName]]) {
                
                entity=[[entityList objectAtIndex:0] retain];
                
            }
            
        } else {
            
            NSObject *parentObject=[entityList objectAtIndex:[entityList count]-2];
            if ([parentObject isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray *list=(NSMutableArray*)parentObject;
                [list addObject:thisObject];
            } else {
                SEL methodSelector;
                methodSelector=NSSelectorFromString([self getSetterString:elementName]);
                if ([parentObject respondsToSelector:methodSelector]) {
                    if (hasContent) {
                        [parentObject performSelector:methodSelector withObject:thisObject];
                    } else {
                        [parentObject performSelector:methodSelector withObject:nil];
                    }
                }
            }
        }
        [entityList removeObjectAtIndex:[entityList count]-1];    
    }
}

- (NSString *)getPropertyType:(id)class property:(NSString *)propertyString {
    if ([propertyString isEqualToString:@"id"]) {
        propertyString=@"nid";
    }
    const char *bytes=[propertyString cStringUsingEncoding:NSUTF8StringEncoding];
    Class c=[class class];
    objc_property_t property=class_getProperty(c, bytes);
    if (property==nil) {
        return nil;
    }
    NSString *attr=[NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding]; 
    NSRange r1=[attr rangeOfString:@"\""];
    if (r1.location == NSNotFound)
    {
        return nil;
    }
    
    NSRange r2=[[attr substringFromIndex:r1.location+1] rangeOfString:@"\""];
    r1.location=r1.location+1;
    r1.length=r2.location;
    NSString *ret=[[attr substringWithRange:r1] retain];
    return [ret autorelease];
}

- (NSString *)getSetterString:(NSString *)value {
	if ([value isEqualToString:@"id"]) {
        value=@"nid";
    }
    NSString *tempMethodStr=value;
    
	NSString *firstLetter=[[value substringToIndex:1] uppercaseString];//截出首字母
	tempMethodStr=[tempMethodStr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstLetter];//将首字母转为大写
	tempMethodStr=[NSString stringWithFormat:@"set%@:",tempMethodStr];//给它加上set，这样就变成了方法名
	return tempMethodStr;
}


// 重构XStream -- getClassName:方法实现，原实现被注释  --- dym 12.7.5.
-(NSString*)getClassName:(NSString *)namespace
{
    //DebugLog(@"getClassName:%@", namespace);
    
    // 处理VO
    if (namespace && [namespace rangeOfString:@"com.yihaodian.mobile.vo"].location != NSNotFound)
    {
        NSRange range = [namespace rangeOfString:@"." options:NSBackwardsSearch];
        if (range.location != NSNotFound)
        {
            NSString* className = [namespace substringFromIndex:range.location + 1];
            Class objClass = NSClassFromString(className);
            if (objClass)
            {
                //DebugLog(@"return:%@", className);
                return className;
            }
        }
    }
    
    
    // 处理Array
    NSArray* nameSpaces = [NSArray arrayWithObjects:
                           @"grouponSerials"
                           , @"pmVOList"
                           , @"colorList"
                           , @"sizeList"
                           , @"objList"
                           , @"list"
                           , @"childOrderList"
                           , @"orderItemList"
                           , @"brandChilds"
                           , @"searchAttributes"
                           , @"attrChilds"
                           , @"childs"
                           , @"searchCategorys"
                           , @"childCategoryList"
                           , @"productVOList"
                           , @"buyItemList"
                           , @"distanceList"
                           , @"userNameList"
                           , @"gifItemtList"
                           , @"invoiceList"
                           , @"advertisingPromotionVOList"
                           , @"keywordList"
                           , @"hotPointNewVOList"
                           , @"product80x80Url"
                           , @"product380x380Url"
                           , @"product600x600Url"
                           , @"optionalPromotionList"
                           , @"productList"
                           , @"unionProductItemVOs"
                           // 新1起摇
                           , @"couponVOList"
                           , @"rockProductV2List"
                           , @"productVOList"
                           , @"promotionGiftList"
                           , @"cashPromotionList"
                           , @"redemptionList"
                           , @"merchantIds"
                           , @"seriesProductVOList"
                           , @"cartBagVOs"
                           , @"cartItemVOs"
                           , @"prizeProductVOList"
                           , @"grouponVOList"
                           , @"childCategoryVOList"
                           , nil];
    
    if (namespace && [nameSpaces indexOfObject:namespace] != NSNotFound)
    {
        //DebugLog(@"return:NSMutableArray");
        return @"NSMutableArray";
    }
    //map类型
    if ([namespace isEqualToString: @"map"]) {
        return [[NSMutableDictionary class] description];
    }
//    if ([namespace isEqualToString:@"entry"]) {
//        return [[NSMutableDictionary class] description];
//    }
    
    return nil;
}



-(NSObject*)getBaseObject:(NSString*)type withData:(NSString*)theContent 
{
    if ([type isEqualToString:@"NSString"]
        || [type isEqualToString:@"string"]) 
    {
        return [[theContent retain] autorelease];
    }
    
    else if ([type isEqualToString:@"NSNumber"]
        || [type isEqualToString:@"long"]
        || [type isEqualToString:@"int"]
        || [type isEqualToString:@"double"]) 
    {
        NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
        NSLocale *china = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease];
        [numberFormatter setLocale:china];
        id result = [[[numberFormatter numberFromString:theContent] retain] autorelease];
        return result;
    }
    
    if ([type isEqualToString:@"NSDate"]) 
    {
        NSDate* date = nil;
        NSString* formatStr = @"yyyy-MM-dd HH:mm:ss";
        int length = [formatStr length];
        if ([theContent length] >= length) 
        {
            NSString *subStr = [theContent substringWithRange:NSMakeRange(0, length)];
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [dateFormatter setDateFormat:formatStr];
            
            date = [dateFormatter dateFromString:subStr];
        } 
        
        return date ? date : [NSDate date];
    }
    
    return nil;
}

-(BOOL)isBaseClass:(NSString *)className 
{
    NSArray* baseClassNames = [NSArray arrayWithObjects:
                               @"NSString"
                               , @"NSNumber"
                               , @"NSDate"
                               , @"long"
                               , @"string"
                               , @"int"
                               , @"double"
                               , nil];
    
    if (className && [baseClassNames indexOfObject:className] != NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

//---- 尖括号转义
-(void)replaceString:(NSString*)anOriginString 
          withString:(NSString*)aNewString 
           forString:(NSMutableString*)aParentString
{
    if (aParentString && anOriginString && aNewString)
    {
        [aParentString replaceOccurrencesOfString:anOriginString withString:aNewString options:NSLiteralSearch range:NSMakeRange(0, [aParentString length])];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(content);
    OTS_SAFE_RELEASE(currentElementName);
    OTS_SAFE_RELEASE(currentKey);
    OTS_SAFE_RELEASE(CurrentValue);
    [currentParamBody release];
    [currentMethodName release];
    
    [super dealloc];
}
@end