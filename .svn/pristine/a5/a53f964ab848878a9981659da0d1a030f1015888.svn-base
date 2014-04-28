//
//  PADCartPageView.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-21.
//
//
#define DEFAULT_COLOR   [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]
#define DARK_RED    [UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]
#define YELLOW_GREEN [UIColor colorWithRed:0.0 green:107.0/255.0 blue:19.0/255.0 alpha:1.0]

#import "PADCartPageView.h"
#import "OTSPageView.h"
#import "MobilePromotionVO.h"
#import "SDImageView+SDWebCache.h"
#import "StrikeThroughLabel.h"
#import "PADCartPromotinView.h"
#import "PADCartTabView.h"
#import "PADCartViewController.h"

@implementation PADCartPageView

-(id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO mobilePromotionVO:(MobilePromotionVO *)mobilePromotionVO type:(PageViewType)type delegate:(id<PADCartPageViewDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        m_CartVO=[cartVO retain];
        m_MobilePromotionVO=[mobilePromotionVO retain];
        m_Type=type;
        m_Delegate=delegate;
        [self initCartPageView];
    }
    return self;
}

-(void)initCartPageView
{
    m_AllPageViewCell=[[NSMutableArray alloc] initWithCapacity:0];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PAGEVIEW_WIDTH, 325)];
    if (m_Type==PAGE_VIEW_GIFT) {
        [imageView setImage:[UIImage imageNamed:@"cart_gift_bg.png"]];
    } else if (m_Type==PAGE_VIEW_REDEMPTION) {
        [imageView setImage:[UIImage imageNamed:@"cart_redemption_bg.png"]];
    }
    [self addSubview:imageView];
    [imageView release];
    
    //标题
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(65, 0, 700, 44)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:[NSString stringWithFormat:@"%@ %@",m_MobilePromotionVO.title,m_MobilePromotionVO.description]];
    [title setFont:[title.font fontWithSize:17.0]];
    [title setTextColor:DEFAULT_COLOR];
    [self addSubview:title];
    [title release];
    
    UILabel *state=[[UILabel alloc] initWithFrame:CGRectMake(800, 0, 90, 44)];
    [state setBackgroundColor:[UIColor clearColor]];
    if (m_Type==PAGE_VIEW_GIFT) {
        [state setText:@"领取状态："];
    } else if (m_Type==PAGE_VIEW_REDEMPTION) {
        [state setText:@"换购状态："];
    }
    [state setFont:[title.font fontWithSize:17.0]];
    [state setTextColor:DEFAULT_COLOR];
    [self addSubview:state];
    [state release];
    
    m_StateInfo=[[UILabel alloc] initWithFrame:CGRectMake(890, 0, 104, 44)];
    [m_StateInfo setBackgroundColor:[UIColor clearColor]];
    if ([m_MobilePromotionVO.canJoin intValue]==1 ) {
        if (m_Type==PAGE_VIEW_GIFT) {
            //是否已领取
            BOOL hasGot=NO;
            int i;
            for (i=0; i<[m_CartVO.gifItemtList count]; i++) {
                CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:i inArray:m_CartVO.gifItemtList];
                int j;
                for (j=0; j<[m_MobilePromotionVO.productVOList count]; j++) {
                    ProductVO *productVO=[OTSUtility safeObjectAtIndex:j inArray:m_MobilePromotionVO.productVOList];
                    if ([cartItemVO.product.productId intValue]==[productVO.productId intValue] && [cartItemVO.product.promotionId isEqualToString:productVO.promotionId]) {
                        hasGot=YES;
                        break;
                        }
                    }
                }
            
            if (hasGot) {
                [m_StateInfo setText:@"已领取1件"];
                [m_StateInfo setTextColor:DEFAULT_COLOR];
            } else {
                [m_StateInfo setText:@"可领取1件"];
                [m_StateInfo setTextColor:YELLOW_GREEN];
                //判断是否还有赠品未领完
                int k;
                for (k =0; k<[m_MobilePromotionVO.productVOList count]; k++) {
                    ProductVO *productVO=[OTSUtility safeObjectAtIndex:k inArray:m_MobilePromotionVO.productVOList];
                    NSLog(@">>>> %d | %d",k,productVO.isSoldOut.intValue);
                    if (productVO.isSoldOut.intValue !=1) {
                        NSLog(@"可领取且还有赠品没领完");
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"ExiteGiftToBeUseNotification" object:@"YES"];
                        break;
                    }
                }
            }
            
        } else if (m_Type==PAGE_VIEW_REDEMPTION) {
            //是否已换购
            BOOL hasGot=NO;
            int i;
            for (i=0; i<[m_CartVO.redemptionItemList count]; i++) {
                CartItemVO *cartItemVO=[OTSUtility safeObjectAtIndex:i inArray:m_CartVO.redemptionItemList];
                int j;
                for (j=0; j<[m_MobilePromotionVO.productVOList count]; j++) {
                    ProductVO *productVO=[OTSUtility safeObjectAtIndex:j inArray:m_MobilePromotionVO.productVOList];
                    if ([cartItemVO.product.productId intValue]==[productVO.productId intValue] && [cartItemVO.product.promotionId isEqualToString:productVO.promotionId]) {
                        hasGot=YES;
                        break;
                    }
                }
            }
            
            if (hasGot) {
                [m_StateInfo setText:@"已换购1件"];
                [m_StateInfo setTextColor:DEFAULT_COLOR];
            } else {
                [m_StateInfo setText:@"可换购1件"];
                [m_StateInfo setTextColor:YELLOW_GREEN];
            }
            
        }
    } else {
        [m_StateInfo setText:@"未满足条件"];
        [m_StateInfo setTextColor:DARK_RED];
    }
    [m_StateInfo setFont:[title.font fontWithSize:17.0]];
    [self addSubview:m_StateInfo];
    
    //多于1页才显示status bar
    OTSDotStatusBar *statusBar;
    int totalCount=[m_MobilePromotionVO.productVOList count];
    if (totalCount>4) {
        statusBar=[[[OTSDotStatusBar alloc] initWithFrame:CGRectMake(0, 275, PAGEVIEW_WIDTH, 31)] autorelease];
    } else {
        statusBar=nil;
    }
    OTSPageView *pageView=[[OTSPageView alloc] initWithFrame:CGRectMake(0, 44, PAGEVIEW_WIDTH, 270) delegate:self statusBar:statusBar sleepTime:0];
    [self addSubview:pageView];
    [pageView release];
    
    //领取、换购成功
    m_ReceiveSuccess=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 70, 40)];
    [m_ReceiveSuccess setImage:[UIImage imageNamed:@"FavouriteResultInCartCell.png"]];
    [self addSubview:m_ReceiveSuccess];
    [m_ReceiveSuccess setHidden:YES];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [label setBackgroundColor:[UIColor clearColor]];
    if (m_Type==PAGE_VIEW_GIFT) {
        [label setText:@"领取成功"];
    } else if (m_Type==PAGE_VIEW_REDEMPTION) {
        [label setText:@"换购成功"];
    }
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[label.font fontWithSize:14.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [m_ReceiveSuccess addSubview:label];
    [label release];
}

