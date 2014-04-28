//
//  YWSystemService.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-29.
//
//

#import "YWSystemService.h"
#import "ResponseInfo.h"
#import "VersionInfo.h"
#import "ResultInfo.h"
@implementation YWSystemService


- (VersionInfo *)checkVersion
{
    ResponseInfo *response = [self startRequestWithMethod:@"sys.version.get"];
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        
        if ([dataDic[@"result"] intValue] == 1)
        {
            VersionInfo *version = [[VersionInfo alloc] init];
            version.miniVersion = [dataDic[@"miniversion"] intValue];
            version.version = [dataDic[@"version"] intValue];
            version.versionStr = dataDic[@"versionstr"];
            version.updateUrl = dataDic[@"updateurl"];
            version.versionDesc = dataDic[@"versiondesc"];
            
            return [version autorelease];
        }
    }
    
    return nil;
}


- (BOOL)isShowAdultCategory
{
    ResponseInfo *response = [self startRequestWithMethod:@"adult.articles.get"];
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        
        if ([dataDic[@"result"] intValue] == 1)
        {
            NSInteger isShow = [dataDic[@"isOpenAdultArticles"] intValue];
            if (isShow == 1)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    
    return NO;
}


- (ResultInfo *)feedBack:(NSDictionary *)param
{
    ResponseInfo *response = [self startRequestWithMethod:@"get.feedback" param:param];
    ResultInfo *result = [[ResultInfo alloc] init];
    result.bRequestStatus = response.isSuccessful;
    result.responseCode = response.statusCode;
    
    NSDictionary *dataDic = response.data;
    result.resultCode = [dataDic[@"result"] intValue];
    return result;
}

@end
