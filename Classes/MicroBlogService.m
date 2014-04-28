//
//  MicroBlogService.m
//  TheStoreApp
//
//  Created by linyy on 11-7-15.
//  Copyright 2011 vsc. All rights reserved.
//requestWentWrongEntity

#import "MicroBlogService.h"
#import "ASIHTTPRequest.h"
#import "ConnectAction.h"
#import "LocationVO.h"
#import "SyncVO.h"
#import "StatusVO.h"
#import "XMLSerializeService.h"
#import "XStream.h"
#import "OTSEverybodyWantsMe.h"
#import "OTSUtility.h"

//#define CURRENT_METHOD_NAME(_cmd) [NSStringFromSelector(_cmd) substringToIndex:[NSStringFromSelector(_cmd) rangeOfString:@":" options:NSLiteralSearch].location]
#define TS_SINA_BASE_URL @"http://m.yihaodian.com/interface/share/"
#define TS_SHARE_SHOW_BASE_URL @"http://m.yihaodian.com/interface/show/"
#define NETWORK_DOING_VALUE 70
#define NETWORK_GONE_WRONG_VALUE 40
#define NETWORK_RESULT_WRONG_VALUE 1145
#define NETWORK_SUCCESS_VALUE 120
#define SERIALIZE_NORMAL_XML_VALUE 742
#define SERIALIZE_XML_WITH_ENTITY_VALUE 743

@implementation MicroBlogService

-(id)init{
    baseUrl=TS_SINA_BASE_URL;
	serializeAction=SERIALIZE_NORMAL_XML_VALUE;
    conn=[ConnectAction alloc];
    return self;
}

