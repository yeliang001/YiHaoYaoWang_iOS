//
//  RecommendProductView.h
//  TheStoreApp
//
//  Created by 林盼 on 14-4-4.
//
//

#import <UIKit/UIKit.h>
@class OTSImageView;
@class ProductInfo;

@interface RecommendProductView : UIView
{
    id _target;
    SEL _act;
    
}
@property (nonatomic, retain) OTSImageView *imageView;
@property (nonatomic, retain) UILabel *priceLbl ;
@property (nonatomic, retain) UILabel *nameLbl;
@property (nonatomic, retain) ProductInfo *product;


- (id)initWithFrame:(CGRect)frame product:(ProductInfo *)product target:(id)aTarget  action:(SEL)act;


@end