#pragma mark - 领取换购tip
-(void)showReceiveTipWithIndex:(NSNumber *)index
{
    CGFloat xValue=[index intValue]%4*PAGEVIEW_WIDTH/4+163;
    [m_ReceiveSuccess setFrame:CGRectMake(xValue, 10, 70, 40)];
    [m_ReceiveSuccess setHidden:NO];
    [self performSelector:@selector(hideReceiveTip) withObject:nil afterDelay:1];
}

//隐藏领取结果提示
-(void)hideReceiveTip
{
    [m_ReceiveSuccess setHidden:YES];
}

#pragma mark - OTSPageViewDelegate
-(void)pageView:(OTSPageView *)pageView didTouchOnPage:(NSIndexPath *)indexPath
{
    
}

-(void)pageView:(OTSPageView *)pageView pageChangedTo:(NSIndexPath *)indexPath
{
    
}

-(UIView *)pageView:(OTSPageView *)pageView pageAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width=pageView.frame.size.width;
    CGFloat height=pageView.frame.size.height;
    UIView *view=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)] autorelease];
    int totalCount=[m_MobilePromotionVO.productVOList count];
    int startIndex=indexPath.row*4;
    int endIndex=indexPath.row*4+3;
    if (endIndex>totalCount-1) {
        endIndex=totalCount-1;
    }
    int i;
    for (i=startIndex; i<=endIndex; i++) {
        CGFloat singleWidth=width/4;
        PADCartPageViewCell *cell;
        if (m_Type==PAGE_VIEW_GIFT) {
            cell=[[PADCartPageViewCell alloc] initWithFrame:CGRectMake((i-startIndex)*singleWidth, 0, singleWidth, pageView.frame.size.height) cartVO:m_CartVO mobilePromotionVO:m_MobilePromotionVO tag:i type:PAGE_VIEW_CELL_GIFT delegate:self];
        } else if (m_Type==PAGE_VIEW_REDEMPTION) {
            cell=[[PADCartPageViewCell alloc] initWithFrame:CGRectMake((i-startIndex)*singleWidth, 0, singleWidth, pageView.frame.size.height) cartVO:m_CartVO mobilePromotionVO:m_MobilePromotionVO tag:i type:PAGE_VIEW_CELL_REDEMPTION delegate:self];
        }
        [view addSubview:cell];
        [cell release];
        [m_AllPageViewCell addObject:cell];
    }
    return view;
}

-(NSInteger)numberOfPagesInPageView:(OTSPageView *)pageView
{
    int totalCount=[m_MobilePromotionVO.productVOList count];
    if (totalCount%4>0) {
        return totalCount/4+1;
    } else {
        return totalCount/4;
    }
}

