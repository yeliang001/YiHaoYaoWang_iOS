//
//  OTSProductDtTab2View.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-26.
//
//

#import "OTSProductDtTab2View.h"
#import "UIView+LayerEffect.h"
#import "MobClick.h"

#define OVERLAP_LEN         15
#define CHANGE_OFFSET_X     40

@interface OTSProductDtTab2View ()
{
    CGRect        defaultRects[4];
    CGRect        longRects[3];
    CGRect        labelRects[4];
    CGRect        imageRects[4];
}
@end

@implementation OTSProductDtTab2View
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [_tabViewSameCate release];
    [_tabViewPromotion release];
    [_tabViewComment release];
    [_tabViewProfile release];
    [_btnSameCate release];
    [_btnPromotion release];
    [_btnComment release];
    [_btnProfile release];
    [_labelSameCate release];
    [_labelPromotion release];
    [_labelComment release];
    [_labelProfile release];
    [_imageViewSameCate release];
    [_imageViewPromotion release];
    [_imageViewComment release];
    [_imageViewProfile release];
    
    [super dealloc];
}

-(void)awakeFromNib
{
    [self selectTabIndex:kPadProdDetailTabDescription];
    
    UIImage *unselImg = [UIImage imageNamed:@"pdTabNormal"];
    UIImage *unselStretchImg = [unselImg stretchableImageWithLeftCapWidth:10.f topCapHeight:0.f];
    
    UIImage *pushedImg = [UIImage imageNamed:@"pdTabPushed"];
    UIImage *pushedStretchImg = [pushedImg stretchableImageWithLeftCapWidth:10.f topCapHeight:0.f];
    
    UIImage *selImg = [UIImage imageNamed:@"pdTabSelected"];
    UIImage *selStretchImg = [selImg stretchableImageWithLeftCapWidth:10.f topCapHeight:0.f];
    
#if 1
    [self.btnProfile setBackgroundImage:unselStretchImg forState:UIControlStateNormal];
    [self.btnComment setBackgroundImage:unselStretchImg forState:UIControlStateNormal];
    [self.btnPromotion setBackgroundImage:unselStretchImg forState:UIControlStateNormal];
    [self.btnSameCate setBackgroundImage:unselStretchImg forState:UIControlStateNormal];
    
    [self.btnProfile setBackgroundImage:pushedStretchImg forState:UIControlStateHighlighted];
    [self.btnProfile setBackgroundImage:selStretchImg forState:UIControlStateSelected];
    
    [self.btnComment setBackgroundImage:pushedStretchImg forState:UIControlStateHighlighted];
    [self.btnComment setBackgroundImage:selStretchImg forState:UIControlStateSelected];
    
    [self.btnPromotion setBackgroundImage:pushedStretchImg forState:UIControlStateHighlighted];
    [self.btnPromotion setBackgroundImage:selStretchImg forState:UIControlStateSelected];
    
    [self.btnSameCate setBackgroundImage:pushedStretchImg forState:UIControlStateHighlighted];
    [self.btnSameCate setBackgroundImage:selStretchImg forState:UIControlStateSelected];
#else
    [self.btnProfile setImage:unselStretchImg forState:UIControlStateNormal];
    [self.btnComment setImage:unselStretchImg forState:UIControlStateNormal];
    [self.btnPromotion setImage:unselStretchImg forState:UIControlStateNormal];
    [self.btnSameCate setImage:unselStretchImg forState:UIControlStateNormal];
    
    [self.btnProfile setImage:pushedStretchImg forState:UIControlStateHighlighted];
    [self.btnProfile setImage:selStretchImg forState:UIControlStateSelected];
    
    [self.btnComment setImage:pushedStretchImg forState:UIControlStateHighlighted];
    [self.btnComment setImage:selStretchImg forState:UIControlStateSelected];
    
    [self.btnPromotion setImage:pushedStretchImg forState:UIControlStateHighlighted];
    [self.btnPromotion setImage:selStretchImg forState:UIControlStateSelected];
    
    [self.btnSameCate setImage:pushedStretchImg forState:UIControlStateHighlighted];
    [self.btnSameCate setImage:selStretchImg forState:UIControlStateSelected];
#endif
    
    //
    labelRects[0] = self.labelProfile.frame;
    labelRects[1] = self.labelComment.frame;
    labelRects[2] = self.labelPromotion.frame;
    labelRects[3] = self.labelSameCate.frame;
    
    //
    imageRects[0] = self.imageViewProfile.frame;
    imageRects[1] = self.imageViewComment.frame;
    imageRects[2] = self.imageViewPromotion.frame;
    imageRects[3] = self.imageViewSameCate.frame;
    
    // 计算矩形
    float thisLength = self.frame.size.width - 40;
    float singleRectLen = (thisLength + OVERLAP_LEN * 3) / 4;
    
    // 默认矩形
    CGRect unitRect = CGRectMake(0, 0, singleRectLen, self.frame.size.height);
    defaultRects[0] = unitRect;
    for (int i = 1; i < 4; i++)
    {
        unitRect = CGRectOffset(unitRect, singleRectLen - OVERLAP_LEN, 0);
        defaultRects[i] = unitRect;
    }
    
    // 长矩形
    singleRectLen = (thisLength + OVERLAP_LEN * 2) / 3;
    unitRect = CGRectMake(0, 0, singleRectLen, self.frame.size.height);
    longRects[0] = unitRect;
    for (int i = 1; i < 3; i++)
    {
        unitRect = CGRectOffset(unitRect, singleRectLen - OVERLAP_LEN, 0);
        longRects[i] = unitRect;
    }
    
    [self hidePromotionTab:YES];

}

