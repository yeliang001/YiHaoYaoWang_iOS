//
//  URLSchemeForPad.m
//  TheStoreApp
//
//  Created by towne on 13-5-7.
//
//

#import "URLSchemeForPad.h"
#import "AlixPayResult.h"
#import "GlobalValue.h"

#define ALIXPAYOK     1
#define ALIXPAYERROR  2


@interface URLSchemeForPad ()
@property(nonatomic)BOOL isNeedChangeProvince;
@end

@implementation URLSchemeForPad
static URLSchemeForPad* scheme;

+(id)sharedScheme{
    @synchronized(self){
        if (scheme==nil) {
            scheme=[[self alloc] init];
        }
    }
    return scheme;
}
-(void)parseWithURL:(NSURL*)url{
    NSArray* components = [[[url absoluteString] substringFromIndex:8] componentsSeparatedByString:@"/"];
    if (components.count > 0) {
        NSString* typeStr = [OTSUtility safeObjectAtIndex:0 inArray:components];
        pramaArr = [[OTSUtility safeObjectAtIndex:1 inArray:components] componentsSeparatedByString:@"_"]; 
        if ([typeStr isEqualToString:@"safepay"]){
            urlType = EURLtype_PadAlixPay;
            [self enterSafePayDeal:url];
        }
        else{
            NSLog(@"typeStr is: %@      NO NONONONONONONONONONONONONONONONONO NONONONONONONONONONONONONONONONONO NONONONONONONONONONONONONONONONO",typeStr);
        }
    }
    
}

#pragma mark - entrances function
-(void)enterSafePayDeal:(NSURL*)url {
    
    AlixPayResult *  result = [self resultFromURL:url];
    if (result) {
        //是否支付成功
        if (9000 == result.statusCode) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"needUpdateMyStoreforCheckOrderStatusHD" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"needUpdateListSucceedStatusHD" object:self userInfo:nil];  
        }
        //如果支付失败,可以通过result.statusCode查询错误码
        else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:result.statusMessage
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            alertView.tag = ALIXPAYERROR;
            [alertView show];
            [alertView release];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == ALIXPAYERROR) {
        SharedPadDelegate.isGpsAlertDisAble = NO;
	}
}

//将url数据封装成AlixPayResult使用,允许外部商户自行优化
- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[[AlixPayResult alloc] initWithResultString:query] autorelease];
}

@end
