//
//  OTSPadProductDetailInfoView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-16.
//
//

#import "OTSPadProductDetailInfoView.h"
#import "OTSLineThroughLabel.h"
#import "UIView+LoadFromNib.h"
#import "OTSAddMinusTextField.h"
#import "OTSPadProductStarView.h"
#import "OTSProductActivityView.h"
#import "ProductVO.h"
#import "OTSGpsHelper.h"
#import "ProvinceVO.h"
#import "MobilePromotionVO.h"

@interface OTSPadProductDetailInfoView ()
@property (retain) ProductVO    *product;
@property (retain) NSArray      *gifts;
@property (retain) NSArray      *exchangeBuys;
@end

@implementation OTSPadProductDetailInfoView
@synthesize priceLbl;
@synthesize marketPriceLbl;
@synthesize product = _product;
@synthesize gifts = _gifts;
@synthesize exchangeBuys = _exchangeBuys;
@synthesize delegate = _delegate;

-(void)setDelegate:(id)delegate
{
    _delegate = delegate;
    self.activityView.delegate = delegate;
}

-(id)delegate
{
    return _delegate;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc {
    [priceLbl release];
    [marketPriceLbl release];
    [_countTextFd release];
    [_starView release];
    [_activityView release];
    [_product release];
    [_gifts release];
    
    [_storageStatLbl release];
    [_addToCartBtn release];
    [_addToFavBtn release];
    [_giftNoteView release];
    [_buyAmountStaticLbl release];
    [_seeCommentBtn release];
    [_exchangeBuys release];
    
    [super dealloc];
}

-(void)awakeFromNib
{
    //self.marketPriceLbl.text = @"￥3999";
    [self.addToCartBtn setImage:[UIImage imageNamed:@"pdProductSellOut"] forState:UIControlStateDisabled];
    
    CGRect countRc = self.countTextFd.frame;
    [self.countTextFd removeFromSuperview];
    self.countTextFd = [OTSAddMinusTextField viewFromNibWithOwner:self];
    self.countTextFd.frame = countRc;
    [self addSubview:self.countTextFd];
    
    CGRect activityRc = self.activityView.frame;
    [self.activityView removeFromSuperview];
    self.activityView = [OTSProductActivityView viewFromNibWithOwner:self];
    self.activityView.frame = activityRc;
    [self.activityView layoutMe];
    [self addSubview:self.activityView];
    
    [self layoutStorageLabel];
    
    self.starView.count = 5;
    
}

-(void)updateUIWithGifts:(NSArray*)aGifts
{
    self.gifts = aGifts;
    
#if 0
    NSMutableString *giftTitle = [NSMutableString string];
    for (MobilePromotionVO *promotion in self.gifts)
    {
        [giftTitle appendFormat:@"%@\n", promotion.title];
    }
#else
    NSString *title = self.gifts.count ? ((MobilePromotionVO *)self.gifts[0]).title : nil;
    self.activityView.giftBuyIv.hidden = self.gifts.count < 1;
#endif
    
    [self.activityView setGiftTitle:title];
    
    [self layoutStorageLabel];
}

-(void)updateUIWithExchangeBuys:(NSArray*)aExchangeBuys
{
    self.exchangeBuys = aExchangeBuys;
    
#if 0
    NSMutableString *title = [NSMutableString string];
    for (MobilePromotionVO *promotion in self.exchangeBuys)
    {
        [title appendFormat:@"%@\n", promotion.title];
    }
#else
    NSString *title = self.exchangeBuys.count ? ((MobilePromotionVO *)self.exchangeBuys[0]).title : nil;
    self.activityView.exchangeBuyDotIv.hidden = self.exchangeBuys.count < 1;
#endif
    
    [self.activityView setExchangeBuyTitle:title];
    
    [self layoutStorageLabel];
}

-(void)layoutStorageLabel
{
    CGRect storageRc = self.storageStatLbl.frame;
    storageRc.origin.y = CGRectGetMaxY(self.activityView.frame);
    self.storageStatLbl.frame = storageRc;
}

-(void)updateUIWithProduct:(ProductVO*)aProduct
{
    self.product = aProduct;
    
    if (self.product)
    {
        self.priceLbl.text = [aProduct priceStringTrimZero:aProduct.realPrice];
        //self.marketPriceLbl.text = [aProduct priceStringTrimZero:aProduct.maketPrice];
        self.starView.count = [self.product.score intValue];
        
        self.giftNoteView.hidden = !self.product.isGiftProduct;
        
        if (self.giftNoteView.hidden) // 不是赠品
        {
            NSString *stockStr = nil;
            if (self.product.isCanBuy)
            {
                stockStr = [self.product.stockDesc stringByReplacingOccurrencesOfString:@"，" withString:@" "];
            }
            else
            {
                stockStr = [NSString stringWithFormat:@"%@无货 到货通知", [OTSGpsHelper sharedInstance].provinceVO.provinceName];
            }
            self.storageStatLbl.text = stockStr;
            
            self.addToCartBtn.hidden = NO;
            self.addToCartBtn.enabled = self.product.isCanBuy;
        }
        else
        {
            self.priceLbl.text = [aProduct priceStringTrimZero:aProduct.maketPrice];
            
            self.addToCartBtn.hidden = YES;
            self.addToFavBtn.hidden = YES;
            self.storageStatLbl.hidden = YES;
            self.countTextFd.hidden = YES;
            self.buyAmountStaticLbl.hidden = YES;
            self.activityView.hidden = YES;
            
            self.frame = CGRectOffset(self.frame, 0, self.giftNoteView.frame.size.height);
        }
    }
}

#pragma mark -
-(IBAction)addToCartAction:(id)sender
{
    LOG_THE_METHORD;
    
    self.product.purchaseAmount = [self.countTextFd.txtFd.text intValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_ADD_TO_CART_IN_DETAIL
                                                        object:self.product];
}

-(IBAction)addToFavAction:(id)sender
{
    LOG_THE_METHORD;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_ADD_TO_FAV_IN_DETAIL
                                                        object:self.product];
    
}

-(IBAction)seeCommentAction:(id)sender
{
    LOG_THE_METHORD;
    SEL selector = _cmd;
    if ([_delegate respondsToSelector:selector])
    {
        [_delegate performSelector:selector];
    }
}

@end
