//
//  RockGameVO.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import "RockGameVO.h"
#import "OTSBaseServiceResult.h"

@implementation RockGameVO
@synthesize nid = _nid;
@synthesize userId = _userId;
@synthesize gameStatus = _gameStatus;
@synthesize createTime = _createTime;
@synthesize updateTime = _updateTime;
@synthesize commonRockResultVO = _commonRockResultVO;
@synthesize rockGameProdList = _rockGameProdList;
@synthesize couponNum=_couponNum;
- (void)dealloc
{
    [_couponNum release];
    [_nid release];
    [_userId release];
    [_gameStatus release];
    [_createTime release];
    [_updateTime release];
    [_commonRockResultVO release];
    [_rockGameProdList release];
    
    [super dealloc];
}


-(OTSRockGameStatus)getStatus
{
    return [self.gameStatus intValue];
}

-(NSString*)description
{
    NSMutableString *des = [NSMutableString string];
    
    [des appendFormat:@"\n<%s : 0X%lx>\n", class_getName([self class]), (unsigned long)self];
    
    [des appendFormat:@"_nid : %@\n", _nid];
    [des appendFormat:@"_userId : %@\n", _userId];
    [des appendFormat:@"_gameStatus : %@\n", _gameStatus];
    [des appendFormat:@"_createTime : %@\n", _createTime];
    [des appendFormat:@"_updateTime : %@\n", _updateTime];
    [des appendFormat:@"_rockGameProdList : %@\n", _rockGameProdList];
    
    return des;
}

@end
