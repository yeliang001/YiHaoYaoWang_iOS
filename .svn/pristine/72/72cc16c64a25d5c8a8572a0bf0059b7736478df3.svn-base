//
//  PADCartTabView.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-20.
//
//
#define DEFAULT_COLOR   [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]
#define DARK_RED    [UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]
#define TAB_WIDTH   141
#define TAB_HEIGHT  41
#import "PADCartTabView.h"
#import "PADCartPromotinView.h"
#import "GlobalValue.h"
#import "MobClick.h"

@implementation PADCartTabView
@synthesize promotionView=m_PromotionView,buyRecordView=m_BuyRecordView,browseHistory=m_BrowseHistory,favoritesView=m_FavoritesView,delegate=m_Delegate;

-(id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO delegate:(id<PADCartTabViewDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_CartVO=[cartVO retain];
        m_Delegate=delegate;
        m_SelectedIndex=0;
        [self initCartTabView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bringToPromotionalReceive) name:@"BringToPromotion" object:nil];
    }
    return self;
}

-(void)updateWithCartVO:(CartVO *)cartVO
{
    if (m_CartVO!=nil) {
        [m_CartVO release];
    }
    m_CartVO=[cartVO retain];
    
    //tab title
    [self updateTabTitleView];
    
    //main view
    m_NeedUpdatePromotion=YES;
    [self updateMainView];
}

-(void)initCartTabView
{
    //tab title
    [self updateTabTitleView];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, TAB_HEIGHT-1, 1024, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    [self addSubview:line];
    [self sendSubviewToBack:line];
    [line release];
    
    //main view
    if (m_MainView!=nil) {
        [m_MainView release];
    }
    m_MainView=[[UIView alloc] initWithFrame:CGRectMake(0, TAB_HEIGHT, 1024, TABVIEW_HEIGHT-TAB_HEIGHT)];
    [self addSubview:m_MainView];
    
    [self updateMainView];
}

