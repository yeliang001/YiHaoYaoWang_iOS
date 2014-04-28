//
//  AlixPayClient.m
//  AliPay
//
//  Created by WenBi on 11-5-16.
//  Copyright 2011 Alipay. All rights reserved.
//

#import <UIKit/UIApplication.h>
#import "AlixPay.h"
#import "JSON.h"
static AlixPay * safepayClient = nil;

#define ALIPAY_SAFEPAY     @"SafePay"
#define ALIPAY_DATASTRING  @"dataString"
#define ALIPAY_SCHEME      @"fromAppUrlScheme"
#define ALIPAY_TYPE        @"requestType"

#pragma mark -
#pragma mark AlixPay
@implementation AlixPay

+ (AlixPay *)shared {
	if (safepayClient == nil) {
		safepayClient = [[AlixPay alloc] init];
	}
	return safepayClient;
}


- (int)pay:(NSString *)orderString applicationScheme:(NSString *)scheme {
	
	int ret = kSPErrorOK;
	NSDictionary * oderParams = [NSDictionary dictionaryWithObjectsAndKeys:
							 orderString,ALIPAY_DATASTRING,
							 scheme, ALIPAY_SCHEME,
							 ALIPAY_SAFEPAY, ALIPAY_TYPE,
							 nil];
	
	//采用SBjson将params转化为json格式的字符串
	SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
	NSString * jsonString = [OderJsonwriter stringWithObject:oderParams];
	[OderJsonwriter release];
    
//  jsonString  = @"{'requestType':'SafePay','dataString':'partner='2088701462230533'&seller='nh@yihaodian.com'&out_trade_no='5626170335'&subject='3'&body='towne'&total_fee='193.0'&notify_url='http://203.110.175.179/online-payment/notify/421/1/1/'&sign='s5GFY6EVNIrHoOqo7%2FFoeXAGDCI9JGJBkH3fzkpXghqBZobOE3tNXRyni2R5%2Fsdpc5sbK5ZTy6hzLFp%2BRyCCemvE9jkSjffb%2FfrMGso2LsILSbvhq21xLBbqfq%2BTx9jEty0WS6kQbP64xNfRC0wulyE0mGCfbZyyz4i6yLpkp0I%3D'&sign_type='RSA','fromAppUrlScheme':'yhd'}";
    
    //将数据拼接成符合alipay规范的Url
    //注意：这里优先接入钱包然后接入快捷支付
	NSString * urlSafypayString = [NSString stringWithFormat:@"safepay://alipayclient/?%@",
                                   [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * urlAlipayString = [NSString stringWithFormat:@"alipay://alipayclient/?%@",
                                  [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURL *safepayUrl = [NSURL URLWithString:urlSafypayString];
    NSURL *alipayUrl = [NSURL URLWithString:urlAlipayString];
	
	//通过打开Url调用快捷支付服务
	//实质上,外部商户只需保证把商品信息拼接成符合规范的字符串转为Url并打开,其余任何函数代码都可以自行优化
	if ([[UIApplication sharedApplication] canOpenURL:alipayUrl]) {
		[[UIApplication sharedApplication] openURL:alipayUrl];
        return ret;
	}
    else if ([[UIApplication sharedApplication] canOpenURL:safepayUrl]) {
		[[UIApplication sharedApplication] openURL:safepayUrl];
        return ret;
	}
	else {
		ret = kSPErrorAlipayClientNotInstalled;
	}
	return ret;
}

//将url数据封装成AlixPayResult使用,允许外部商户自行优化
- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[[AlixPayResult alloc] initWithResultString:query] autorelease];
}

//将安全支付回调url解析数据
- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] isEqualToString:@"safepay"]) {
		result = [self resultFromURL:url];
	}
		
	return result;
}

@end
