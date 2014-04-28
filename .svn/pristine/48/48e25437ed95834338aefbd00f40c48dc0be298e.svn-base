//
//  OTSSecurityValidateService.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSSecurityValidateService.h"
#import "SendValidCodeResult.h"
#import "CheckSmsResult.h"
#import "PayService.h"
#import "GlobalValue.h"

@implementation OTSSecurityValidateService
@synthesize sendValidCodeResult, checkSmsResult;

-(SendValidCodeResult*)requestSendValidateCodeToPhone:(NSString*)aPhoneNumber
{
#if defined (OTS_SECURITY_VALIDATE_SERVICE_TESTMODE)
    self.sendValidCodeResult = [[[SendValidCodeResult alloc] init] autorelease];
    sendValidCodeResult.resultCode = [NSNumber numberWithInt:1];
    sleep(2);
#else
    PayService* payService = [[[PayService alloc] init] autorelease];
    self.sendValidCodeResult = [payService sendValidCodeToUserBindMobile:[GlobalValue getGlobalValueInstance].token mobile:aPhoneNumber];
#endif
    
    return sendValidCodeResult;
}

-(CheckSmsResult*)requestCheckValidateCode:(NSString*)aValidateCode
{
#if defined (OTS_SECURITY_VALIDATE_SERVICE_TESTMODE)
    self.checkSmsResult = [[[CheckSmsResult alloc] init] autorelease];
    checkSmsResult.resultCode = [NSNumber numberWithInt:1];
    sleep(2);
#else
    PayService* payService = [[[PayService alloc] init] autorelease];
    self.checkSmsResult = [payService checkSms:[GlobalValue getGlobalValueInstance].token validCode:aValidateCode];
#endif
    
    return checkSmsResult;
}

@end
