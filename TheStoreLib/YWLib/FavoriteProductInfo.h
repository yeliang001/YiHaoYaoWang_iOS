//
//  FavoriteProductInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-19.
//
//

#import <Foundation/Foundation.h>

@interface FavoriteProductInfo : NSObject

@property (copy, nonatomic) NSString *addTime;
@property (copy, nonatomic) NSString *catId;
@property (copy, nonatomic) NSString *catalogId;
@property (copy, nonatomic) NSString *favorCatId;
@property (copy, nonatomic) NSString *flag;
@property (copy, nonatomic) NSString *goodsId;
@property (copy, nonatomic) NSString *favoriteId;
@property (copy, nonatomic) NSString *newUserNote;
@property (copy, nonatomic) NSString *nowPrice;
@property (copy, nonatomic) NSString *oldUserNote;
@property (copy, nonatomic) NSString *pid;
@property (copy, nonatomic) NSString *popularity;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *productImgUrl;
@property (copy, nonatomic) NSString *productName;
@property (copy, nonatomic) NSString *siteId;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userNote;
@property (copy, nonatomic) NSString *userTagName;
@property (copy, nonatomic) NSString *venderId;
@property (copy, nonatomic) NSString *venderName;
@property (assign, nonatomic) NSInteger status;
@property (copy, nonatomic) NSString *stockInfo;


- (BOOL)isOnSale;
- (NSInteger)currentStock;

@end