#pragma mark - PADCartPageViewCellDelegate
-(void)selectGiftPageViewCellAtIndex:(NSNumber *)index
{
    PADCartPromotinView *promotionView=m_Delegate;
    PADCartTabView *tabView=promotionView.delegate;
    PADCartViewController *viewController=tabView.delegate;
    if ([viewController threadRunning]) {
        return;
    }
    
    int i;
    for (i=0; i<[m_AllPageViewCell count]; i++) {
        PADCartPageViewCell *cell=[OTSUtility safeObjectAtIndex:i inArray:m_AllPageViewCell];
        if (i==[index intValue]) {
            [cell setSelectedState:YES];
        } else {
            [cell setSelectedState:NO];
        }
    }
    
    [m_StateInfo setText:@"已领取1件"];
    [m_StateInfo setTextColor:DEFAULT_COLOR];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ExiteGiftToBeUseNotification" object:@"NO"];
    
    if ([m_Delegate respondsToSelector:@selector(receiveGift:withTarget:selector:object:)]) {
        ProductVO *productVO=[OTSUtility safeObjectAtIndex:[index intValue] inArray:m_MobilePromotionVO.productVOList];
        [m_Delegate receiveGift:productVO withTarget:self selector:@selector(showReceiveTipWithIndex:) object:index];
    }
}

-(void)selectRedemptionPageViewCellAtIndex:(NSNumber *)index
{
    PADCartPromotinView *promotionView=m_Delegate;
    PADCartTabView *tabView=promotionView.delegate;
    PADCartViewController *viewController=tabView.delegate;
    if ([viewController threadRunning]) {
        return;
    }
    
    int i;
    for (i=0; i<[m_AllPageViewCell count]; i++) {
        PADCartPageViewCell *cell=[OTSUtility safeObjectAtIndex:i inArray:m_AllPageViewCell];
        if (i==[index intValue]) {
            [cell setSelectedState:YES];
        } else {
            [cell setSelectedState:NO];
        }
    }
    
    [m_StateInfo setText:@"已换购1件"];
    [m_StateInfo setTextColor:DEFAULT_COLOR];
    
    if ([m_Delegate respondsToSelector:@selector(receiveRedemption:withTarget:selector:object:)]) {
        ProductVO *productVO=[OTSUtility safeObjectAtIndex:[index intValue] inArray:m_MobilePromotionVO.productVOList];
        [m_Delegate receiveRedemption:productVO withTarget:self selector:@selector(showReceiveTipWithIndex:) object:index];
    }
}

-(void)deleteGiftPageViewCellAtIndex:(NSNumber *)index
{
    PADCartPromotinView *promotionView=m_Delegate;
    PADCartTabView *tabView=promotionView.delegate;
    PADCartViewController *viewController=tabView.delegate;
    if ([viewController threadRunning]) {
        return;
    }
    
    int i;
    for (i=0; i<[m_AllPageViewCell count]; i++) {
        PADCartPageViewCell *cell=[OTSUtility safeObjectAtIndex:i inArray:m_AllPageViewCell];
        [cell setSelectedState:NO];
    }
    
    [m_StateInfo setText:@"可领取1件"];
    [m_StateInfo setTextColor:YELLOW_GREEN];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ExiteGiftToBeUseNotification" object:@"YES"];
    
    if ([m_Delegate respondsToSelector:@selector(deleteGift:withTarget:selector:object:)]) {
        ProductVO *productVO=[OTSUtility safeObjectAtIndex:[index intValue] inArray:m_MobilePromotionVO.productVOList];
        [m_Delegate deleteGift:productVO withTarget:self selector:nil object:nil];
    }
}

-(void)deleteRedemptionPageViewCellAtIndex:(NSNumber *)index
{
    PADCartPromotinView *promotionView=m_Delegate;
    PADCartTabView *tabView=promotionView.delegate;
    PADCartViewController *viewController=tabView.delegate;
    if ([viewController threadRunning]) {
        return;
    }
    
    int i;
    for (i=0; i<[m_AllPageViewCell count]; i++) {
        PADCartPageViewCell *cell=[OTSUtility safeObjectAtIndex:i inArray:m_AllPageViewCell];
        [cell setSelectedState:NO];
    }
    
    [m_StateInfo setText:@"可换购1件"];
    [m_StateInfo setTextColor:YELLOW_GREEN];
    
    if ([m_Delegate respondsToSelector:@selector(deleteRedemption:withTarget:selector:object:)]) {
        ProductVO *productVO=[OTSUtility safeObjectAtIndex:[index intValue] inArray:m_MobilePromotionVO.productVOList];
        [m_Delegate deleteRedemption:productVO withTarget:self selector:nil object:nil];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_CartVO);
    OTS_SAFE_RELEASE(m_MobilePromotionVO);
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_AllPageViewCell);
    OTS_SAFE_RELEASE(m_StateInfo);
    OTS_SAFE_RELEASE(m_ReceiveSuccess);
    [super dealloc];
}

@end


