//
//  Page.m
//  ProtocolDemo
//
//  Created by vsc on 11-1-30.
//  Copyright 2011 vsc. All rights reserved.
//

#import "Page.h"


@implementation Page

@synthesize currentPage;
@synthesize objList;
@synthesize pageSize;
@synthesize totalSize;
@synthesize userInfo = _userInfo;

- (id)init
{
    self = [super init];
    if (self) {
        _userInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:currentPage forKey:@"currentPage"];
    [aCoder encodeObject:objList forKey:@"objList"];
    [aCoder encodeObject:pageSize forKey:@"pageSize"];
    [aCoder encodeObject:totalSize forKey:@"totalSize"];
    [aCoder encodeObject:_userInfo forKey:@"userInfo"];
    [aCoder encodeObject:_adFloorList forKey:@"adFloorList"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.currentPage = [aDecoder decodeObjectForKey:@"currentPage"];
    self.objList = [aDecoder decodeObjectForKey:@"objList"];
    self.pageSize = [aDecoder decodeObjectForKey:@"pageSize"];
    self.totalSize = [aDecoder decodeObjectForKey:@"totalSize"];
    self.userInfo = [aDecoder decodeObjectForKey:@"userInfo"];
    self.adFloorList = [aDecoder decodeObjectForKey:@"adFloorList"];
    return self;
}
-(void)dealloc{
    if(currentPage!=nil){
        [currentPage release];
    }
    if(objList!=nil){
        [objList release];
    }
    if(pageSize!=nil){
        [pageSize release];
    }
    if(totalSize!=nil){
        [totalSize release];
    }
    
    [_userInfo release];
    [_adFloorList release];
    [super dealloc];
}


-(NSString*)description
{
    NSMutableString *des = [NSMutableString string];
    
    [des appendFormat:@"\n<%s : 0X%lx>\n", class_getName([self class]), (unsigned long)self];
    
    [des appendFormat:@"currentPage : %@\n", currentPage];
    [des appendFormat:@"pageSize : %@\n", pageSize];
    [des appendFormat:@"totalSize : %@\n", totalSize];
    [des appendFormat:@"objList : %@\n", objList];
    [des appendFormat:@"adFloorList : %@\n", _adFloorList];
    
    return des;
}

@end
