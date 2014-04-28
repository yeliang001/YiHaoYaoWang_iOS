//
//  ProductView.h
//  yhd
//
//  Created by  on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductVO;

// CLASS_DESC:view in product list cell
@interface ProductView : UIView
{
    CGPoint beginPoint;
    UIImageView *imageView;
    ProductVO *product;
    BOOL isPop;
}

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)ProductVO *product;
@property(nonatomic)BOOL isPop;

- (id)initWithFrame:(CGRect)frame product:(ProductVO *)aproduct ispop:(BOOL)ispop productListType:(NSInteger)productListType;
- (void) setLast;
@end
