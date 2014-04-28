//
//  CartVO+ProductCart.h
//  yhd
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CartVO.h"
#import "ProductVO.h"
#import "CartItemVO.h"
@interface CartVO (ProductCart)
-(CartItemVO *)containsProduct:(ProductVO *)product;
-(BOOL)containsLandingPageProduct;
@end
