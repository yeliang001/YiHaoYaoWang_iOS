//
//  PADCartFloatView.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-23.
//
//
#define DEFAULT_COLOR   [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]
#define DARK_RED    [UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]
#import "PADCartFloatView.h"
#import "SDImageView+SDWebCache.h"
#import "GlobalValue.h"

@implementation PADCartFloatView

-(id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO delegate:(id<PADCartFloatViewDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_Delegate=delegate;
        
        //背景图片
        UIImageView *bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FLOATVIEW_WIDTH, FLOATVIEW_HEIGHT)];
        [bg setImage:[UIImage imageNamed:@"cart_layer_bg.png"]];
        [self addSubview:bg];
        [bg release];
        
        //商品图片
        m_ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(25, FLOATVIEW_HEIGHT/2-33, 66, 66)];
        [self addSubview:m_ImageView];
        
        //价格
        m_PriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(103, FLOATVIEW_HEIGHT/2-33, 120, 25)];
        [m_PriceLabel setBackgroundColor:[UIColor clearColor]];
        [m_PriceLabel setTextColor:DARK_RED];
        [m_PriceLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [self addSubview:m_PriceLabel];
        
        //减号
        m_MinusBtn=[[UIButton alloc] initWithFrame:CGRectMake(103, FLOATVIEW_HEIGHT/2+3, 32, 30)];
        [m_MinusBtn setBackgroundImage:[UIImage imageNamed:@"reduceavailabel.png"] forState:UIControlStateNormal];
        [m_MinusBtn setBackgroundImage:[UIImage imageNamed:@"reduceunavailabel.png"] forState:UIControlStateDisabled];
        [m_MinusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_MinusBtn];
        
        //单品数量
        m_CountBtn=[[UIButton alloc] initWithFrame:CGRectMake(135, FLOATVIEW_HEIGHT/2+3, 40, 30)];
        [m_CountBtn.layer setBorderWidth:1.0];
        [m_CountBtn.layer setBorderColor:[[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0] CGColor]];
        [m_CountBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
        [self addSubview:m_CountBtn];
        
        //加号
        m_AddBtn=[[UIButton alloc] initWithFrame:CGRectMake(175, FLOATVIEW_HEIGHT/2+3, 32, 30)];
        [m_AddBtn setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [m_AddBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_AddBtn];
        
        //数量、重量
        m_CountLabel=[[UILabel alloc] initWithFrame:CGRectMake(300, FLOATVIEW_HEIGHT/2-25, 250, 50)];
        [m_CountLabel setBackgroundColor:[UIColor clearColor]];
        [m_CountLabel setNumberOfLines:2];
        [m_CountLabel setTextColor:DEFAULT_COLOR];
        [m_CountLabel setFont:[m_CountLabel.font fontWithSize:17.0]];
        [m_CountLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:m_CountLabel];
        
        //商品合计
        m_TotalLabel=[[UILabel alloc] initWithFrame:CGRectMake(550, FLOATVIEW_HEIGHT/2-16, 185, 32)];
        [m_TotalLabel setBackgroundColor:[UIColor clearColor]];
        [m_TotalLabel setText:[NSString stringWithFormat:@"商品合计(未含运费):"]];
        [m_TotalLabel setFont:[UIFont systemFontOfSize:17.0]];
        [m_TotalLabel setTextColor:DEFAULT_COLOR];
        [m_TotalLabel setFont:[m_TotalLabel.font fontWithSize:19.0]];
        [m_TotalLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:m_TotalLabel];
        
        m_TotalPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(735, FLOATVIEW_HEIGHT/2-16, 120, 32)];
        [m_TotalPriceLabel setBackgroundColor:[UIColor clearColor]];
        [m_TotalPriceLabel setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
        [m_TotalPriceLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [self addSubview:m_TotalPriceLabel];
        
        //去结算
        m_BuyBtn=[[UIButton alloc] initWithFrame:CGRectMake(855, FLOATVIEW_HEIGHT/2-21.5, 113, 43)];
        [m_BuyBtn setBackgroundImage:[UIImage imageNamed:@"red_short.png"] forState:UIControlStateNormal];
        [m_BuyBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [m_BuyBtn.titleLabel setShadowColor:[UIColor darkTextColor]];
        [m_BuyBtn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [m_BuyBtn.titleLabel setFont:[m_BuyBtn.titleLabel.font fontWithSize:20.0]];
        [m_BuyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_BuyBtn];
        
        //空态页面
        m_NilView=[[UILabel alloc] initWithFrame:CGRectMake(FLOATVIEW_WIDTH/2-150, 0, 300, FLOATVIEW_HEIGHT)];
        [m_NilView setBackgroundColor:[UIColor clearColor]];
        [m_NilView setText:@"您的购物车是空的"];
        [m_NilView setTextColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0]];
        [m_NilView setFont:[m_NilView.font fontWithSize:20.0]];
        [m_NilView setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:m_NilView];
        
        //拖动提示
        m_DragPromp=[[UIImageView alloc] initWithFrame:CGRectMake(FLOATVIEW_WIDTH/2-195, FLOATVIEW_HEIGHT/2-27, 389, 54)];
        [m_DragPromp setImage:[UIImage imageNamed:@"cart_drag.png"]];
        [self addSubview:m_DragPromp];
        [m_DragPromp setHidden:YES];
        
        [self updateWithCartVO:cartVO];
    }
    return self;
}

-(void)updateWithCartVO:(CartVO *)cartVO
{
    if (m_CartVO!=nil) {
        [m_CartVO release];
    }
    m_CartVO=[cartVO retain];
    
    [self updateUI];
}

-(void)updateUI
{
    if (m_CartVO!=nil && m_CartVO.buyItemList!=nil && [m_CartVO.buyItemList count]>0) {
        //图片
        CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:[m_CartVO.buyItemList count]-1 inArray:m_CartVO.buyItemList];
        ProductVO *productVO=cartItemVO.product;
        
        [m_ImageView setImageWithURL:[NSURL URLWithString:productVO.miniDefaultProductUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"productDefault"]];
        [m_ImageView setHidden:NO];
        
        //单价
        if (productVO.promotionId!=nil && ![productVO.promotionId isEqualToString:@""]) {
            [m_PriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[productVO.promotionPrice doubleValue]]];
        } else {
            [m_PriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[productVO.price doubleValue]]];
        }
        [m_PriceLabel setHidden:NO];
        
        //减号
        int minCount=[productVO.shoppingCount intValue];
        if (minCount<1) {
            minCount=1;
        }
        int buyCount=[cartItemVO.buyQuantity intValue];
        if (buyCount<=minCount) {
            [m_MinusBtn setEnabled:NO];
        } else {
            [m_MinusBtn setEnabled:YES];
        }
        [m_MinusBtn setHidden:NO];
        
        //单品数量
        [m_CountBtn setTitle:[NSString stringWithFormat:@"%d",buyCount] forState:UIControlStateNormal];
        [m_CountBtn setHidden:NO];
        
        //加号
        [m_AddBtn setHidden:NO];
        
        //数量、重量
        if ([GlobalValue getGlobalValueInstance].token!=nil) {
            if ([m_CartVO.gifItemtList count]>0) {
                [m_CountLabel setText:[NSString stringWithFormat:@"数量:%@件     重量:%.3fkg\n赠品:%d件",m_CartVO.totalquantity,[m_CartVO.totalWeight doubleValue],[m_CartVO.gifItemtList count]]];
            } else {
                [m_CountLabel setText:[NSString stringWithFormat:@"数量:%@件     重量:%.3fkg",m_CartVO.totalquantity,[m_CartVO.totalWeight doubleValue]]];
            }
        } else {
            [m_CountLabel setText:[NSString stringWithFormat:@"数量:%@件",m_CartVO.totalquantity]];
        }
        [m_CountLabel setHidden:NO];
        
        //"商品合计："
        [m_TotalLabel setHidden:NO];
        
        //商品合计
        [m_TotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[m_CartVO.totalprice doubleValue]]];
        [m_TotalPriceLabel setHidden:NO];
        
        //结算
        [m_BuyBtn setHidden:NO];
        
        //空态页面
        [m_NilView setHidden:YES];
    } else {
        [m_ImageView setHidden:YES];
        [m_PriceLabel setHidden:YES];
        [m_MinusBtn setHidden:YES];
        [m_CountBtn setHidden:YES];
        [m_AddBtn setHidden:YES];
        [m_CountLabel setHidden:YES];
        [m_TotalLabel setHidden:YES];
        [m_TotalPriceLabel setHidden:YES];
        [m_BuyBtn setHidden:YES];
        //空态页面
        [m_NilView setHidden:NO];
    }
}

