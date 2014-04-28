//
//  CartAnimation.m
//  TheStoreApp
//
//  Created by zhengchen on 11-12-3.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import "CartAnimation.h"

#define cartAnimationBootHeight ApplicationHeight-50
#define cartAnimationXposition  ApplicationWidth/5*2


@implementation CartAnimation
@synthesize delegate;

-(id)init:(UIView *)view
{
    self=[super init];
    if (self) {
        m_AnimationView=[view retain];
        m_ProductImgView=[[UIImageView alloc] initWithFrame:CGRectMake(155,100,5,5)];
        m_CartImgView=[[UIImageView alloc] initWithFrame:CGRectMake(320, 356, 64, 60)];
    }
    return self;
}

-(void)commitCartAnimations
{
    [UIView commitAnimations];
}
-(void)beginCartAnimationWithProductImageView:(UIImageView*)imageV point:(CGPoint)orignPoint{
    
    [m_AnimationView addSubview:imageV];
    [m_AnimationView bringSubviewToFront:imageV];
    [imageV setFrame:CGRectMake(orignPoint.x-10, orignPoint.y-10, 60, 60)];
    
    [UIView animateWithDuration:0.5f animations:^{
        [imageV setFrame:CGRectMake(cartAnimationXposition, cartAnimationBootHeight, 60, 60)];
    }completion:^(BOOL finished){
        [imageV removeFromSuperview];
    }];
}

-(void)beginAnimation:(UIImage *)image {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    [m_ProductImgView setAlpha:0.1f];
    [m_ProductImgView setImage:image];
    [m_ProductImgView setFrame:CGRectMake(155,100,5,5)];
    [m_AnimationView addSubview:m_ProductImgView];
	
	[m_CartImgView setImage:[UIImage imageNamed:@"driveCarLeft.png"]];
    [m_CartImgView setFrame:CGRectMake(320, 356, 64, 60)];
    [m_AnimationView addSubview:m_CartImgView];
    
	[m_AnimationView bringSubviewToFront:m_ProductImgView];
	[m_AnimationView bringSubviewToFront:m_CartImgView];
    
    [NSThread sleepForTimeInterval:0.1];
	[self otsDetatchMemorySafeNewThreadSelector:@selector(productAnimationStep1) toTarget:self withObject:nil];
    [pool drain];
}

-(void)productAnimationStep1 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    [m_AnimationView bringSubviewToFront:m_CartImgView];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationRepeatAutoreverses:NO];
	[m_ProductImgView setAlpha:1.0f];
	[m_ProductImgView setFrame:CGRectMake(128, 73, 60, 60)];
	[m_CartImgView setFrame:CGRectMake(192, 356, 64, 60)];
	[m_AnimationView bringSubviewToFront:m_ProductImgView];
	[self performSelectorOnMainThread:@selector(commitCartAnimations) withObject:nil waitUntilDone:NO];
	
    [NSThread sleepForTimeInterval:0.1];
    
    [self otsDetatchMemorySafeNewThreadSelector:@selector(productAnimationStep2) toTarget:self withObject:nil ];
    [pool drain];
}

-(void)productAnimationStep2 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	[m_AnimationView bringSubviewToFront:m_ProductImgView];
	[m_AnimationView bringSubviewToFront:m_CartImgView];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5f];  
	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 	 
	[UIView setAnimationRepeatAutoreverses:NO];	 
	[NSThread sleepForTimeInterval:0.5];
	[m_AnimationView sendSubviewToBack:m_ProductImgView];
	[m_ProductImgView setFrame:CGRectMake(210, 356, 35, 35)];
	[self performSelectorOnMainThread:@selector(commitCartAnimations) withObject:nil waitUntilDone:NO];
	
    [NSThread sleepForTimeInterval:0.1];
	[self otsDetatchMemorySafeNewThreadSelector:@selector(productAnimationStep3) toTarget:self withObject:nil ];
    [pool drain];
}

-(void)productAnimationStep3 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	[m_AnimationView bringSubviewToFront:m_ProductImgView];
	[m_AnimationView bringSubviewToFront:m_CartImgView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_CartImgView cache:NO];
	[m_CartImgView setImage:[UIImage imageNamed:@"driveCarRight.png"]];
	[self performSelectorOnMainThread:@selector(commitCartAnimations) withObject:nil waitUntilDone:NO];
    [NSThread sleepForTimeInterval:0.1];
	[self otsDetatchMemorySafeNewThreadSelector:@selector(productAnimationStep4) toTarget:self withObject:nil];
	[pool drain];
}

-(void)productAnimationStep4 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    [m_AnimationView bringSubviewToFront:m_ProductImgView];
    [m_AnimationView bringSubviewToFront:m_CartImgView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];  
    [UIView setAnimationCurve:UIViewAnimationCurveLinear]; 	  
    [UIView setAnimationRepeatAutoreverses:NO];	 
    [NSThread sleepForTimeInterval:0.5];
    [m_CartImgView setFrame:CGRectMake(320, 356, 64, 60)];
    
    [m_ProductImgView removeFromSuperview];
    
    [self performSelectorOnMainThread:@selector(commitCartAnimations) withObject:nil waitUntilDone:NO];
    [NSThread sleepForTimeInterval:0.1];
    
    [self otsDetatchMemorySafeNewThreadSelector:@selector(productAnimationStep5) toTarget:self withObject:nil];
    [pool drain];
}

