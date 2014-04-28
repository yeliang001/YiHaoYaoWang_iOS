//
//  UIView+LayerEffect.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//

#import "UIView+LayerEffect.h"

@implementation UIView(LayerEffect)

+(void)applyShadowToView:(UIView*)aView
{
    [self applyEffectToView:aView
                  hasShadow:YES
                    opacity:1.f
                borderWidth:0
                borderColor:nil
               cornerRadius:0];
}

+(void)applyMenuEffectToView:(UIView*)aView
{
    [self applyEffectToView:aView
                  hasShadow:NO
                    opacity:.5f
                borderWidth:1
                borderColor:[UIColor whiteColor]
               cornerRadius:3];
}

+(void)applyShadowAndBorderToView:(UIView*)aView
{
    [self applyShadowAndBorderToView:aView borderColor:[UIColor whiteColor]];
}

+(void)applyShadowAndBorderToView:(UIView*)aView corner:(float)aCornerRadius
{
    [self applyShadowAndBorderToView:aView borderColor:[UIColor whiteColor] corner:aCornerRadius];
}

+(void)applyShadowAndBorderToView:(UIView*)aView borderColor:(UIColor*)aColor
{
    [self applyShadowAndBorderToView:aView borderColor:aColor corner:0];
}

+(void)applyShadowAndBorderToView:(UIView*)aView
                      borderColor:(UIColor*)aColor
                           corner:(float)aCornerRadius
{
    [self applyEffectToView:aView
                  hasShadow:YES
                    opacity:1.f
                borderWidth:.5f
                borderColor:aColor
               cornerRadius:aCornerRadius];
}



+(void)applyEffectToView:(UIView*)aView
               hasShadow:(BOOL)aHasShadow
                 opacity:(float)anOpacity
             borderWidth:(float)aBorderWidth
             borderColor:(UIColor*)aBorderColor
            cornerRadius:(float)aCornerRadius
{
    if (aView)
    {
        aView.layer.cornerRadius = aCornerRadius;
        
        aView.layer.borderWidth = aBorderWidth;
        aView.layer.borderColor = aBorderColor.CGColor;
        
        aView.layer.opacity = anOpacity;
        
        if (aHasShadow)
        {
            aView.clipsToBounds = NO;
            aView.layer.shadowOpacity = .3f;
            aView.layer.shadowOffset = CGSizeMake(2, 2);
            aView.layer.shadowRadius = 2.f;
            aView.layer.shadowColor = [UIColor blackColor].CGColor;
        }
    }
}

+(UIColor*)colorFromRGB:(int)aRGBValue
{
    float red = ((float)((aRGBValue & 0xFF0000) >> 16)) / 255.0;
    float green = ((float)((aRGBValue & 0xFF00) >> 8))/255.0;
    float blue = ((float)(aRGBValue & 0xFF))/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

-(void)applyBorderWithWidth:(int)aWidth color:(UIColor*)aColor
{
    self.layer.borderWidth = aWidth;
    aColor = aColor ? aColor : [UIColor lightGrayColor];
    self.layer.borderColor = aColor.CGColor;
}

@end
