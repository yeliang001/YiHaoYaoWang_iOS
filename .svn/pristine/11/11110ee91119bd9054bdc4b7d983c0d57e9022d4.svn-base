//
//  OTSXMLParser.m
//  TheStoreApp
//
//  Created by Daniel Yim on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>

#import "OTSXMLParser.h"

#define HTML_TAG            @"<html>"
#define ERROR_TAG           @"<error>"
#define TOKEN_TIME_OUT_TAG  @"<error>用户Token过期,请重新登录</error>"
#define MUT_ARR_CLASS_NAME  @"__NSArrayM"

@interface OTSXMLParser ()

@property(retain)NSMutableArray             *nodePaths;
@property(copy)NSMutableString              *currentValue;
@property(retain)id                         resultObject;

-(NSString*)getClassName:(NSString *)namespace;
-(objc_property_t)propertyWithName:(NSString *)propertyName ofClass:(Class)aClass;
- (NSString *)typeStringWithPropertyName:(NSString *)propertyName ofClass:(Class)aClass;
-(NSObject*)getBaseObject:(NSString*)type withData:(NSString*)theContent;
-(void)printObject:(id)anObject;
-(BOOL)isMutableArray:(id)anObject;
@end

@implementation OTSXMLParser
@synthesize nodePaths, currentValue, resultObject;
@synthesize tokenTimeOut;

-(void)dealloc
{
    [nodePaths release];
    [currentValue release];
    [resultObject release];
    
    [super dealloc];
}

-(NSString*)stringFromData:(NSData*)aData
{
    return [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
}

- (NSObject *)fromXML:(NSData *)contentData
{
    return [self objectFromXml:contentData];
}

-(BOOL)canParseWithData:(NSData*)aXmlData
{
    BOOL  canParse = aXmlData ? YES : NO;
    
    NSString* xmlStr = [self stringFromData:aXmlData];
    
    if ([xmlStr rangeOfString:@"<"].location == NSNotFound
        || [xmlStr isEqualToString:@"<null/>"]
        || [xmlStr rangeOfString:HTML_TAG].location == 0)
    {
        canParse = NO;
    }
    
    else if ([xmlStr rangeOfString:ERROR_TAG].location == 0)
    {
        canParse = NO;
        if ([xmlStr rangeOfString:TOKEN_TIME_OUT_TAG].location == 0)
        {
            self.tokenTimeOut = YES;
        }
    }
    
    return canParse;
}

-(NSObject*)objectFromXml:(NSData*)aXmlData
{
    @synchronized([OTSXMLParser class])
    {
        DebugLog(@"start parsing xml:\n%@", [self stringFromData:aXmlData]);
        
        if (![self canParseWithData:aXmlData])
        {
            return nil;
        }
        
        self.nodePaths = [NSMutableArray arrayWithCapacity:10];
        self.resultObject = nil;
        self.currentValue = nil;
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];// pool created
        
        NSXMLParser* parser = [[[NSXMLParser alloc] initWithData:aXmlData] autorelease];
        parser.delegate = self;
        [parser parse];
        
        [pool drain];// pool drained
        
        DebugLog(@"parse finished, object:");
        [self printObject:resultObject];
        return resultObject;
    }
}

