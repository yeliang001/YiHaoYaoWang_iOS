//
//  ConnectAction.m
//  TheStoreApp
//
//  Created by linyy on 11-1-20.
//  Copyright vsc. All rights reserved.
//	用于连接并发送数据，返回一个XML

#import "ConnectAction.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "GlobalValue.h"
#import "TheStoreAppAppDelegate.h"

#define ERROR_CONNECTION_FAILURE 3

@implementation ConnectAction

@synthesize m_urlStr;
@synthesize m_fileDataStr;
@synthesize m_methodNameStr;
@synthesize request;
//@synthesize queue;

- (NSData *)getConnectionReturnData:(NSString *) urlStr fileDataStr:(NSString *) fileDataStr methodName:(NSString *) methodNameStr{
	NSCondition * condition=[[NSCondition alloc]init];
    [condition lock];
	if (![self connectedToNetwork]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"showWebErrorAlertView" object:nil];
		[condition signal];
		[condition unlock];
		[condition release];
		return nil;
	}
	
    sendComplete=NO;
    [self setM_urlStr:urlStr];
    [self setM_fileDataStr:fileDataStr];
    [self setM_methodNameStr:methodNameStr];
    [self doConnectAct];
    NSDate * shouldRetunDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:[request timeOutSeconds]];
    NSDate * currentDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0];
   
	while ([currentDate compare:shouldRetunDate]!=NSOrderedDescending) {
        [currentDate release];
        currentDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0];
        if(resultData!=nil&&sendComplete){
            [currentDate release];
            [shouldRetunDate release];
            [condition signal];
            [condition unlock];
            [condition release];
            return resultData;
        }
		if (resultData==nil&&sendComplete) {//tjs
			[currentDate release];
            [shouldRetunDate release];
            [condition signal];
            [condition unlock];
            [condition release];
            //[self doFail];
            return [(NSData *)[[NSNull alloc] init] autorelease];
		}
    }
    [currentDate release];
    [shouldRetunDate release];
    [condition signal];
    [condition unlock];
    [condition release];
    [self doFail];
	
    return nil;
}

-(void)doConnectAct{
    resultData=nil;
	request=nil;
	/*@try {
		[condition lock];
		NSMutableData * postBody=[[NSMutableData alloc] init];
		NSURL * url=[NSURL URLWithString:m_urlStr];
		NSMutableURLRequest *urlRequest=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		[urlRequest setHTTPMethod:@"POST"];
		[urlRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
		NSString * did=[NSString stringWithFormat:@"methodName=%@&methodBody=%@",m_methodNameStr,m_fileDataStr];
		[postBody appendData:[did dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
		[urlRequest setHTTPBody:postBody];
		[postBody release];//tjs
		if (![self connectedToNetwork]) {
            resultData=nil;
			[self doFail];
            [urlRequest release];
			return;
		}
		NSLog(@"doConnectAct 3");
        [pool drain];
		resultData=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        
        NSLog(@"doConnectAct 4");
		if(resultData==nil){
			[self doFail];
            [urlRequest release];
			return;
		}
        
		sendComplete=YES;
		[condition signal];
		[condition unlock];
		[urlRequest release];
        
	}@catch (NSException *e) {
		//[self doFail];
	}@finally {
        
        if(![connectThread isCancelled]){
            [connectThread cancel];
        }
	}*/
    
    //[condition lock];
    
    
    NSMutableData * postBody=[[NSMutableData alloc] init];
    NSURL * url = [NSURL URLWithString:m_urlStr];
    request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
    NSString * did=[NSString stringWithFormat:@"methodName=%@&methodBody=%@",m_methodNameStr,m_fileDataStr];
    
    DebugLog(@"post ody:\n%@", did);
    
    [postBody appendData:[did dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [request setPostBody:postBody];
    [postBody release];
    
    [request setTimeOutSeconds:11];
    [request setDelegate:self];
    //[request setDidFinishSelector:@selector(requestDone:)];
    //[request setDidFailSelector:@selector(requestWentWrong:)];
    //[self.queue addOperation:request];
    [request startAsynchronous];
//    [condition signal];
//	[condition unlock];

}

- (void)requestFinished:(ASIHTTPRequest *)_request{
	DebugLog(@"RESP XML:\n%@",[_request responseString]);
    resultData = [[NSData alloc] initWithData:[_request responseData]];
    sendComplete=YES;
}

- (void)requestFailed:(ASIHTTPRequest *)_request{
    //[self doFail];
    if(resultData!=nil){
        [resultData release];
        resultData=nil;
    }
    [request cancel];
	sendComplete=YES;//tjs
}

-(void)doFail{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"cancelIndicator" object:nil];
    if ([SharedDelegate respondsToSelector:@selector(clearCartNum)]) {
        [SharedDelegate performSelector:@selector(clearCartNum) withObject:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setLoingBtnIcon" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showWebErrorAlertView" object:nil];

}

-(BOOL)connectedToNetwork{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags){
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


-(void)dealloc{
    //[errorNumValue release];
	if(m_urlStr!=nil){
		[m_urlStr release];
	}
	if(m_fileDataStr!=nil){
		[m_fileDataStr release];
	}
	if(m_methodNameStr!=nil){
		[m_methodNameStr release];
	}
    /*if(queue!=nil){
        [queue release];
    }*/
    //[request clearDelegatesAndCancel];
	if(resultData!=nil){
		[resultData release];
	}
    request=nil;
    [super dealloc];
}

@end
