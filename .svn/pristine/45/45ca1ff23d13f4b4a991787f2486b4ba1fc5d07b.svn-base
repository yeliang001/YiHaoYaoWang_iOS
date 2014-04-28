//
//  URLScheme.h
//  TheStoreApp
//
//  Created by xuexiang on 13-4-10.
//
//

#import <Foundation/Foundation.h>

typedef enum _URLType{
    EURLType_CMS = 0,
    EURLtype_Product,
    EURLtype_Goupon,
    EURLtype_RockBuy,
    EURLtype_Search,
    EURLtype_PromoFree,
    EURLtype_PromoNN,
    EURLtype_PromoCutOff,
    EURLtype_AlixPay
}URLType;

@interface URLScheme : NSObject{
    URLType urlType;
    NSArray* pramaArr;
}
+(id)sharedScheme;
-(void)parseWithURL:(NSURL*)url;
@end


/**** URL 示例
跳转到CMS活动页= yhd://cms/cmsID_provinceid
跳转到爆款单品详情页=yhd://product/productid_provinceid_promotionid（如果没有promotionid就进入普通商品详情页）
跳转到团购单品详情页=yhd://groupon/grouponid_groupaeaid
跳转到摇一摇首页=yhd://rockhomepage/
跳转到搜索页=yhd://search/keyword_searchid_serchtype
跳转到赠品促销页=yhd://promofree/promotionid_levelid
跳转到n元n件促销页=yhd://promonn/promotionid_levelid
跳转到满减列表促销页=yhd://promocutoff/promotionid_levelid
支付宝回调 = yhd://safepay/xxxxxxxx
****/