-(void)updateTabTitleView
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {//已登录
        BOOL hasGift=NO;
        BOOL hasRedemption=NO;
        int i;
        for (i=0; i<[m_CartVO.buyItemList count]; i++) {
            CartItemVO *cartItemVO=[m_CartVO.buyItemList objectAtIndex:i];
            ProductVO *productVO=cartItemVO.product;
            if ([productVO.hasGift intValue]==1) {
                hasGift=YES;
            }
            if ([productVO.hasRedemption intValue]==1) {
                hasRedemption=YES;
            }
        }
        //标题
        if (m_Titles!=nil) {
            [m_Titles release];
        }
        if (hasGift || hasRedemption) {
            m_Titles=[[NSArray alloc] initWithObjects:@"  促销领取", @"  购买记录", @"  浏览历史", @"收藏夹", nil];
        } else {
            m_Titles=[[NSArray alloc] initWithObjects:@"  购买记录", @"  浏览历史", @"收藏夹", nil];
        }
        
        if (m_SelectedIndex>=[m_Titles count]) {
            m_SelectedIndex=[m_Titles count]-1;
        }
        
        //选中图片
        if (m_SelectImages!=nil) {
            [m_SelectImages release];
        }
        if (hasGift || hasRedemption) {
            m_SelectImages=[[NSArray alloc] initWithObjects:@"promo_sel", @"cart_sel", @"history_sel", @"fav_sel", nil];
        } else {
            m_SelectImages=[[NSArray alloc] initWithObjects:@"cart_sel", @"history_sel", @"fav_sel", nil];
        }
        
        //未选中图片
        if (m_UnselectImages!=nil) {
            [m_UnselectImages release];
        }
        if (hasGift || hasRedemption) {
            m_UnselectImages=[[NSArray alloc] initWithObjects:@"promo_unsel", @"cart_unsel", @"hitory_unsel", @"fav_unsel", nil];
        } else {
            m_UnselectImages=[[NSArray alloc] initWithObjects:@"cart_unsel", @"hitory_unsel", @"fav_unsel", nil];
        }
    } else {//未登录只显示浏览历史
        //标题
        if (m_Titles!=nil) {
            [m_Titles release];
        }
        m_Titles=[[NSArray alloc] initWithObjects:@"  浏览历史", nil];
        
        //选中图片
        if (m_SelectImages!=nil) {
            [m_SelectImages release];
        }
        m_SelectImages=[[NSArray alloc] initWithObjects:@"history_sel", nil];
        
        //未选中图片
        if (m_UnselectImages!=nil) {
            [m_UnselectImages release];
        }
        m_UnselectImages=[[NSArray alloc] initWithObjects:@"hitory_unsel", nil];
    }
    
    if (m_TitleButtons==nil) {
        m_TitleButtons=[[NSMutableArray alloc] initWithCapacity:0];
    } else {
        for (UIButton *button in m_TitleButtons) {
            [button removeFromSuperview];
        }
        [m_TitleButtons removeAllObjects];
    }
    
    if (m_TitleImages==nil) {
        m_TitleImages=[[NSMutableArray alloc] initWithCapacity:0];
    } else {
        for (UIImageView *imageView in m_TitleImages) {
            [imageView removeFromSuperview];
        }
        [m_TitleImages removeAllObjects];
    }
    
    int count=[m_Titles count];
    int i;
    for (i=0; i<count; i++) {
        NSString *title=[OTSUtility safeObjectAtIndex:i inArray:m_Titles];
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(TAB_WIDTH*i-10*i, 0, TAB_WIDTH, TAB_HEIGHT)];
        [button setTag:100+i];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[button.titleLabel.font fontWithSize:17.0]];
        [button addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button release];
        [m_TitleButtons addObject:button];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 25, 25)];
        [button addSubview:imageView];
        [imageView release];
        [m_TitleImages addObject:imageView];
        
        if (i==m_SelectedIndex) {
            [button setBackgroundImage:[UIImage imageNamed:@"tab_select"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"tab_high"] forState:UIControlStateHighlighted];
            [button setTitleColor:DARK_RED forState:UIControlStateNormal];
            [self bringSubviewToFront:button];
            
            [imageView setImage:[UIImage imageNamed:[OTSUtility safeObjectAtIndex:i inArray:m_SelectImages]]];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"tab_unselect"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"tab_high"] forState:UIControlStateHighlighted];
            [button setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
            [self sendSubviewToBack:button];
            
            [imageView setImage:[UIImage imageNamed:[OTSUtility safeObjectAtIndex:i inArray:m_UnselectImages]]];
        }
    }
}

