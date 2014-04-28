//
//  SpecialRecommendInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-7-17.
//
//  特别推荐的商品或者专题大图  

#import <Foundation/Foundation.h>


typedef enum
{
    kYaoSpecialBrand = 1, //品牌列表
    kYaoSpecialCatagory = 2, //分类列表
    kYaoSpecialProduct = 3 //商品页面
}kYaoSpecialType;


@interface SpecialRecommendInfo : NSObject<NSCoding>

@property (copy, nonatomic) NSString *specialId;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) kYaoSpecialType type;
@property (assign, nonatomic) int sindex;
@property (assign, nonatomic) int specialType;

@property (assign, nonatomic) NSUInteger brandId;   //品牌id
@property (assign, nonatomic) NSUInteger catalogId; //分类id
@property (assign, nonatomic) NSUInteger productId; //商品id

@end
