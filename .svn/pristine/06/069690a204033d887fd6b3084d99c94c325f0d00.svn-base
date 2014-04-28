//
//  CartCache.h
//  TheStoreApp
//
//  Created by yuan jun on 13-5-3.
//
//

#import <Foundation/Foundation.h>
#import "CartVO.h"
#import "ProductVO.h"
@interface CartCache : NSObject
{
    CartVO* cartCache;
    NSMutableArray* giftArCache;
    NSMutableArray* redemptionArCache;
}
@property(nonatomic,retain) CartVO* cartCache;
@property(nonatomic,retain) NSMutableArray* giftArCache;
@property(nonatomic,retain) NSMutableArray* redemptionArCache;
+(CartCache*)sharedCartCache;
-(void)deleteGift:(ProductVO*)gift;
-(void)deleteProduct:(ProductVO*)gift;
-(void)deleteRedemPromotion:(ProductVO*)redem;
-(void)deleteCashPromotion:(ProductVO*)cash;
-(BOOL)compareCacheWithCart:(CartVO*)cartvo;
-(void)deleteGiftOrRedemProduct:(ProductVO *)promotion;
-(void)deleteQuantity:(int)deleteQuantity;
-(void)updateProduct:(ProductVO*)product newCount:(int)newCount;
@end