//刷新main view
-(void)updateMainView
{
    if (m_PromotionView!=nil) {
        [m_PromotionView removeFromSuperview];
    }
    if (m_BuyRecordView!=nil) {
        [m_BuyRecordView removeFromSuperview];
    }
    if (m_BrowseHistory!=nil) {
        [m_BrowseHistory removeFromSuperview];
    }
    if (m_FavoritesView!=nil) {
        [m_FavoritesView removeFromSuperview];
    }
    
    if ([GlobalValue getGlobalValueInstance].token!=nil) {//已登录
        if (m_SelectedIndex==[m_Titles count]-1) {//收藏夹
            if (m_FavoritesView==nil) {
                m_FavoritesView=[[PADCartFavoritesView alloc] initWithFrame:CGRectMake(0, 0, m_MainView.frame.size.width, m_MainView.frame.size.height) delegate:self];
            }
            [m_MainView addSubview:m_FavoritesView];
        } else if (m_SelectedIndex==[m_Titles count]-2) {//浏览历史
            if (m_BrowseHistory==nil) {
                m_BrowseHistory=[[PADCartBrowseHistoryView alloc] initWithFrame:CGRectMake(0, 0, m_MainView.frame.size.width, m_MainView.frame.size.height) delegate:self];
            }
            [m_MainView addSubview:m_BrowseHistory];
        } else if (m_SelectedIndex==[m_Titles count]-3) {//购买记录
            if (m_BuyRecordView==nil) {
                m_BuyRecordView=[[PADCartBuyRecordView alloc] initWithFrame:CGRectMake(0, 0, m_MainView.frame.size.width, m_MainView.frame.size.height) delegate:self];
            }
            [m_MainView addSubview:m_BuyRecordView];
        } else if ((m_SelectedIndex==[m_Titles count]-4) && m_SelectedIndex>=0) {//促销信息
            if (m_PromotionView==nil) {
                m_PromotionView=[[PADCartPromotinView alloc] initWithFrame:CGRectMake(0, 0, m_MainView.frame.size.width, m_MainView.frame.size.height) cartVO:m_CartVO delegate:self];
            } else {
                if (m_NeedUpdatePromotion) {
                    [m_PromotionView updateWithCartVO:m_CartVO];
                }
            }
            [m_MainView addSubview:m_PromotionView];
            m_NeedUpdatePromotion=NO;
        } else {
            //do nothing
        }
    } else {//未登录
        if (m_SelectedIndex==[m_Titles count]-1) {//浏览历史
            if (m_BrowseHistory==nil) {
                m_BrowseHistory=[[PADCartBrowseHistoryView alloc] initWithFrame:CGRectMake(0, 0, m_MainView.frame.size.width, m_MainView.frame.size.height) delegate:self];
            }
            [m_MainView addSubview:m_BrowseHistory];
        }
    }
}

-(void)bringToPromotionalReceive
{
    [m_Delegate tabView:self tabClickedAtIndex:0];
    m_SelectedIndex = 0; // 返回第一个按钮
    int count=[m_Titles count];
    int i;
    for (i=0; i<count; i++) {
        UIButton *button=[OTSUtility safeObjectAtIndex:i inArray:m_TitleButtons];
        UIImageView *imageView=[OTSUtility safeObjectAtIndex:i inArray:m_TitleImages];
        if (i==m_SelectedIndex) {
            [button setBackgroundImage:[UIImage imageNamed:@"tab_select.png"] forState:UIControlStateNormal];
            [button setTitleColor:DARK_RED forState:UIControlStateNormal];
            [self bringSubviewToFront:button];
            
            [imageView setImage:[UIImage imageNamed:[OTSUtility safeObjectAtIndex:i inArray:m_SelectImages]]];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"tab_unselect.png"] forState:UIControlStateNormal];
            [button setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
            
            [imageView setImage:[UIImage imageNamed:[OTSUtility safeObjectAtIndex:i inArray:m_UnselectImages]]];
        }
    }
    [self updateMainView];
}

-(void)tabClicked:(id)sender
{
    UIButton *button=sender;
    
    if ([m_Delegate respondsToSelector:@selector(tabView:tabClickedAtIndex:)]) {
        [m_Delegate tabView:self tabClickedAtIndex:button.tag-100];
    }
    
    if (button.tag==100+m_SelectedIndex) {
        return;
    }
    
    m_SelectedIndex=button.tag-100;
    
    int count=[m_Titles count];
    int i;
    for (i=0; i<count; i++) {
        UIButton *button=[OTSUtility safeObjectAtIndex:i inArray:m_TitleButtons];
        UIImageView *imageView=[OTSUtility safeObjectAtIndex:i inArray:m_TitleImages];
        if (i==m_SelectedIndex) {
            [button setBackgroundImage:[UIImage imageNamed:@"tab_select.png"] forState:UIControlStateNormal];
            [button setTitleColor:DARK_RED forState:UIControlStateNormal];
            [self bringSubviewToFront:button];
            
            [imageView setImage:[UIImage imageNamed:[OTSUtility safeObjectAtIndex:i inArray:m_SelectImages]]];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"tab_unselect.png"] forState:UIControlStateNormal];
            [button setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
            
            [imageView setImage:[UIImage imageNamed:[OTSUtility safeObjectAtIndex:i inArray:m_UnselectImages]]];
        }
    }
    [self updateMainView];
    
    //友盟统计
    if ([GlobalValue getGlobalValueInstance].token!=nil) {//已登录
        if (m_SelectedIndex==[m_Titles count]-1) {//收藏夹
            [MobClick event:@"cart_fav"];
        } else if (m_SelectedIndex==[m_Titles count]-2) {//浏览历史
            [MobClick event:@"cart_history"];
        } else if (m_SelectedIndex==[m_Titles count]-3) {//购买记录
            [MobClick event:@"cart_record"];
        } else if ((m_SelectedIndex==[m_Titles count]-4) && m_SelectedIndex>=0) {//促销信息
            [MobClick event:@"cart_promo"];
        } else {
            //do nothing
        }
    } else {//未登录
        if (m_SelectedIndex==[m_Titles count]-1) {//浏览历史
            [MobClick event:@"cart_history"];
        }
    }
}

