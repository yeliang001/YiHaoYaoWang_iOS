//
//  OTSProductActivityView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-19.
//
//

#import "OTSProductActivityView.h"

@interface OTSProductActivityView ()
@property (retain) UIImage  *stretchImage;
@property (retain) UIGestureRecognizer *giftGest;
@property (retain) UIGestureRecognizer *exchangeBuyGest;
@end

@implementation OTSProductActivityView
@synthesize stretchImage = _stretchImage;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)dealloc {
    [_giftBgIV release];
    [_exchangeBuyIV release];
    [_giftLabel release];
    [_exchangeBuyLabel release];
    [_giftView release];
    [_exchangeBuyView release];
    [_stretchImage release];
    
    [_exchangeBuyDotIv release];
    [_giftBuyIv release];
    
    [_giftGest release];
    [_exchangeBuyGest release];
    
    [super dealloc];
}

-(void)awakeFromNib
{
    UIImage *image = self.giftBgIV.image;
    self.stretchImage = [image stretchableImageWithLeftCapWidth:4.f topCapHeight:4.f];
    self.giftBgIV.image = self.stretchImage;
    self.exchangeBuyIV.image = self.stretchImage;
    
    _giftGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giftTapped:)];
    [_giftView addGestureRecognizer:_giftGest];
    
    _exchangeBuyGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeBuyTapped:)];
    [_exchangeBuyView addGestureRecognizer:_exchangeBuyGest];
}

-(void)setGiftTitle:(NSString*)aTitle
{
    self.giftLabel.text = aTitle;
    [self layoutMe];
}

-(void)setExchangeBuyTitle:(NSString*)aTitle
{
    self.exchangeBuyLabel.text = aTitle;
    [self layoutMe];
}

-(void)layoutMe
{
    self.giftView.hidden = (self.giftLabel.text.length <= 0);
    self.exchangeBuyView.hidden = (self.exchangeBuyLabel.text.length <= 0);
    
    if (!self.giftView.hidden)
    {
        [self.giftLabel sizeToFit];
        CGRect giftBgRc = self.giftBgIV.frame;
        giftBgRc.size.height = CGRectGetMaxY(self.giftLabel.frame) + 10;
        self.giftBgIV.frame = giftBgRc;
    }
    
    int offsetY = 0;
    if (!self.giftView.hidden)
    {
        offsetY = CGRectGetMaxY(self.giftBgIV.frame) + 20;
    }
    
    if (!self.exchangeBuyView.hidden)
    {
        CGRect exchangeBuyRc = self.exchangeBuyView.frame;
        exchangeBuyRc.origin.y = offsetY;
        self.exchangeBuyView.frame = exchangeBuyRc;
        
        [self.exchangeBuyLabel sizeToFit];
        
        CGRect exchangeBuyIVRc = self.exchangeBuyIV.frame;
        exchangeBuyIVRc.size.height = CGRectGetMaxY(self.exchangeBuyLabel.frame) + 10;
        self.exchangeBuyIV.frame = exchangeBuyIVRc;
        
        exchangeBuyRc = self.exchangeBuyView.frame;
        exchangeBuyRc.size.height = CGRectGetMaxY(self.exchangeBuyIV.frame);
        self.exchangeBuyView.frame = exchangeBuyRc;
        
        offsetY = CGRectGetMaxY(self.exchangeBuyView.frame) + 10;
    }
    
    CGRect thisRc = self.frame;
    thisRc.size.height = offsetY;
    self.frame = thisRc;
}

#pragma mark - action
-(IBAction)giftTapped:(id)sender
{
    LOG_THE_METHORD;
    [self seePromotion];
}

-(IBAction)exchangeBuyTapped:(id)sender
{
    LOG_THE_METHORD;
    [self seePromotion];
}

-(void)seePromotion
{
    SEL sel = @selector(seePromotionAction:);
    if ([_delegate respondsToSelector:sel])
    {
        [_delegate performSelector:sel];
    }
}

@end
