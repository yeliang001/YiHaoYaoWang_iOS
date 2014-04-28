//
//  HotPointVO.h
//  TheStoreApp
//
//  Created by linyy on 11-6-22.
//  Copyright 2011年 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductVO;

@interface HotPointVO : NSObject {
    NSString * detailUrl;//获取活动详细链接
    ProductVO *	hotProduct;//获取热销商品对象
    NSString * title;//获取活动主题
    NSNumber * type;//获取热点类型 (0:热销商品 1：热销活动 2：市场活动规则 3:绑定团购)
}
@property(retain,nonatomic)NSString * detailUrl;
@property(retain,nonatomic)ProductVO * hotProduct;
@property(retain,nonatomic)NSString * title;
@property(retain,nonatomic)NSNumber * type;

@end
