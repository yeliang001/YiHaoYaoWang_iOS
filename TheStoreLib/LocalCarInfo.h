//
//  LocalCarInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-23.
//
//

#import <Foundation/Foundation.h>

@interface LocalCarInfo : NSObject


@property(copy, nonatomic) NSString *productId;
@property(copy,nonatomic) NSString *num; //购买数量
@property(copy, nonatomic) NSString *imageUrlStr;
@property(copy,nonatomic) NSString *price;
@property(copy, nonatomic) NSString *provinceId;
@property(copy, nonatomic) NSString *uid;

@property(copy, nonatomic) NSString *productNO;
@property(copy, nonatomic) NSString *itemId;



- (id)initWithProductId:(NSString *)aProductId
          shoppingCount:(NSString *)count
               imageUrl:(NSString *)imgurl
                  price:(NSString *)aPrice
             provinceId:(NSString *)aProvinceId
                    uid:(NSString *)aUid
              productNO:(NSString *)aProductNO
                 itemId:(NSString *)aItemId;



@end
