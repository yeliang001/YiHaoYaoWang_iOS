//
//  CartCache.m
//  TheStoreApp
//
//  Created by yuan jun on 13-5-3.
//
//

#import "CartCache.h"
#import "CartItemVO.h"
@implementation CartCache
@synthesize  cartCache;
@synthesize giftArCache;
@synthesize redemptionArCache;
static CartCache* sharedInstance=nil;
-(void)dealloc{
  [cartCache release];
     [giftArCache release];
     [redemptionArCache release];
    [super dealloc];
}

-(id)init
{
    if (self=[super init]) {
        giftArCache=[[NSMutableArray alloc] init];
        redemptionArCache=[[NSMutableArray alloc] init];
    }
    return self;
}

+(CartCache*)sharedCartCache{

    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}
-(BOOL)compareCacheWithCart:(CartVO*)cartvo{
    return YES;
}

-(void)deleteQuantity:(int)deleteQuantity{
    int tempQ=cartCache.totalquantity.intValue;
    cartCache.totalquantity=[NSNumber numberWithInt:tempQ-deleteQuantity];
}

-(void)deleteGift:(ProductVO*)gift{
    CartItemVO* temp=nil;
    for (CartItemVO* itemVO in cartCache.gifItemtList) {
        if (itemVO.product.productId.longValue ==gift.productId.longValue
            && [itemVO.product.promotionId isEqualToString:gift.promotionId]) {
            temp=itemVO;
            break;
        }
    }
    if (temp!=nil) {
        [cartCache.gifItemtList removeObject:temp];
    }
}
-(void)updateProduct:(ProductVO*)product newCount:(int)newCount{
    CartItemVO* temp=nil;
    for (CartItemVO* itemVO in cartCache.buyItemList) {
        if (itemVO.product.productId.longValue ==product.productId.longValue) {
            if (product.promotionId!=nil) {
                if ([itemVO.product.promotionId isEqualToString:product.promotionId]) {
                    temp=itemVO;
                    break;
                }
            }else{
                temp=itemVO;
                break;
            }
        }
    }
    int oldCount=temp.buyQuantity.intValue;
    temp.buyQuantity=[NSNumber numberWithInt:newCount];
    int delta=newCount-oldCount;
    int tempQ=cartCache.totalquantity.intValue;
    cartCache.totalquantity=[NSNumber numberWithInt:tempQ+delta];
}

-(void)deleteProduct:(ProductVO*)product{
    CartItemVO* temp=nil;

    for (CartItemVO* itemVO in cartCache.buyItemList) {
        if (itemVO.product.productId.longValue ==product.productId.longValue) {
            if (product.promotionId!=nil) {
                if ([itemVO.product.promotionId isEqualToString:product.promotionId]) {
                    temp=itemVO;
                    break;
                }
            }else{
                temp=itemVO;
                break;
            }
        }
    }
    if (temp!=nil) {
    [cartCache.buyItemList removeObject:temp];
    }
}

-(void)deleteRedemPromotion:(ProductVO*)redem{
    CartItemVO* temp=nil;
    for (CartItemVO* itemVO in cartCache.redemptionItemList) {
        if (itemVO.product.productId.longValue ==redem.productId.longValue
            && [itemVO.product.promotionId isEqualToString:redem.promotionId]) {
            temp=itemVO;
            break;
        }
    }
    if (temp!=nil) {
    [cartCache.redemptionItemList removeObject:temp];
    }

}

-(void)deleteCashPromotion:(ProductVO*)cash{
    CartItemVO* temp=nil;
    for (CartItemVO* itemVO in cartCache.cashPromotionList) {
        if (itemVO.product.productId.longValue ==cash.productId.longValue
            && [itemVO.product.promotionId isEqualToString:cash.promotionId]) {
            temp=itemVO;
            break;
        }
    }
    if (temp!=nil) {
        [cartCache.cashPromotionList removeObject:temp];
    }

}

-(void)deleteGiftOrRedemProduct:(ProductVO *)promotion{
    CartItemVO* temp=nil;
    int type=0;
    for (CartItemVO* itemVO in cartCache.redemptionItemList) {
        if (itemVO.product.productId.longValue ==promotion.productId.longValue
            && [itemVO.product.promotionId isEqualToString:promotion.promotionId]) {
            temp=itemVO;
            type=1;
            break;
        }
    }
    for (CartItemVO* itemVO in cartCache.gifItemtList) {
        if (itemVO.product.productId.longValue ==promotion.productId.longValue
            && [itemVO.product.promotionId isEqualToString:promotion.promotionId]) {
            temp=itemVO;
            type=2;
            break;
        }
    }
    if (temp!=nil) {
        if (type==1) {
            [cartCache.redemptionItemList removeObject:temp];
        }
        if (type==2) {
            [cartCache.gifItemtList removeObject:temp];
        }            
    }

}
@end
