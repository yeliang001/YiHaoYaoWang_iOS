//
//  YWSystemService.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-29.
//
//

#import "YWBaseService.h"
@class VersionInfo;
@class ResultInfo;
@interface YWSystemService : YWBaseService

- (VersionInfo *)checkVersion;

- (BOOL)isShowAdultCategory;

- (ResultInfo *)feedBack:(NSDictionary *)param;


@end
