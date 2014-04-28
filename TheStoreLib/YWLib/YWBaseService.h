//
//  BaseService.h
//  TheStoreApp
//
//  Created by LinPan on 13-7-15.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@class ResponseInfo;
@interface YWBaseService : NSObject
{
    ASIHTTPRequest *_httpRequest;
}

- (ResponseInfo *)startRequestWithMethod:(NSString *)method;
- (NSString *)convertParam2String:(NSDictionary *)dic;
- (ResponseInfo *)startRequestWithMethod:(NSString *)method param:(NSDictionary *)aParam;
@end


