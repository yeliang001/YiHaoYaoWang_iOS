//
//  BaseService.m
//  TheStoreApp
//
//  Created by LinPan on 13-7-15.
//
//

#import "YWBaseService.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ResponseInfo.h"
#import "NSString+Common.h"
#import "JSONKit.h"
#import "GlobalValue.h"

#define kVenderId @"2011102716210000" //@"2011102716210000"
#define KAppKey @"3452AB32D98C987E798E010D798E010D" //@"3452AB32D98C987E798E010D798E010D"

@implementation YWBaseService



- (void)dealloc
{
    [_httpRequest cancel];
    _httpRequest.delegate = nil;
    [_httpRequest release];
    [super dealloc];
}

//发起请求 ，参数后面定，暂时只传一个接口名
- (ResponseInfo *)startRequestWithMethod:(NSString *)method
{
    
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *urlStr = [self getRequestUrlWithMethod:method];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    DebugLog(@"编码之后的地址 %@",urlStr);
    NSURL *requestURL = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *indexRequest = [ASIHTTPRequest requestWithURL:requestURL];
    
    if (_httpRequest)
    {
        [_httpRequest release];
        _httpRequest = nil;
    }
    _httpRequest = [indexRequest retain];
    [indexRequest setDelegate:self];
    [indexRequest setTimeOutSeconds:30];
    [indexRequest startSynchronous];
    
    if (indexRequest.error)
    {
        DebugLog(@"requestErrorInfo:%@",indexRequest.error);
        ResponseInfo *result = [[ResponseInfo alloc] initWithSuccessfulStatus:NO statusCode:-100 userId:nil description:@"网络异常，请检查网络配置..." data:nil];
        return [result autorelease];
    }
    else
    {
        DebugLog(@"请求返回的最初结果 %@",indexRequest.responseString);
        NSDictionary *responseDic = [self convert2DicFromJson:indexRequest.responseString jsonData:indexRequest.responseData];
        DebugLog(@"responseDic %@",responseDic);
        ResponseInfo *result = [[ResponseInfo alloc] init];
        NSString *isSuccessful = responseDic[@"issuccessful"];
        if ([isSuccessful isEqualToString:@"true"])
        {
            result.isSuccessful = YES;
            result.statusCode = [responseDic[@"statuscode"] intValue];
            result.desc = responseDic[@"description"];
            result.data = responseDic[@"data"];
            result.userId = responseDic[@"userid"];
        }
        else
        {
            result.isSuccessful = NO;
            result.statusCode = [responseDic[@"statusCode"] intValue];
            result.desc = responseDic[@"description"];
            result.data = responseDic[@"data"];
            result.userId = nil;
        }
        
        return [result autorelease];
    }

}



- (ResponseInfo *)startRequestWithMethod:(NSString *)method param:(NSDictionary *)aParam
{
    
    
    NSString *urlStr = [self getRequestUrlWithMethod:method];

    NSURL *requestURL = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *indexRequest = [ASIFormDataRequest requestWithURL:requestURL];
    
    if (_httpRequest)
    {
        [_httpRequest release];
        _httpRequest = nil;
    }
    _httpRequest = [indexRequest retain];
    
    for (NSString *key in [aParam allKeys])
    {
        [indexRequest addPostValue:aParam[key] forKey:key];
        DebugLog(@"key:%@ value:%@",key,aParam[key]);
    }
    
    [indexRequest setDelegate:self];
    [indexRequest setTimeOutSeconds:30];
    [indexRequest startSynchronous];
    
    if (indexRequest.error)
    {
        DebugLog(@"requestErrorInfo:%@",indexRequest.error);
        ResponseInfo *result = [[ResponseInfo alloc] initWithSuccessfulStatus:NO statusCode:-100 userId:nil description:@"网络异常，请检查网络配置..." data:nil];
        return [result autorelease];
    }
    else
    {
        DebugLog(@"请求返回的最初结果 %@",indexRequest.responseString);
        NSDictionary *responseDic = [self convert2DicFromJson:indexRequest.responseString jsonData:indexRequest.responseData];
        DebugLog(@"responseDic %@",responseDic);
        ResponseInfo *result = [[ResponseInfo alloc] init];
        NSString *isSuccessful = responseDic[@"issuccessful"];
        if ([isSuccessful isEqualToString:@"true"])
        {
            result.isSuccessful = YES;
            result.statusCode = [responseDic[@"statuscode"] intValue];
            result.desc = responseDic[@"description"];
            result.data = responseDic[@"data"];
            result.userId = responseDic[@"userid"];
        }
        else
        {
            result.isSuccessful = NO;
            result.statusCode = [responseDic[@"statuscode"] intValue];
            result.desc = responseDic[@"description"];
            result.data = responseDic[@"data"];;
            result.userId = nil;
        }
        return [result autorelease];
    }
}


