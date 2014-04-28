////
////  XMLSerializeService.m
////  TheStoreApp
////
////  Created by linyy on 11-1-20.
////  Copyright 2011 vsc. All rights reserved.
//
//#import "XMLSerializeService.h"
//#import "ObjectArraySender.h"
//#import "Trader.h"
//#import "SenderMethodBody.h"
//#import "ProductVO.h"
//#import "ProvinceVO.h"
//#import "Page.h"
//#import "GlobalValue.h"
//
//#define ERROR_USER_TOKEN_EXPIRED 0
//#define ERROR_SERVICE_FAILURE 1
//#define ERROR_SERVICE_OTHER_FAILURE 2
//
//@implementation XMLSerializeService
//
//@synthesize isInnerClass;
//
//#pragma mark 解析xml，为类成员赋值
//
//-(id)init{
//    self = [super init];	// added by: dong yiming at: 2012.5.24. reason: to obey apple's guideline
//    haveEntity=NO;
//    isInnerClass=NO;
//    findFirstClass=YES;																		//是否第一次查找实体
//    haveAnotherClass=NO;																	//是否有不同实体
//    haveInnerClass=NO;																		//是否有内部实体
//    return self;
//}
//
//- (NSObject *)fromXML:(NSData *)contentData{
//	if(contentData==nil|| [contentData isKindOfClass:[NSNull class]]){
//        return nil;
//    }
//    @try {
//        serilizeData=[[NSMutableData alloc]initWithData:contentData];
//    }
//    @catch (NSException *exception) {
//        return nil;
//    }
//    @finally {
//        
//    }
//	
//	if(serilizeData!=nil){
//        //resultClassArray=[[NSMutableArray alloc]initWithCapacity:0];
//		resultClassArrayRetainCount=0;
//        serializeInnerClassStatus=0;
//		serializeCollectionClassStatus=0;
//		i_endIndex=0;
//		//NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
//		NSString * result=[[NSString alloc] initWithData:serilizeData encoding:NSUTF8StringEncoding];
//        
//        if([result rangeOfString:@"<"].length==0 || [result isEqualToString:@"<null/>"]){
//            //[result release];
//            NSNumber * errorValue=[[NSNumber alloc] initWithInt:ERROR_SERVICE_FAILURE];
//            errorNumValue=[errorValue retain];
//			[[GlobalValue getGlobalValueInstance] setErrorType:errorNumValue];
//            [errorValue release];
//            //[pool drain];
//            if([result rangeOfString:@"<"].length==0){
//                [result release];
//                return nil;
//            }
//            [result release];
//			return [[NSNull alloc] init];
//		}
//
//		DebugLog(@"from XML is:\n%@",result);
//
//        NSString * result1 = [result stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
//
//		DebugLog(@"from XML is:\n%@",result1);
//
//		parser=[[NSXMLParser alloc] initWithData: [result1 dataUsingEncoding:NSUTF8StringEncoding]];
//		//parser=[[NSXMLParser alloc] initWithData:serilizeData];									//设置需要解析的XML
//		classStr=[NSString stringWithString:@""];
//		i_tag=[NSString stringWithString:@""];
//		i_classStr=[NSString stringWithString:@""];
//		c_classStr=[NSString stringWithString:@""];
//		cmpClassStr=[NSString stringWithString:@""];
//		methodStr=[NSString stringWithString:@""];
//		cmpFirstListStr=[NSString stringWithString:@""];
//		cmpNextListStr=[NSString stringWithString:@""];
//        longArrayRetainCount=0;
//        stringArrayRetainCount=0;
//        intArrayRetainCount=0;
//        classArrayRetainCount=0;
//		
//		indexOfStartOfAClass=0;
//		
//		
//		NSRange beginMatchRange=[result rangeOfString:@"<"];
//		NSRange endMatchRange=[result rangeOfString:@">"];
//		int beginMatchPos=beginMatchRange.location;
//		int endMatchPos=endMatchRange.location;
//		cmpStr=[result substringWithRange:NSMakeRange(beginMatchPos+1,endMatchPos-1)];			//截取第一个标签，用于比较、分析
//		
//		if([cmpStr rangeOfString:@"."].length!=0){												//是否包含句号
//			headOfCollection=NO;																//以实体开头
//		}
//		else{
//			headOfCollection=YES;
//		}
//		
//		[parser setDelegate:self];																//设置响应NSXMLParser的类，为本类
//		//[parser setShouldProcessNamespaces:YES];												//是否解析名字空间，这里设置为是
//		[parser parse];																			//XML解析開始
//		[parser release];																		//XML解析结束
//        [result release];
//		//[pool drain];
//	}
//	
//    if(headOfCollection){
//        resultObject=resultClassArray;
//    }
//    else if(haveEntity){
//        resultObject=[[resultClassArray objectAtIndex:0] retain];
//        if(!isInnerClass){
//            [resultClassArray removeAllObjects];
//        }
//        [resultClassArray release];
//    }
//	return resultObject;
//}
//
//#pragma mark 通过方法实体，生成一个xml
//- (NSString *)toXML:(ObjectArraySender *)transportContent{
//	NSString * transportContentStr=[NSString stringWithString:@"<object-array>"];
//	if(transportContent!=nil){
//		if(transportContent.trader!=nil){														//如果包含Trader则封装Trader
//			transportContentStr=[transportContentStr stringByAppendingString:@"<com.yihaodian.mobile.vo.bussiness.Trader>"];
//			if(transportContent.trader.clientAppVersion!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"clientAppVersion" attributeValue:transportContent.trader.clientAppVersion]];
//			}
//			if(transportContent.trader.clientSystem!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"clientSystem" attributeValue:transportContent.trader.clientSystem]];
//			}
//			if(transportContent.trader.clientTelnetPhone!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"clientTelnetPhone" attributeValue:transportContent.trader.clientTelnetPhone]];
//			}
//			if(transportContent.trader.clientVersion!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"clientVersion" attributeValue:transportContent.trader.clientVersion]];
//			}
//			if(transportContent.trader.interfaceVersion!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"interfaceVersion" attributeValue:transportContent.trader.interfaceVersion]];
//			}
//            if(transportContent.trader.latitude!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"latitude" attributeValue:[NSString stringWithFormat:@"%.10f",[transportContent.trader.latitude doubleValue]]]];
//			}
//            if(transportContent.trader.longitude!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"longitude" attributeValue:[NSString stringWithFormat:@"%.10f",[transportContent.trader.longitude doubleValue]]]];
//			}
//			if(transportContent.trader.protocolStr!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"protocol" attributeValue:transportContent.trader.protocolStr]];
//			}
//			if(transportContent.trader.provinceId!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"provinceId" attributeValue:transportContent.trader.provinceId]];
//			}
//			if(transportContent.trader.serialVersionUID!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"serialVersionUID" attributeValue:
//									  [transportContent.trader.serialVersionUID stringValue]]];
//			}
//			if(transportContent.trader.traderName!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"traderName" attributeValue:transportContent.trader.traderName]];
//			}
//			if(transportContent.trader.traderPassword!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"traderPassword" attributeValue:transportContent.trader.traderPassword]];
//			}
//			if(transportContent.trader.unionKey!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"unionKey" attributeValue:transportContent.trader.unionKey]];
//			}
//            if(transportContent.trader.deviceCode!=nil){
//				transportContentStr=[transportContentStr stringByAppendingString:
//									 [self addTagAndContentToXML:@"deviceCode" attributeValue:transportContent.trader.deviceCode]];
//			}
//			transportContentStr=[transportContentStr stringByAppendingString:@"</com.yihaodian.mobile.vo.bussiness.Trader>"];
//		}
//		if(transportContent.methodBodyArray!=nil){									//如果方法集合不为空
//			NSArray * bodyArray=[[NSArray alloc]initWithArray:transportContent.methodBodyArray];//定义一个不可变集合，存放方法集合
//			for(SenderMethodBody * senderMethods in bodyArray){						//迭代处所有方法集合中的SenderMethodBody对象，即一个属性、值对应的结构体
//				if(senderMethods.methodValue==nil){
//					transportContentStr=[transportContentStr stringByAppendingString:@"<null/>"];
//				}
//				else{
//					if([senderMethods.methodType isEqualToString:@"list"] || 
//					   [senderMethods.methodType rangeOfString:@"."].length!=0){	//如果方法体的属性为一个集合，则迭代其值（其值亦为一集合）中的所有对象
//						
//						transportContentStr=[transportContentStr stringByAppendingFormat:@"<%@>",senderMethods.methodType];
//						for(SenderMethodBody * bodyArrayValue in senderMethods.methodValue){
//							transportContentStr=[transportContentStr stringByAppendingString:
//												 [self addTagAndContentToXML:bodyArrayValue.methodType attributeValue:
//												  [bodyArrayValue.methodValue objectAtIndex:0]]];
//						}
//						transportContentStr=[transportContentStr stringByAppendingFormat:@"</%@>",senderMethods.methodType];
//					}
//					else{															//否则就是一个普通的基本类型的参数
//						transportContentStr=[transportContentStr stringByAppendingString:
//											 [self addTagAndContentToXML:senderMethods.methodType attributeValue:
//											  [senderMethods.methodValue objectAtIndex:0]]];
//					}
//				}
//			}
//			[bodyArray release];//tjs
//		}
//		
//	}
//	
//	transportContentStr=[transportContentStr stringByAppendingString:@"</object-array>"];//给它加上<object-array>
//	return transportContentStr;
//}
//
//#pragma mark 添加一个tag标签
//- (NSString *)addTagAndContentToXML:(NSString *)attrName attributeValue:(NSString *)attrValue{
//	NSString * resultStr=[NSString stringWithFormat:@"<%@>%@</%@>",attrName,attrValue,attrName];//tjs
//	return resultStr;
//}
//
//#pragma mark 生成一个set字样的方法的字符串
//- (NSString *)getSetterStr:(NSString *)value{
//	NSString * tempMethodStr=value;
//	NSString * firstLetter=[[value substringToIndex:1] uppercaseString];										//截出首字母
//	tempMethodStr=[tempMethodStr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstLetter];	//将首字母转为大写
//	tempMethodStr=[NSString stringWithFormat:@"set%@:",tempMethodStr];											//给它加上set，这样就变成了方法名
//	//假设有属性att，则方法就为setAtt
//	return tempMethodStr;
//}
//
//#pragma mark 通过获取到的xml为其作为成员的类对象进行赋值(assignment)
//- (void)setClassCollection:(NSString *)elementName{
//	SEL c_methodSelector=NSSelectorFromString(methodStr);														//定义一个方法选择器
//	if(haveInnerClass && serializeInnerClassStatus==1 && serializeCollectionClassStatus!=2){//如果有内部实体，且内部实体的为正在解析状态，且解析集合实体状态未结束
//		NSObject * innerClass=[self setInnerClass:nil];															//获取内部类
//		SEL i_methodSelector=NSSelectorFromString([self getSetterStr:i_tag]);									//内部类的方法选择器
//		if([c_classId respondsToSelector:i_methodSelector]){
//			[c_classId performSelector:i_methodSelector withObject:innerClass];
//		}
//		cmpStr=[NSString stringWithString:methodStr];
//		serializeInnerClassStatus=2;
//	}
//	if([c_classId respondsToSelector:c_methodSelector] && dataObj!=nil){										//普通实体方法赋值
//		if(![cmpStr isEqualToString:methodStr]){
//			[c_classId performSelector:c_methodSelector withObject:dataObj];
//		}
//		cmpStr=[NSString stringWithString:methodStr];															//用于记录方法名，防止下次再次访问，赋值错误
//	}
//	
//	else if([elementName rangeOfString:@"."].length!=0){														//如果是有句号的标签
//		int beginPos=[elementName rangeOfString:@"." options:NSBackwardsSearch].location+1;						//记录句号所在下标
//		NSString * tempCmpStr=[[NSString alloc]initWithString:[elementName substringFromIndex:beginPos]];		//截取句号后面的标签字符串
//		if([tempCmpStr isEqualToString:cmpClassStr] && ![tempCmpStr isEqualToString:@"Page"]){					//如果字符串是最近对应的实体 且 标签不是Page
//			//(Page有可能不出现objList，无法判断是否有
//			//另一个类)
//			if(classArrayRetainCount==0){
//                classArray=[[NSMutableArray alloc] initWithCapacity:0];
//            }
//            classArrayRetainCount++;
//            [classArray addObject:c_classId];																	//将本类作为对象加入类集合
//			[longArray removeAllObjects];																		//清空long集合，防止重复赋值
//			[stringArray removeAllObjects];
//		}
//		else if([tempCmpStr isEqualToString:classStr]){															//如果是最外层的类
//			if(resultClassArrayRetainCount==0){
//                resultClassArray=[[NSMutableArray alloc] initWithCapacity:0];
//            }
//            resultClassArrayRetainCount++;
//            [resultClassArray addObject:m_classId];																//封装成最终对象
//		}
//		[tempCmpStr release];
//	}
//	else if((([elementName rangeOfString:@"list" options:NSCaseInsensitiveSearch].length!=0 || 
//			  [elementName isEqualToString:@"top5Experience"]) && ![elementName isEqualToString:@"list"]) || 
//			([elementName isEqualToString:@"list"] && [classStr isEqualToString:@"LocationVO"]) ||
//			([elementName isEqualToString:@"list"] && [classStr isEqualToString:@"SyncVO"]) ||
//			([elementName isEqualToString:@"list"] && [classStr isEqualToString:@"StatusVO"])
//			){		//如果包含list标签，就作为一个类集合处理
//		
//		attStr=[NSString stringWithString:elementName];													//记录属性标签名称
//		m_methodSelector=NSSelectorFromString([self getSetterStr:attStr]);										//成员方法选择器
//		if([m_classId respondsToSelector:m_methodSelector]){
//			if(dataObj==nil && currentResult!=nil){
//				[m_classId performSelector:m_methodSelector withObject:nil];
//			}
//			else if((![elementName isEqualToString:cmpNextListStr] && ![cmpNextListStr isEqualToString:@""] 
//					 && dataObj==nil && ![cmpFirstListStr isEqualToString:cmpNextListStr] && 
//					 ![elementName isEqualToString:cmpNextListStr])){											//如果出现不同的list标签
//				m_methodSelector=NSSelectorFromString([self getSetterStr:cmpNextListStr]);
//				[m_classId performSelector:m_methodSelector 
//								withObject:[classArray subarrayWithRange:NSMakeRange(indexOfStartOfAClass,[classArray count]-1)]];
//				indexOfStartOfAClass=[classArray count]-1;
//				m_methodSelector=NSSelectorFromString([self getSetterStr:elementName]);
//				[m_classId performSelector:m_methodSelector withObject:[NSMutableArray arrayWithObject:[classArray lastObject]]];
//				serializeCollectionClassStatus=2;
//			}
//			else if(serializeCollectionClassStatus!=1){
//				m_methodSelector=NSSelectorFromString([self getSetterStr:attStr]);
//				[m_classId performSelector:m_methodSelector withObject:classArray];
//				if(headOfCollection && [elementName isEqualToString:@"objList"]){								//如果有多个Page，则先释放类集合，再分配空间
//					[classArray release];
//					classArray=[[NSMutableArray alloc] initWithCapacity:0];
//				}
//			}
//		}
//		cmpNextListStr=[NSString stringWithString:elementName];													//记录结束的list关键字标签
//	}
//	else{
//		if(haveInnerClass && serializeInnerClassStatus==1){														//如果为非集合的含有内部类的XML
//			NSObject * innerClass=[self setInnerClass:nil];
//			SEL i_methodSelector=NSSelectorFromString([self getSetterStr:i_tag]);
//			if([m_classId respondsToSelector:i_methodSelector]){
//				[m_classId performSelector:i_methodSelector withObject:innerClass];
//				
//			}
//			serializeInnerClassStatus=2;
//		}
//		if([m_classId respondsToSelector:m_methodSelector] && dataObj!=nil){
//			[m_classId performSelector:m_methodSelector withObject:dataObj];
//			serializeCollectionClassStatus=2;
//		}
//	}
//}
//
//#pragma mark 设置内部成员类
//- (NSObject *)setInnerClass:(NSString *)elementName{
//	if(serializeInnerClassStatus==1){																			//如果内部类处于解析状态 
//		NSString * tempSubbedDataStr1=[[NSString alloc]initWithData:serilizeData encoding:NSUTF8StringEncoding];
//		NSString * startTag=[[NSString alloc]initWithFormat:@"<%@>",i_tag];
//		NSString * endTag=[[NSString alloc]initWithFormat:@"</%@>",i_tag];
//		NSRange tempStartRange=[tempSubbedDataStr1 rangeOfString:startTag options:NSLiteralSearch 
//														   range:NSMakeRange(i_endIndex, [tempSubbedDataStr1 length]-i_endIndex)];
//		NSRange tempEndRange=[tempSubbedDataStr1 rangeOfString:endTag options:NSLiteralSearch 
//														 range:NSMakeRange(i_endIndex, [tempSubbedDataStr1 length]-i_endIndex)];
//		
//		[startTag release];//tjs
//		[endTag release];//tjs
//		NSString * tempSubbedDataStr2=[[NSString alloc] initWithString:[tempSubbedDataStr1 substringWithRange:
//																		NSMakeRange(tempStartRange.location+tempStartRange.length,
//																					tempEndRange.location-(tempStartRange.location+tempStartRange.length))]];		//截取内部类所在区域，作为另一个XML来解析
//        [tempSubbedDataStr1 release];
//		NSString * subbedDataStr=[[NSString alloc]initWithFormat:@"<com.yihaodian.%@>%@</com.yihaodian.%@>",i_classStr,tempSubbedDataStr2,i_classStr];
//        [tempSubbedDataStr2 release];
//		i_endIndex=tempEndRange.location+tempEndRange.length;
//		NSData * subbedData=[NSData dataWithData:[subbedDataStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
//        [subbedDataStr release];
//        NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
//		XMLSerializeService * i_serializeParseServ=[[XMLSerializeService alloc] init];
//        [i_serializeParseServ setIsInnerClass:YES];
//		NSObject * resultObj=[i_serializeParseServ fromXML:subbedData];						//解析结果，作为一个普通的类保存并返回
//        [i_serializeParseServ release];
//        [pool drain];
//		return resultObj;
//	}
//	return nil;
//}
//
//#pragma mark 通过获取到的xml生成一个对象，为其分配空间
//- (void)createEntity:(NSString *)elementName{
//	int beginPos=[elementName rangeOfString:@"." options:NSBackwardsSearch].location+1;
//	cmpClassStr=[elementName substringFromIndex:beginPos];
//	Class tmpClass;
//	if(headOfCollection && [cmpClassStr isEqualToString:@"Page"]){
//		haveAnotherClass=YES;
//	}
//	if((!findFirstClass && ![cmpClassStr isEqualToString:classStr])){
//		haveAnotherClass=YES;
//		tmpClass=NSClassFromString(cmpClassStr);
//		c_classStr=cmpClassStr;
//		c_classId=[tmpClass new];																				//开辟一块空间
//		return;
//	}
//	classStr=[elementName substringFromIndex:beginPos];
//	tmpClass=NSClassFromString(classStr);
//	m_classId=[tmpClass new];
//}
//
//#pragma mark 通过获取到的xml为对象的成员变量(亦称属性)进行赋值(assignment)
//- (void)setAttribute:(NSString *)elementName{
//	if([elementName isEqualToString:@"string"] || [elementName isEqualToString:@"long"] || 
//	   [elementName rangeOfString:@"list" options:NSCaseInsensitiveSearch].length!=0){
//		[self setCollection:elementName];
//	}
//	else if(![elementName isEqualToString:@"string"] && ![elementName isEqualToString:@"long"] && 
//			[elementName rangeOfString:@"list" options:NSCaseInsensitiveSearch].length==0 && 
//			[elementName rangeOfString:@"."].length==0){
//		attStr=[NSString stringWithString:elementName];
//		if([attStr isEqualToString:@"id"]){
//			attStr=@"nid";
//		}
//        methodStr=[self getSetterStr:attStr];
//	}
//}
//
//#pragma mark 通过获取到的xml为对象的成员变量(亦称属性)中的集合进行赋值(assignment)
//- (void)setCollection:(NSString *)elementName{
//	if([elementName isEqualToString:@"long"]){
//        if(longArrayRetainCount==0){
//            longArray=[[NSMutableArray alloc]initWithCapacity:0];
//        }
//        longArrayRetainCount++;
//		NSNumber * longValue=[[NSNumber alloc]initWithInt:[currentResult intValue]];
//		[longArray addObject:longValue];
//		[longValue release];//tjs
//	}
//	else if([elementName isEqualToString:@"string"]){
//        if(stringArrayRetainCount==0){
//            stringArray=[[NSMutableArray alloc]initWithCapacity:0];
//        }
//        stringArrayRetainCount++;
//		[stringArray addObject:currentResult];
//	}
//	else if([elementName isEqualToString:@"int"]){
//        if(intArrayRetainCount==0){
//            intArray=[[NSMutableArray alloc]initWithCapacity:0];
//        }
//        intArrayRetainCount++;
//		NSNumber * intValue=[[NSNumber alloc]initWithInt:[currentResult intValue]];
//		[intArray addObject:intValue];
//		[intValue release];//tjs
//	}
//}
//
//#pragma mark NSXMLParser的协议方法，找到开始标签执行的方法
//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
//  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
//	attributes:(NSDictionary *)attributeDict{
//
//    //DebugLog(@"=======%@",elementName);
//
//	tabStr=[NSString stringWithString:elementName];												//记录标签的值
//	currentResult=[NSString stringWithString:@""];
//	if([elementName isEqualToString:@"error"]){				//如果服务器出现错误
//		resultClassArray=nil;
//        return;
//	}
//	if(([elementName rangeOfString:@"list" options:NSCaseInsensitiveSearch].length!=0 && [elementName length]>5) || 
//	   [elementName isEqualToString:@"top5Experience"] ||
//	   ([elementName isEqualToString:@"list"] && [classStr isEqualToString:@"LocationVO"]) ||
//	   ([elementName isEqualToString:@"list"] && [classStr isEqualToString:@"SyncVO"])){						//如果出现类集合
//		cmpFirstListStr=elementName;
//	}
//	if([elementName rangeOfString:@"."].length!=0){
//		haveEntity=YES;
//		[self createEntity:elementName];
//		findFirstClass=NO;
//		return;
//	}
//	else if([elementName isEqualToString:@"product"] || [elementName isEqualToString:@"rating"] || 
//			[elementName isEqualToString:@"goodReceiver"] || [elementName isEqualToString:@"coupon"] || 
//            [elementName isEqualToString:@"hotProduct"] || [elementName isEqualToString:@"productVO"]){	//如果出现内部类
//		i_tag=elementName;
//		if([elementName isEqualToString:@"product"] || [elementName isEqualToString:@"hotProduct"] || [elementName isEqualToString:@"productVO"]){
//			i_classStr=@"ProductVO";
//		}
//		else if([elementName isEqualToString:@"rating"]){
//			i_classStr=@"ProductRatingVO";
//		}
//		else if([elementName isEqualToString:@"goodReceiver"]){
//			i_classStr=@"GoodReceiverVO";
//		}
//		else if([elementName isEqualToString:@"coupon"]){
//			i_classStr=@"CouponVO";
//		}
//		serializeInnerClassStatus=1;
//		haveInnerClass=YES;
//	}
//}
//
//#pragma mark NSXMLParser的协议方法，找到标签内有值执行的方法
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//
//    //DebugLog(@"string=====%@,tabaStr=====%@",string,tabStr);
//
//	if([tabStr isEqualToString:@"error"]){							//如果服务器出现错误
//		if([string rangeOfString:@"用户Token过期"].length!=0){
//            NSNumber * errorValue=[[NSNumber alloc] initWithInt:ERROR_USER_TOKEN_EXPIRED];
//            errorNumValue=[errorValue retain];
//			[[GlobalValue getGlobalValueInstance] setErrorType:errorValue];
//            [errorValue release];
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"tokenTimeout" object:@"tokenTimeOut"]; //向首页发消息，自动登录
//			return;
//		}
//		else if([string rangeOfString:@"服务器内部"].length!=0){
//            NSNumber * errorValue=[[NSNumber alloc] initWithInt:ERROR_SERVICE_FAILURE];
//            errorNumValue=[errorValue retain];
//			[[GlobalValue getGlobalValueInstance] setErrorType:errorValue];
//            [errorValue release];
//			return;
//		}
//		else{
//            NSNumber * errorValue=[[NSNumber alloc] initWithInt:ERROR_SERVICE_OTHER_FAILURE];
//            errorNumValue=[errorValue retain];
//			[[GlobalValue getGlobalValueInstance] setErrorType:errorNumValue];
//            [errorValue release];
//            NSString * errorString=[[NSString alloc] initWithString:string];
//            globalErrorString=[errorString retain];
//            [[GlobalValue getGlobalValueInstance] setErrorString:globalErrorString];
//            [errorString release];
//            //[[NSNotificationCenter defaultCenter] postNotificationName:@"showWebOtherErrorAlertView" object:nil];
//			return;
//		}
//	}
//	NSString * trimBlank=[NSString stringWithFormat:@"%c",'\n'];
//	if([tabStr isEqualToString:@"description"] || [tabStr isEqualToString:@"remark"] || 
//	   ([tabStr isEqualToString:@"content"] && ([classStr isEqualToString:@"InnerMessageVO"] || 
//												[c_classStr isEqualToString:@"InnerMessageVO"]))){
//		if([tabStr isEqualToString:@"remark"]){
//			if([string rangeOfString:@"\r"].length!=0){
//				[string stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];					//去掉标签值内的换行，不然下面的XML走不了协议
//			}
//		}
//		currentResult=[currentResult stringByAppendingString:string];
//	}
//	else if(![string isEqualToString:@""] && string!=nil && [string rangeOfString:trimBlank].length==0 
//			&& ![string isEqualToString:@" "]){
//		if([string rangeOfString:trimBlank].length!=0){
//			[string stringByReplacingOccurrencesOfString:trimBlank withString:@""];
//		}
//		if([tabStr isEqualToString:@"cnName"] || [tabStr isEqualToString:@"advertisement"] || [tabStr isEqualToString:@"categoryName"]
//           || [tabStr isEqualToString:@"title"] || [tabStr isEqualToString:@"detailUrl"] || [tabStr isEqualToString:@"recordName"] ||
//		   [tabStr isEqualToString:@"bankname"] || [tabStr isEqualToString:@"icon"] || [tabStr isEqualToString:@"url"] ||
//		   [tabStr isEqualToString:@"name"] || [tabStr isEqualToString:@"addr"] || [tabStr isEqualToString:@"message"]){//有可能出现的字符是一个转义字符，协议认为有多个标签
//			currentResult=[currentResult stringByAppendingString:string];
//			dataObj=currentResult;
//			return;
//		}
//		currentResult=[NSString stringWithString:string];
//	}
//	else{
//		currentResult=nil;
//	}
//	if([tabStr isEqualToString:@"string"]){
//		dataObj=stringArray;
//	}
//	else if([tabStr isEqualToString:@"long"]){
//		dataObj=longArray;
//	}
//	else if([tabStr isEqualToString:@"int"]){
//		dataObj=intArray;
//	}
//	else{
//		dataObj=currentResult;
//	}
//}
//
//#pragma mark NSXMLParser的协议方法，找到结束标签执行的方法
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
//  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName{
//
//    //DebugLog(@"elementName=====%@",elementName);
//
//	if([elementName isEqualToString:@"error"] || [elementName isEqualToString:@"null"]){
//		return;
//	}
//	if(!haveEntity){
//		if(headOfCollection){
//			if(![elementName rangeOfString:@"list"].length!=0){
//                if(resultClassArrayRetainCount==0){
//                    resultClassArray=[[NSMutableArray alloc] initWithCapacity:0];
//                }
//                resultClassArrayRetainCount++;
//                if (currentResult==nil) {
//                    currentResult=[NSString stringWithString:@""];
//                }
//				[resultClassArray addObject:currentResult];
//			}
//			return;
//		}
//		else{
//			resultClassArray=dataObj;
//		}
//	}
//	
//	[self setAttribute:elementName];													//开始设置属性
//	
//	m_methodSelector=NSSelectorFromString(methodStr);
//	if(headOfCollection && !haveAnotherClass){
//		if([m_classId respondsToSelector:m_methodSelector] && dataObj!=nil){
//			if(![cmpStr isEqualToString:methodStr]){
//				[m_classId performSelector:m_methodSelector withObject:dataObj];
//			}
//			//cmpStr=[NSString stringWithString:methodStr];
//		}
//		if([elementName rangeOfString:@"."].length!=0){
//            if(resultClassArrayRetainCount==0){
//                resultClassArray=[[NSMutableArray alloc] initWithCapacity:0];
//            }
//            resultClassArrayRetainCount++;
//			[resultClassArray addObject:m_classId];
//		}
//	}
//	else if(haveAnotherClass){															//如果有其它实体
//		
//		[self setClassCollection:elementName];
//	}
//	else{
//		if(haveInnerClass && serializeInnerClassStatus==1){								//如果内部实体标签作为最后一个标签出现
//			NSObject * innerClass=[self setInnerClass:nil];
//            NSString * i_methodStr=[self getSetterStr:i_tag];
//			SEL i_methodSelector=NSSelectorFromString(i_methodStr);
//			if([m_classId respondsToSelector:i_methodSelector]){
//				[m_classId performSelector:i_methodSelector withObject:innerClass];
//				
//			}
//			serializeInnerClassStatus=2;
//		}
//		if([m_classId respondsToSelector:m_methodSelector] && dataObj!=nil){
//            if(![cmpStr isEqualToString:methodStr]){
//                [m_classId performSelector:m_methodSelector withObject:dataObj];
//            }
//            
//		}
//		if([elementName rangeOfString:@"."].length!=0){
//            if(resultClassArrayRetainCount==0){
//                resultClassArray=[[NSMutableArray alloc] initWithCapacity:0];
//            }
//            resultClassArrayRetainCount++;
//			[resultClassArray addObject:m_classId];
//		}
//	}
//    cmpStr=[NSString stringWithString:methodStr];
//}
//
//-(void)dealloc{
//    if(errorNumValue!=nil){
//        [errorNumValue release];
//    }
//    if(serilizeData!=nil){
//        [serilizeData release];
//    }
//    if(resultClassArray!=nil){
//        if(headOfCollection){
//            if(haveEntity){
//                if(longArray!=nil){
//                    
//                    [longArray removeAllObjects];
//                    [longArray release];
//                }
//                if(stringArray!=nil){
//					
//                    [stringArray removeAllObjects];
//                    [stringArray release];
//                }
//                if(intArray!=nil){
//                    
//                    [intArray removeAllObjects];
//                    [intArray release];
//                }
//                if(classArray!=nil){
//                    
//                    [classArray removeAllObjects];
//                    [classArray release];
//                }
//            }
//            if(!haveInnerClass && haveEntity){
//                if(resultClassArray!=nil){
//                    [resultClassArray removeAllObjects];
//                    [resultClassArray release];
//                }
//            }
//        }
//    }
//    [super dealloc];
//}
//
//@end