-(void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qualifiedName 
   attributes:(NSDictionary *)attributeDict 
{ 
    DebugLog(@"---=== parser start element :BEGIN ===---");
    
    DebugLog(@"elementName:%@", elementName);
    self.currentValue = [NSMutableString stringWithCapacity:100];
    NSString *className = [self getClassName:elementName];
    
    if (className)
    {
        DebugLog(@"className:%@", className);
        id theObject = [[[NSClassFromString(className) alloc] init] autorelease];
        if ([nodePaths count] <= 0)
        {
            DebugLog(@"first object, set it to result object!");
            self.resultObject = theObject;
        }
        
        NSDictionary* item = [NSDictionary dictionaryWithObject:theObject forKey:elementName];
        [nodePaths addObject:item];
        DebugLog(@"path add new object, now count is:%d", [nodePaths count]);
    }
    
    DebugLog(@"---=== parser start element :END ===---");
}

-(void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string 
{
    //DebugLog(@"string:[%@]", string);
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //[currentValue appendString:string]; // why cant append??
    self.currentValue = [NSString stringWithFormat:@"%@%@", currentValue, string];
    //DebugLog(@"currentValue:[%@]", currentValue);
}

-(void)parser:(NSXMLParser *)parser 
didEndElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qualifiedName 
{
    DebugLog(@"---=== parser end element :BEGIN ===---");
    DebugLog(@"elementName:%@", elementName);
    DebugLog(@"node count:%d", [nodePaths count]);
    
    if ([nodePaths count] <= 0)
    {
        DebugLog(@"no model matching, base value assumed");
        self.resultObject = [self getBaseObject:elementName withData:currentValue];
        [self printObject:resultObject];
    }
    
    else
    {
        NSDictionary* lastItem = [nodePaths lastObject];
        id theObject = [lastItem objectForKey:elementName];
        if (theObject)
        {
            DebugLog(@"the object must not be a base class, otherwise, it wont appear in array");
            [self printObject:theObject];
            
            if ([nodePaths count] > 1)
            {
                NSDictionary* previousItem = [nodePaths objectAtIndex:[nodePaths count] - 2]; // item before last item
                id parentObject = [[previousItem allValues] objectAtIndex:0];
                
                DebugLog(@"Parent Object:");
                [self printObject:parentObject];
                
                if ([self isMutableArray:parentObject])
                {
                    DebugLog(@"parent is an array, add object to it.");
                    DebugLog(@"The Object:");
                    [self printObject:theObject];
                    [((NSMutableArray*)parentObject) addObject:theObject];
                }
                else
                {
                    DebugLog(@"parent is not an array, set property");
                    DebugLog(@"The Object:");
                    [self printObject:theObject];
                    [parentObject setValue:theObject forKey:elementName];
                    DebugLog(@"'%@' setValue:'%@' forKey:'%@'", [parentObject class], [theObject class], elementName);
                }
            }
            
            [nodePaths removeLastObject];
        }
        else
        {
            DebugLog(@"it's a base object, set it to parent object's property, or if parent is an array, add it to the array");
            
            id parentObject = [[lastItem allValues] objectAtIndex:0];
            
            DebugLog(@"Parent Object:");
            [self printObject:parentObject];
            
            if ([self isMutableArray:parentObject])
            {
                id theObject = [self getBaseObject:elementName withData:currentValue];
                if (theObject) 
                {
                    DebugLog(@"parent is an array, add object to it.");
                    DebugLog(@"The Object:");
                    [self printObject:theObject];
                    [((NSMutableArray*)parentObject) addObject:theObject];
                }
            }
            else
            {
                NSString* propertyTypeString = [self typeStringWithPropertyName:elementName ofClass:[parentObject class]];
                
                if (propertyTypeString)
                {
                    id theObject = [self getBaseObject:propertyTypeString withData:currentValue];
                    
                    if (theObject)
                    {
                        DebugLog(@"parent is not an array, set property");
                        DebugLog(@"The Object:");
                        [self printObject:theObject];
                        [parentObject setValue:theObject forKey:elementName];
                        DebugLog(@"'%@' setValue:'%@' forKey:'%@'", [parentObject class], [theObject class], elementName);
                    }
                }
                
                
            }
        }
    }
    
    DebugLog(@"---=== parser end element :END ===---");
}

#pragma mark -
-(BOOL)isMutableArray:(id)anObject
{
    if (anObject)
    {
        return [[[anObject class] description] isEqualToString:MUT_ARR_CLASS_NAME];
    }
    
    return NO;
}

-(void)printObject:(id)anObject
{
    if (anObject)
    {
        Class objClass = [anObject class];
        DebugLog(@"object <%@> \nis a:<%@>", anObject, [objClass description]);
    }
}

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
                           , @"productVOList"
                           , @"buyItemList"
                           , @"distanceList"
                           , @"userNameList"
                           , @"gifItemtList"
                           , @"invoiceList"
                           , @"advertisingPromotionVOList"
                           , @"keywordList"
                           , @"hotPointNewVOList"
                           , nil];
    
    if (namespace && [nameSpaces indexOfObject:namespace] != NSNotFound)
    {
        //DebugLog(@"return:NSMutableArray");
        return @"NSMutableArray";
    }
    
    //DebugLog(@"return:nil");
    return nil;
}

-(objc_property_t)propertyWithName:(NSString *)propertyName ofClass:(Class)aClass
{
    if ([propertyName isEqualToString:@"id"])
    {
        propertyName = @"nid";
    }
    
    const char *bytes = [propertyName cStringUsingEncoding:NSUTF8StringEncoding];
    return class_getProperty(aClass, bytes);
}

- (NSString *)typeStringWithPropertyName:(NSString *)propertyName ofClass:(Class)aClass
{
    objc_property_t property = [self propertyWithName:propertyName ofClass:aClass];
    
    if (property)
    {
        NSString *attrStr = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        NSRange r1=[attrStr rangeOfString:@"\""];
        if (r1.location != NSNotFound)
        {
            NSRange r2 = [[attrStr substringFromIndex:r1.location + 1] rangeOfString:@"\""];
 
            NSString *typrStr = [attrStr substringWithRange:NSMakeRange(r1.location + 1, r2.location)];
            
            return typrStr;
        }
        
    }
    
    return nil;    
}

-(NSObject*)getBaseObject:(NSString*)type withData:(NSString*)theContent
{
    DebugLog(@"--== getBaseObject==--");
    DebugLog(@"type:%@, content:%@", type, theContent);
    
    if ([type isEqualToString:@"NSString"]
        || [type isEqualToString:@"string"])
    {
        return theContent;
    }
    
    else if ([type isEqualToString:@"NSNumber"]
             || [type isEqualToString:@"long"]
             || [type isEqualToString:@"int"]
             || [type isEqualToString:@"double"])
    {
        NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [[[numberFormatter numberFromString:theContent] retain] autorelease];
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

@end
