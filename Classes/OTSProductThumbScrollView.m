//
//  OTSProductThumbScrollView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSProductThumbScrollView.h"
#import "OrderItemVO.h"
#import "ProductVO.h"
#import "DataController.h"
#import <QuartzCore/QuartzCore.h>
#import "OTSChachedImageView.h"
#import "OTSUtility.h"
//#import " "

#define SELF_WIDTH      300
#define SELF_HEIGHT     50

@implementation OTSProductThumbScrollView
@synthesize orderItems, scrollView;

+(int)myHeight
{
    return SELF_HEIGHT;
}

-(NSMutableArray*)orderItems
{
    return orderItems;
}

-(void)setOrderItems:(NSMutableArray *)aOrderItems
{
    orderItems = aOrderItems;
    
    for (UIView* sub in scrollView.subviews)
    {
        [sub removeFromSuperview];
    }
    
    CGRect scrollRect = self.bounds;
    scrollRect.origin.x += 20;
    scrollRect.size.width -= 40;
    
    int offsetX = 0;
    for (int i = 0; i < [orderItems count]; i ++)
    {
        OrderItemVO* orderItem = [orderItems objectAtIndex:i];
        if (orderItem && orderItem.product)
        {
            offsetX += 10;
            
            
            CGRect imageRect = CGRectMake(offsetX
                                          , (scrollRect.size.height - 40) / 2
                                          , 40
                                          , 40);
            
            UIImageView* iv = [[[UIImageView alloc] initWithFrame:imageRect] autorelease];
            
            UIImage* img = [OTSUtility miniImageForProduct:orderItem.product];
            iv.image = img;
            
//            OTSProductImageView* iv = [[[OTSProductImageView alloc] initWithFrame:imageRect productId:orderItem.product.productId defaultImage:[UIImage imageNamed:OTS_DEFAULT_PRODUCT_IMG]] autorelease];
            
            iv.backgroundColor = [UIColor redColor];
            iv.layer.cornerRadius = 2;
            iv.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //iv.layer.borderWidth = 1;
            [scrollView addSubview:iv];
            
            offsetX += imageRect.size.width;
        }
    }
    
    offsetX += 10;
    scrollView.contentSize = CGSizeMake(offsetX, scrollView.frame.size.height);
}

#pragma mark - 
-(void)leftArrowAction
{
    if (scrollView.contentSize.width > scrollView.frame.size.width 
        && scrollView.contentOffset.x > 0)
    {
        int newOffsetX = scrollView.contentOffset.x - 50;
        newOffsetX -= newOffsetX % 50;
        
        newOffsetX = newOffsetX > 0 ? newOffsetX : 0;

        scrollView.contentOffset = CGPointMake(newOffsetX, scrollView.contentOffset.y);
    }
}

-(void)rightArrowAction
{
    if (scrollView.contentSize.width > scrollView.frame.size.width 
        && scrollView.contentOffset.x < scrollView.contentSize.width - scrollView.frame.size.width)
    {
        int newOffsetX = scrollView.contentOffset.x + 50;
        newOffsetX -= newOffsetX % 50;
        
        newOffsetX = newOffsetX < scrollView.contentSize.width - scrollView.frame.size.width ? newOffsetX : scrollView.contentSize.width - scrollView.frame.size.width;
        
        scrollView.contentOffset = CGPointMake(newOffsetX, scrollView.contentOffset.y);
    }
}


#pragma mark -
-(void)assembleScrollView
{
    CGRect scrollRect = self.bounds;
    scrollRect.origin.x += 20;
    scrollRect.size.width -= 40;
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:scrollRect] autorelease];
    scrollView.backgroundColor = [UIColor whiteColor];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:scrollView];
    
    // leftBtn
    UIButton* leftArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* arrow_image_normal = [UIImage imageNamed:@"mf_arrow_left_normal"];
    UIImage* arrow_image_pushed = [UIImage imageNamed:@"mf_arrow_left_pushed"];
    
    leftArrowBtn.frame = CGRectMake(10
                                    , (self.frame.size.height - arrow_image_normal.size.height) / 2
                                    , arrow_image_normal.size.width
                                    , arrow_image_normal.size.height);
    
    [leftArrowBtn setBackgroundImage:arrow_image_normal forState:UIControlStateNormal];
    [leftArrowBtn setBackgroundImage:arrow_image_pushed forState:UIControlStateHighlighted];
    [leftArrowBtn addTarget:self action:@selector(leftArrowAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftArrowBtn];
    
    // rightBtn
    UIButton* rightArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    arrow_image_normal = [UIImage imageNamed:@"mf_arrow_right_normal"];
    arrow_image_pushed = [UIImage imageNamed:@"mf_arrow_right_pushed"];
    rightArrowBtn.frame = CGRectMake(self.frame.size.width - arrow_image_normal.size.width - 10
                                     , leftArrowBtn.frame.origin.y
                                     , arrow_image_normal.size.width
                                     , arrow_image_normal.size.height);
    
    [rightArrowBtn setBackgroundImage:arrow_image_normal forState:UIControlStateNormal];
    [rightArrowBtn setBackgroundImage:arrow_image_pushed forState:UIControlStateHighlighted];
    [rightArrowBtn addTarget:self action:@selector(rightArrowAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightArrowBtn];
}

-(void)assembleSubViews
{
    [self assembleScrollView];
}

-(id)initWithPos:(CGPoint)aPos
{
    self = [super initWithFrame:CGRectMake(aPos.x, aPos.y, SELF_WIDTH, SELF_HEIGHT)];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self assembleSubViews];
    }
    return self;
}


-(void)dealloc
{
    [scrollView release];
    
    [super dealloc];
}

@end
