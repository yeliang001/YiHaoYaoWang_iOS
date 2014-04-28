//
//  OTSPromoteProductItemView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import <UIKit/UIKit.h>
#import "OTSPadProductDetailView.h"

@interface OTSPromoteProductItemView : UIView
@property (retain, nonatomic) IBOutlet UILabel      *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel      *limitLabel;
@property (retain, nonatomic) IBOutlet UILabel      *priceLabel;
@property (retain, nonatomic) IBOutlet UIImageView  *pictureIV;
@property (retain, nonatomic) IBOutlet UIView       *bgView;
@property (retain, nonatomic) IBOutlet UIButton     *btnAddToCart;
@property (retain, nonatomic) IBOutlet UIImageView  *soldOutMarkIV;
@property (retain, nonatomic) IBOutlet UIView       *gestureView;


@property (assign)  id<OTSPadProductDetailViewDelegate>  delegate;


@property (retain)  ProductVO       *product;

-(float)width;
+(float)height;
-(void)switchToSameCate;
-(void)switchToPoppedMode;

-(IBAction)addToCartAction:(id)sender;

-(void)updateWithProduct:(ProductVO*)aProduct;

@end
