//
//  SearchParameterVO.h
//  TheStoreApp
//
//  Created by towne on 12-11-27.
//
//

#import <Foundation/Foundation.h>

@interface SearchParameterVO : NSObject
{
 @private
    NSString *keyword;              //搜索关键字，""表示无
    NSNumber *categoryId;           //categoryId 分类id，0表示全部分类
    NSNumber *brandId;              //品牌id，0表示无
    NSString *attributes;           //导购属性，""表示无，多个导购属性用,隔开
    NSString *priceRange;           //priceRange 价格区间，""表示无，"10,100"表示10到100元，"10,"表示大于10，",100"表示小于100
    NSString *filter;               //"0"表示无，"01"表示促销，"02"表示有赠品，"03"表示新品，"012"表示促销、有赠品，"023"表示有赠品、新品，"013"表示促销、新品，"0123"表示促销、有赠品、新品
    NSNumber *sortType;             //0:不排序,1:按相关性排序,2:按销量倒序,3:按价格升序,4:按价格倒序,5:按好评度倒序,6:按上架时间倒序
    NSNumber *promotionId;          //促销活动Id
    NSNumber *promotionLevelId;     //促销活动级别级别Id
}
@property(nonatomic,retain)NSString *keyword;
@property(nonatomic,retain)NSNumber *categoryId;
@property(nonatomic,retain)NSNumber *brandId;
@property(nonatomic,retain)NSString *attributes;
@property(nonatomic,retain)NSString *priceRange;
@property(nonatomic,retain)NSString *filter;
@property(nonatomic,retain)NSNumber *sortType;
@property(nonatomic,retain)NSNumber *promotionId;
@property(nonatomic,retain)NSNumber *promotionLevelId;

-(NSString *)toXML;

@end