-(void)productAnimationStep5 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];  
	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 	  
	[UIView setAnimationRepeatAutoreverses:NO];	 
	[NSThread sleepForTimeInterval:0.5];
	[m_CartImgView setFrame:CGRectMake(320, 356, 64, 60)];
    
    [m_CartImgView removeFromSuperview];
	
	[self performSelectorOnMainThread:@selector(commitCartAnimations) withObject:nil waitUntilDone:NO];
    [NSThread sleepForTimeInterval:0.1];
    [self.delegate animationFinished];
    [pool drain];
}

-(void)beginPackageAnimation:(UIImage *)image1 image:(UIImage *) image2 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    m_ProductImgView=[[UIImageView alloc]initWithFrame:CGRectMake(50,100,5,5)];
	[m_ProductImgView setAlpha:0.1f];
	[m_ProductImgView setImage:image1];
    [m_AnimationView addSubview:m_ProductImgView];
    [m_ProductImgView release];
    
    m_PackageImgView=[[UIImageView alloc]initWithFrame:CGRectMake(150,100,5,5)];
    [m_PackageImgView setAlpha:0.1f];
    [m_PackageImgView setImage:image2];
    [m_AnimationView addSubview:m_PackageImgView];
    [m_PackageImgView release];
    
	m_CartImgView=[[UIImageView alloc]initWithFrame:CGRectMake(320, 356, 64, 60)];
	[m_CartImgView setImage:[UIImage imageNamed:@"driveCarLeft.png"]];
    [m_AnimationView addSubview:m_CartImgView];
    [m_CartImgView release];
	
	[m_AnimationView bringSubviewToFront:m_ProductImgView];
    [m_AnimationView bringSubviewToFront:m_PackageImgView];
	[m_AnimationView bringSubviewToFront:m_CartImgView];
    
    [NSThread sleepForTimeInterval:0.1];
	[self otsDetatchMemorySafeNewThreadSelector:@selector(packageAnimationStep1) toTarget:self withObject:nil ];
    [pool drain];
}

-(void)packageAnimationStep1 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	[m_AnimationView bringSubviewToFront:m_CartImgView];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];  
	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 	 
	[UIView setAnimationRepeatAutoreverses:NO];	 
	[m_ProductImgView setAlpha:1.0f];
	[m_ProductImgView setFrame:CGRectMake(28, 73, 60, 60)];
    
	[m_PackageImgView setAlpha:1.0f];
	[m_PackageImgView setFrame:CGRectMake(128, 73, 60, 60)];
    
	[m_CartImgView setFrame:CGRectMake(192, 356, 64, 60)];
	[m_AnimationView bringSubviewToFront:m_ProductImgView];
    [m_AnimationView bringSubviewToFront:m_PackageImgView];
	[UIView commitAnimations];
	
    [NSThread sleepForTimeInterval:0.1];
    
    [self otsDetatchMemorySafeNewThreadSelector:@selector(packageAnimationStep2) toTarget:self withObject:nil ];
    [pool drain];
	
}

-(void)packageAnimationStep2 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	[m_AnimationView bringSubviewToFront:m_ProductImgView];
    [m_AnimationView bringSubviewToFront:m_PackageImgView];
    [m_AnimationView bringSubviewToFront:m_CartImgView];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5f];  
	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 	 
	[UIView setAnimationRepeatAutoreverses:NO];	 
	[NSThread sleepForTimeInterval:0.5];
	[m_AnimationView sendSubviewToBack:m_ProductImgView];
    [m_AnimationView sendSubviewToBack:m_PackageImgView];
	[m_ProductImgView setFrame:CGRectMake(210, 356, 35, 35)];
    [m_PackageImgView setFrame:CGRectMake(210, 356, 35, 35)];
	[UIView commitAnimations];
	
    [NSThread sleepForTimeInterval:0.1];
	[self otsDetatchMemorySafeNewThreadSelector:@selector(packageAnimationStep3) toTarget:self withObject:nil ];
    [pool drain];
}

-(void)packageAnimationStep3 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	[m_AnimationView bringSubviewToFront:m_ProductImgView];
    [m_AnimationView bringSubviewToFront:m_PackageImgView];
	[m_AnimationView bringSubviewToFront:m_CartImgView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_CartImgView cache:NO];
	[m_CartImgView setImage:[UIImage imageNamed:@"driveCarRight.png"]];
	[UIView commitAnimations];
    [NSThread sleepForTimeInterval:0.1];
	[self otsDetatchMemorySafeNewThreadSelector:@selector(packageAnimationStep4) toTarget:self withObject:nil];
	[pool drain];
}

-(void)packageAnimationStep4 {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    [m_AnimationView bringSubviewToFront:m_ProductImgView];
    [m_AnimationView bringSubviewToFront:m_PackageImgView];
    [m_AnimationView bringSubviewToFront:m_CartImgView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatAutoreverses:NO];
    [NSThread sleepForTimeInterval:0.5];
    [m_CartImgView setFrame:CGRectMake(320, 356, 64, 60)];
    
    [m_ProductImgView removeFromSuperview];
    [m_PackageImgView removeFromSuperview];
    [UIView commitAnimations];
    [NSThread sleepForTimeInterval:0.1];
    [self.delegate animationFinished];
    [self otsDetatchMemorySafeNewThreadSelector:@selector(productAnimationStep5) toTarget:self withObject:nil];
    [pool drain];
}

-(void)dealloc
{
    if (m_ProductImgView!=nil) {
        [m_ProductImgView release];
        m_ProductImgView=nil;
    }
    if (m_CartImgView!=nil) {
        [m_CartImgView release];
        m_CartImgView=nil;
    }
    OTS_SAFE_RELEASE(m_AnimationView);
    [super dealloc];
}

@end
