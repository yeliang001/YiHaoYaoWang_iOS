//
//  PADCartPageViewCell.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-22.
//
//
#define DEFAULT_COLOR   [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]
#define DARK_RED    [UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]

#import "PADCartPageViewCell.h"
#import "MobilePromotionVO.h"
#import "SDImageView+SDWebCache.h"
#import "StrikeThroughLabel.h"
#import "MobClick.h"

@implementation PADCartPageViewCell

-(id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO mobilePromotionVO:(MobilePromotionVO *)mobilePromotionVO tag:(int)tag type:(PageViewCellType)type delegate:(id<PADCartPageViewCellDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_CartVO=[cartVO retain];
        m_MobilePromotionVO=[mobilePromotionVO retain];
        m_Tag=tag;
        m_Type=type;
        m_Delegate=delegate;
        
        ProductVO *productVO=[OTSUtility safeObjectAtIndex:tag inArray:m_MobilePromotionVO.productVOList];
        CGFloat width=frame.size.width;
        
        //商品图片
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(width/2-80, 10, 160, 160)];
        [imageView setImageWithURL:[NSURL URLWithString:productVO.midleDefaultProductUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"productDefault"]];
        [self addSubview:imageView];
        [imageView release];
        
        //商品名称
        UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(20, 185, width-40, 50)];
        [name setBackgroundColor:[UIColor clearColor]];
        [name setNumberOfLines:2];
        [name setText:productVO.cnName];
        [name setTextColor:DEFAULT_COLOR];
        [name setFont:[name.font fontWithSize:17.0]];
        [self addSubview:name];
        [name release];
        
        //价格
        UILabel *price;
        if (m_Type==PAGE_VIEW_CELL_GIFT) {//赠品化掉市场价
            price=[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(20, 235, 100, 25)];
            if ([productVO.maketPrice doubleValue]>0.0001) {//优先显示市场价
                [price setText:[NSString stringWithFormat:@"￥%.2f",[productVO.maketPrice doubleValue]]];
            } else if ([productVO.price doubleValue]>0.0001) {//其次显示原价
                [price setText:[NSString stringWithFormat:@"￥%.2f",[productVO.price doubleValue]]];
            } else {//最后显示促销价
                [price setText:[NSString stringWithFormat:@"￥%.2f",[productVO.promotionPrice doubleValue]]];
            }
        } else {
            price=[[UILabel alloc] initWithFrame:CGRectMake(20, 235, 100, 25)];
            if ([productVO.promotionPrice doubleValue]>0.0001) {//优先显示促销价
                [price setText:[NSString stringWithFormat:@"￥%.2f",[productVO.promotionPrice doubleValue]]];
            } else {//最后显示原价
                [price setText:[NSString stringWithFormat:@"￥%.2f",[productVO.price doubleValue]]];
            }
        }
        [price setBackgroundColor:[UIColor clearColor]];
        [price setTextColor:DARK_RED];
        [price setFont:[UIFont boldSystemFontOfSize:20.0]];
        [self addSubview:price];
        [price release];
        
        //限量
        UILabel *limit=[[UILabel alloc] initWithFrame:CGRectMake(width-140, 235, 120, 25)];
        [limit setBackgroundColor:[UIColor clearColor]];
        [limit setText:productVO.totalQuantityLimit];
        [limit setTextColor:DEFAULT_COLOR];
        [limit setFont:[name.font fontWithSize:17.0]];
        [limit setTextAlignment:NSTextAlignmentRight];
        [self addSubview:limit];
        [limit release];
        
        //已领完
        if ([productVO.isSoldOut intValue]==1) {
            UIImageView *soldoutImage=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-68, 0, 67, 69)];
            [soldoutImage setImage:[UIImage imageNamed:@"padSoldOutCornerMark"]];
            [self addSubview:soldoutImage];
            [soldoutImage release];
        } else {
            //do nothing
        }
        
        //虚线
        UIImageView *dotline=[[UIImageView alloc] initWithFrame:CGRectMake(width-1, 0, 1, frame.size.height)];
        [dotline setImage:[UIImage imageNamed:@"cart_gift_dotline.png"]];
        [self addSubview:dotline];
        [dotline release];
        
        if ([m_MobilePromotionVO.canJoin intValue]==1 && [productVO.isSoldOut intValue]!=1) {//满足领取条件，未领完
            //选中状态
            m_SelectStateImageView=[[UIImageView alloc] initWithFrame:CGRectMake(178, 0, 39, 35)];
            
            BOOL shouldSelect=NO;
            NSArray *tempArray;
            if (m_Type==PAGE_VIEW_CELL_GIFT) {
                tempArray=m_CartVO.gifItemtList;
            } else if (m_Type==PAGE_VIEW_CELL_REDEMPTION) {
                tempArray=m_CartVO.redemptionItemList;
            }
            int i;
            for (i=0; i<[tempArray count]; i++) {
                CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:i inArray:tempArray];
                if ([cartItemVO.product.productId intValue]==[productVO.productId intValue] && [cartItemVO.product.promotionId isEqualToString:productVO.promotionId]) {
                    shouldSelect=YES;
                    break;
                }
            }
            
            m_Selected=shouldSelect;
            if (shouldSelect) {
                [m_SelectStateImageView setImage:[UIImage imageNamed:@"cart_gift_sel.png"]];
            } else {
                [m_SelectStateImageView setImage:[UIImage imageNamed:@"cart_gift_unsel.png"]];
            }
            [self addSubview:m_SelectStateImageView];
            
            //手势处理
            UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [self addGestureRecognizer:tapGes];
            [tapGes release];
        }
    }
    return self;
}

//手势处理
-(void)handleTap:(UIPanGestureRecognizer*)gestureRecognizer
{
    if (m_Type==PAGE_VIEW_CELL_GIFT) {
        if (m_Selected) {
            if ([m_Delegate respondsToSelector:@selector(deleteGiftPageViewCellAtIndex:)]) {
                [m_Delegate deleteGiftPageViewCellAtIndex:[NSNumber numberWithInt:m_Tag]];
            }
        } else {
            if ([m_Delegate respondsToSelector:@selector(selectGiftPageViewCellAtIndex:)]) {
                [m_Delegate selectGiftPageViewCellAtIndex:[NSNumber numberWithInt:m_Tag]];
            }
            //友盟统计
            [MobClick event:@"buy_free"];
        }
    } else if (m_Type==PAGE_VIEW_CELL_REDEMPTION) {
        if (m_Selected) {
            if ([m_Delegate respondsToSelector:@selector(deleteRedemptionPageViewCellAtIndex:)]) {
                [m_Delegate deleteRedemptionPageViewCellAtIndex:[NSNumber numberWithInt:m_Tag]];
            }
        } else {
            if ([m_Delegate respondsToSelector:@selector(selectRedemptionPageViewCellAtIndex:)]) {
                [m_Delegate selectRedemptionPageViewCellAtIndex:[NSNumber numberWithInt:m_Tag]];
            }
            //友盟统计
            [MobClick event:@"buy_huangou"];
        }
    }
}

-(void)setSelectedState:(BOOL)selected
{
    m_Selected=selected;
    if (selected) {
        [m_SelectStateImageView setImage:[UIImage imageNamed:@"cart_gift_sel.png"]];
    } else {
        [m_SelectStateImageView setImage:[UIImage imageNamed:@"cart_gift_unsel.png"]];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_CartVO);
    OTS_SAFE_RELEASE(m_MobilePromotionVO);
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_SelectStateImageView);
    [super dealloc];
}

@end
