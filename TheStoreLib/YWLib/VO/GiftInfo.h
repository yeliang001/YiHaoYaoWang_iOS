//
//  GiftInfo.h
//  TheStoreApp
//
//  Created by LinPan on 14-1-8.
//
//

//促销活动中的赠品
#import <Foundation/Foundation.h>
@class ProductInfo;
@interface GiftInfo : NSObject

@property (copy, nonatomic) NSString *giftId;
@property (copy, nonatomic) NSString *giftName;
@property (assign, nonatomic) NSInteger giftStatus;
@property (assign, nonatomic) NSInteger itemId;
@property (assign, nonatomic) NSInteger limitCount;
@property (assign, nonatomic) CGFloat markPrice;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) NSInteger promotionId;
@property (assign, nonatomic) NSInteger quantity;
@property (assign, nonatomic) NSInteger schemeId;
@property (assign, nonatomic) NSInteger storeId;

@property (assign, nonatomic) NSInteger selectedCount; //该赠品被选的数量
@property (retain, nonatomic) ProductInfo *detailProduct; //这个赠品对应的正常商品，，，，mb的，在购物车里，选择的赠品给服务器之后返回了productInfo 的数据结构

- (NSString *)giftImageStr;

@end
