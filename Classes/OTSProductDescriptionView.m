//
//  OTSProductDescriptionView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSProductDescriptionView.h"
#import "OTSNaviAnimation.h"
#import "ProductInfo.h"
@implementation OTSProductDescriptionView

-(id)initWithFrame:(CGRect)frame productVO:(ProductInfo *)productVO
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [imageView setImage:[UIImage imageNamed:@"title_bg.png"]];
        [self addSubview:imageView];
        [imageView release];
        
        UIButton *returnBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 44)];
        [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
        [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
        [returnBtn addTarget:self action:@selector(returnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:returnBtn];
        [returnBtn release];
        
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 44)];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setText:@"商品描述"];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:20.0]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setShadowColor:[UIColor darkGrayColor]];
        [title setShadowOffset:CGSizeMake(1, -1)];
        [self addSubview:title];
        [title release];
        
        //商品名称
        UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 40)];
        [name setText:productVO.name];
        [name setFont:[UIFont systemFontOfSize:15.0]];
        [self addSubview:name];
        [name release];
        
        //1号价
        UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 90, 100, 20)];
        [priceLabel setText:@"1号药店价："];
        [priceLabel setFont:[UIFont systemFontOfSize:15.0]];
        [self addSubview:priceLabel];
        [priceLabel release];
        
        UILabel *price=[[UILabel alloc] initWithFrame:CGRectMake(90, 90, 120, 20)];
//        if (productVO.promotionId!=nil && ![productVO.promotionId isEqualToString:@""]) {
//            [price setText:[NSString stringWithFormat:@"￥%.2f",[productVO.promotionPrice doubleValue]]];
//        } else {
            [price setText:[NSString stringWithFormat:@"￥%.2f",[productVO.price doubleValue]]];
//        }
        [price setFont:[UIFont boldSystemFontOfSize:17.0]];
        [price setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
        [self addSubview:price];
        [price release];
        
        //横线
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 119, 320, 1)];
        [line setBackgroundColor:[UIColor colorWithRed:167.0/255.0 green:32.0/255.0 blue:36.0/255.0 alpha:1.0]];
        [self addSubview:line];
        [line release];
        
        //web
        UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 120, 320, self.frame.size.height-120.0)];
        [webView setScalesPageToFit:YES];
        [webView loadHTMLString:productVO.desc baseURL:nil];
        
        CGRect rc = webView.frame;
        rc.size.height = frame.size.height-120;
        rc.origin.y = 120;
        webView.frame = rc;
        webView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:webView];
        [webView release];
        

    }
    return self;
}

-(void)returnBtnClicked:(id)sender
{
    [self.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeFromSuperview];
}

@end
