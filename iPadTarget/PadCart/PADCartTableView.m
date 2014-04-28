//
//  PADCartTableView.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-20.
//
//
#define DEFAULT_COLOR   [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]
#import "PADCartTableView.h"
#import "PADCartTableViewCell.h"
#import "CartVO.h"
#import "GlobalValue.h"
#import "PADCartViewController.h"
#import "MBProgressHUD.h"

@implementation PADCartTableView

-(id)initWithFrame:(CGRect)frame promotions:(BOOL)promot cartVO:(CartVO *)cartVO delegate:(id<PADCartTableViewDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_CartVO=[cartVO retain];
        m_Delegate=delegate;
        
        CGFloat yValue=20.0;
        
        [self initBackgroundView];
        
        [self initTableTitleViewWithFrame:CGRectMake(0, yValue, TABLEVIEW_WIDTH, 46)];
        yValue+=46.0;
        
        m_TableView=[[UITableView alloc] initWithFrame:CGRectMake(1, yValue, TABLEVIEW_WIDTH-2, 460)];
        [m_TableView setDelegate:self];
        [m_TableView setDataSource:self];
        [m_TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:m_TableView];
        yValue+=m_TableView.frame.size.height;
        
        [self initTableFootViewWithFrame:CGRectMake(0, yValue, TABLEVIEW_WIDTH, 64)];
        yValue+=64.0;
        
        [self initConfirmClearCartView];
        [self initConfirmDeleteCartItemView];
        
        // 验证是否有促销 和 传过来的促销状态
        CGPoint po=CGPointMake(60,yValue+40);
        if (cartVO.totalquantityMall.intValue>0) {
            po=CGPointMake(60,yValue);
        }
        if (promot && [self checkExsitPromotionItems:cartVO] && [GlobalValue getGlobalValueInstance].token) {
            [self showBarTip:@"" offset:po];
            SharedPadDelegate.isFirstLaunchCart = NO;
            if ([m_Delegate respondsToSelector:@selector(removePromotTag)]) {
                [delegate removePromotTag];
            }
        }
        
        m_FootLabel=[[UILabel alloc] initWithFrame:CGRectMake(375, yValue, 604, 52)];
        [m_FootLabel setBackgroundColor:[UIColor clearColor]];
        int currentProvinceId=[[GlobalValue getGlobalValueInstance].provinceId intValue];
        if (currentProvinceId==1 || currentProvinceId==2 || currentProvinceId==5 || currentProvinceId==6 || currentProvinceId==20) {
            [m_FootLabel setText:@"1号药店商品每满100元免10kg运费,服装类商品满100元免1kg运费"];
        } else if (currentProvinceId==3 || currentProvinceId==18) {
            [m_FootLabel setText:@"1号药店商品每满100元免5kg运费,服装类商品满100元免1kg运费"];
        } else {
            [m_FootLabel setText:@"1号药网商品每满500元免3kg运费,服装类商品满100元免1kg运费"];
        }
        [m_FootLabel setTextColor:DEFAULT_COLOR];
        [m_FootLabel setFont:[m_FootLabel.font fontWithSize:17.0]];
        [m_FootLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:m_FootLabel];
        yValue+=m_FootLabel.frame.size.height;
    }
    return self;
}


//判断购物车有无促销
-(BOOL)checkExsitPromotionItems:(CartVO *)cartVO
{
    BOOL hasGift=NO;
    BOOL hasRedemption=NO;
    int i;
    for (i=0; i<[cartVO.buyItemList count]; i++) {
        CartItemVO *cartItemVO=[cartVO.buyItemList objectAtIndex:i];
        ProductVO *productVO=cartItemVO.product;
        if ([productVO.hasGift intValue]==1) {
            hasGift=YES;
        }
        if ([productVO.hasRedemption intValue]==1) {
            hasRedemption=YES;
        }
    }

    return hasGift || hasRedemption;
}