#pragma mark - PADCartPromotionViewDelegate
-(void)receiveGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
    if ([m_Delegate respondsToSelector:@selector(tabView:receiveGift:withTarget:selector:object:)]) {
        [m_Delegate tabView:self receiveGift:productVO withTarget:target selector:selector object:object];
    }
}

-(void)receiveRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
    if ([m_Delegate respondsToSelector:@selector(tabView:receiveRedemption:withTarget:selector:object:)]) {
        [m_Delegate tabView:self receiveRedemption:productVO withTarget:target selector:selector object:object];
    }
}

-(void)deleteGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
    if ([m_Delegate respondsToSelector:@selector(tabView:deleteGift:withTarget:selector:object:)]) {
        [m_Delegate tabView:self deleteGift:productVO withTarget:target selector:selector object:object];
    }
}

-(void)deleteRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
    if ([m_Delegate respondsToSelector:@selector(tabView:deleteRedemption:withTarget:selector:object:)]) {
        [m_Delegate tabView:self deleteRedemption:productVO withTarget:target selector:selector object:object];
    }
}

#pragma mark - PADCartBuyRecordViewDelegate
-(void)handelLongPressForRebuyOrder:(UILongPressGestureRecognizer*)aGesture
{
    if ([m_Delegate respondsToSelector:@selector(tabView:handelLongPressForRebuyOrder:)]) {
        [m_Delegate tabView:self handelLongPressForRebuyOrder:aGesture];
    }
}

-(void)handelLongPressForAddProduct:(UILongPressGestureRecognizer*)aGesture
{
    if ([m_Delegate respondsToSelector:@selector(tabView:handelLongPressForAddProduct:)]) {
        [m_Delegate tabView:self handelLongPressForAddProduct:aGesture];
    }
}

-(void)enterProductDetail:(ProductVO *)productVO
{
    if ([m_Delegate respondsToSelector:@selector(tabView:enterProductDetail:)]) {
        [m_Delegate tabView:self enterProductDetail:productVO];
    }
}

-(void)addProduct:(ProductVO *)productVO
{
    if ([m_Delegate respondsToSelector:@selector(tabView:addProduct:)]) {
        [m_Delegate tabView:self addProduct:productVO];
    }
}

#pragma mark - long press
-(void)handelLongPress:(UILongPressGestureRecognizer*)aGesture
{
    if ([m_Delegate respondsToSelector:_cmd]) {
        [m_Delegate performSelector:_cmd withObject:aGesture];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_Titles);
    OTS_SAFE_RELEASE(m_SelectImages);
    OTS_SAFE_RELEASE(m_UnselectImages);
    OTS_SAFE_RELEASE(m_CartVO);
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_MainView);
    OTS_SAFE_RELEASE(m_TitleButtons);
    OTS_SAFE_RELEASE(m_TitleImages);
    OTS_SAFE_RELEASE(m_PromotionView);
    OTS_SAFE_RELEASE(m_BuyRecordView);
    OTS_SAFE_RELEASE(m_BrowseHistory);
    OTS_SAFE_RELEASE(m_FavoritesView);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
