//
//  OTSInterestedProducts.m
//  TheStoreApp
//
//  Created by jiming huang on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSInterestedProducts.h"
#import "ProductService.h"
#import "GlobalValue.h"
#import "SDImageView+SDWebCache.h"
#import "OTSUtility.h"
#import "StrikeThroughLabel.h"
#import "OTSImageView.h"
@implementation OTSInterestedProducts

-(id)initWithFrame:(CGRect)frame productVO:(ProductVO *)productVO delegate:(id<OTSInterestedProductsDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        [self performInThreadBlock:^{
            NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
            ProductService *pServ=[[[ProductService alloc] init] autorelease];
            Page *tempPage=[pServ getMoreInterestedProducts:[GlobalValue getGlobalValueInstance].trader productId:productVO.productId provinceId:[GlobalValue getGlobalValueInstance].provinceId currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:10]];
            if (m_Array!=nil) {
                [m_Array release];
            }
            if (tempPage!=nil && [tempPage objList]!=nil && [[tempPage objList] count]>0) {
                m_Array=[[tempPage objList] retain];
            } else {
                m_Array=nil;
            }
            [pool drain];
        }completionInMainBlock:^{
            if (m_Array!=nil) {
                m_Delegate=delegate;
                
                [self.layer setBorderWidth:1.0];
                [self.layer setBorderColor:[[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0] CGColor]];
                
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(15, 15, 290, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:@"您可能感兴趣的"];
                [label setFont:[UIFont systemFontOfSize:15.0]];
                [self addSubview:label];
                [label release];
                
                UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, 185)];
                [self addSubview:scrollView];
                [scrollView release];
                CGFloat xValue=10.0;
                int i;
                for (i=0; i<[m_Array count]; i++) {
                    ProductVO *vo=[OTSUtility safeObjectAtIndex:i inArray:m_Array];
                    //商品图片
                    OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, 5, 80, 80)];
                    [imageView setTag:200+i];
                    [imageView.layer setBorderWidth:1.0];
                    [imageView.layer setBorderColor:[[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0] CGColor]];
                    [imageView loadImgUrl:vo.miniDefaultProductUrl];
                    //                    [imageView setImageWithURL:[NSURL URLWithString:vo.miniDefaultProductUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"img_default.png"]];
                    [imageView setUserInteractionEnabled:YES];
                    [scrollView addSubview:imageView];
                    [imageView release];
                    //手势处理
                    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                    [imageView addGestureRecognizer:tapGes];
                    [tapGes release];
                    //商品名称
                    label=[[UILabel alloc] initWithFrame:CGRectMake(xValue, 90, 80, 40)];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setTag:200+i];
                    [label setNumberOfLines:2];
                    [label setText:vo.cnName];
                    [label setFont:[UIFont systemFontOfSize:15.0]];
                    [label setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];

                    [scrollView addSubview:label];
                    [label release];
                    //价格
                    label=[[UILabel alloc] initWithFrame:CGRectMake(xValue, 130, 80, 20)];
                    [label setBackgroundColor:[UIColor clearColor]];
                    if (vo.promotionId!=nil && ![vo.promotionId isEqualToString:@""]) {
                        [label setText:[NSString stringWithFormat:@"￥%.2f",[vo.promotionPrice doubleValue]]];
                    } else {
                        [label setText:[NSString stringWithFormat:@"￥%.2f",[vo.price doubleValue]]];
                    }
                    [label setFont:[UIFont systemFontOfSize:15.0]];
                    [label setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
                    [scrollView addSubview:label];
                    [label release];
                    //市场价
                    if (vo.promotionId!=nil && ![vo.promotionId isEqualToString:@""]) {
                        StrikeThroughLabel *sLabel=[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(xValue, 150, 80, 20)];
                        [sLabel setBackgroundColor:[UIColor clearColor]];
                        [sLabel setText:[NSString stringWithFormat:@"￥%.2f",[vo.price doubleValue]]];
                        [sLabel setFont:[UIFont systemFontOfSize:15.0]];
                        [sLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
                        [scrollView addSubview:sLabel];
                        [sLabel release];
                    }
                    
                    UIButton* b=[UIButton buttonWithType:UIButtonTypeCustom];
                    b.tag=200+i;
                    [b addTarget:self action:@selector(bClick:) forControlEvents:UIControlEventTouchUpInside];
                    b.backgroundColor=[UIColor clearColor];
                    b.frame=CGRectMake(xValue, 90, 80, 60);
                    [scrollView addSubview:b];
                    xValue+=110.0;
                }
                [scrollView setContentSize:CGSizeMake(xValue-20.0, 180.0)];
            } else {
                [self setFrame:CGRectMake(0, self.frame.origin.y, 320, 0)];
                if ([m_Delegate respondsToSelector:@selector(interestedProductIsNull:)]) {
                    [m_Delegate interestedProductIsNull:self];
                }
            }
        }];
    }
    return self;
}
-(void)bClick:(UIButton*)btn{
    int index=btn.tag-200;
    ProductVO *vo=[OTSUtility safeObjectAtIndex:index inArray:m_Array];
    if ([m_Delegate respondsToSelector:@selector(interestedProductClicked:)]) {
        [m_Delegate performSelector:@selector(interestedProductClicked:) withObject:vo];
    }
}

-(void)handleTap:(UIPanGestureRecognizer*)gestureRecognizer
{
    UIView *view=gestureRecognizer.view;
    int index=view.tag-200;
    ProductVO *vo=[OTSUtility safeObjectAtIndex:index inArray:m_Array];
    if ([m_Delegate respondsToSelector:@selector(interestedProductClicked:)]) {
        [m_Delegate performSelector:@selector(interestedProductClicked:) withObject:vo];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_Array);
    [super dealloc];
}

@end
