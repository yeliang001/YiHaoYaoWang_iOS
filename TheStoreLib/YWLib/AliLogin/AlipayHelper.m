//
//  AlipayHelper.m
//  TheStoreApp
//
//  Created by LinPan on 13-12-25.
//
//

#import "AlipayHelper.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixLibService.h"
#import "YWConst.h"

@implementation AlipayHelper

- (void)loginByAlipay:(SEL)callback
{
    NSString* orderInfo = [self getYaoWangOrderInfo]; //[self getOrderInfo:indexPath.row];
    NSString* signedStr = [self doRsa:orderInfo];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderInfo, signedStr, @"RSA"];
	
    [AlixLibService payOrder:orderString AndScheme: KYaoSchemeURL seletor:nil target:self];
}

- (NSString *)getYaoWangOrderInfo
{
    NSString *info = [NSString stringWithFormat:@"app_name=\"mc\"&biz_type=\"trust_login\"&partner=\"%@\"&app_id=\"%@\"&notify_url=\"%@\"",PartnerID,AliAppID,AliNotifyURL];
    
    return info;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}
@end