-(int)shareCheck:(NSString *)userName password:(NSString *)password targetId:(long)targetId{
    int connectTimes=1;
	actionResult=NETWORK_DOING_VALUE;
	serializeAction=SERIALIZE_NORMAL_XML_VALUE;
    if(![conn connectedToNetwork]){
        return 0;
    }
    NSMutableData * postBody=[[NSMutableData alloc] init];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.do",baseUrl,CURRENT_METHOD_NAME(_cmd)]];
    request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
    NSString * did=[NSString stringWithFormat:@"userName=%@&password=%@&targetId=%ld",userName,password,targetId];
	
    [postBody appendData:[did dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [request setPostBody:postBody];
    [postBody release];
    
    [request setTimeOutSeconds:11];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request startSynchronous];
    /*while(actionResult==NETWORK_DOING_VALUE){
	 
	 }
	 while(actionResult==NETWORK_GONE_WRONG_VALUE){
	 [request startAsynchronous];
	 connectTimes++;
	 if(connectTimes>3){
	 return 0;
	 }
	 }
	 if(actionResult==NETWORK_SUCCESS_VALUE){
	 return 1;
	 }*/
	while(YES){
		if(actionResult==NETWORK_GONE_WRONG_VALUE && connectTimes<=3){
			[request startAsynchronous];
			connectTimes++;
		}
		if(actionResult==NETWORK_SUCCESS_VALUE){
			return 1;
		}
		if(actionResult==NETWORK_RESULT_WRONG_VALUE){
			return iResultValue;
		}
		if(connectTimes>3){
			break;
		}
	}
    return 0;
}

-(void)sharePublish:(NSString *)name password:(NSString *)password 
		   targetId:(long)targetId comment:(NSString *)comment guid:(NSString *)guid syncs:(NSString *)syncs{
	int connectTimes=1;
    actionResult=NETWORK_DOING_VALUE;
	serializeAction=SERIALIZE_NORMAL_XML_VALUE;
    if(![conn connectedToNetwork]){
        return;
    }
    NSMutableData * postBody=[[NSMutableData alloc] init];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.do?r=%d",baseUrl,CURRENT_METHOD_NAME(_cmd),arc4random()%1000]];
    request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
	NSString * did=nil;
	if(targetId==1l){
		did=[NSString stringWithFormat:@"userName=%@&password=%@&targetId=1&comment=%@",name,password,comment];
	}
	else if(targetId==3l){
		did=[NSString stringWithFormat:@"userName=%@&password=%@&targetId=3&comment=%@&guid=%@"
			  ,name,password,comment,guid];
		if(syncs!=nil){
			did=[NSString stringWithFormat:@"%@&syncs=%@",did,syncs];
		}
	}
    [postBody appendData:[did dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [request setPostBody:postBody];
    [postBody release];
    
    [request setTimeOutSeconds:11];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request startAsynchronous];
	while(actionResult==NETWORK_GONE_WRONG_VALUE){
		[request startAsynchronous];
		connectTimes++;
		if(connectTimes>3){
			return;
		}
	}
}

-(int)saveShow:(NSString *)aid userName:(NSString *)u orderCode:(NSString *)oid productId:(NSString *)pid
	merchantId:(NSString *)mid pronvinceId:(NSString *)vid gpsX:(NSString *)gx gpsY:(NSString *)gy
	  targetId:(NSString *)tid fromId:(NSString *)fid{
	int connectTimes=1;
	actionResult=NETWORK_DOING_VALUE;
	serializeAction=SERIALIZE_NORMAL_XML_VALUE;
    if(![conn connectedToNetwork]){
        return 0;
    }
    NSMutableData * postBody=[[NSMutableData alloc] init];
	NSString * showBaseUrl=TS_SHARE_SHOW_BASE_URL;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.do",showBaseUrl,CURRENT_METHOD_NAME(_cmd)]];
    request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
    NSString * did=[NSString stringWithFormat:@"aid=%@&u=%@&oid=%@&pid=%@",aid,u,oid,pid];
	if(mid && ![mid isEqualToString:@""]){
		did=[did stringByAppendingFormat:@"&mid=%@",mid];
	}
	did=[did stringByAppendingFormat:@"&vid=%@",vid];
	if(gx && ![gx isEqualToString:@""] && [gx intValue]>1){
		did=[did stringByAppendingFormat:@"&gx=%@",gx];
	}
	if(gy && ![gy isEqualToString:@""] && [gy intValue]>1){
		did=[did stringByAppendingFormat:@"&gy=%@",gy];
	}
	did=[did stringByAppendingFormat:@"&tid=%@&fid=%@",tid,fid];
	
    [postBody appendData:[did dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [request setPostBody:postBody];
    [postBody release];
    
    [request setTimeOutSeconds:11];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request startAsynchronous];
    
	while(YES){
		if(actionResult==NETWORK_GONE_WRONG_VALUE && connectTimes<=3){
			[request startAsynchronous];
			connectTimes++;
		}
		if(actionResult==NETWORK_SUCCESS_VALUE){
			return 1;
		}
		if(actionResult==NETWORK_RESULT_WRONG_VALUE){
			return 0;
		}
		if(connectTimes>3){
			break;
		}
	}
    return 0;
}

-(int)exists:(NSString *)aid userName:(NSString *)u orderCode:(NSString *)oid productId:(NSString *)pid 
 pronvinceId:(NSString *)vid{
	int connectTimes=1;
	actionResult=NETWORK_DOING_VALUE;
	serializeAction=SERIALIZE_NORMAL_XML_VALUE;
    if(![conn connectedToNetwork]){
        return 0;
    }
    NSMutableData * postBody=[[NSMutableData alloc] init];
	NSString * showBaseUrl=TS_SHARE_SHOW_BASE_URL;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.do",showBaseUrl,CURRENT_METHOD_NAME(_cmd)]];
    request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
    NSString * did=[NSString stringWithFormat:@"aid=%@&u=%@&oid=%@",aid,u,oid];
	if(pid && ![pid isEqualToString:@""]){
		did=[did stringByAppendingFormat:@"&pid=%@",pid];
	}
	if(vid && ![vid isEqualToString:@""]){
		did=[did stringByAppendingFormat:@"&vid=%@",vid];
	}
	
    [postBody appendData:[did dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [request setPostBody:postBody];
    [postBody release];
    
    [request setTimeOutSeconds:11];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request startAsynchronous];
    
	while(YES){
		if(actionResult==NETWORK_GONE_WRONG_VALUE && connectTimes<=3){
			[request startAsynchronous];
			connectTimes++;
		}
		if(actionResult==NETWORK_SUCCESS_VALUE){
			return 1;
		}
		if(actionResult==NETWORK_RESULT_WRONG_VALUE){
			return 0;
		}
		if(connectTimes>3){
			break;
		}
	}
    return -1;
}

-(LocationVO *)locations:(NSString *)userName password:(NSString *)password 
				targetId:(long)targetId pageNum:(long)pageNum count:(long)count query:(NSString *)query 
					city:(NSString *)city lon:(float)lon lat:(float)lat{
    
    sendComplete=NO;
	connectedTimes=1;
    if(![conn connectedToNetwork]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showWebErrorAlertView" object:nil];
        return nil;
    }
    NSMutableData * postBody=[[NSMutableData alloc] init];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.do",baseUrl,CURRENT_METHOD_NAME(_cmd)]];
    request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
	/*NSString * did=[NSString stringWithFormat:@"userName=%@&password=%@&targetId=%ld&pageNum=%ld&count=%ld&query=%@&city=%@&lon=%.6f&lat=%.6f"
	 ,userName,password,targetId,pageNum,count,query,city,lon,lat];*/
	NSString * did=[NSString stringWithFormat:@"userName=%@&password=%@&targetId=%ld&pageNum=%ld&count=%ld"
					 ,userName,password,targetId,pageNum,count];
	if(query!=nil){
		did=[NSString stringWithFormat:@"%@&query=%@",did,query];
	}
	if(city!=nil){
		did=[NSString stringWithFormat:@"%@&city=%@",did,city];
	}
	if(lon>0.01f){
		did=[NSString stringWithFormat:@"%@&lon=%.9f",did,lon];
	}
	else{
		did=[NSString stringWithFormat:@"%@&lon=0.0",did];
	}
	if(lon>0.01f){
		did=[NSString stringWithFormat:@"%@&lat=%.9f",did,lat];
	}
	else{
		did=[NSString stringWithFormat:@"%@&lat=0.0",did];
	}
    [postBody appendData:[did dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [request setPostBody:postBody];
    [postBody release];
	
    [request setTimeOutSeconds:11];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDoneEntity:)];
    [request setDidFailSelector:@selector(requestWentWrongEntity:)];
    [request startAsynchronous];
    
    NSDate * shouldRetunDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:[request timeOutSeconds]];
    NSDate * currentDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0];
	while ([currentDate compare:shouldRetunDate]!=NSOrderedDescending) {
        [currentDate release];
        currentDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0];
        if(resultData!=nil && sendComplete && connectedTimes<=3){
            [currentDate release];
            [shouldRetunDate release];
            
            return (LocationVO *)[self parseEntity];
        }
		if (resultData==nil&&sendComplete && connectedTimes<=3) {
			[request setDelegate:self];
            [request setDidFinishSelector:@selector(requestDoneEntity:)];
            [request setDidFailSelector:@selector(requestWentWrongEntity:)];
            [request startAsynchronous];
		}
        if(connectedTimes>3){
            break;
        }
    }
    [currentDate release];
    [shouldRetunDate release];
	
    return nil;
}

-(SyncVO *)syncs:(NSString *)userName password:(NSString *)password targetId:(long)targetId{
    
	sendComplete=NO;
    connectedTimes=1;
    if(![conn connectedToNetwork]){
        return nil;
    }
    NSMutableData * postBody=[[NSMutableData alloc] init];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.do",baseUrl,CURRENT_METHOD_NAME(_cmd)]];
    request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
	NSString * did=[NSString stringWithFormat:@"userName=%@&password=%@&targetId=%ld"
					 ,userName,password,targetId];
    [postBody appendData:[did dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [request setPostBody:postBody];
    [postBody release];
    
    [request setTimeOutSeconds:11];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDoneEntity:)];
    [request setDidFailSelector:@selector(requestWentWrongEntity:)];
    [request startAsynchronous];
	
    NSDate * shouldRetunDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:[request timeOutSeconds]];
    NSDate * currentDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0];
    while ([currentDate compare:shouldRetunDate]!=NSOrderedDescending) {
        [currentDate release];
        currentDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0];
        if(resultData!=nil && sendComplete && connectedTimes<=3){
            [currentDate release];
            [shouldRetunDate release];
            return (SyncVO *)[self parseEntity];
        }
		if (resultData==nil&&sendComplete && connectedTimes<=3) {
			[request setDelegate:self];
            [request setDidFinishSelector:@selector(requestDoneEntity:)];
            [request setDidFailSelector:@selector(requestWentWrongEntity:)];
            [request startAsynchronous];
		}
        if(connectedTimes>3){
            break;
        }
    }
    [currentDate release];
    [shouldRetunDate release];
	
    return nil;
}

