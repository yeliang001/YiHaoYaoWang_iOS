//
//  PADCartProductColumnCell.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//
#define DEFAULT_COLOR   [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]
#define DARK_RED    [UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]

#import "PADCartProductColumnCell.h"
#import "SDImageView+SDWebCache.h"
#import "MobClick.h"

@implementation PADCartProductColumnCell
@synthesize imageView=m_ImageView,productVO=m_ProductVO,type=m_Type;

-(id)initWithFrame:(CGRect)frame delegate:(id<PADTableViewColumnCellDelegate>)delegate type:(ProductColumnCellType)type
{
    self=[super initWithFrame:frame delegate:delegate];
    if (self) {
        // Initialization code
        m_Type=type;
        //商品图片
        m_ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(43, 13, 170, 170)];
        [m_BackgroundImage addSubview:m_ImageView];
        
        //名称
        m_Name=[[UILabel alloc] initWithFrame:CGRectMake(43, 183, 170, 45)];
        [m_Name setBackgroundColor:[UIColor clearColor]];
        [m_Name setNumberOfLines:2];
        [m_Name setTextColor:DEFAULT_COLOR];
        [m_Name setFont:[m_Name.font fontWithSize:17.0]];
        [m_BackgroundImage addSubview:m_Name];
        
        //价格
        m_Price=[[UILabel alloc] initWithFrame:CGRectMake(43, 228, 170, 25)];
        [m_Price setBackgroundColor:[UIColor clearColor]];
        [m_Price setTextColor:DARK_RED];
        m_Price.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
        [m_BackgroundImage addSubview:m_Price];
        
        //购物车图标
        m_Cart=[[UIButton alloc] initWithFrame:CGRectMake(196, 211, 60, 60)];
        [m_Cart setBackgroundImage:[UIImage imageNamed:@"cart_product_cart.png"] forState:UIControlStateNormal];
        [m_Cart addTarget:self action:@selector(cartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_Cart];
        
        UIView *rightLine=[[UIView alloc] initWithFrame:CGRectMake(frame.size.width-1, 0, 1, frame.size.height)];
        [rightLine setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]];
        [self addSubview:rightLine];
        [rightLine release];
        
        UIView *downLine=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        [downLine setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]];
        [self addSubview:downLine];
        [downLine release];
    }
    return self;
}

-(void)updateWithArray:(NSArray *)array index:(NSInteger)index
{
    [super updateWithArray:array index:index];
    if (m_ProductVO!=nil) {
        [m_ProductVO release];
    }
    if (index<[array count]) {
        ProductVO *productVO=[OTSUtility safeObjectAtIndex:index inArray:array];
        m_ProductVO=[productVO retain];
        if (productVO.midleDefaultProductUrl!=nil) {
            [m_ImageView setImageWithURL:[NSURL URLWithString:productVO.midleDefaultProductUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"productDefault"]];
        } else {
            [m_ImageView setImageWithURL:[NSURL URLWithString:productVO.miniDefaultProductUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"productDefault"]];
        }
        [m_Name setText:productVO.cnName];
        NSString *priceStr=nil;
        [m_Price setHidden:NO];
        if (m_Type==CELL_FOR_FAVORITE) {
            //商品价格，优先显示1号店价
            if (productVO.price == nil || productVO.price.doubleValue == 0){
                priceStr = @"";
                [m_Price setHidden:YES];
            }else
            if ([productVO.price doubleValue]>0.0001) {
                priceStr=[NSString stringWithFormat:@"￥%.2f",[productVO.price doubleValue]];
            } else {
                priceStr=[NSString stringWithFormat:@"￥%.2f",[productVO.promotionPrice doubleValue]];
            }
        }
        else if(m_Type==CELL_FOR_BROWSE){
            //商品价格，优先显示1号店价
            if ([productVO.price doubleValue]>0.0001) {
                priceStr=[NSString stringWithFormat:@"￥%.2f",[productVO.price doubleValue]];
            } else {
                priceStr=[NSString stringWithFormat:@"￥%.2f",[productVO.promotionPrice doubleValue]];
            }
        }
        else {
            //商品价格，优先显示促销价
            if (productVO.promotionId!=nil && ![productVO.promotionId isEqualToString:@""]) {
                priceStr=[NSString stringWithFormat:@"￥%.2f",[productVO.promotionPrice doubleValue]];
            } else {
                priceStr=[NSString stringWithFormat:@"￥%.2f",[productVO.price doubleValue]];
            }
        }
        if ([priceStr hasSuffix:@"0"] ) {
            priceStr=[priceStr substringToIndex:priceStr.length-1];
            if ([priceStr hasSuffix:@".0"] ) {
                priceStr=[priceStr substringToIndex:priceStr.length-2];
            }
        }
        [m_Price setText:priceStr];

        if ([productVO.canBuy isEqualToString:@"false"] || (m_Type == CELL_FOR_FAVORITE && (productVO.price == nil || productVO.price.doubleValue == 0))) {
            [m_Cart setBackgroundImage:[UIImage imageNamed:@"cart_product_cart_unsel.png"] forState:UIControlStateDisabled];
            [m_Cart setEnabled:NO];
        } else {
            [m_Cart setBackgroundImage:[UIImage imageNamed:@"cart_product_cart.png"] forState:UIControlStateNormal];
            [m_Cart setEnabled:YES];
        }
    } else {
        m_ProductVO=nil;
    }
}

-(void)cartBtnClicked:(id)sender
{
    if ([m_ProductVO.canBuy isEqualToString:@"false"]) {
        return;
    } else {
        if ([m_Delegate respondsToSelector:@selector(tableViewColumnCell:addProductAtIndex:)]) {
            [m_Delegate tableViewColumnCell:self addProductAtIndex:m_Index];
        }
        
        //友盟统计
        if (m_Type==CELL_FOR_BROWSE) {
            [MobClick event:@"buy_history"];
        } else if (m_Type==CELL_FOR_FAVORITE) {
            [MobClick event:@"buy_fav"];
        } else {
            [MobClick event:@"buy_cartrecord"];
        }
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_ImageView);
    OTS_SAFE_RELEASE(m_Name);
    OTS_SAFE_RELEASE(m_Price);
    OTS_SAFE_RELEASE(m_Cart);
    OTS_SAFE_RELEASE(m_ProductVO);
    [super dealloc];
}

@end
