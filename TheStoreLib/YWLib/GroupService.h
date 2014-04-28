//
//  GroupService.h
//  TheStoreApp
//
//  Created by LinPan on 13-12-23.
//
//

#import "YWBaseService.h"
@class ResultInfo;
@interface GroupService : YWBaseService


- (ResultInfo *)getGroupList:(NSDictionary *)dic;

@end