- (NSString *)getRequestUrlWithMethod:(NSString *)method
{
    NSString *timeReq = [NSString stringWithDate:[NSDate date] formater:@"yyyyMMddHHmmss"];
    NSString *unCodedSign = [NSString stringWithFormat:@"os=iphone&timestamp=%@&appkey=%@",timeReq,KAppKey];
    DebugLog(@"unCodedSign %@",unCodedSign);
    NSString *sign = [unCodedSign md5HexDigest];
    DebugLog(@"codedSign %@",sign);
//测试服务器
    NSString *ceshiUrlString = [NSString stringWithFormat:@"http://192.168.89.18:19121/ApiControl?sign=%@&timestamp=%@&os=iphone&venderId=%@&method=%@&signMethod=md5&format=json&type=mobile",sign,timeReq,kVenderId,method];
//李丽服务器
    NSString *liLiUrlString = [NSString stringWithFormat:@"http://192.168.90.108/mobile-web/ApiControl?sign=%@&timestamp=%@&os=iphone&venderId=%@&method=%@&signMethod=md5&format=json&type=mobile",sign,timeReq,kVenderId,method];
//生产服务器 mobi.111.com.cn  ip = 101.226.186.3:8080
    NSString *urlString = [NSString stringWithFormat:@"http://mobi.111.com.cn/ApiControl?sign=%@&timestamp=%@&os=iphone&venderId=%@&method=%@&signMethod=md5&format=json&type=mobile",sign,timeReq,kVenderId,method/*,[GlobalValue getGlobalValueInstance].provinceId*/];
//预生产
    NSString *preUrlString = [NSString stringWithFormat:@"http://101.226.186.59/ApiControl?sign=%@&timestamp=%@&os=iphone&venderId=%@&method=%@&signMethod=md5&format=json&type=mobile",sign,timeReq,kVenderId,method/*,[GlobalValue getGlobalValueInstance].provinceId*/];

    if ([GlobalValue getGlobalValueInstance].hostIndex == 0)
    {
        //0－>生产服务器
        DebugLog(@"URL-> %@",urlString);
        return urlString;
    }
    else if ([GlobalValue getGlobalValueInstance].hostIndex == 1)
    {
        DebugLog(@"URL-> %@",ceshiUrlString);
        return ceshiUrlString;
    }
    else if ([GlobalValue getGlobalValueInstance].hostIndex == 2)
    {
        DebugLog(@"URL-> %@",liLiUrlString);
        return liLiUrlString;
    }
    else if ([GlobalValue getGlobalValueInstance].hostIndex == 3)
    {
        return preUrlString;
    }
    
    return urlString;
}

- (NSDictionary *)convert2DicFromJson:(NSString *)json jsonData:(NSData *)jsonData
{
    json = [json stringByReplacingOccurrencesOfString:@"NaN" withString:@"0"];
//    json = [json stringByReplacingOccurrencesOfString:@"\"null\"" withString:@"null"];

//    json = [json stringByReplacingOccurrencesOfString:@"null" withString:@"0"];

//    json = [json stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];

    
    NSLog(@"过滤一些问题字符之后的json: \n%@",json);
    
    NSData *responseDate = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [responseDate objectFromJSONData];
    return  resultDict;
}

- (NSString *)convertParam2String:(NSDictionary *)dic
{
    NSString *resultStr = @"";
    for (NSString *key in [dic allKeys])
    {
        resultStr = [resultStr stringByAppendingFormat:@"&%@=%@",key,dic[key]];
    }
    return  resultStr;
}

//
// "attribute": "null,西药,胶凝",
//     "brandFacet": "967997_康瑞保__4_0_null",



@end