-(void)initBackgroundView
{
    UIView *bg=[[UIView alloc] initWithFrame:CGRectMake(0, 20.0, TABLEVIEW_WIDTH, 570)];
    [bg setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [bg.layer setCornerRadius:10.0];
    [bg.layer setBorderWidth:1.0];
    [bg.layer setBorderColor:[[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0] CGColor]];
    [self addSubview:bg];
    [bg release];
}

-(void)initTableTitleViewWithFrame:(CGRect)frame
{
    CGFloat tableTitleHeight=frame.size.height;
    UIView *tableTitleView=[[UIView alloc] initWithFrame:frame];
    [self addSubview:tableTitleView];
    [tableTitleView release];
    
    //商品名称
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, tableTitleHeight)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"商品名称"];
    [label setTextColor:DEFAULT_COLOR];
    [label setFont:[label.font fontWithSize:17.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [tableTitleView addSubview:label];
    [label release];
    
    //单价
    label=[[UILabel alloc] initWithFrame:CGRectMake(345, 0, 125, tableTitleHeight)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"单价"];
    [label setTextColor:DEFAULT_COLOR];
    [label setFont:[label.font fontWithSize:17.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [tableTitleView addSubview:label];
    [label release];
    
    //购买数量
    label=[[UILabel alloc] initWithFrame:CGRectMake(487, 0, 85, tableTitleHeight)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"购买数量"];
    [label setTextColor:DEFAULT_COLOR];
    [label setFont:[label.font fontWithSize:17.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [tableTitleView addSubview:label];
    [label release];
    
    //重量
    label=[[UILabel alloc] initWithFrame:CGRectMake(604, 0, 115, tableTitleHeight)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"重量"];
    [label setTextColor:DEFAULT_COLOR];
    [label setFont:[label.font fontWithSize:17.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [tableTitleView addSubview:label];
    [label release];
    
    //商品合计
    label=[[UILabel alloc] initWithFrame:CGRectMake(722, 0, 125, tableTitleHeight)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"商品合计"];
    [label setTextColor:DEFAULT_COLOR];
    [label setFont:[label.font fontWithSize:17.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [tableTitleView addSubview:label];
    [label release];
    
    //操作
    label=[[UILabel alloc] initWithFrame:CGRectMake(843, 0, 125, tableTitleHeight)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"操作"];
    [label setTextColor:DEFAULT_COLOR];
    [label setFont:[label.font fontWithSize:17.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [tableTitleView addSubview:label];
    [label release];
}

-(void)initTableFootViewWithFrame:(CGRect)frame
{
    CGFloat tableFootHeight=frame.size.height;
    UIView *tableFootView=[[UIView alloc] initWithFrame:frame];
    [self addSubview:tableFootView];
    [tableFootView release];
    
    //清空购物车
    UIButton *clearCartBtn=[[UIButton alloc] initWithFrame:CGRectMake(17, tableFootHeight/2-16, 97, 32)];
    [clearCartBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [clearCartBtn setTitle:@"清空购物车" forState:UIControlStateNormal];
    [clearCartBtn.titleLabel setShadowColor:[UIColor darkTextColor]];
    [clearCartBtn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [clearCartBtn addTarget:self action:@selector(clearCartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tableFootView addSubview:clearCartBtn];
    [clearCartBtn release];
    
    //继续购物
    UIButton *shopBtn=[[UIButton alloc] initWithFrame:CGRectMake(128, tableFootHeight/2-16, 97, 32)];
    [shopBtn setBackgroundImage:[UIImage imageNamed:@"gray_mid.png"] forState:UIControlStateNormal];
    [shopBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [shopBtn setTitle:@"继续购物" forState:UIControlStateNormal];
    [shopBtn addTarget:self action:@selector(shopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tableFootView addSubview:shopBtn];
    [shopBtn release];
    
    //数量、重量
    m_CountLabel=[[UILabel alloc] initWithFrame:CGRectMake(297, tableFootHeight/2-16, 250, 32)];
    [m_CountLabel setBackgroundColor:[UIColor clearColor]];    
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        [m_CountLabel setText:[NSString stringWithFormat:@"数量:%@件     重量:%.3fkg",m_CartVO.totalquantity,[m_CartVO.totalWeight doubleValue]]];
    } else {
        [m_CountLabel setText:[NSString stringWithFormat:@"数量:%@件",m_CartVO.totalquantity]];
    }
    [m_CountLabel setTextColor:DEFAULT_COLOR];
    [m_CountLabel setFont:[m_CountLabel.font fontWithSize:17.0]];
    [m_CountLabel setTextAlignment:NSTextAlignmentCenter];
    [tableFootView addSubview:m_CountLabel];
    
    //商品合计
    UILabel *totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(547, tableFootHeight/2-16, 185, 32)];
    [totalLabel setBackgroundColor:[UIColor clearColor]];
    [totalLabel setText:[NSString stringWithFormat:@"商品合计(未含运费):"]];
    [totalLabel setFont:[UIFont systemFontOfSize:17.0]];
    [totalLabel setTextColor:DEFAULT_COLOR];
    [totalLabel setFont:[totalLabel.font fontWithSize:19.0]];
    [totalLabel setTextAlignment:NSTextAlignmentRight];
    [tableFootView addSubview:totalLabel];
    [totalLabel release];
    
    m_TotalPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(732, tableFootHeight/2-16, 120, 32)];
    [m_TotalPriceLabel setBackgroundColor:[UIColor clearColor]];

    NSString* priceStr=[NSString stringWithFormat:@"￥%.2f",[m_CartVO.totalprice doubleValue]];
    if ([priceStr hasSuffix:@"0"] ) {
        priceStr=[priceStr substringToIndex:priceStr.length-1];
        if ([priceStr hasSuffix:@".0"] ) {
            priceStr=[priceStr substringToIndex:priceStr.length-2];
        }
    }
    m_TotalPriceLabel.text=priceStr;
    [m_TotalPriceLabel setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
    [m_TotalPriceLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [tableFootView addSubview:m_TotalPriceLabel];
    
    //去结算
    UIButton *buyBtn=[[UIButton alloc] initWithFrame:CGRectMake(852, 11, 113, 43)];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"red_short.png"] forState:UIControlStateNormal];
    [buyBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [buyBtn.titleLabel setShadowColor:[UIColor darkTextColor]];
    [buyBtn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [buyBtn.titleLabel setFont:[buyBtn.titleLabel.font fontWithSize:20.0]];
    [buyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tableFootView addSubview:buyBtn];
    [buyBtn release];
}

-(void)initConfirmClearCartView
{
    m_ClearCartView=[[UIView alloc] initWithFrame:CGRectMake(25, self.frame.size.height-180, 290, 86)];
    [self addSubview:m_ClearCartView];
    [m_ClearCartView setHidden:YES];
    
    UIImageView *bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 86)];
    [bg setImage:[UIImage imageNamed:@"confirm_black_down.png"]];
    [m_ClearCartView addSubview:bg];
    [bg release];
    
    UIButton *confirmBtn=[[UIButton alloc] initWithFrame:CGRectMake(7, 8, 275, 46)];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"confirm_red"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"confirm_red_h"] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"清空购物车" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [confirmBtn.titleLabel setFont:[confirmBtn.titleLabel.font fontWithSize:20.0]];
    [confirmBtn addTarget:self action:@selector(didClearCart:) forControlEvents:UIControlEventTouchUpInside];
    [m_ClearCartView addSubview:confirmBtn];
    [confirmBtn release];
}

-(void)initConfirmDeleteCartItemView
{
    m_DeleteCartItemView=[[UIView alloc] initWithFrame:CGRectMake(624, 0, 290, 86)];
    [self addSubview:m_DeleteCartItemView];
    [m_DeleteCartItemView setHidden:YES];
    
    UIImageView *bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 86)];
    [bg setImage:[UIImage imageNamed:@"confirm_black_up.png"]];
    [m_DeleteCartItemView addSubview:bg];
    [bg release];
    
    UIButton *confirmBtn=[[UIButton alloc] initWithFrame:CGRectMake(7, 24, 275, 46)];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"confirm_red"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"confirm_red_h"] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"删除商品" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [confirmBtn.titleLabel setFont:[confirmBtn.titleLabel.font fontWithSize:20.0]];
    [confirmBtn addTarget:self action:@selector(didDeleteCartItem:) forControlEvents:UIControlEventTouchUpInside];
    [m_DeleteCartItemView addSubview:confirmBtn];
    [confirmBtn release];
}

-(void)updateWithCartVO:(CartVO *)cartVO promotions:(BOOL)promot delegate:(id<PADCartTableViewDelegate>)delegate
{
    if (m_CartVO!=nil) {
        [m_CartVO release];
    }
    m_CartVO=[cartVO retain];
    
    [m_TableView reloadData];
    
    
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        [m_CountLabel setText:[NSString stringWithFormat:@"数量:%@件     重量:%.3fkg",m_CartVO.totalquantity,[m_CartVO.totalWeight doubleValue]]];
    } else {
        [m_CountLabel setText:[NSString stringWithFormat:@"数量:%@件",m_CartVO.totalquantity]];
    }
    
    NSString* priceStr=[NSString stringWithFormat:@"￥%.2f",[m_CartVO.totalprice doubleValue]];
    if ([priceStr hasSuffix:@"0"] ) {
        priceStr=[priceStr substringToIndex:priceStr.length-1];
        if ([priceStr hasSuffix:@".0"] ) {
            priceStr=[priceStr substringToIndex:priceStr.length-2];
        }
    }
    m_TotalPriceLabel.text=priceStr;
    
    int currentProvinceId=[[GlobalValue getGlobalValueInstance].provinceId intValue];
    if (currentProvinceId==1 || currentProvinceId==2 || currentProvinceId==5 || currentProvinceId==6 || currentProvinceId==20) {
        [m_FootLabel setText:@"1号药店商品每满100元免10kg运费,服装类商品满100元免1kg运费"];
    } else if (currentProvinceId==3 || currentProvinceId==18) {
        [m_FootLabel setText:@"1号药店商品每满100元免5kg运费,服装类商品满100元免1kg运费"];
    } else {
        [m_FootLabel setText:@"1号药店商品每满500元免3kg运费,服装类商品满100元免1kg运费"];
    }
    // 验证是否有促销 和 传过来的促销状态
    if (promot && [self checkExsitPromotionItems:cartVO] && [GlobalValue getGlobalValueInstance].token) {
        if (cartVO.totalquantityMall.intValue>0) {
            [self showBarTip:@"" offset:CGPointMake(60,m_FootLabel.frame.origin.y)];
        }else{
            [self showBarTip:@"" offset:CGPointMake(60,m_FootLabel.frame.origin.y+40)];
        }
        SharedPadDelegate.isFirstLaunchCart = NO;
        if ([m_Delegate respondsToSelector:@selector(removePromotTag)]) {
            [delegate removePromotTag];
        }
    }
}

-(void)hideConfirmView
{
    [m_ClearCartView setHidden:YES];
    [m_DeleteCartItemView setHidden:YES];
    [MBProgressHUD hideHUDForView:self animated:YES];
}

//清空购物车按钮
-(void)clearCartBtnClicked:(id)sender
{
    PADCartViewController *viewController=m_Delegate;
    if ([viewController threadRunning]) {
        return;
    }
    
    if ([m_ClearCartView isHidden]) {
        [m_ClearCartView setHidden:NO];
    } else {
        [m_ClearCartView setHidden:YES];
    }
    
    [m_DeleteCartItemView setHidden:YES];
}

//清空购物车
-(void)didClearCart:(id)sender
{
    if ([m_Delegate respondsToSelector:@selector(clearCartForTableView:)]) {
        [m_Delegate clearCartForTableView:self];
    }
    [self hideConfirmView];
}

//确认删除
-(void)didDeleteCartItem:(id)sender
{
    [m_DeleteCartItemView setHidden:YES];
    if (m_DeleteCartItemIndexPath.section==0) {//删除普通商品
        CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:m_DeleteCartItemIndexPath.row inArray:m_CartVO.buyItemList];
        if ([m_Delegate respondsToSelector:@selector(tableView:deleteCartItem:)]) {
            [m_Delegate tableView:self deleteCartItem:cartItemVO];
        }
    } else if (m_DeleteCartItemIndexPath.section==1) {//删除赠品
        CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:m_DeleteCartItemIndexPath.row inArray:m_CartVO.gifItemtList];
        if ([m_Delegate respondsToSelector:@selector(tableView:deleteGift:)]) {
            [m_Delegate tableView:self deleteGift:cartItemVO];
        }
    } else {//删除换购
        CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:m_DeleteCartItemIndexPath.row inArray:m_CartVO.redemptionItemList];
        if ([m_Delegate respondsToSelector:@selector(tableView:deleteRedemption:)]) {
            [m_Delegate tableView:self deleteRedemption:cartItemVO];
        }
    }
}

//继续购物
-(void)shopBtnClicked:(id)sender
{
    if ([m_Delegate respondsToSelector:@selector(goShopForTableView:)]) {
        [m_Delegate goShopForTableView:self];
    }
    [self hideConfirmView];
}

//去结算
-(void)buyBtnClicked:(id)sender
{
    if ([m_Delegate respondsToSelector:@selector(enterCheckOrderForTableView:)]) {
        [m_Delegate enterCheckOrderForTableView:self];
    }
    [self hideConfirmView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [m_CartVO.buyItemList count];
    } else if (section==1) {
        return [m_CartVO.gifItemtList count];
    } else {
        return [m_CartVO.redemptionItemList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PADCartTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PADCartCell"];
    if (cell==nil) {
        cell=[[[PADCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PADCartCell"] autorelease];
        [cell setDelegate:self];
    }
    CartItemVO *cartItemVO;
    if (indexPath.section==0) {
        cartItemVO=[OTSUtility safeObjectAtIndex:indexPath.row inArray:m_CartVO.buyItemList];
        [cell updateWithCartItemVO:cartItemVO type:CARTITEM_TYPE_NORMAL];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    } else if (indexPath.section==1) {
        cartItemVO=[OTSUtility safeObjectAtIndex:indexPath.row inArray:m_CartVO.gifItemtList];
        [cell updateWithCartItemVO:cartItemVO type:CARTITEM_TYPE_GIFT];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    } else {
        cartItemVO=[OTSUtility safeObjectAtIndex:indexPath.row inArray:m_CartVO.redemptionItemList];
        [cell updateWithCartItemVO:cartItemVO type:CARTITEM_TYPE_REDEMPTION];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0) {
        CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:indexPath.row inArray:m_CartVO.buyItemList];
        if ([m_Delegate respondsToSelector:@selector(tableView:didSelectCartItem:)]) {
            [m_Delegate tableView:self didSelectCartItem:cartItemVO];
        }
    }
    [self hideConfirmView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideConfirmView];
}

#pragma mark - PADCartTableViewCell
-(void)tableViewCell:(PADCartTableViewCell *)cell setCartItemCount:(int)count
{
    CartItemVO *cartItemVO=cell.cartItemVO;
    if ([m_Delegate respondsToSelector:@selector(tableView:cartItem:setCount:)]) {
        [m_Delegate tableView:self cartItem:cartItemVO setCount:count];
    }
    [self hideConfirmView];
}

-(void)tableViewCellDeleteCartItem:(PADCartTableViewCell *)cell
{
    PADCartViewController *viewController=m_Delegate;
    if ([viewController threadRunning]) {
        return;
    }
    
    NSIndexPath *indexPath=[m_TableView indexPathForCell:cell];
    if (m_DeleteCartItemIndexPath.section==indexPath.section && m_DeleteCartItemIndexPath.row==indexPath.row) {
        if ([m_DeleteCartItemView isHidden]) {
            [m_DeleteCartItemView setHidden:NO];
        } else {
            [m_DeleteCartItemView setHidden:YES];
        }
    } else {
        if (m_DeleteCartItemIndexPath!=nil) {
            [m_DeleteCartItemIndexPath release];
        }
        m_DeleteCartItemIndexPath=[indexPath retain];
        [m_DeleteCartItemView setHidden:NO];
    }
    
    [m_DeleteCartItemView setFrame:CGRectMake(624, 132+cell.frame.origin.y-m_TableView.contentOffset.y, 290, 86)];
    
    [m_ClearCartView setHidden:YES];
}

-(void)tableViewCellAddFavorite:(PADCartTableViewCell *)cell
{
    CartItemVO *cartItemVO=cell.cartItemVO;
    if ([m_Delegate respondsToSelector:@selector(tableView:cell:addFavoriteForCartItem:)]) {
        [m_Delegate tableView:self cell:cell addFavoriteForCartItem:cartItemVO];
    }
    [self hideConfirmView];
}

#pragma mark - 显示促销 tips
-(void)showBarTip:(NSString*)aMessage offset:(CGPoint)point
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.userInteractionEnabled = NO;
	// Configure for text only and offset down
//	hud.mode = MBProgressHUDModeText;
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [UIImage imageNamed:@"hasgiftandredemption@2x.png"];
    CALayer *layer = hud.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.bounds = CGRectMake(0, 0, image.size.width/2,image.size.height/2);
    layer.contents = (id)[image CGImage];
    hud.center = point;
    hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:6];
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_TableView);
    OTS_SAFE_RELEASE(m_CountLabel);
    OTS_SAFE_RELEASE(m_TotalPriceLabel);
    OTS_SAFE_RELEASE(m_FootLabel);
    OTS_SAFE_RELEASE(m_CartVO);
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_ClearCartView);
    OTS_SAFE_RELEASE(m_DeleteCartItemView);
    OTS_SAFE_RELEASE(m_DeleteCartItemIndexPath);
    [super dealloc];
}

@end