//减少
-(void)minusBtnClicked:(id)sender
{
    CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:[m_CartVO.buyItemList count]-1 inArray:m_CartVO.buyItemList];
    int count=[[m_CountBtn titleForState:UIControlStateNormal] intValue];
    int minCount=[cartItemVO.product.shoppingCount intValue];
    if (minCount<1) {
        minCount=1;
    }
    if (count>minCount) {
        if ([m_Delegate respondsToSelector:@selector(floatView:cartItem:setCount:)]) {
            [m_Delegate floatView:self cartItem:cartItemVO setCount:count-1];
        }
    }
}

//增加
-(void)addBtnClicked:(id)sender
{
    CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:[m_CartVO.buyItemList count]-1 inArray:m_CartVO.buyItemList];
    int count=[[m_CountBtn titleForState:UIControlStateNormal] intValue];
    if ([m_Delegate respondsToSelector:@selector(floatView:cartItem:setCount:)]) {
        [m_Delegate floatView:self cartItem:cartItemVO setCount:count+1];
    }
}

//去结算
-(void)buyBtnClicked:(id)sender
{
    if ([m_Delegate respondsToSelector:@selector(enterCheckOrderForFloatView:)]) {
        [m_Delegate enterCheckOrderForFloatView:self];
    }
}

-(void)showDragPrompt
{
    [m_ImageView setHidden:YES];
    [m_PriceLabel setHidden:YES];
    [m_MinusBtn setHidden:YES];
    [m_CountBtn setHidden:YES];
    [m_AddBtn setHidden:YES];
    [m_CountLabel setHidden:YES];
    [m_TotalLabel setHidden:YES];
    [m_TotalPriceLabel setHidden:YES];
    [m_BuyBtn setHidden:YES];
    [m_NilView setHidden:YES];
    [m_DragPromp setHidden:NO];
}

-(void)hideDragPrompt
{
    [self updateUI];
    [m_DragPromp setHidden:YES];
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_CartVO);
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_ImageView);
    OTS_SAFE_RELEASE(m_PriceLabel);
    OTS_SAFE_RELEASE(m_MinusBtn);
    OTS_SAFE_RELEASE(m_CountBtn);
    OTS_SAFE_RELEASE(m_AddBtn);
    OTS_SAFE_RELEASE(m_CountLabel);
    OTS_SAFE_RELEASE(m_TotalLabel);
    OTS_SAFE_RELEASE(m_TotalPriceLabel);
    OTS_SAFE_RELEASE(m_BuyBtn);
    OTS_SAFE_RELEASE(m_NilView);
    OTS_SAFE_RELEASE(m_DragPromp);
    [super dealloc];
}

@end
