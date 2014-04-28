//
//  Trader.m
//  ProtocolDemo
//
//  Created by vsc on 11-1-20.
//  Copyright 2011 vsc. All rights reserved.
//

#import "Trader.h"
#import "UIDevice+IdentifierAddition.h"

@implementation Trader

@synthesize clientAppVersion;
@synthesize clientSystem;
@synthesize clientTelnetPhone;
@synthesize clientVersion;
@synthesize interfaceVersion;
@synthesize latitude;
@synthesize longitude;
@synthesize protocolStr;
@synthesize provinceId;
@synthesize userToken;
@synthesize serialVersionUID;
@synthesize traderName;
@synthesize traderPassword;
@synthesize unionKey;
@synthesize deviceCode;
@synthesize deviceCodeNotEncrypt;
-(id)init
{
    self = [super init];
    if (self) 
    {
        NSBundle *bundle=[NSBundle mainBundle];
        NSString * appVersion = [NSString stringWithFormat:@"%@",[bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
        
       self.clientAppVersion = [NSString stringWithString:appVersion];
        
        self.clientSystem = @"iPhone";
        self.clientVersion = [NSString stringWithString:systemVersion];
        self.interfaceVersion = @"1.2.5";
        self.protocolStr = @"HTTPXML";
        
        if (ISIPADDEVICE)
        {
            self.clientSystem = @"ipad";
            self.traderName = @"ipadSystem";
            self.traderPassword = @"1HaoP@d";
        }
        else
        {
            self.clientSystem = @"iPhone";
            self.traderName = @"iosSystem";
            self.traderPassword = @"4JanEnE@";
        }
        
        self.unionKey = @"10442025702";		// appstore
        self.deviceCode = [NSString stringWithString:[[UIDevice currentDevice] uniqueDeviceIdentifier]];
        self.deviceCodeNotEncrypt=[NSString stringWithString:[[UIDevice currentDevice] macaddress]];
    }
    return self;
}
-(NSDictionary*)toParamDict{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(clientAppVersion!=nil){
        [dict setObject:clientAppVersion forKey:@"clientAppVersion"];
    }
    if(clientVersion!=nil){
        [dict setObject:clientVersion forKey:@"clientVersion"];
    }
    if(interfaceVersion!=nil){
        [dict setObject:interfaceVersion forKey:@"interfaceVersion"];
    }
    
    if(traderName!=nil){
        [dict setObject:traderName forKey:@"traderName"];
    }
    if(traderPassword!=nil){
        [dict setObject:traderPassword forKey:@"traderPassword"];
    }
    if(unionKey!=nil){
        [dict setObject:unionKey forKey:@"unionKey"];
    }
    if(deviceCode!=nil){
        [dict setObject:deviceCode forKey:@"deviceCode"];
    }

    return [dict autorelease];
}
-(NSString *) toXml {
    NSString * ret = @"<com.yihaodian.mobile.vo.bussiness.Trader>";
    if(clientAppVersion!=nil){
        ret = [ret stringByAppendingFormat:@"<clientAppVersion>%@</clientAppVersion>",clientAppVersion];
    }
    if(clientSystem!=nil){
        ret = [ret stringByAppendingFormat:@"<clientSystem>%@</clientSystem>",clientSystem];
    }
    if(clientTelnetPhone!=nil){
        ret = [ret stringByAppendingFormat:@"<clientTelnetPhone>%@</clientTelnetPhone>",clientTelnetPhone];
    }
    if(clientVersion!=nil){
        ret = [ret stringByAppendingFormat:@"<clientVersion>%@</clientVersion>",clientVersion];
    }
    if(interfaceVersion!=nil){
        ret = [ret stringByAppendingFormat:@"<interfaceVersion>%@</interfaceVersion>",interfaceVersion];
    }
    if(latitude!=nil){
        ret = [ret stringByAppendingFormat:@"<latitude>%.10f</latitude>",[latitude doubleValue]];
    }
    if(longitude!=nil){
        ret = [ret stringByAppendingFormat:@"<longitude>%.10f</longitude>",[longitude doubleValue]];
    }
    if(protocolStr!=nil){
        ret = [ret stringByAppendingFormat:@"<protocol>%@</protocol>",protocolStr];
    }
    if(provinceId!=nil){
        ret = [ret stringByAppendingFormat:@"<provinceId>%@</provinceId>",provinceId];
    }
    if(userToken != nil) {
        ret =[ret stringByAppendingFormat:@"<userToken>%@</userToken>",userToken];
    }
    if(serialVersionUID!=nil){
        ret = [ret stringByAppendingFormat:@"<serialVersionUID>%@</serialVersionUID>",[serialVersionUID stringValue]];
    }
    if(traderName!=nil){
        ret = [ret stringByAppendingFormat:@"<traderName>%@</traderName>",traderName];
    }
    if(traderPassword!=nil){
        ret = [ret stringByAppendingFormat:@"<traderPassword>%@</traderPassword>",traderPassword];
    }
    if(unionKey!=nil){
        ret = [ret stringByAppendingFormat:@"<unionKey>%@</unionKey>",unionKey];
    }
    if(deviceCode!=nil){
        ret = [ret stringByAppendingFormat:@"<deviceCode>%@</deviceCode>",deviceCode];
    }
    if (deviceCodeNotEncrypt!=nil) {
        ret=[ret stringByAppendingFormat:@"<deviceCodeNotEncrypt>%@</deviceCodeNotEncrypt>",deviceCodeNotEncrypt];
    }
    ret = [ret stringByAppendingString:@"</com.yihaodian.mobile.vo.bussiness.Trader>"];
    return ret;
}

-(void)dealloc{
    if(clientAppVersion!=nil){
        [clientAppVersion release];
    }
    if(clientSystem!=nil){
        [clientSystem release];
    }
    if(clientTelnetPhone!=nil){
        [clientTelnetPhone release];
    }
    if(clientVersion!=nil){
        [clientVersion release];
    }
    if(interfaceVersion!=nil){
        [interfaceVersion release];
    }
    if(protocolStr!=nil){
        [protocolStr release];
    }
    if(provinceId!=nil){
        [provinceId release];
    }
    if(userToken != nil){
        [userToken release];
    }
    if(serialVersionUID!=nil){
        [serialVersionUID release];
    }
    if(traderName!=nil){
        [traderName release];
    }
    if(traderPassword!=nil){
        [traderPassword release];
    }
    if(unionKey!=nil){
        [unionKey release];
    }
    if (deviceCode) {
        [deviceCode release];
    }
    if (deviceCodeNotEncrypt!=nil) {
        [deviceCodeNotEncrypt release];
    }
    [super dealloc];
}

@end
