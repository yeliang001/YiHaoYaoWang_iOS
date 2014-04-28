//
//  GrouponOrderVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GoodReceiver.h"
#import "GrouponVO.h"
#import "UserVO.h"
#import "OrderV2.h"

@interface GrouponOrderVO : NSObject {
@private GrouponVO *grouponVO;//团购信息
@private UserVO *userVO;//用户信息
@private NSArray *pmVOList;//支付方式信息
@private OrderV2 *orderVO;//订单信息
@private NSString *hasError;//是否有校验错误
@private NSString *errorInfo;//错误提示信息
}

@property(nonatomic,retain) GrouponVO *grouponVO;
@property(nonatomic,retain) UserVO *userVO;
@property(nonatomic,retain) NSArray *pmVOList;
@property(nonatomic,retain) OrderV2 *orderVO;
@property(nonatomic,retain) NSString *hasError;
@property(nonatomic,retain) NSString *errorInfo;
@end
