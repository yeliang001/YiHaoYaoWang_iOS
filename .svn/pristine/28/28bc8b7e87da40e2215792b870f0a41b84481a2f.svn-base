//
//  CartVO+ProductCart.m
//  yhd
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CartVO+ProductCart.h"

@implementation CartVO (ProductCart)
-(CartItemVO *)containsProduct:(ProductVO *)product{

    for (CartItemVO *cartItem in self.buyItemList) {
        if ([cartItem.product.productId intValue]==[product.productId intValue])
        {
            if ([[self isStringAvable:cartItem.product.promotionId] isEqualToString:[self isStringAvable:product.promotionId]])
            {
                return cartItem;
            }
            else if ([self isStringAvable:cartItem.product.promotionId] == nil && [self isStringAvable:product.promotionId] == nil)
            {
                return cartItem;
            }
            // 这个判断不可靠
//            if ([cartItem.product.promotionId isEqualToString:product.promotionId])
//            {
//                return cartItem;
//            }
//            else if (cartItem.product.promotionId == nil && product.promotionId == nil)
//            {
//                return cartItem;
//            }
        }
    }
    return nil;
}
-(NSString*)isStringAvable:(NSString*)str{
    if (str && ![str isEqualToString:@""]) {
        return str;
    }else
        return nil;
}

-(BOOL)containsLandingPageProduct
{
    for (CartItemVO *cartItem in self.buyItemList)
    {
        if ([cartItem.product isLandingPage])
        {
            return YES;
        }
    }
    
    return NO;
}
@end
