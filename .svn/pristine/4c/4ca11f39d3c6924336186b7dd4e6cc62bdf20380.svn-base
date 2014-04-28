//
//  GrouponVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductVO.h"
#import "GrouponSerialVO.h"

@interface GrouponVO : NSObject <NSCoding>{
@private NSNumber *nid;//团购id
@private NSString *name;//团购名称
@private NSNumber *categoryId;//团购分类id 101:掌上专享
@private NSString *startTime;//开始时间
@private NSString *endTime;//结束时间
@private NSNumber *productId;//商品id
@private NSNumber *merchantId;//商家id
@private NSNumber *price;//团购价格
@private NSNumber *discount;//折扣
@private NSNumber *saveCost;//节省
@private NSNumber *areaId;//地区id
@private NSNumber *remainTime;//团购剩余时间
@private NSNumber *productNumber;//团购商品数量
@private NSNumber *peopleLower;//团购下限
@private NSNumber *peopleUpper;//团购上限
@private NSNumber *limitLower;//团购商品下限
@private NSNumber *limitUpper;//团购商品上限
@private NSString *miniImageUrl;//团购首页图片
@private NSString *middleImageUrl;//团购详情页图片
@private NSString *sellingPoint;//团购卖点
@private NSString *prompt;//团购提示
@private NSNumber *status;//团购状态 0初始化 100团购中 101团购中-成功 102团购中-人数满 200结束-失败 201结束-成功 202可转DO
@private NSNumber *peopleNumber;//实际参团人数
@private NSString *type;//团购类型 -1历史 0当期 1将来
@private NSString *remarkerPrompt;//团购购买备注的提示信息
@private NSNumber *isGrouponSerial;//是否为系列产品 1是 0否
@private NSNumber *siteType;//0为全部站点，1为1号店，2为1号商场
@private GrouponSerialVO *grouponSerialVO;//系列产品信息
@private NSArray *grouponSerials;//团购系列商品列表
@private NSArray *colorList;//系列产品所有颜色属性集合
@private NSArray *sizeList;//系列产品所有尺寸属性集合
@private NSString *mallURL;//一号商城团购地址
@private ProductVO *productVO;
}
@property(nonatomic,retain) NSNumber *nid;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSNumber *categoryId;
@property(nonatomic,retain) NSString *startTime;
@property(nonatomic,retain) NSString *endTime;
@property(nonatomic,retain) NSNumber *productId;
@property(nonatomic,retain) NSNumber *siteType;
@property(nonatomic,retain) NSNumber *merchantId;
@property(nonatomic,retain) NSNumber *price;
@property(nonatomic,retain) NSNumber *discount;
@property(nonatomic,retain) NSNumber *saveCost;
@property(nonatomic,retain) NSNumber *areaId;
@property(nonatomic,retain) NSNumber *remainTime;
@property(nonatomic,retain) NSNumber *productNumber;
@property(nonatomic,retain) NSNumber *peopleLower;
@property(nonatomic,retain) NSNumber *peopleUpper;
@property(nonatomic,retain) NSNumber *limitLower;
@property(nonatomic,retain) NSNumber *limitUpper;
@property(nonatomic,retain) NSString *miniImageUrl;
@property(nonatomic,retain) NSString *middleImageUrl;
@property(nonatomic,retain) NSString *sellingPoint;
@property(nonatomic,retain) NSString *prompt;
@property(nonatomic,retain) NSNumber *status;
@property(nonatomic,retain) NSNumber *peopleNumber;
@property(nonatomic,retain) NSString *type;
@property(nonatomic,retain) NSString *remarkerPrompt;
@property(nonatomic,retain) NSNumber *isGrouponSerial;
@property(nonatomic,retain) GrouponSerialVO *grouponSerialVO;
@property(nonatomic,retain) NSArray *grouponSerials;
@property(nonatomic,retain) NSArray *colorList;
@property(nonatomic,retain) NSArray *sizeList;
@property(nonatomic,retain) NSString *mallURL;
@property(nonatomic,retain) ProductVO *productVO;

-(NSMutableDictionary *)dictionaryFromVO;
+(id)voFromDictionary:(NSMutableDictionary *)mDictionary;
@end
