//
//  OTSInterestedProducts.h
//  TheStoreApp
//
//  Created by jiming huang on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductVO;
@class OTSInterestedProducts;

@protocol OTSInterestedProductsDelegate

@required
-(void)interestedProductClicked:(ProductVO *)productVO;
-(void)interestedProductIsNull:(OTSInterestedProducts *)interestedProducts;

@end

@interface OTSInterestedProducts : UIView {
    id m_Delegate;
    NSArray *m_Array;
}

-(id)initWithFrame:(CGRect)frame productVO:(ProductVO *)productVO delegate:(id<OTSInterestedProductsDelegate>)delegate;
@end
