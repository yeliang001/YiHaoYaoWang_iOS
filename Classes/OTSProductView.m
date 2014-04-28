//
//  OTSProductView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSProductView.h"
#import "ProductVO.h"
#import "StrikeThroughLabel.h"
#import "SDImageView+SDWebCache.h"
#import "GlobalValue.h"
#import "LocalCartItemVO.h"
#import "TheStoreAppAppDelegate.h"
#import "DoTracking.h"
#import "CartService.h"
#import "AddProductResult.h"
#import "OTSActionSheet.h"
#import "OTSImageView.h"
#import "GlobalValue.h"
#import "ColorNStringView.h"
#import "CheckSecKillResult.h"
#import "ProductInfo.h"
#import "YWLocalCatService.h"
#import "LocalCarInfo.h"
#import "UserInfo.h"

#define SECKILLROBBEDOVER   1001
#define SECKILLEND          1002

@interface OTSProductView()
@property(nonatomic, retain)CartAnimation* cartAnimation;
-(void)showBuyProductAnimation;
-(void)showInfo:(NSString *)info;
@end

@implementation OTSProductView
@synthesize delegate;
@synthesize pointProduct;
@synthesize colorstringView;
@synthesize m_timer;
@synthesize cartAnimation;
-(id)initWithFrame:(CGRect)frame productVO:(ProductInfo *)productVO fromTag:(OTSProductDetailFromTag)fromTag
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_ProductVO=[productVO retain];
        m_FromTag=fromTag;
        [self setBackgroundColor:[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSpikeState) name:@"NOTIFY_LOGIN_SUCCESS" object:nil];
//        testttt = YES;
    }
    return self;
}


//是秒杀商品的话需要更新一下秒杀状态
-(void)updateSpikeState
{
//    __block CheckSecKillResult * checkSecKillResult;
//    if ([m_ProductVO isSeckillProduct] && [m_ProductVO ifSeckillProduct]) {
//        Trader * trader = [GlobalValue getGlobalValueInstance].trader;
//        NSNumber * provinceId = [GlobalValue getGlobalValueInstance].provinceId;
//        NSString * promotionId = m_ProductVO.promotionId;
//        NSNumber * productId = m_ProductVO.productId;
//        [self performInThreadBlock:^(){
//            CartService *cService=[[[CartService alloc] init] autorelease];
//            checkSecKillResult = [[cService checkIfSecKill:trader promotionId:promotionId provinceId:provinceId productId:productId] retain];
//            
//        } completionInMainBlock:^()
//         {
//             [m_ProductVO setCanSecKill:checkSecKillResult.canSecKill];
//             [m_ProductVO setIfSecKill:checkSecKillResult.ifSecKill];
//             [self refreshView];
//             [checkSecKillResult release];
//         }];
//    }
//    else
        [self refreshView];
}



-(void)refreshView
{
    for (UIView* u in  self.subviews)
    {
        [u removeFromSuperview];
    }
    //商品名称
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 43)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:2];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [label setText:m_ProductVO.name];
    [self addSubview:label];
    [label release];
    
    //商品图片
    OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(10, 63, 100, 100)];
    [imageView loadImgUrl:m_ProductVO.mainImg3];

    [self addSubview:imageView];
    [imageView release];

