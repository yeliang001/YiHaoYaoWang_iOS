//
//  HotPointNewVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotPointNewVO : NSObject <NSCoding>{
@private
    NSNumber *nid;//热销活动id
    NSString *title;//热销活动名称
    NSString *subtitle;//活动副标题
    NSString *detailUrl;//热销活动地址
    NSNumber *type;//热销活动类型：0-热销商品；1- 热销活动 ；2- 市场活动规则；3-绑定团购；4新热销活动；5-热门促销(n元N件等促销活动)；6-热门促销(赠品、满减等促销活动)
    NSNumber *promotionId; //促销活动Id
    NSNumber *promotionLevelId;// 促销级别Id
    NSString *picUrl;//轮播图片
    NSString *logoPicUrl;//活动logo图片
    NSString *topicId;//活动topicId
    NSArray *productVOList;//商品列表(若为热销商品时返回)
    NSArray *grouponVOList;//团购列表(若为绑定团购时返回)
    NSNumber *ipadPicType;//ipad轮播图类型 0-长形图，1-方形图
}

@property(nonatomic,retain) NSNumber *nid;//热销活动id
@property(nonatomic,retain) NSString *title;//热销活动名称
@property(nonatomic,retain) NSString *subtitle;//活动副标题
@property(nonatomic,retain) NSString *detailUrl;//热销活动地址
@property(nonatomic,retain) NSNumber *type;//热销活动类型：0-热销商品；1- 热销活动 ；2- 市场活动规则；3-绑定团购；4新热销活动；5-热门促销(n元N件等促销活动)；6-热门促销(赠品、满减等促销活动)
@property(nonatomic,retain) NSNumber *promotionId;//促销活动Id
@property(nonatomic,retain) NSNumber *promotionLevelId;//促销级别Id
@property(nonatomic,retain) NSString *picUrl;//轮播图片
@property(nonatomic,retain) NSString *logoPicUrl;//活动logo图片
@property(nonatomic,retain) NSString *topicId;//活动topicId
@property(nonatomic,retain) NSArray *productVOList;//商品列表(若为热销商品时返回)
@property(nonatomic,retain) NSArray *grouponVOList;//团购列表(若为绑定团购时返回)
@property(nonatomic,retain) NSNumber *ipadPicType;//ipad轮播图类型 0-长形图，1-方形图

-(NSMutableDictionary *)dictionaryFromVO;
+(id)voFromDictionary:(NSMutableDictionary *)mDictionary;
@end
