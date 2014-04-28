//
//  OTSBaseServiceResult.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-2.
//
//

#import "OTSBaseServiceResult.h"

@implementation OTSBaseServiceResult
@synthesize resultCode = _resultCode;
@synthesize errorInfo = _errorInfo;


- (void)dealloc
{
    [_resultCode release];
    [_errorInfo release];
    
    [super dealloc];
}


-(BOOL)isSuccess
{
    return [self.resultCode boolValue];
}

-(NSString*)description
{
    NSMutableString *des = [NSMutableString string];
    
    [des appendFormat:@"\n<%s : 0X%lx>\n", class_getName([self class]), (unsigned long)self];
    
    [des appendFormat:@"_resultCode : %@\n", _resultCode];
    [des appendFormat:@"_errorInfo : %@\n", _errorInfo];
    
    return des;
}

@end

@implementation PushMappingResult
@end
@implementation CommonRockResultVO


//<com.yihaodian.mobile.vo.promotion.RockGameVO>
//<commonRockResultVO>
//<resultCode>-101</resultCode>
//<errorInfo>该用户还没有开启游戏</errorInfo>
//</commonRockResultVO>
//</com.yihaodian.mobile.vo.promotion.RockGameVO>

-(BOOL)isSuccess
{
//成功条件还未给出，这里假定
    return [self.resultCode intValue] != -101;
}

@end



// 判断摇出的商品是否未结算
@implementation CheckRockResultResult

-(BOOL)isSuccess
{
    return [self.resultCode intValue] == kWrCheckRockResultOK;
}
@end


// 通过活动Id添加抵用券到用户
@implementation AddCouponByActivityIdResult

-(BOOL)isSuccess
{
    return [self.resultCode intValue] == kWrAddCouponResultSuccess;
}

@end


// 添加商品或抵用券到我的寄存箱
@implementation AddStorageBoxResult
@end

@implementation InviteeResult
@end
