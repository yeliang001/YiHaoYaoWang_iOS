//
//  InterfaceResult.m
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import "NormResult.h"

@implementation NormResult
@synthesize resultCode,errorInfo;

-(void)dealloc{
    
    
    [resultCode release];
    [errorInfo release];
    
    [super dealloc];
}

@end

//*添加或删除n元n件活动到购物车结果
@implementation AddOrDeletePromotionResult
@end

//*购物车中是否存在指定的n元n件活动结果实体
@implementation ExistOptionalResult
@end

//*替换活动结构实体
@implementation UpadtePromotionResult
@end
