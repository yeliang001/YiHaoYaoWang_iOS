//
//  SeriesProductVO.h
//  TheStoreApp
//
//  Created by xuexiang on 12-11-30.
//
//

#import <Foundation/Foundation.h>
#import "ProductVO.h"

@interface SeriesProductVO : NSObject<NSCoding>{
    /**
	 *
	 */
	NSNumber* serialVersionUID;
	NSNumber* nid;
    /**
     * 主系列商品ID
     */
    NSNumber* mainProductID;
    
    /**
     * 子系列商品Id
     */
    NSNumber* subProductID;
    
    /**
     * 子系列商品信息
     */
    ProductVO* productVO;
    
	/**
	 * 产品颜色
	 */
	NSString* productColor;
	
	/**
	 * 产品尺寸
	 */
	NSString* productSize;
}
@property(nonatomic, retain)NSNumber* serialVersionUID;
@property(nonatomic, retain)NSNumber* nid;
@property(nonatomic, retain)NSNumber* mainProductID;
@property(nonatomic, retain)NSNumber* subProductID;
@property(nonatomic, retain)ProductVO* productVO;
@property(nonatomic, retain)NSString* productColor;
@property(nonatomic, retain)NSString* productSize;
@end
