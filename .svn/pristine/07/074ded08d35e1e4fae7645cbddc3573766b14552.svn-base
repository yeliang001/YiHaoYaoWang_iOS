//
//  InterfaceResult.h
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import <Foundation/Foundation.h>

@interface NormResult : NSObject{
@private
    NSNumber     *resultCode;
    NSString     *errorInfo;
}
@property(nonatomic, retain)NSNumber      *resultCode;
@property(nonatomic, retain)NSString      *errorInfo;

@end

//*添加或删除n元n件活动到购物车结果
@interface AddOrDeletePromotionResult : NormResult
@end

//*购物车中是否存在指定的n元n件活动结果实体
@interface ExistOptionalResult : NormResult
@end

//*替换活动结构实体
@interface UpadtePromotionResult : NormResult

@end