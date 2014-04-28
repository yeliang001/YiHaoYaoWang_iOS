//
//  CartInputVO.h
//  TheStoreApp
//
//  Created by yuan jun on 13-5-6.
//
//
//public class CartInputVO implements Serializable {
//    
//    /**
//     * 产品id
//     */
//    private Long productId;
//    
//    /**
//     * 商家id
//     */
//    private Long merchantId;
//    
//    /**
//     * 促销条件=promotionId_promotionLevelId_promotionType
//     * 对应以前ProductVO.promotionId
//     */
//    private Long promotionCondition;
//    
//    /**
//     * X元Y件的数量
//     */
//    private Long quantity;

#import <Foundation/Foundation.h>

@interface CartInputVO : NSObject
{
    NSNumber* productId;
    NSNumber* merchantId;
    NSString* promotionCondition;
    NSNumber* quantity;
}
@property(nonatomic,retain) NSNumber* productId;
@property(nonatomic,retain) NSNumber* merchantId;
@property(nonatomic,retain) NSString* promotionCondition;
@property(nonatomic,retain) NSNumber* quantity;

@end
