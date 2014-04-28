//
//  ProductDescVO.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-8-15.
//
//

#import <Foundation/Foundation.h>

@interface ProductDescVO : NSObject
@property(retain)       NSNumber        *serialVersionUID;
@property(copy)         NSString        *tabName;
@property(copy)         NSString        *tabDetail;
@property(retain)       NSNumber        *tabType;   // TAB类型，由EOtsProdctDesTabType定义
@end

typedef enum _EOtsProdctDesTabType
{
    KOtsProdctDesTabProductDesc = 1         // 1-产品描述 
    , KOtsProdctDesTabSpecifyParam          // 2-规格参数 
    , KOtsProdctDesTabPackageList           // 3-包装清单 
    , KOtsProdctDesTabPostSaleService       // 4-售后服务
}EOtsProdctDesTabType;
