//
//  OTSGpsHelper.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-26.
//
//

#import "OTSGpsHelper.h"
#import "DataHandler.h"
#import "ProvinceVO.h"
#import "GlobalValue.h"

@implementation OTSGpsHelper
@synthesize provinceVO = _provinceVO;
@synthesize gpsProvinceVO = _gpsProvinceVO;

#pragma mark - singleton methods
static OTSGpsHelper *sharedInstance = nil;

-(NSDictionary*)provinceNameValueDic
{
    NSString* rootPath = [[NSBundle mainBundle] resourcePath];
    NSString* path = [rootPath stringByAppendingPathComponent:@"ProvinceID.plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

-(NSString*)provinceSavePath
{
    return [[DataHandler sharedDataHandler] dataFilePath:@"set.plist"];
}

-(NSDictionary*)provinceSetDic
{
    NSString *setPath = [self provinceSavePath];
    return [NSDictionary dictionaryWithContentsOfFile:setPath];
}

-(void)saveProvince
{
    [self saveProvince:self.provinceVO];
}

-(void)saveProvince:(ProvinceVO*)aProvinceVO
{
    self.provinceVO = aProvinceVO;
    
    if (aProvinceVO)
    {
        [self saveProvinceWithName:aProvinceVO.provinceName provinceID:aProvinceVO.nid];
    }
}

-(void)saveProvinceWithName:(NSString*)aProvinceName provinceID:(NSNumber*)aProvinceID
{
    if (aProvinceID && aProvinceName)
    {
        NSDictionary *proviceDic = [NSDictionary dictionaryWithObjectsAndKeys:aProvinceName, @"provincename"
                                    ,aProvinceID ,@"provinceid"
                                    , nil];
        [proviceDic writeToFile:[self provinceSavePath] atomically:YES];
    }
}

-(void)extraInit
{
    ProvinceVO *provinceVO = [[ProvinceVO alloc] init];
    NSDictionary *settingDic = [self provinceSetDic];
    if (settingDic)
    {
        provinceVO.provinceName = [settingDic objectForKey:@"provincename"];
        provinceVO.nid = [settingDic objectForKey:@"provinceid"];
    }
    else
    {
        provinceVO.provinceName = @"上海";
        provinceVO.nid = [NSNumber numberWithInt:1];
    }
    _provinceVO = provinceVO;
    
    [GlobalValue getGlobalValueInstance].provinceId = _provinceVO.nid;
}

+ (OTSGpsHelper *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
            
            [sharedInstance extraInit];
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
