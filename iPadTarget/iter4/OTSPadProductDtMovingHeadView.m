//
//  OTSPadProductDtMovingHeadView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-19.
//
//

#import "OTSPadProductDtMovingHeadView.h"
#import "UIView+LayerEffect.h"

@interface OTSPadProductDtMovingHeadView ()
@property (retain)  ProductVO           *product;
@end

@implementation OTSPadProductDtMovingHeadView
@synthesize product = _product;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_nameLabel release];
    [_priceLabel release];
    [_addToCartBtn release];
    [_product release];
    
    [_bgIv release];
    [super dealloc];
}

-(void)awakeFromNib
{
    [self.addToCartBtn setImage:[UIImage imageNamed:@"pdProductSellOut"] forState:UIControlStateDisabled];
    self.priceLabel.textColor = [UIView colorFromRGB:0xCC0000];
    self.nameLabel.textColor = [UIView colorFromRGB:0x444444];
    
    UIImage *bgImg = [UIImage imageNamed:@"pdMovingHeadBg"];
    UIImage *stretchImg = [bgImg stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f];
    self.bgIv.image = stretchImg;
}

-(IBAction)addToCartAction:(id)sender
{
    LOG_THE_METHORD;
    self.product.purchaseAmount = 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_ADD_TO_CART_IN_DETAIL
                                                        object:self.product];
}

-(void)updateWithProdut:(ProductVO*)aProduct
{
    self.product = aProduct;
    if (aProduct == nil)
    {
        return;
    }
    
    self.nameLabel.text = aProduct.cnName;
    self.priceLabel.text = [aProduct priceStringTrimZero:aProduct.realPrice];//[NSString stringWithFormat:@"￥%.2f", [aProduct.realPrice floatValue]];
    self.addToCartBtn.enabled = aProduct.isCanBuy;
    self.addToCartBtn.hidden = aProduct.isGiftProduct;
}

-(void)switchToShortMode
{
    float factorX = 110.f;
    
    CGRect bgRc = self.bgIv.frame;
    bgRc.size.width -= factorX;
    self.bgIv.frame = bgRc;
    
    CGRect thisRc = self.frame;
    thisRc.size.width -= factorX;
    self.frame = thisRc;
    
    CGRect nameRc = self.nameLabel.frame;
    nameRc.size.width -= factorX;
    self.nameLabel.frame = nameRc;
    
    self.addToCartBtn.frame = CGRectOffset(self.addToCartBtn.frame, -factorX, 0);
}

@end
