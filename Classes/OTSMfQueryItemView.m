//
//  OTSMfQueryItemView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSMfQueryItemView.h"
#import "OrderV2.h"
#import "OrderItemVO.h"
#import "DataController.h"
#import "ProductVO.h"
#import <QuartzCore/QuartzCore.h>

#import "OTSMFInfoButton.h"
#import "OTSMfStackLabel.h"
#import "OTSImagedLabel.h"

#import "OTSProductThumbScrollView.h"
#import "OTSUtility.h"
#import "MyOrderInfo.h"

@implementation OTSMfQueryItemView
@synthesize order, titleBtnNib, infoButton, productThumbScrollView, imgLbl, packageInfoLbl;
@dynamic statusMessages;

-(void)handleInfoBtnClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:OTS_ENTER_ORDER_DETAIL object:order];
}

-(NSArray*)statusMessages
{
    return packageInfoLbl.statusMessages;
}

-(void)setStatusMessages:(NSArray *)statusMessages
{
    packageInfoLbl.statusMessages = statusMessages;
    
    CGRect newProductRc = CGRectMake(productThumbScrollView.frame.origin.x
                                      , CGRectGetMaxY(packageInfoLbl.frame) + 1
                                      , productThumbScrollView.frame.size.width
                                      , productThumbScrollView.frame.size.height);
    
    productThumbScrollView.frame = newProductRc;
    imgLbl.frame = newProductRc;
    
    CGRect lineRc = [self viewWithTag:101].frame;
    lineRc.origin.y = CGRectGetMaxY(packageInfoLbl.frame);
    [self viewWithTag:101].frame = lineRc;
    
    self.frame = CGRectMake(self.frame.origin.x
                            , self.frame.origin.y
                            , self.frame.size.width
                            , CGRectGetMaxY(productThumbScrollView.frame));
}


-(void)addDevideLineAtPosY:(int)aPosY tag:(int)aTag
{
    UIView* line = [[[UIView alloc] initWithFrame:CGRectMake(0, aPosY, self.frame.size.width, 1)] autorelease];
    line.backgroundColor = [UIColor lightGrayColor];
    line.tag = aTag;
    [self addSubview:line];
}

-(void)extraInit
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
    
    // height: 35
    self.titleBtnNib = [UINib nibWithNibName:@"MaterialFlowCellInfoButton" bundle:nil];
        
    self.infoButton = [[titleBtnNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    infoButton.delegate = self;
    [infoButton.button setBackgroundImage:[UIImage imageNamed:@"skyblue1x1.png"] forState:UIControlStateHighlighted];
    [self addSubview:infoButton];
    
    
    // height:variable
    [self addDevideLineAtPosY:CGRectGetMaxY(infoButton.frame) tag:100];
    
    // 包裹信息
    CGRect pkgRc = CGRectMake(0
                              , CGRectGetMaxY(infoButton.frame) + 1
                              , self.frame.size.width
                              , 0);
    self.packageInfoLbl = [[[OTSMfStackLabel alloc] initWithFrame:pkgRc] autorelease];
    packageInfoLbl.delegate = self;
    [self addSubview:packageInfoLbl];
    
    
    //
    [self addDevideLineAtPosY:CGRectGetMaxY(packageInfoLbl.frame) tag:101];
    
    // 商品图片
    // when order has more than one product, show this
    self.productThumbScrollView = [[[OTSProductThumbScrollView alloc] initWithPos:CGPointMake(0, CGRectGetMaxY(packageInfoLbl.frame) + 1)] autorelease];
    [self addSubview:productThumbScrollView];
    productThumbScrollView.hidden = YES;
    
    // when order has only one product, show this
    self.imgLbl = [[[OTSImagedLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(infoButton.frame) + 1, self.frame.size.width, [OTSProductThumbScrollView myHeight])] autorelease];
    [self addSubview:imgLbl];
    imgLbl.hidden = YES;
    
    

    // 调整frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(productThumbScrollView.frame));
}

#pragma mark -
-(void)updateData
{
    //
    infoButton.orderCodeLbl.text = order.orderId;
    infoButton.orderPriceLbl.text = [NSString stringWithFormat:OTS_MONEY_STR_MORMAT, order.theAllMoney];
    
    //
//    NSString* formatStr = @"yyyy-MM-dd";
//    NSMutableString* orderDateStr = nil;
//    int length = [formatStr length];
//    if ([order.orderCreateTime length] >= length) 
//    {
//        NSString *subStr = [order.orderCreateTime substringWithRange:NSMakeRange(0, length)];
//        orderDateStr = [NSString stringWithFormat:@"%@", subStr];
//    }
//    else
//    {
//        orderDateStr = [NSString stringWithFormat:@"%@", [order createOrderLocalTime]];
//    }
    
    infoButton.orderDateLbl.text = order.orderDate; //orderDateStr;
    infoButton.orderCountLbl.text = [NSString stringWithFormat:@"共%d件", order.productNum];
    
    [infoButton makeGroupBuyLogoVisible: NO];//[order.orderType intValue] == 2];
    
    //
//orderItemList is nil in base order info, but can be retrieved in detail
    if (order.productInfoArr)
    {
        if ([order.productInfoArr count] > 1)
        {
            productThumbScrollView.hidden = NO;
            productThumbScrollView.orderItems = order.productInfoArr;
        }
        else if ([order.productInfoArr count] == 1)
        {
            imgLbl.hidden = NO;

            OrderProductInfo* orderItem = [order.productInfoArr objectAtIndex:0];
            
            if (orderItem)
            {
                
                UIImage* img = [NSData dataWithContentsOfURL:[NSURL URLWithString:orderItem.productPicture]]; //; [OTSUtility miniImageForProduct:orderItem.product];
                
                if (img) 
                {
                    [imgLbl.iv setImage:img];
                }
                else 
                {
                    [imgLbl.iv setImage:[UIImage imageNamed:@"defaultimg85.png"]];
                }
            }
            
            imgLbl.lbl.text = orderItem.productName;
        }
    }
    
    //
}

-(id)initWithFrame:(CGRect)aFrame order:(MyOrderInfo*)aOrder
{
    self = [self initWithFrame:aFrame];
    if (self) 
    {
        [self extraInit];
  
        self.order = aOrder;
        
        [self updateData];
    }
    
    return self;
}



-(void)dealloc
{
    [infoButton release];
    [titleBtnNib release];
    [productThumbScrollView release];
    [imgLbl release];
    [packageInfoLbl release];
    
    [super dealloc];
}
@end