-(IBAction)tabClicked:(id)sender
{
    if (sender == self.btnProfile)
    {
        [self selectTabIndex:kPadProdDetailTabDescription];
    }
    
    else if (sender == self.btnComment)
    {
        [MobClick event:@"click_comment"];
        [self selectTabIndex:kPadProdDetailTabComment];
    }
    
    else if (sender == self.btnPromotion)
    {
        [MobClick event:@"click_promo"];
        [self selectTabIndex:kPadProdDetailTabPromotion];
    }
    
    else if (sender == self.btnSameCate)
    {
        [MobClick event:@"click_reference"];
        [self selectTabIndex:kPadProdDetailTabSameCate];
    }
}

-(void)selectTabIndex:(int)aTabIndex
{
    UIColor *defaultColor = [UIColor blackColor];
    UIColor *selectedColor = [UIView colorFromRGB:0xCC0000];
    
    self.btnProfile.selected = NO;
    self.btnComment.selected = NO;
    self.btnPromotion.selected = NO;
    self.btnSameCate.selected = NO;
    
    self.labelProfile.textColor = defaultColor;
    self.labelComment.textColor = defaultColor;
    self.labelPromotion.textColor = defaultColor;
    self.labelSameCate.textColor = defaultColor;
    
    self.imageViewProfile.image = [UIImage imageNamed:@"pdTabProfileNoramal"];
    self.imageViewComment.image = [UIImage imageNamed:@"pdTabCommendNormal"];
    self.imageViewPromotion.image = [UIImage imageNamed:@"pdTabPromitonNormal"];
    self.imageViewSameCate.image = [UIImage imageNamed:@"pdTabSameCateNormal"];
    
    switch (aTabIndex)
    {
        case kPadProdDetailTabDescription:
        {
            [self bringSubviewToFront:self.tabViewProfile];
            self.btnProfile.selected = YES;
            self.labelProfile.textColor = selectedColor;
            
            self.imageViewProfile.image = [UIImage imageNamed:@"pdTabProfileSelected"];
        }
            break;
            
        case kPadProdDetailTabComment:
        {
            [self bringSubviewToFront:self.tabViewComment];
            self.btnComment.selected = YES;
            self.labelComment.textColor = selectedColor;
            
            self.imageViewComment.image = [UIImage imageNamed:@"pdTabCommendSelected"];
        }
            break;
            
        case kPadProdDetailTabPromotion:
        {
            [self bringSubviewToFront:self.tabViewPromotion];
            self.btnPromotion.selected = YES;
            self.labelPromotion.textColor = selectedColor;
            
            self.imageViewPromotion.image = [UIImage imageNamed:@"pdTabPromitonSelected"];
        }
            break;
            
        case kPadProdDetailTabSameCate:
        {
            [self bringSubviewToFront:self.tabViewSameCate];
            self.btnSameCate.selected = YES;
            self.labelSameCate.textColor = selectedColor;
            
            self.imageViewSameCate.image = [UIImage imageNamed:@"pdTabSameCateSelected"];
        }
            break;
            
        default:
            break;
    }
    
    [self.delegate tabTappedWithIndex:aTabIndex];
}

-(void)hidePromotionTab:(BOOL)aIsHide
{
    self.tabViewPromotion.hidden = aIsHide;
    
    if (self.tabViewPromotion.hidden)
    {
        self.tabViewProfile.frame = longRects[0];
        self.btnProfile.frame = self.tabViewProfile.bounds;
        self.labelProfile.frame = CGRectOffset(labelRects[0], CHANGE_OFFSET_X, 0);
        self.imageViewProfile.frame = CGRectOffset(imageRects[0], CHANGE_OFFSET_X, 0);
        
        self.tabViewComment.frame = longRects[1];
        self.btnComment.frame = self.tabViewComment.bounds;
        self.labelComment.frame = CGRectOffset(labelRects[1], CHANGE_OFFSET_X, 0);
        self.imageViewComment.frame = CGRectOffset(imageRects[1], CHANGE_OFFSET_X, 0);
        
        self.tabViewSameCate.frame = longRects[2];
        self.btnSameCate.frame = self.tabViewSameCate.bounds;
        self.labelSameCate.frame = CGRectOffset(labelRects[3], CHANGE_OFFSET_X, 0);
        self.imageViewSameCate.frame = CGRectOffset(imageRects[3], CHANGE_OFFSET_X, 0);
    }
    else
    {
        self.tabViewProfile.frame = defaultRects[0];
        self.btnProfile.frame = self.tabViewProfile.bounds;
        self.labelProfile.frame = labelRects[0];
        self.imageViewProfile.frame = imageRects[0];
        
        self.tabViewComment.frame = defaultRects[1];
        self.btnComment.frame = self.tabViewComment.bounds;
        self.labelComment.frame = labelRects[1];
        self.imageViewComment.frame = imageRects[1];
        
        self.tabViewPromotion.frame = defaultRects[2];
        self.btnPromotion.frame = self.tabViewPromotion.bounds;
        self.labelPromotion.frame = labelRects[2];
        self.imageViewPromotion.frame = imageRects[2];
        
        self.tabViewSameCate.frame = defaultRects[3];
        self.btnSameCate.frame = self.tabViewSameCate.bounds;
        self.labelSameCate.frame = labelRects[3];
        self.imageViewSameCate.frame = imageRects[3];
    }
}

@end
