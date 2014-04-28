//
//  ProductView.m
//  yhd
//
//  Created by  on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductView.h"
#import "ProductVO.h"
#import "SDImageView+SDWebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "DataHandler.h"
@implementation ProductView
@synthesize product,isPop;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES; //设置响应交互行为，默认是no

       


    }
    return self;
}


-(void)handleAddToCartFromProductView:(id)sender
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate performSelector:_cmd withObject:self];
    }
}

- (id)initWithFrame:(CGRect)frame product:(ProductVO *)aproduct ispop:(BOOL)ispop productListType:(NSInteger)plType; {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (ispop) {
            UIImageView *bgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            if ([aproduct.canBuy isEqualToString:@"true"]) {
                bgView.image=[UIImage imageNamed:@"proview_bg.png"];
            }else {
                bgView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height+30);
                bgView.image=[UIImage imageNamed:@"proViewNo.png"];
            }
            [self addSubview:bgView];
            [bgView release];
        }else {
//            self.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
//            self.layer.borderWidth =0.5;
            
            // 用这个蛋碎的方法替换上面的。Cause赠品的标签会被上面的遮住
            [self setBackgroundColor:[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0]];
            UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0.5, 0.5, frame.size.width-1, frame.size.height-1)];
            [bgView setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:bgView];
            [bgView release];

            UIButton *cartBut=[UIButton buttonWithType:UIButtonTypeCustom];
            [cartBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //[closeBut setTitle:@"收起" forState:UIControlStateNormal];
            [cartBut setImage:[UIImage imageNamed:@"proview_cart1.png"] forState:UIControlStateNormal];
            [cartBut setImage:[UIImage imageNamed:@"proview_cart2.png"] forState:UIControlStateDisabled];
            [cartBut addTarget:self action:@selector(handleAddToCartFromProductView:) forControlEvents:UIControlEventTouchUpInside];
            [cartBut setFrame:CGRectMake(195, 223, 31, 27)];//
            [self addSubview:cartBut];
            
            if(![aproduct.canBuy isEqualToString:@"true"]){
                cartBut.enabled=NO;
            }
            if (aproduct.isYihaodian!=nil&&aproduct.isYihaodian.intValue==0) {
                 UIImageView* mallTag=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-37, self.frame.size.height-37, 37, 37)];
                mallTag.image=[UIImage imageNamed:@"mallProduct"];
                [self addSubview:mallTag];
                [mallTag release];
                cartBut.hidden=YES;
            }else{
                cartBut.hidden=NO;
            }

        }
        int y=frame.size.height>263?9:0;
        if (![aproduct.canBuy isEqualToString:@"true"]) {
            if (ispop){
                y+=30;
            }
        }
        self.product=aproduct;
        
        self.userInteractionEnabled = YES; //设置响应交互行为，默认是no
    
       
        
         imageView=[[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-165)/2, 10+y, 165.0, 165.0)];
        
        imageView.userInteractionEnabled=YES;
        
        [imageView setImageWithURL:[NSURL URLWithString:product.midleDefaultProductUrl]]; //refreshCache:NO placeholderImage:SharedPadDelegate.defaultProductImg];
        [self insertSubview:imageView atIndex:1];
        [imageView release];

        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-160)/2, 180+y, 160.0, 40.0) ];
        nameLabel.textColor = kBlackColor;  
        nameLabel.backgroundColor=[UIColor clearColor];
        //nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.numberOfLines=2;
        nameLabel.font=[nameLabel.font fontWithSize:15.0];
        nameLabel.text=product.cnName;
        [self insertSubview:nameLabel atIndex:1];
        [nameLabel release];
        

        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-165)/2, 226+y, 165.0, 20.0) ];
        price.textColor = kRedColor;  
        price.backgroundColor=[UIColor clearColor];
        //price.textAlignment=NSTextAlignmentCenter;
        price.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
       
//        NSString *priceStr=[NSString stringWithFormat:@"%.2f",[product.price floatValue]];
//        
//        //-----------landingpage时取promoteprice---------------
//        if ([product.promotionId rangeOfString:@"landingpage"].length!=0) {
//            priceStr = [NSString stringWithFormat:@"%.2f",[product.promotionPrice floatValue]];
//        }
        //商品价格，优先显示一号店价
        NSString *priceStr = nil;
        if ([product.price doubleValue]>0.0001) {
            priceStr=[NSString stringWithFormat:@"￥%.2f",[product.price doubleValue]];
        } else {
            priceStr=[NSString stringWithFormat:@"￥%.2f",[product.promotionPrice doubleValue]];
        }
        if (plType==3&&product.promotionPrice!=nil) {
            priceStr=[NSString stringWithFormat:@"￥%.2f",[product.promotionPrice doubleValue]];
        }
        if ([priceStr hasSuffix:@"0"] ) {
            priceStr=[priceStr substringToIndex:priceStr.length-1];
            if ([priceStr hasSuffix:@".0"] ) {
                priceStr=[priceStr substringToIndex:priceStr.length-2];
            }
        }

        price.text=[NSString stringWithFormat:@"%@",priceStr];
        [self insertSubview:price atIndex:1];
        [price release];
        
                
//        if ([product.hasGift intValue]==1) {
//
//            UIImageView *zenpinView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"proview_zengpin.png"]];
//            zenpinView.frame=CGRectMake((frame.size.width-220)/2, 0+y, 66, 43.0);
//            [self addSubview:zenpinView];
//        }
        //---------------landingpage 划算----------------------------
        //        NSLog(@"dasdas %d",[@"search" rangeOfString:@"landingpage"].length);
        //浏览历史 不显示 划算
        if (plType != 4) {
            if ([product.promotionId rangeOfString:@"landingpage"].length!=0) {
                UIImageView *huasuanView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huasuan@2x.png"]];
                huasuanView.frame=CGRectMake((frame.size.width-220)/2-10, 10+y, 132.0/2, 43.0/2);
                [self addSubview:huasuanView];
                [huasuanView release];
            }
        }
    }
    return self;
}
- (void) setLast {
    CGRect rect= self.frame;
    rect.origin.y-=1;
    //rect.size.width+=1;
    rect.size.height+=1;
    self.frame=rect;
     self.layer.borderWidth =1.0;
}


@end
