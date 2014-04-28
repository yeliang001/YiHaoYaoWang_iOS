//
//  MerchantInfoVO.h
//  TheStoreApp
//
//  Created by xuexiang on 12-11-30.
//
//

#import <Foundation/Foundation.h>

@interface MerchantInfoVO : NSObject<NSCoding>
{
    /**
     *
     */
    NSNumber* serialVersionUID;
    
    /**
     * 商家名称
     */
    NSString* MerchantName;
    
    /**
     * 运费信息
     */
    NSString* freightInformation;
    
    /**
     * 配送方式
     */
    NSString* shippingMethod;
    
    /**
     * 支付方式
     */
    NSString* paymentMethod;
}
@property(nonatomic, retain)NSNumber* serialVersionUID;
@property(nonatomic, retain)NSString* MerchantName;
@property(nonatomic, retain)NSString* freightInformation;
@property(nonatomic, retain)NSString* shippingMethod;
@property(nonatomic, retain)NSString* paymentMethod;

-(NSMutableDictionary *)dictionaryFromVO;
+(id)voFromDictionary:(NSMutableDictionary *)mDictionary;

-(MerchantInfoVO*)clone;

@end