-(StatusVO *)checkin:(NSString *)userName password:(NSString *)password 
			targetId:(long)targetId comment:(NSString *)comment guid:(NSString *)guid syncs:(NSString *)syncs{
	sendComplete=NO;
    connectedTimes=1;
    if(![conn connectedToNetwork]){
        return nil;
    }
    NSMutableData * postBody=[[NSMutableData alloc] init];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.do",baseUrl,CURRENT_METHOD_NAME(_cmd)]];
    request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
	
	NSString * did=nil;
	if(targetId==1l){
		did=[NSString stringWithFormat:@"userName=%@&password=%@&targetId=1&comment=%@",userName,password,comment];
	}
	else if(targetId==3l){
		did=[NSString stringWithFormat:@"userName=%@&password=%@&targetId=3&comment=%@&guid=%@"
			  ,userName,password,comment,guid];
		if(syncs!=nil){
			did=[NSString stringWithFormat:@"%@&syncs=%@",did,syncs];
		}
	}
	
    [postBody appendData:[did dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [request setPostBody:postBody];
    [postBody release];
    
    [request setTimeOutSeconds:11];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDoneEntity:)];
    [request setDidFailSelector:@selector(requestWentWrongEntity:)];
    [request startAsynchronous];
	
    NSDate * shouldRetunDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:[request timeOutSeconds]];
    NSDate * currentDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0];
    while ([currentDate compare:shouldRetunDate]!=NSOrderedDescending) {
        [currentDate release];
        currentDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0];
        if(resultData!=nil && sendComplete && connectedTimes<=3){
            [currentDate release];
            [shouldRetunDate release];
            return (StatusVO *)[self parseEntity];
        }
		if (resultData==nil&&sendComplete && connectedTimes<=3) {
			[request setDelegate:self];
            [request setDidFinishSelector:@selector(requestDoneEntity:)];
            [request setDidFailSelector:@selector(requestWentWrongEntity:)];
            [request startAsynchronous];
		}
        if(connectedTimes>3){
            break;
        }
    }
    [currentDate release];
    [shouldRetunDate release];
	
    return nil;
}

