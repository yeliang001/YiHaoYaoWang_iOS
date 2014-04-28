//
//  ConnectAction.h
//  TheStoreApp
//
//  Created by linyy on 11-1-20.
//  Copyright vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface ConnectAction : NSObject<ASIHTTPRequestDelegate> {
	BOOL sendComplete;
    NSNumber * errorNumValue;                                   //错误码的值
    NSData * resultData;
    NSString * m_urlStr;
    NSString * m_fileDataStr;
    NSString * m_methodNameStr;
    ASIHTTPRequest * request;
}
@property(retain,nonatomic)NSString * m_urlStr;
@property(retain,nonatomic)NSString * m_fileDataStr;
@property(retain,nonatomic)NSString * m_methodNameStr;
@property(retain,nonatomic)ASIHTTPRequest * request;

-(NSData *)getConnectionReturnData:(NSString *) urlStr fileDataStr:(NSString *) fileDataStr methodName:(NSString *) methodNameStr;
-(void)doFail;
-(BOOL)connectedToNetwork;
-(void)doConnectAct;
@end
