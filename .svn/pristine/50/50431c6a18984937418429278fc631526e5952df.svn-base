//
//  OTSSecurityValidateService.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SendValidCodeResult;
@class CheckSmsResult;

@interface OTSSecurityValidateService : NSObject
{
    SendValidCodeResult     *sendValidCodeResult;
    CheckSmsResult          *checkSmsResult;
}
@property(retain)SendValidCodeResult     *sendValidCodeResult;
@property(retain)CheckSmsResult          *checkSmsResult;

-(SendValidCodeResult*)requestSendValidateCodeToPhone:(NSString*)aPhoneNumber;
-(CheckSmsResult*)requestCheckValidateCode:(NSString*)aValidateCode;
@end


//#define OTS_SECURITY_VALIDATE_SERVICE_TESTMODE