//    if (pointProduct==1)
//    {
//        double yValue = 70.0;
//        
//        UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(125, yValue, 75, 20)];
//        [label1 setBackgroundColor:[UIColor clearColor]];
//        [label1 setFont:[UIFont systemFontOfSize:14.0]];
//        [label1 setText:@"兑 换:"];
//        [self addSubview:label1];
//        [label1 release];
//        
//        label=[[UILabel alloc] initWithFrame:CGRectMake(190, yValue, 45, 20)];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setFont:[UIFont boldSystemFontOfSize:15.0]];
//        label.adjustsFontSizeToFitWidth=YES;
//        label.textAlignment=NSTextAlignmentRight;
//        label.text=[NSString stringWithFormat:@"¥%@",m_ProductVO.promotionPrice];
//        [label setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
//        [self addSubview:label];
//        [label release];
//        
//        UILabel* plabel=[[UILabel alloc] initWithFrame:CGRectMake(240, yValue, 80, 20)];
//        plabel.text=[NSString stringWithFormat:@"+%@积分",m_ProductVO.activitypoint];
//        [plabel setBackgroundColor:[UIColor clearColor]];
//        [plabel setTextColor:[UIColor lightGrayColor]];
//        [plabel setFont:[UIFont boldSystemFontOfSize:16.0]];
//        [self addSubview:plabel];
//        [plabel release];
//        
//        
//        if ([GlobalValue getGlobalValueInstance].token!=nil) {
//            yValue+=21;
//            UILabel* mypoints=[[UILabel alloc] initWithFrame:CGRectMake(125, yValue, 75, 20)];
//            [mypoints setBackgroundColor:[UIColor clearColor]];
//            [mypoints setFont:[UIFont systemFontOfSize:14.0]];
//            [mypoints setText:@"我的积分:"];
//            [self addSubview:mypoints];
//            [mypoints release];
//            
//            label=[[UILabel alloc] initWithFrame:CGRectMake(200, yValue, 120, 20)];
//            [label setBackgroundColor:[UIColor clearColor]];
//            [label setFont:[UIFont systemFontOfSize:15.0]];
//            
//            label.text=[NSString stringWithFormat:@"%d积分",[GlobalValue getGlobalValueInstance].currentUser.enduserPoint.intValue];
//            [label setTextColor:[UIColor lightGrayColor]];
//            [self addSubview:label];
//            [label release];
//        }
//        
//        yValue += 21.0;
//        //1号店价格
//        UILabel* label2=[[UILabel alloc] initWithFrame:CGRectMake(125, yValue, 75, 20)];
//        [label2 setBackgroundColor:[UIColor clearColor]];
//        [label2 setFont:[UIFont systemFontOfSize:13.0]];
//        [label2 setText:@"1号店价:"];
//        [self addSubview:label2];
//        [label2 release];
//        
//        StrikeThroughLabel *sLabel=[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(200, yValue, 120, 20)];
//        [sLabel setBackgroundColor:[UIColor clearColor]];
//        [sLabel setFont:[UIFont systemFontOfSize:15.0]];
//        NSString *text=[NSString stringWithFormat:@"￥%.2f",[m_ProductVO.price doubleValue]];
//        [sLabel setText:text];
//        [sLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
//        [self addSubview:sLabel];
//        [sLabel release];
//    }
//    else
//    {
        //1号店价
        double yValue = 70.0;
        UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(125, yValue, 90, 20)];
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label1 setFont:[UIFont systemFontOfSize:15.0]];
        
        [self addSubview:label1];
        [label1 release];
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(215, yValue, 120, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont boldSystemFontOfSize:18.0]];
        if (m_FromTag==PD_FROM_FAVORITE || m_FromTag==PD_FROM_BROWSE)
        {
            //收藏和最近浏览进入，显示原价
            [label1 setText:@"1号药店价:"];
            [label setText:[NSString stringWithFormat:@"￥%.2f",[m_ProductVO.price doubleValue]]];
        }
        else
        {
            //条件：促销id不为空串  或 秒杀还没有结束
//            if (m_ProductVO.promotionId!=nil && ![m_ProductVO.promotionId isEqualToString:@""])
//            {
//                // 有促销价显示促销价和1号店价
//                if ([m_ProductVO ifSeckillProduct]) {
//                    UIImageView *imgview1 =  [[UIImageView alloc] initWithFrame:CGRectMake(125, yValue, 48, 16)];
//                    if ([m_ProductVO canSecKillProduct]) {
//                        [label1 setHidden:YES];
//                        [imgview1 setImage:[UIImage imageNamed:@"seckillprice@2x.png"]];
//                        [label setText:[NSString stringWithFormat:@"￥%.2f",[m_ProductVO.promotionPrice doubleValue]]];
//                    }
//                    else
//                    {
//                        [label setHidden:YES];
//                        [imgview1 setImage:[UIImage imageNamed:@"seckillpricegray@2x.png"]];
//                        StrikeThroughLabel *sLabel=[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(200, yValue, 120, 20)];
//                        [sLabel setBackgroundColor:[UIColor clearColor]];
//                        [sLabel setFont:[UIFont systemFontOfSize:15.0]];
//                        NSString *text=[NSString stringWithFormat:@"￥%.2f",[m_ProductVO.promotionPrice doubleValue]];
//                        [sLabel setText:text];
//                        [sLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
//                        [self addSubview:sLabel];
//                        [sLabel release];
//                        //已抢完
//                        CGPoint lspoint = [ColorNStringView getLableBackPosition:sLabel];
//                        UILabel * robLabel = [[UILabel alloc] initWithFrame:CGRectMake(lspoint.x, yValue, 120, 20)];
//                        [robLabel setFont:[UIFont systemFontOfSize:13.0]];
//                        [robLabel setText:[NSString stringWithFormat:@"已抢完"]];
//                        [self addSubview:robLabel];
//                        [robLabel release];
//                    }
//                    [self addSubview:imgview1];
//                    [imgview1 release];
//                }
//                else
//                {
//                    [label1 setText:@"促销价:"];
//                    [label setText:[NSString stringWithFormat:@"￥%.2f",[m_ProductVO.promotionPrice doubleValue]]];
//                }
//                
//                yValue += 21.0;
//                //市场价
//                UILabel* label2=[[UILabel alloc] initWithFrame:CGRectMake(125, yValue, 75, 20)];
//                [label2 setBackgroundColor:[UIColor clearColor]];
//                [label2 setFont:[UIFont systemFontOfSize:13.0]];
//                [label2 setText:@"1号店价:"];
//                [self addSubview:label2];
//                [label2 release];
//                
//                if (![m_ProductVO canSecKillProduct]) {
//                    UILabel * sLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, yValue, 120, 20)];
//                    [sLabel setText:[NSString stringWithFormat:@"￥%.2f",[m_ProductVO.price doubleValue]]];
//                    [sLabel setTextColor:[UIColor redColor]];
//                    [self addSubview:sLabel];
//                    [sLabel release];
//                }
//                else
//                {
//                    StrikeThroughLabel *sLabel=[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(200, yValue, 120, 20)];
//                    [sLabel setBackgroundColor:[UIColor clearColor]];
//                    [sLabel setFont:[UIFont systemFontOfSize:15.0]];
//                    NSString *text=[NSString stringWithFormat:@"￥%.2f",[m_ProductVO.price doubleValue]];
//                    [sLabel setText:text];
//                    [sLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
//                    [self addSubview:sLabel];
//                    [sLabel release];
//                }
//                
//            } else {
                [label1 setText:@"1号药店价："];
                [label setText:[NSString stringWithFormat:@"￥%.2f",[m_ProductVO.price doubleValue]]];
//            }
        }
        
        [label setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
        [self addSubview:label];
        [label release];
        
        yValue += 21.0;
        
        //秒杀商品显示倒计时,条件：1.是秒杀商品 2.秒杀商品未有抢完 3.秒杀未结束
//        if ([m_ProductVO ifSeckillProduct] && [m_ProductVO canSecKillProduct])
//        {
//            
//            UIImageView * seckillcountdown =  [[UIImageView alloc] initWithFrame:CGRectMake(125, yValue, 17, 17)];
//            [seckillcountdown setImage:[UIImage imageNamed:@"seckillcountdown@2x.png"]];
//            [self addSubview:seckillcountdown];
//            [seckillcountdown release];
//            
//            self.colorstringView = [[ColorNStringView alloc] initWithFrame:CGRectMake(145, yValue, 200, 20) withNSString:[m_ProductVO SeckillCountdown]];
//            
//            //增加判断秒杀结束条件
//            if ([m_ProductVO SeckillEnd]) {
//                [m_ProductVO setCanSecKill:@"false"];
//                [self refreshView];
//                return;
//            }
//            else
//            {
//                self.m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//            
//            }
//            [self addSubview:colorstringView];
//            [colorstringView release];
//            yValue += 21.0;
//        }
        
        //评分
        for (int i=0; i<5; i++)
        {
            UIImageView *star=[[UIImageView alloc] initWithFrame:CGRectMake(125+14*i, yValue+4, 13, 13)];
            if (i<[m_ProductVO.userGrade intValue])
            {
                [star setImage:[UIImage imageNamed:@"pentagon_Yellow.png"]];
            }
            else
            {
                [star setImage:[UIImage imageNamed:@"pentagon_Gray.png"]];
            }
            [self addSubview:star];
            [star release];
        }
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(200, yValue, 120, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [label setText:[NSString stringWithFormat:@"%d (%@人)",[m_ProductVO.userGrade intValue],m_ProductVO.userGradeCount]];
        [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [self addSubview:label];
        [label release];
        
        yValue += 30.0;
    
    //药网增加处方药说明
    if ([m_ProductVO isOTC])
    {

        label=[[UILabel alloc] initWithFrame:CGRectMake(125, yValue-12, 150, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"本品为处方药，需在药师指导下购买."];
        [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        //自动折行设置
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [self addSubview:label];
        [label release];
        
        yValue += 25.0;
    }
    
    //限购
    if (m_ProductVO.limitCount > 0)
    {
        label=[[UILabel alloc] initWithFrame:CGRectMake(125, yValue-12, 150, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[NSString stringWithFormat:@"本商品每位用户限购%d件",m_ProductVO.limitCount]];
        [label setTextColor:[UIColor redColor]];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        //自动折行设置
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [self addSubview:label];
        [label release];
        
        yValue += 25.0;
    }
    
    //起购
    if (m_ProductVO.leastCount > 0)
    {
        label=[[UILabel alloc] initWithFrame:CGRectMake(125, yValue-12, 150, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[NSString stringWithFormat:@"本商品%d件起购",m_ProductVO.leastCount]];
        [label setTextColor:[UIColor redColor]];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        //自动折行设置
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [self addSubview:label];
        [label release];
        
        yValue += 25.0;
    }
    
    
    
    
        //满减
//        if (m_ProductVO.isJoinCash) {
//            imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(125, yValue, 16, 16)];
//            [imageView setImage:[UIImage imageNamed:@"manjian.png"]];
//            [self addSubview:imageView];
//            [imageView release];
//            
//            label=[[UILabel alloc] initWithFrame:CGRectMake(145, yValue-12, 150, 40)];
//            [label setBackgroundColor:[UIColor clearColor]];
//            [label setText:m_ProductVO.hasCash];
//            [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
//            [label setFont:[UIFont systemFontOfSize:13.0]];
//            //自动折行设置
//            label.lineBreakMode = UILineBreakModeWordWrap;
//            label.numberOfLines = 0;
//            [self addSubview:label];
//            [label release];
//            
//            yValue += 25.0;
//        }
        
        //N元n件
//        if (m_ProductVO.offerName.length > 0) {
//            imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(125, yValue, 16, 16)];
//            [imageView setImage:[UIImage imageNamed:@"hui"]];
//            [self addSubview:imageView];
//            [imageView release];
//            
//            label=[[UILabel alloc] initWithFrame:CGRectMake(145, yValue-7, 150, 30)];
//            [label setBackgroundColor:[UIColor clearColor]];
//            [label setText:m_ProductVO.offerName];
//            [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
//            [label setFont:[UIFont systemFontOfSize:13.0]];
//            //自动折行设置
//            label.lineBreakMode = UILineBreakModeWordWrap;
//            label.numberOfLines = 0;
//            [self addSubview:label];
//            [label release];
//            
//            yValue += 25.0;
//        }
    
        //赠品
//        double xValue = 125.0;
//        if ([m_ProductVO.hasGift intValue]==1)
//        {
//            imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, yValue, 16, 16)];
//            [imageView setImage:[UIImage imageNamed:@"zengpin.png"]];
//            [self addSubview:imageView];
//            [imageView release];
//            
//            label=[[UILabel alloc] initWithFrame:CGRectMake(xValue+20, yValue-2, 50, 20)];
//            [label setBackgroundColor:[UIColor clearColor]];
//            [label setText:@"有赠品"];
//            [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
//            [label setFont:[UIFont systemFontOfSize:13.0]];
//            [self addSubview:label];
//            [label release];
//            
//            xValue = CGRectGetMaxX(label.frame) + 8;
//        }
//        
//        //支持换购
//        if ([m_ProductVO.hasRedemption intValue]) {
//            imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, yValue, 16, 16)];
//            imageView.image=[UIImage imageNamed:@"huangou.png"];
//            [self addSubview:imageView];
//            [imageView release];
//            
//            label=[[UILabel alloc] initWithFrame:CGRectMake(xValue+25, yValue-2, 72, 20)];
//            [label setBackgroundColor:[UIColor clearColor]];
//            [label setText:@"支持换购"];
//            [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
//            [label setFont:[UIFont systemFontOfSize:13.0]];
//            [self addSubview:label];
//            [label release];
//        }
//        
//        //生鲜运费说明
//        if([m_ProductVO isFreshProduct])
//        {
//            //63+100-15  如果没有促销 以商品图片下部为基准算 yValue
//            if (yValue < 148) {
//                yValue = 148;
//            }
//            imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(0, yValue+20, 320, 20)];
//            imageView.image=[UIImage imageNamed:@"yunfei1@2x.png"];
//            [self addSubview:imageView];
//            [imageView release];
//        }
//    }
    
    //减少
    m_MinusBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 224, 30, 30)];
    [m_MinusBtn setBackgroundImage:[UIImage imageNamed:@"minus_enable.png"] forState:UIControlStateNormal];
    [m_MinusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_MinusBtn];
    [m_MinusBtn setEnabled:NO];
    
    //数量
    m_CountBtn=[[UIButton alloc] initWithFrame:CGRectMake(50, 224, 44, 30)];
    [m_CountBtn.layer setBorderWidth:1.0];
    [m_CountBtn.layer setBorderColor:[[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0] CGColor]];
    if (m_ProductVO.leastCount > 0)
    {
         m_MinCount = m_ProductVO.leastCount;
    }
    else
    {
        m_MinCount = 1;
    }
    
    if (m_ProductVO.limitCount > 0)
    {
        m_MaxCount = m_ProductVO.limitCount;
    }
    else
    {
        m_MaxCount = [m_ProductVO.currentStore intValue];
    }
   
    
    
//    if ([m_ProductVO.shoppingCount intValue]>m_MinCount)
//    {
//        m_MinCount=[m_ProductVO.shoppingCount intValue];
//    }
    
    
    [m_CountBtn setTitle:[NSString stringWithFormat:@"%d",m_MinCount] forState:UIControlStateNormal];
    [m_CountBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [m_CountBtn addTarget:self action:@selector(countBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_CountBtn];
    
    //增加
    m_AddBtn=[[UIButton alloc] initWithFrame:CGRectMake(104, 224, 30, 30)];
    [m_AddBtn setBackgroundImage:[UIImage imageNamed:@"add_enable.png"] forState:UIControlStateNormal];
    [m_AddBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_AddBtn];
    if (m_MinCount == m_MaxCount)
    {
        [m_AddBtn setEnabled:NO];
    }
    
    
    //秒杀商品不能改数量 & 背景变灰
    //条件：1.是秒杀商品 2.秒杀商品未有抢完 3.秒杀未结束
//    if ([m_ProductVO ifSeckillProduct] && [m_ProductVO canSecKillProduct]) {
//        [m_CountBtn setEnabled:NO];
//        [m_CountBtn setBackgroundColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0]];
//        [m_AddBtn setEnabled:NO];
//    }
    
    //加入购物车
    m_AddCartBtn=[[UIButton alloc] initWithFrame:CGRectMake(175, 217, 137, 39)];
    [m_AddCartBtn setBackgroundImage:[UIImage imageNamed:@"orange_btn.png"] forState:UIControlStateNormal];
//    if (pointProduct==1)
//    {
//        [m_AddCartBtn setTitle:@"兑 换" forState:UIControlStateNormal];
//    }
    
    [m_CountBtn setEnabled:YES];
    [m_AddBtn setEnabled:YES];
    [m_AddCartBtn setEnabled:YES];
    
    if (m_ProductVO.isOTC) //[m_ProductVO.prescription intValue] == 16)
    {
        [m_AddCartBtn setTitle:@"咨询药师" forState:UIControlStateNormal];
    }
    else if ([m_ProductVO.currentStore intValue] >= m_MinCount) //大于最小起购时才算有货 。 没有起购要求的 最小值默认1
    {
        [m_AddCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
    else
    {
        [m_AddCartBtn setTitle:@"缺货" forState:UIControlStateNormal];
        [m_AddCartBtn setBackgroundImage:[UIImage imageNamed:@"gray_long_button.png"] forState:UIControlStateNormal];
        [m_AddCartBtn setEnabled:NO];
        [m_AddBtn setEnabled:NO];
        [m_MinusBtn setEnabled:NO];
        [m_CountBtn setEnabled:NO];
    }
    [[m_AddCartBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:19.0]];
    [m_AddCartBtn addTarget:self action:@selector(addCartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_AddCartBtn];
    
    //已售完 或者是 秒杀
//    if ([[m_ProductVO canBuy] isEqualToString:@"false"]) {
//        [m_CountBtn setEnabled:NO];
//        [m_AddBtn setEnabled:NO];
//        [m_AddCartBtn setEnabled:NO];
//        if (pointProduct==1) {
//            [m_AddCartBtn setTitle:@"已兑完" forState:UIControlStateNormal];
//        }else{
//            [m_AddCartBtn setTitle:@"已售完" forState:UIControlStateNormal];
//        }
//        [m_AddCartBtn setBackgroundImage:[UIImage imageNamed:@"gray_long_btn.png"] forState:UIControlStateNormal];
//    }
//    else if([m_ProductVO ifSeckillProduct] && [m_ProductVO canSecKillProduct])
//    {
//        [m_CountBtn setEnabled:NO];
//        [m_AddBtn setEnabled:NO];
//    }
//    else
//    {
        
//        if (pointProduct==1){
//            [m_AddCartBtn setTitle:@"兑 换" forState:UIControlStateNormal];
//        }
//        else
//        {
//            [m_AddCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
//        }
//        [m_AddCartBtn setBackgroundImage:[UIImage imageNamed:@"orange_button.png"] forState:UIControlStateNormal];
//    }
    
}
-(void)cashclick{
    if (delegate!=nil) {
        [delegate cashBuyClick];
    }
}

//-(void)timerFireMethod:(NSTimer*)timer
//{
//    [self.colorstringView reflush:[m_ProductVO SeckillCountdown]];
//    //秒杀结束
//    if ([m_ProductVO SeckillEnd]) {
//        [m_timer invalidate];
//        self.m_timer = nil;
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOGIN_SUCCESS object:nil];
//    }
//}

//减少商品数量
-(void)minusBtnClicked:(id)sender
{
    int currentCount=[[m_CountBtn titleForState:UIControlStateNormal] intValue];
    

    
    if (currentCount<=m_MinCount)
    {
        [m_MinusBtn setEnabled:NO];
    }
    else
    {
        currentCount--;
        [m_CountBtn setTitle:[NSString stringWithFormat:@"%d",currentCount] forState:UIControlStateNormal];
        if (currentCount<=m_MinCount)
        {
            [m_MinusBtn setEnabled:NO];
        }
        else
        {
            [m_MinusBtn setEnabled:YES];
        }
        
        if (currentCount < m_MaxCount) //[m_ProductVO.currentStore intValue])
        {
            [m_AddBtn setEnabled:YES];
        }
        
    }
}

//增加商品数量
-(void)addBtnClicked:(id)sender
{
    int currentCount=[[m_CountBtn titleForState:UIControlStateNormal] intValue];
    currentCount++;
    [m_CountBtn setTitle:[NSString stringWithFormat:@"%d",currentCount] forState:UIControlStateNormal];
   
    if (currentCount >= m_MaxCount)
    {
        [m_AddBtn setEnabled:NO];
    }
    
//    //如果限购
//    if (currentCount >= m_ProductVO.limitCount)
//    {
//        [m_AddBtn setEnabled:NO];
//    }


    
    if (currentCount<=m_MinCount)
    {
        [m_MinusBtn setEnabled:NO];
    }
    else
    {
        [m_MinusBtn setEnabled:YES];
    }
}

//秒杀商品
/*
-(void)seckillProduct:(void(^)(void))aCompletion
{
    __block SeckillResultVO * preSeckillResult;
    
    NSString * token = [GlobalValue getGlobalValueInstance].storeToken;
    NSNumber * provinceId = [GlobalValue getGlobalValueInstance].provinceId;
    NSString * promotionId = m_ProductVO.promotionId;
    NSNumber * productId = m_ProductVO.productId;
    [self performInThreadBlock:^(){
        CartService *cService=[[[CartService alloc] init] autorelease];
        preSeckillResult = [[cService seckillProduct:token provinceId:provinceId promotionId:promotionId productId:productId] retain];
        
    } completionInMainBlock:^()
     {
         if([preSeckillResult.resultCode integerValue] == 0)
         {
             [self showInfo:@"系统繁忙，请稍后再试"];
         }
         else if([preSeckillResult.resultCode integerValue] == 1)
         {
             [self showSecKillRobbedOver];
         }
         else if([preSeckillResult.resultCode integerValue] == 2)
         { 
             [self showInfo:@"对不起，该商品限购3件。"];
         }
         else
         {
             aCompletion();
         }

         [preSeckillResult release];
     }];
}*/

//加入购物车点击
-(void)addCartBtnClicked:(id)sender
{
    
    if ([m_ProductVO isOTC])
    {
        if (delegate)
        {
            [delegate callPhone];
        }
        
        return;
    }
    
    if ([m_ProductVO isSeriesProductInProductDetail])
    {
        if (delegate)
        {
            [delegate showSeriesView];
        }
        return;
    }
    
    
    
    
    if (cartAnimation == nil) {
        cartAnimation = [[CartAnimation alloc]init:self.superview.superview];// superview是VC的scrollview, scrollview的superview才是 VC的view
        [cartAnimation setDelegate:self];
    }
    //秒杀抢完
//    if ([m_ProductVO ifSeckillProduct] && ![m_ProductVO canSecKillProduct])
//    {
//        [self showSecKillRobbedOver];
//    }
//    //开始秒杀
//    else if([m_ProductVO ifSeckillProduct] && [m_ProductVO canSecKillProduct])
//    {
//        if ([GlobalValue getGlobalValueInstance].storeToken == nil) {
//            [SharedDelegate enterUserManageWithTag:0];
//        }
//        else
//        {
//            [self seckillProduct:^(){
//                [self addProductV2ToCart];
//            }];
//        }
//    }
//    else
        [self addProductV2ToCart];
    
}

-(void)addProductV2ToCart
{
//    if (!m_AddingCart)
//    {
//        m_AddingCart=YES;
        SharedDelegate.m_UpdateCart=YES;
//        if ([GlobalValue getGlobalValueInstance].ywToken!=nil)
//        {
			[self performInThreadBlock:^{

                int quantity=[[m_CountBtn titleForState:UIControlStateNormal] intValue];


                YWLocalCatService *localCatService = [[YWLocalCatService alloc] init];
              

                    
                    LocalCarInfo *localCart = [[LocalCarInfo alloc] initWithProductId:m_ProductVO.productId
                                                                        shoppingCount:[NSString stringWithFormat:@"%d",quantity]
                                                                             imageUrl:m_ProductVO.mainImg3
                                                                                price:m_ProductVO.price
                                                                           provinceId:[[GlobalValue getGlobalValueInstance].provinceId stringValue]
                                                                                  uid:[GlobalValue getGlobalValueInstance].userInfo.ecUserId
                                                                            productNO:m_ProductVO.productNO
                                                                               itemId:m_ProductVO.itemId];
                    
                    BOOL result = [localCatService saveLocalCartToDB:localCart];

                    if (m_AddProductResult!=nil)
                    {
                        [m_AddProductResult release];
                    }
                    
                    if (result)
                    {
                        m_AddProductResult = [[AddProductResult alloc] init];
                        m_AddProductResult.resultCode = [NSNumber numberWithInt:1];
                        m_AddProductResult.errorInfo = @"添加成功";
                    }
                    else
                    {
                        m_AddProductResult = nil;
                    }
                    

            }completionInMainBlock:^{
                m_AddingCart=NO;
                if (m_AddProductResult!=nil)
                {
                    if ([[m_AddProductResult resultCode] intValue]==1)
                    {
                        //成功
                        [self showBuyProductAnimation];
                        //刷新购物车
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"promotioncartload" object:nil];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"cartload" object:nil];
//                        SharedDelegate.m_UpdateCart=YES;
                    } else
                    {
                        [self showInfo:[m_AddProductResult errorInfo]];
                    }
                }
                else
                {
                    [self showInfo:@"网络异常，请检查网络配置..."];
                }
            }];
//		}
//        else
//        {
            //积分商品 或 秒杀 需要登陆
//            if (pointProduct)
//            {
//                [SharedDelegate enterUserManageWithTag:0];
//                m_AddingCart=NO;
//            }else
//            {
//                if (pointProduct==2||([m_ProductVO ifSeckillProduct] && ![m_ProductVO canSecKillProduct])) {
//                    m_ProductVO.promotionId = nil;
//                }
//                LocalCartItemVO *lCartItemVO=[[LocalCartItemVO alloc] initWithProductVO:m_ProductVO quantity:[m_CountBtn titleForState:UIControlStateNormal]];
//                [SharedDelegate addProductToLocal:lCartItemVO];
//                m_AddingCart=NO;
//                [self showBuyProductAnimation];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
//                [lCartItemVO release];
//            }
//		}
//    }
}

//修改商品数量
-(void)countBtnClicked:(id)sender
{
    if (m_ActionSheet!=nil) {
        [m_ActionSheet release];
    }
	m_ActionSheet=[[OTSActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    UIButton *tempbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 40, 320, 216)];
    [m_ActionSheet addSubview:tempbutton];
	[tempbutton release];
    
	UIPickerView *pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    [pickerView setShowsSelectionIndicator:YES];
    m_PickerViewSelectedIndex=[[m_CountBtn titleForState:UIControlStateNormal] intValue]-m_MinCount;
    if ([[m_CountBtn titleForState:UIControlStateNormal] intValue]> m_MaxCount) //[m_ProductVO.currentStore intValue])
    {
        m_PickerViewSelectedIndex=0;
    }
    [pickerView selectRow:m_PickerViewSelectedIndex inComponent:0 animated:NO];
    [tempbutton addSubview:pickerView];
    [pickerView release];
	
	//完成
    UIButton *finishSetBtn=[[UIButton alloc]initWithFrame:CGRectMake(252, 5, 50, 30)];
	[finishSetBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
	[finishSetBtn addTarget:self action:@selector(finishPickerView:) forControlEvents:UIControlEventTouchUpInside];
	[finishSetBtn setTitle:@"完成" forState:UIControlStateNormal];
    [m_ActionSheet addSubview:finishSetBtn];
	[finishSetBtn release];
    //取消
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(18, 5, 50, 30)];
	[cancelBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
	[cancelBtn addTarget:self action:@selector(cancelPickerView:) forControlEvents:UIControlEventTouchUpInside];
	[cancelBtn setTitle:@"取消" forState:0];
    [m_ActionSheet addSubview:cancelBtn];
    [cancelBtn release];
    
	[m_ActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

//pickerview点取消
-(void)cancelPickerView:(id)sender
{
 	[m_ActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

//pickerview点完成
-(void)finishPickerView:(id)sender{
 	[m_ActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
	if (m_PickerViewSelectedIndex<=0)
    {
        [m_MinusBtn setEnabled:NO];
    }
    else
    {
        [m_MinusBtn setEnabled:YES];
    }
    [m_CountBtn setTitle:[NSString stringWithFormat:@"%d",m_PickerViewSelectedIndex+m_MinCount] forState:UIControlStateNormal];
    
    //达到了最大值
    if (m_PickerViewSelectedIndex + m_MinCount >= m_MaxCount)
    {
        [m_AddBtn setEnabled:NO];
    }
    
}

-(void)showInfo:(NSString *)info
{
    [AlertView showAlertView:nil alertMsg:info buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}

//错误提示 秒杀已抢完
-(void)showSecKillRobbedOver
{
    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"秒杀已抢完" message:@"秒杀商品已抢完，您可以1号药店价购买，是否现在购买?" delegate:self cancelButtonTitle:@"暂时不要" otherButtonTitles:@"1号药店价购买", nil];
    [alert setTag:SECKILLROBBEDOVER];
	[alert show];
	[alert release];
}

//错误提示 秒杀已结束
-(void)showSecKillEnd
{
    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"秒杀已结束" message:@"秒杀活动已结束，去首页看看别的活动" delegate:self cancelButtonTitle:@"暂时不要" otherButtonTitles:@"去首页", nil];
    [alert setTag:SECKILLEND];
	[alert show];
	[alert release];
}

#pragma mark 购物车动画
-(void)showBuyProductAnimation
{
    if (!m_Animating) {
        m_Animating=YES;
        // 添加商品到购物车的动画
        CGPoint point = CGPointMake(10, 63);
        point = [self convertPoint:point toView:self.superview.superview];
        
        UIImageView* imageV = [[UIImageView alloc]init];
        [imageV setImageWithURL:[NSURL URLWithString:m_ProductVO.mainImg3] refreshCache:NO placeholderImage:[UIImage imageNamed:@"defaultimg76"]];
        [cartAnimation beginCartAnimationWithProductImageView:imageV point:point];
        [imageV release];
        
        [m_AddCartBtn setEnabled:NO];
        [SharedDelegate showAddCartAnimationWithDelegate:self];
        int quantity=[[m_CountBtn titleForState:UIControlStateNormal] intValue];
        [SharedDelegate setCartNum:quantity];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
	}
}

-(void)animationFinished
{
    m_Animating=NO;
    [m_AddCartBtn setEnabled:YES];
}

#pragma mark - UIPickerView相关delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  m_MaxCount - m_MinCount + 1; //[m_ProductVO.currentStore intValue];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d",row+m_MinCount];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m_PickerViewSelectedIndex=row;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 90.0;
}

#pragma mark    alertView的deleaget
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case SECKILLROBBEDOVER: {
            if (buttonIndex==1) {
                [self addProductV2ToCart];
            }
            break;
        }
        case SECKILLEND: {
            if (buttonIndex==1) {
                [SharedDelegate enterHomePageRoot];
            }
            break;
        }
        default:
            break;
    }
}


//离开页面的时候重写removeFromSuperview 关闭定时器
- (void)removeFromSuperview
{
    [m_timer invalidate];
    self.m_timer = nil;
    
    [super removeFromSuperview];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    OTS_SAFE_RELEASE(m_MinusBtn);
    OTS_SAFE_RELEASE(m_AddBtn);
    OTS_SAFE_RELEASE(m_CountBtn);
    OTS_SAFE_RELEASE(m_AddCartBtn);
    OTS_SAFE_RELEASE(m_ProductVO);
    OTS_SAFE_RELEASE(m_AddProductResult);
    OTS_SAFE_RELEASE(m_ActionSheet);
    OTS_SAFE_RELEASE(colorstringView);
    OTS_SAFE_RELEASE(cartAnimation);
    [m_timer invalidate];
    self.m_timer = nil;
    [super dealloc];
}

@end
