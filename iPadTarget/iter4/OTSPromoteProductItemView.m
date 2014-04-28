//
//  OTSPromoteProductItemView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import "OTSPromoteProductItemView.h"
#import "UIView+LayerEffect.h"
#import "SDImageView+SDWebCache.h"
#import "OTSLineThroughLabel.h"

#define SELF_WIDTH      240
#define SELF_HEIGHT     280

@interface OTSPromoteProductItemView ()
@property (retain) UITapGestureRecognizer   *enterDetailTapGest;
@end

@implementation OTSPromoteProductItemView
@synthesize product = _product;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_nameLabel release];
    [_limitLabel release];
    [_priceLabel release];
    [_pictureIV release];
    [_bgView release];
    [_btnAddToCart release];
    [_product release];
    
    [_soldOutMarkIV release];
    [_gestureView release];
    
    [_enterDetailTapGest release];
    
    [super dealloc];
}

-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProductDetailDestroyed:) name:PAD_NOTIFY_PRODUCT_DETAIL_VC_DEALLOC object:nil];
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIView colorFromRGB:0xEEEEEE].CGColor;
    self.clipsToBounds = YES;
    
    [self.btnAddToCart setImage:[UIImage imageNamed:@"pdSameCateCartGray"] forState:UIControlStateDisabled];
    
    //
    UILongPressGestureRecognizer *longPress = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handelLongPress:)] autorelease];
    longPress.minimumPressDuration = kLongPressTime;
    [self addGestureRecognizer:longPress];
    
    _enterDetailTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterDetailAction:)];
    [self addGestureRecognizer:_enterDetailTapGest];
}

-(void)handleProductDetailDestroyed:(NSNotification*)aNote
{
    id productdetailObj = aNote.object;
    if ([productdetailObj longLongValue] == (long long)_delegate)
    {
        _delegate = nil;
    }
}

#pragma mark - guesture

-(void)handelLongPress:(UILongPressGestureRecognizer*)aGesture
{
    if ([_delegate respondsToSelector:_cmd])
    {
        [_delegate performSelector:_cmd withObject:aGesture];
    }
}

-(void)switchToSameCate
{
    //self.limitLabel.hidden = YES;
    self.btnAddToCart.hidden = NO;
}

-(float)width
{
    return self.frame.size.width;
}

+(float)height
{
    return SELF_HEIGHT;
}

-(IBAction)addToCartAction:(id)sender
{
    LOG_THE_METHORD;
    
    self.product.purchaseAmount = 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_ADD_TO_CART_IN_DETAIL
                                                        object:self.product];
}

-(IBAction)enterDetailAction:(id)sender
{
    ProductVO *productClone = [self.product clone];
    productClone.promotionId = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_VIEW_DETAIL_IN_DETAIL
                                                        object:productClone];
}

#pragma mark - update
-(void)updateWithProduct:(ProductVO*)aProduct
{
    self.product = aProduct;
    
    if (self.product)
    {
        self.soldOutMarkIV.hidden = !self.product.isProductSoldOut;
        
        if (self.product.isGiftProduct)
        {
            self.limitLabel.text = self.product.totalQuantityLimit;
            
            CGRect priceRc = self.priceLabel.frame;
            OTSLineThroughLabel* lineThroughLabel = [[[OTSLineThroughLabel alloc] init] autorelease];
            lineThroughLabel.frame = priceRc;
            lineThroughLabel.font = self.priceLabel.font;
            [self.priceLabel removeFromSuperview];
            self.priceLabel = lineThroughLabel;
            [self addSubview:self.priceLabel];
            self.priceLabel.text = [self.product priceStringTrimZero:aProduct.maketPrice];
            
            
//            if (self.product.isProductSoldOut) // 赠品领完标志
//            {
//                self.soldOutMarkIV.hidden = NO;
//                UIView *grayMask = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
//                grayMask.backgroundColor = [UIColor lightGrayColor];
//                grayMask.layer.opacity = .3f;
//                [self addSubview:grayMask];
//            }
        }
        else
        {
            [self switchToSameCate];
            self.priceLabel.text = [self.product priceStringTrimZero:aProduct.realPrice];
            self.limitLabel.text = self.product.totalQuantityLimit;
        }
        
        if ([_delegate isPopped])
        {
            [self switchToPoppedMode];
        }
        
        NSString *imgUrlStr = self.product.midleDefaultProductUrl ? self.product.midleDefaultProductUrl : self.product.miniDefaultProductUrl;
        [self.pictureIV setImageWithURL:[NSURL URLWithString:imgUrlStr] refreshCache:YES placeholderImage:SharedPadDelegate.defaultProductImg];
        
        self.nameLabel.text = self.product.cnName;
        
        self.btnAddToCart.enabled = self.product.isCanBuy;
    }
}

-(void)switchToPoppedMode
{
    float factorX = 25;
    
    CGRect thisRc = self.frame;
    thisRc.size.width -= factorX;
    self.frame = thisRc;
    
    CGRect gestureRc = self.gestureView.frame;
    gestureRc.size.width -= factorX;
    self.gestureView.frame = gestureRc;
    
    CGRect bgRc = self.bgView.frame;
    bgRc.size.width -= factorX;
    self.bgView.frame = bgRc;
    
    self.priceLabel.frame = CGRectOffset(self.priceLabel.frame, -(factorX * 0.5f), 0);
    self.limitLabel.frame = CGRectOffset(self.limitLabel.frame, -(factorX * 0.5f), 0);
    self.nameLabel.frame = CGRectOffset(self.nameLabel.frame, -(factorX * 0.5f), 0);
    self.pictureIV.frame = CGRectOffset(self.pictureIV.frame, -(factorX * 0.5f), 0);
    self.btnAddToCart.frame = CGRectOffset(self.btnAddToCart.frame, -factorX, 0);
    self.soldOutMarkIV.frame = CGRectOffset(self.soldOutMarkIV.frame, -factorX, 0);
    
//    CGRect cartRc = self.btnAddToCart.frame;
//    cartRc.origin.x -= 85;
//    self.btnAddToCart.frame = cartRc;
}

@end
