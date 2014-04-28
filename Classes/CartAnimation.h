//
//  CartAnimation.h
//  TheStoreApp
//
//  Created by zhengchen on 11-12-3.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartAnimationDelegate;

@interface CartAnimation : NSObject{
    id <CartAnimationDelegate> delegate;
    UIView *m_AnimationView;
    UIImageView *m_ProductImgView;
    UIImageView *m_CartImgView;
    UIImageView *m_PackageImgView;
}

@property (nonatomic, assign) id <CartAnimationDelegate> delegate;
-(id) init:(UIView *) view;
-(void) beginAnimation:(UIImage *)image;
-(void) beginPackageAnimation:(UIImage *)image1 image:(UIImage *) image2;
-(void)beginCartAnimationWithProductImageView:(UIImageView*)imageV point:(CGPoint)orignPoint;
@end

@protocol CartAnimationDelegate <NSObject>
    -(void) animationFinished ;
@end