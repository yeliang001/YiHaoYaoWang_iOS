//
//  HomeModuleVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomeModuleVO.h"

@implementation HomeModuleVO
@synthesize moduleId;
@synthesize moduleName;
@synthesize moduleIcon;
@synthesize wapUrl;


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:moduleId forKey:@"moduleId"];
    [aCoder encodeObject:moduleName forKey:@"moduleName"];
    [aCoder encodeObject:moduleIcon forKey:@"moduleIcon"];
    [aCoder encodeObject:wapUrl forKey:@"wapUrl"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.moduleId = [aDecoder decodeObjectForKey:@"moduleId"];
    self.moduleName = [aDecoder decodeObjectForKey:@"moduleName"];
    self.moduleIcon = [aDecoder decodeObjectForKey:@"moduleIcon"];
    self.wapUrl = [aDecoder decodeObjectForKey:@"wapUrl"];
    return self;
}

-(void)dealloc
{
    if (moduleId!=nil) {
        [moduleId release];
        moduleId=nil;
    }
    if (moduleName!=nil) {
        [moduleName release];
        moduleName=nil;
    }
    if (moduleIcon!=nil) {
        [moduleIcon release];
        moduleIcon=nil;
    }
    if (wapUrl!=nil) {
        [wapUrl release];
        wapUrl=nil;
    }
    [super dealloc];
}
@end
