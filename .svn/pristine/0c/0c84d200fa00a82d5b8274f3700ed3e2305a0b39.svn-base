//
//  OTSProductImagesView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSProductImagesView.h"
#import "ProductVO.h"
#import "OTSUtility.h"
#import "SDImageView+SDWebCache.h"
#import "OTSImageView.h"
#import "ProductInfo.h"
@implementation OTSProductImagesView

-(id)initWithFrame:(CGRect)frame productVO:(ProductInfo *)productVO
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        [self setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0]];
        //上渐变色
        CAGradientLayer *gradientLayer=[[CAGradientLayer alloc] init];
        [gradientLayer setFrame:CGRectMake(0, 0, 320, 4)];
        [gradientLayer setColors:[NSArray arrayWithObjects: (id)[[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0] CGColor], nil]];
        [gradientLayer setStartPoint:CGPointMake(0.5,0.0)];
        [gradientLayer setEndPoint:CGPointMake(0.5,1.0)];
        [self.layer addSublayer:gradientLayer];
        [gradientLayer release];
        
        //下渐变色
        gradientLayer=[[CAGradientLayer alloc] init];
        [gradientLayer setFrame:CGRectMake(0, 186, 320, 4)];
        [gradientLayer setColors:[NSArray arrayWithObjects: (id)[[UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor], nil]];
        [gradientLayer setStartPoint:CGPointMake(0.5,0.0)];
        [gradientLayer setEndPoint:CGPointMake(0.5,1.0)];
        [self.layer addSublayer:gradientLayer];
        [gradientLayer release];
        
        //商品图片
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        [scrollView release];
        
        CGFloat xValue=80.0;
        int i;
        for (i=0; i<[productVO.middleDetailImgList count]; i++)
        {
            OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, 15.0, 160, 160)];
            [imageView.layer setBorderWidth:1.0];
            [imageView.layer setBorderColor:[[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0] CGColor]];
            NSString *urlString=[OTSUtility safeObjectAtIndex:i inArray:productVO.middleDetailImgList];
            [imageView loadImgUrl:urlString];
            [scrollView addSubview:imageView];
            [imageView release];
            xValue+=180.0;
        }
        [scrollView setContentSize:CGSizeMake(xValue+60, frame.size.height)];
    }
    return self;
}

@end
