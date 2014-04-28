//
//  PADCartTableViewCell.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-23.
//
//
#define DEFAULT_COLOR   [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]

#import "PADCartTableViewCell.h"
#import "SDImageView+SDWebCache.h"
#import "CartService.h"
#import "GlobalValue.h"

@implementation PADCartTableViewCell
@synthesize delegate=m_Delegate,cartItemVO=m_CartItemVO;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        m_ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 16, 70, 70)];
        [self addSubview:m_ImageView];
        
        m_NameLabel=[[UILabel alloc] initWithFrame:CGRectMake(110, 26, 230, 50)];
        [m_NameLabel setBackgroundColor:[UIColor clearColor]];
        [m_NameLabel setTextColor:DEFAULT_COLOR];
        [m_NameLabel setFont:[m_NameLabel.font fontWithSize:17.0]];
        [m_NameLabel setNumberOfLines:2];
        [self addSubview:m_NameLabel];
        
        m_UnitPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(345, 36, 125, 30)];
        [m_UnitPriceLabel setBackgroundColor:[UIColor clearColor]];
        [m_UnitPriceLabel setTextColor:DEFAULT_COLOR];
        [m_UnitPriceLabel setFont:[m_UnitPriceLabel.font fontWithSize:17.0]];
        [m_UnitPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:m_UnitPriceLabel];
        
        m_MinusBtn=[[UIButton alloc] initWithFrame:CGRectMake(482, 36, 32, 30)];
        [m_MinusBtn setBackgroundImage:[UIImage imageNamed:@"reduceavailabel.png"] forState:UIControlStateNormal];
        [m_MinusBtn setBackgroundImage:[UIImage imageNamed:@"reduceunavailabel.png"] forState:UIControlStateDisabled];
        [m_MinusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_MinusBtn];
        
        m_CountBtn=[[UIButton alloc] initWithFrame:CGRectMake(514, 36, 40, 30)];
        [m_CountBtn.layer setBorderWidth:1.0];
        [m_CountBtn.layer setBorderColor:[[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0] CGColor]];
        [m_CountBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
        [self addSubview:m_CountBtn];
        
        m_AddBtn=[[UIButton alloc] initWithFrame:CGRectMake(554, 36, 32, 30)];
        [m_AddBtn setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [m_AddBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_AddBtn];
        
        m_WeightLabel=[[UILabel alloc] initWithFrame:CGRectMake(604, 36, 115, 30)];
        [m_WeightLabel setBackgroundColor:[UIColor clearColor]];
        [m_WeightLabel setTextColor:DEFAULT_COLOR];
        [m_WeightLabel setFont:[m_WeightLabel.font fontWithSize:17.0]];
        [m_WeightLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:m_WeightLabel];
        
        m_TotalPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(722, 36, 125, 30)];
        [m_TotalPriceLabel setBackgroundColor:[UIColor clearColor]];
        [m_TotalPriceLabel setTextColor:DEFAULT_COLOR];
        [m_TotalPriceLabel setFont:[m_TotalPriceLabel.font fontWithSize:17.0]];
        [m_TotalPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:m_TotalPriceLabel];
        
        m_DeleteBtn=[[UIButton alloc] initWithFrame:CGRectMake(846, 35, 55, 32)];
        [m_DeleteBtn setBackgroundImage:[UIImage imageNamed:@"gray_short.png"] forState:UIControlStateNormal];
        [m_DeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [m_DeleteBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
        [m_DeleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_DeleteBtn];
        
        m_FavoriteBtn=[[UIButton alloc] initWithFrame:CGRectMake(909, 35, 55, 32)];
        [m_FavoriteBtn setBackgroundImage:[UIImage imageNamed:@"gray_short.png"] forState:UIControlStateNormal];
        [m_FavoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [m_FavoriteBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
        [m_FavoriteBtn addTarget:self action:@selector(favoriteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_FavoriteBtn];
        
        //商品类型，普通商品、赠品或换购
        m_TypeImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        [self addSubview:m_TypeImage];
        
        //收藏成功
        m_FavoriteSuccess=[[UIImageView alloc] initWithFrame:CGRectMake(902, -1, 70, 40)];
        [m_FavoriteSuccess setImage:[UIImage imageNamed:@"FavouriteResultInCartCell.png"]];
        [self addSubview:m_FavoriteSuccess];
        [m_FavoriteSuccess setHidden:YES];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"收藏成功"];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[label.font fontWithSize:14.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [m_FavoriteSuccess addSubview:label];
        [label release];
        
        //商品已收藏
        m_HaveFavorited=[[UIImageView alloc] initWithFrame:CGRectMake(894, -1, 85, 40)];
        [m_HaveFavorited setImage:[UIImage imageNamed:@"FavouriteResultInCartCellLong.png"]];
        [self addSubview:m_HaveFavorited];
        [m_HaveFavorited setHidden:YES];
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 35)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"商品已收藏"];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[label.font fontWithSize:14.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [m_HaveFavorited addSubview:label];
        [label release];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 101, 976, 1)];
        [line setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
        [self addSubview:line];
        [line release];
    }
    return self;
}

-(void)updateWithCartItemVO:(CartItemVO *)cartItemVO type:(CartItemType)type
{
    if (m_CartItemVO!=nil) {
        [m_CartItemVO release];
    }
    m_CartItemVO=[cartItemVO retain];
    
    ProductVO *productVO=cartItemVO.product;
    [m_ImageView setImageWithURL:[NSURL URLWithString:productVO.miniDefaultProductUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"productDefault"]];
    if (type==CARTITEM_TYPE_GIFT) {
        [m_TypeImage setImage:[UIImage imageNamed:@"free"]];
    } else if (type==CARTITEM_TYPE_CASH) {
        [m_TypeImage setImage:nil];
    } else if (type==CARTITEM_TYPE_REDEMPTION) {
        [m_TypeImage setImage:[UIImage imageNamed:@"redeem"]];
    } else {
        [m_TypeImage setImage:nil];
    }
    [m_NameLabel setText:productVO.cnName];
    double realPrice;
    if (productVO.promotionId!=nil && ![productVO.promotionId isEqualToString:@""]) {
        realPrice=[productVO.promotionPrice doubleValue];
    } else {
        realPrice=[productVO.price doubleValue];
    }
    NSString* priceStr=[NSString stringWithFormat:@"￥%.2f",realPrice];
    if ([priceStr hasSuffix:@"0"] ) {
        priceStr=[priceStr substringToIndex:priceStr.length-1];
        if ([priceStr hasSuffix:@".0"] ) {
            priceStr=[priceStr substringToIndex:priceStr.length-2];
        }
    }
    [m_UnitPriceLabel setText:priceStr];
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
    [m_CountBtn setTitle:[NSString stringWithFormat:@"%d",buyCount] forState:UIControlStateNormal];
    if (cartItemVO.grossWeight!=nil) {
        [m_WeightLabel setText:[NSString stringWithFormat:@"%.3fkg",[cartItemVO.grossWeight doubleValue]]];
    } else {
        [m_WeightLabel setText:@""];
    }
    
    NSString* priStr=[NSString stringWithFormat:@"￥%.2f",realPrice*buyCount];
    if ([priStr hasSuffix:@"0"] ) {
        priStr=[priStr substringToIndex:priStr.length-1];
        if ([priStr hasSuffix:@".0"] ) {
            priStr=[priStr substringToIndex:priStr.length-2];
        }
    }
    [m_TotalPriceLabel setText:priStr];
    
    if (type==CARTITEM_TYPE_NORMAL) {
        [m_MinusBtn setHidden:NO];
        [m_AddBtn setHidden:NO];
        [m_CountBtn.layer setBorderColor:[[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0] CGColor]];
        [m_FavoriteBtn setHidden:NO];
    } else {
        [m_MinusBtn setHidden:YES];
        [m_AddBtn setHidden:YES];
        [m_CountBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
        [m_FavoriteBtn setHidden:YES];
    }
}

//减少
-(void)minusBtnClicked:(id)sender
{
    int count=[[m_CountBtn titleForState:UIControlStateNormal] intValue];
    int minCount=[m_CartItemVO.product.shoppingCount intValue];
    if (minCount<1) {
        minCount=1;
    }
    if (count>minCount) {
        if ([m_Delegate respondsToSelector:@selector(tableViewCell:setCartItemCount:)]) {
            [m_Delegate tableViewCell:self setCartItemCount:count-1];
        }
    }
}

//增加
-(void)addBtnClicked:(id)sender
{
    int count=[[m_CountBtn titleForState:UIControlStateNormal] intValue];
    if ([m_Delegate respondsToSelector:@selector(tableViewCell:setCartItemCount:)]) {
        [m_Delegate tableViewCell:self setCartItemCount:count+1];
    }
}

//删除
-(void)deleteBtnClicked:(id)sender
{
    if ([m_Delegate respondsToSelector:@selector(tableViewCellDeleteCartItem:)]) {
        [m_Delegate tableViewCellDeleteCartItem:self];
    }
}

//收藏
-(void)favoriteBtnClicked:(id)sender
{
    if ([m_Delegate respondsToSelector:@selector(tableViewCellAddFavorite:)]) {
        [m_Delegate tableViewCellAddFavorite:self];
    }
}

//收藏结果提示
-(void)showFavoriteTip:(CartItemFavoriteResult)result
{
    if (result==CARTITEM_FAVORITE_SUCCESS) {//收藏成功
        [m_FavoriteSuccess setHidden:NO];
        [m_HaveFavorited setHidden:YES];
    } else if (result==CARTITEM_HAVE_FAVORITED) {//商品已收藏
        [m_FavoriteSuccess setHidden:YES];
        [m_HaveFavorited setHidden:NO];
    }
    [self performSelector:@selector(hideFavoriteTip) withObject:nil afterDelay:3];
}

//隐藏收藏结果提示
-(void)hideFavoriteTip
{
    [m_FavoriteSuccess setHidden:YES];
    [m_HaveFavorited setHidden:YES];
}

-(void)dealloc
{
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_ImageView);
    OTS_SAFE_RELEASE(m_TypeImage);
    OTS_SAFE_RELEASE(m_NameLabel);
    OTS_SAFE_RELEASE(m_UnitPriceLabel);
    OTS_SAFE_RELEASE(m_MinusBtn);
    OTS_SAFE_RELEASE(m_CountBtn);
    OTS_SAFE_RELEASE(m_AddBtn);
    OTS_SAFE_RELEASE(m_WeightLabel);
    OTS_SAFE_RELEASE(m_TotalPriceLabel);
    OTS_SAFE_RELEASE(m_DeleteBtn);
    OTS_SAFE_RELEASE(m_FavoriteBtn);
    OTS_SAFE_RELEASE(m_CartItemVO);
    OTS_SAFE_RELEASE(m_FavoriteSuccess);
    OTS_SAFE_RELEASE(m_HaveFavorited);
    [super dealloc];
}

@end