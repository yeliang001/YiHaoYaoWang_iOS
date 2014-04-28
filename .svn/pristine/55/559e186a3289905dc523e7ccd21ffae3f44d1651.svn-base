//
//  OTSPadImageSliderView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-16.
//
//

#import "OTSPadImageSliderView.h"
#import "UIView+LayerEffect.h"
#import "SDImageView+SDWebCache.h"

#define THUMB_SIZE      80

@interface OTSPadImageSliderView ()

@end

@implementation OTSPadImageSliderView
@synthesize tapGesture = _tapGesture;
@synthesize thumbScrollView = _thumbScrollView;
@synthesize pictureIV = _pictureIV;
@synthesize product = _product;


- (void)dealloc
{
    [_product release];
    
    [_tapGesture release];
    [_thumbScrollView release];
    [_pictureIV release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        DebugLog(@"hi, mum, i was called...");
    }
    return self;
}

-(void)awakeFromNib
{
    UIColor *color = [UIView colorFromRGB:0xEEEEEE];
    [self.pictureIV applyBorderWithWidth:1 color:color];
    self.thumbScrollView.showsHorizontalScrollIndicator = NO;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailTapped:)];
    [self addGestureRecognizer:_tapGesture];
    
    [self updateUI];
}

-(void)updateUI
{
    for (UIView *sub in self.thumbScrollView.subviews)
    {
        [sub removeFromSuperview];
    }
    
    NSArray *thumbs = self.product.product80x80Url;
    int count = thumbs.count;
    int offsetX = 0;
    UIImage *defaultImg = [UIImage imageNamed:@"productSliderSmallDefault.jpg"];
    for (int i = 0; i < count; i++)
    {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect itemRc = CGRectMake(offsetX, 0, THUMB_SIZE, THUMB_SIZE);
        itemBtn.frame = itemRc;
        itemBtn.tag = i;
        //itemBtn.userInteractionEnabled = YES;
        //[itemBtn addGestureRecognizer:self.tapGesture];
        [itemBtn addTarget:self action:@selector(thumbnailTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn applyBorderWithWidth:1 color:[UIView colorFromRGB:0xEEEEEE]];
        
        [self.thumbScrollView addSubview:itemBtn];
        
        NSString *imageUrl = [thumbs objectAtIndex:i];
        __block UIImage *theImage = nil;
        [self performInThreadBlock:^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            theImage = [[UIImage imageWithData:imageData] retain];
            
        } completionInMainBlock:^{
            
            [itemBtn setImage:theImage forState:UIControlStateNormal];
            [theImage release];
            
        }];
        
        offsetX += defaultImg.size.width + 30;
    }
    
    self.thumbScrollView.contentSize = CGSizeMake(offsetX, self.thumbScrollView.contentSize.height);
    
    [self setProductPictureWithIndex:0];
}

-(void)setProductPictureWithIndex:(NSUInteger)aIndex
{
    NSString *bigImgUrl = self.product.miniDefaultProductUrl;
    if (aIndex < self.product.product380x380Url.count)
    {
        bigImgUrl = [self.product.product380x380Url objectAtIndex:aIndex];
    }
    
    [self.pictureIV setImageWithURL:[NSURL URLWithString:bigImgUrl] refreshCache:NO placeholderImage:SharedPadDelegate.defaultProductImg];
}

-(void)updateUIWithProduct:(ProductVO*)aProduct
{
    self.product = aProduct;
    
    [self updateUI];
}

-(IBAction)thumbnailTapped:(id)sender
{
    LOG_THE_METHORD;
    
    for (UIButton *btn in self.thumbScrollView.subviews)
    {
        if (btn == sender)
        {
            [btn applyBorderWithWidth:1 color:nil];
            // BUG fixed 0126787
            UIButton *theBtn = (UIButton*)sender;
            [self setProductPictureWithIndex:theBtn.tag];
        }
        else
        {
            [btn applyBorderWithWidth:1 color:[UIView colorFromRGB:0xEEEEEE]];
        }
    }
    
//    NSString *bigImgUrl = [self.product.product380x380Url objectAtIndex:theBtn.tag];
//    [self.pictureIV setImageWithURL:[NSURL URLWithString:bigImgUrl]];
}

@end