-(NSObject *)parseEntity{
    XStream *xStream=[[[XStream alloc] init] autorelease];
    NSObject * resultObject=[xStream fromXML:resultData];
    return resultObject;
}

- (void)requestDoneEntity:(ASIHTTPRequest *)_request{
    resultData = [[NSData alloc] initWithData:[_request responseData]];
    sendComplete=YES;
	//NSLog(@"entity:\n%@",[_request responseString]);
}

- (void)requestWentWrongEntity:(ASIHTTPRequest *)_request{
    if(resultData!=nil){
        [resultData release];
        resultData=nil;
    }
    sendComplete=YES; 
}

-(void)requestDone:(ASIHTTPRequest *)_request{
    [self doSerialize:[_request responseData]];
	//NSLog(@"done:\n%@",[_request responseString]);
}

-(void)requestWentWrong:(ASIHTTPRequest *)_request{
    actionResult=NETWORK_GONE_WRONG_VALUE;
}

-(void)doSerialize:(NSData *)xmlData{
    parser=[[NSXMLParser alloc] initWithData:[xmlData retain]];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
}

#pragma mark NSXMLParser的协议方法，找到开始标签执行的方法
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
}

#pragma mark NSXMLParser的协议方法，找到标签内有值执行的方法
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	currentResult=[NSString stringWithString:string];
}

#pragma mark NSXMLParser的协议方法，找到结束标签执行的方法
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName{
	if([elementName isEqualToString:@"ResultCode"]){
        if([currentResult isEqualToString:@"1"]){
            actionResult=NETWORK_SUCCESS_VALUE;
        }
        else if([currentResult isEqualToString:@"0"]){
			iResultValue=[currentResult intValue];
            actionResult=NETWORK_RESULT_WRONG_VALUE;
        }
		else{
			iResultValue=[currentResult intValue];
			actionResult=NETWORK_RESULT_WRONG_VALUE;
		}
    }
}

-(void)dealloc{
    if(conn!=nil){
        [conn release];
    }
    [super dealloc];
}

@end