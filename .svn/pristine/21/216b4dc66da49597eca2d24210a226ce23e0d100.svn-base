//
//  GpsUtil.m
//  TheStoreApp
//
//  Created by towne on 13-3-4.
//
//
#import "GPSUtil.h"
#import "GlobalValue.h"
#import "ProvinceVO.h"
#import "Reachability.h"
#import "OTSServiceHelper.h"
#import "OTSUtility.h"

@implementation GPSUtil
@synthesize provinceVO;
@synthesize gpsProvinceVO;

#pragma mark - singleton methods
static GPSUtil *sharedInstance = nil;


-(NSDictionary *)getProvinceDic
{
    NSString *path=[[NSBundle mainBundle]resourcePath];
    NSString *filename=[path stringByAppendingPathComponent:@"ProvinceID.plist"];
    NSDictionary* provinceDic=[[NSDictionary alloc] initWithContentsOfFile:filename];
    return [provinceDic autorelease];
}

-(void)saveProvinceDic:(NSDictionary *)LocalProDic
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"ProvinceID.plist"];
    [LocalProDic writeToFile:filename  atomically:NO];
}


-(NSString *)getProvinceFromPlist
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"SaveProvinceId.plist"];
    NSMutableArray *userArray=[NSMutableArray arrayWithContentsOfFile:filename];
    return [userArray objectAtIndex:0];
}

-(void)saveProvinceToPlist:(NSMutableArray *) userArray
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"SaveProvinceId.plist"];
    [userArray writeToFile:filename  atomically:NO];
}


-(void)extraInit
{
    __block NSArray * __tempArray = nil;
    
    [self performInThreadBlock:^(){
        
        __tempArray = [[[OTSServiceHelper sharedInstance] getAllProvince:[GlobalValue getGlobalValueInstance].trader] retain];
        
    } completionInMainBlock:^(){
        
        NSMutableDictionary *ProvinceID_D = [NSMutableDictionary dictionary];
        for (int i=0; i<[__tempArray count]; i++) {
            ProvinceVO *pvo =  [OTSUtility safeObjectAtIndex:i inArray:__tempArray];
            [ProvinceID_D setValue:pvo.nid forKey:pvo.provinceName];
        }
        self.provinceVO = [[[ProvinceVO alloc] init] autorelease];
        NSString     *localPro = [self getProvinceFromPlist];
        if (localPro) {
            provinceVO.provinceName = localPro;
            provinceVO.nid = [ProvinceID_D objectForKey:localPro];
        }
        else
        {
            provinceVO.provinceName = @"上海";
            provinceVO.nid = [NSNumber numberWithInt:1];
        }
        [GlobalValue getGlobalValueInstance].provinceId = provinceVO.nid;
        [self saveProvinceDic:ProvinceID_D];
        [__tempArray release];
    }];
}



#pragma mark - // 检查网络状态
+(NSString *)checkNetWorkType{
    // 检查网络状态
	NSString *netType = nil;
	Reachability *r = [Reachability reachabilityWithHostName:@"interface.m.yihaodian.com"];
    switch ([r currentReachabilityStatus]) {
		case NotReachable:
			// 没有网络连接
			netType = @"no";
			break;
		case ReachableViaWWAN:
			// 使用3G网络
			netType = @"3G";
			break;
		case ReachableViaWiFi:
			// 使用WiFi网络
			netType = @"WiFi";
			break;
    }
	//DebugLog(@"netType:%@",netType);
    return netType;
}

+ (GPSUtil *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
            
//            [sharedInstance extraInit];
        }
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
}

- (id)autorelease
{
    return self;
}

@end
