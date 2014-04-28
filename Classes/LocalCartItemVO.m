//
//  LocalCartItemVO.m
//  TheStoreApp
//
//  Created by linyy on 11-7-6.
//  Copyright 2011年 vsc. All rights reserved.
//

#import "LocalCartItemVO.h"
#import "ProductVO.h"
#import "CartItemVO.h"

@implementation LocalCartItemVO

@synthesize productId;
@synthesize cnName;
@synthesize price;
@synthesize shoppingCount;
@synthesize miniDefaultProductUrl;
@synthesize merchantId;
@synthesize quantity;
@synthesize promotionId;
@synthesize promotionPrice;
@synthesize hasGift, mobileProductType,hasCash,hasRedemption;

#pragma mark 初始化本地购物车商品
-(id)initWithProductVO:(ProductVO *)aProductVO quantity:(NSString *)quantityStr{
    self = [super init];		// added by: dong yiming at: 2012.5.24. reason: to obey apple's guideline
    if(aProductVO!=nil){
        if(aProductVO.productId!=nil){
            productId=[[NSString alloc] initWithFormat:@"%@",aProductVO.productId];
        }
        if(aProductVO.cnName!=nil){
            cnName=[[NSString alloc] initWithFormat:@"%@",aProductVO.cnName];
        }
        if(aProductVO.price!=nil){
            price=[[NSString alloc] initWithFormat:@"%.2f",[aProductVO.price doubleValue]];
        }
        if(aProductVO.shoppingCount!=nil){
            shoppingCount=[[NSString alloc] initWithFormat:@"%@",aProductVO.shoppingCount];
        }
        else{
            shoppingCount=[[NSString alloc] initWithString:@"0"];
        }
        if(aProductVO.miniDefaultProductUrl!=nil){
            miniDefaultProductUrl=[[NSString alloc] initWithFormat:@"%@",aProductVO.miniDefaultProductUrl];
        }
        else{
            miniDefaultProductUrl=[[NSString alloc] initWithString:@"(default)"];
        }
        if(aProductVO.merchantId!=nil){
            merchantId=[[NSString alloc] initWithFormat:@"%@",aProductVO.merchantId];
        }
        if(aProductVO.promotionId != nil) {
            promotionId = [[NSString alloc] initWithFormat:@"%@",aProductVO.promotionId];
        }
        if(aProductVO.promotionPrice != nil){
            promotionPrice = [[NSString alloc] initWithFormat:@"%.2f",[aProductVO.promotionPrice doubleValue] ];
        }
        if (aProductVO.hasGift!=nil) {
            hasGift=[[NSString alloc] initWithFormat:@"%@",[aProductVO hasGift]];
        }
        
        if (aProductVO.mobileProductType) 
        {
            self.mobileProductType = [NSString stringWithFormat:@"%@", [aProductVO mobileProductType]];
        }
        if (aProductVO.hasCash!=nil) {
            hasCash=[[NSString alloc]initWithFormat:@"%@",[aProductVO hasCash]];
        }
        if (aProductVO.hasRedemption!=nil) {
            hasRedemption=[[NSString alloc]initWithFormat:@"%@",[aProductVO hasRedemption]];
        }
    }
    if(quantityStr!=nil){
        quantity=[[NSString alloc] initWithFormat:@"%@",quantityStr];
    }
    return self;
}

-(ProductVO *)changeToProductVO
{
    ProductVO *productVO=[[[ProductVO alloc] init] autorelease];
    [productVO setProductId:[NSNumber numberWithInt:[[self productId] intValue]]];
    [productVO setCnName:[self cnName]];
    [productVO setPrice:[NSNumber numberWithFloat:[[self price] floatValue]]];
    [productVO setShoppingCount:[NSNumber numberWithInt:[[self shoppingCount] intValue]]];
    [productVO setMiniDefaultProductUrl:[self miniDefaultProductUrl]];
    [productVO setMerchantId:[NSNumber numberWithInt:[[self merchantId] intValue]]];
    [productVO setPromotionId:[self promotionId]];
    [productVO setPromotionPrice:[NSNumber numberWithFloat:[[self promotionPrice] floatValue]]];
    [productVO setHasGift:[NSNumber numberWithInt:[[self hasGift] intValue]]];
    [productVO setHasCash:[self hasCash]];
    [productVO setHasRedemption:[NSNumber numberWithInt:[self.hasRedemption intValue]]];
    productVO.mobileProductType = [NSNumber numberWithInt:[mobileProductType intValue]];
    
    return productVO;
}

-(CartItemVO *)changeToCartItemVO
{
    CartItemVO *cartItemVO=[[[CartItemVO alloc] init] autorelease];
    [cartItemVO setBuyQuantity:[NSNumber numberWithInt:[quantity intValue]]];
    [cartItemVO setProduct:[self changeToProductVO]];
    return cartItemVO;
}

-(int)productCount
{
    return [quantity intValue];
}

-(void)dealloc{
    if(productId!=nil){
        [productId release];
    }
    if(cnName!=nil){
        [cnName release];
    }
    if(price!=nil){
        [price release];
    }
    if(shoppingCount!=nil){
        [shoppingCount release];
    }
    if(miniDefaultProductUrl!=nil){
        [miniDefaultProductUrl release];
    }
    if(merchantId!=nil){
        [merchantId release];
    }
    if(quantity){
        [quantity release];
    }
    if (promotionId != nil) {
        [promotionId release];
    }
    if (promotionPrice != nil) {
        [promotionPrice release];
    }
    if (hasGift!=nil) {
        [hasGift release];
        hasGift=nil;
    }
    if (hasCash!=nil) {
        [hasCash release];
        hasCash=nil;
    }
    if (hasRedemption!=nil) {
        [hasRedemption release];
        hasRedemption=nil;
    }
    [mobileProductType release];
    
    [super dealloc];
}

@end
