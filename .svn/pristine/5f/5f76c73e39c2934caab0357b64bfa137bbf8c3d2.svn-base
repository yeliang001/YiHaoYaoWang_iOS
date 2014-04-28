//
//  PADCartPromotinView.m
//  TheStoreApp
//
//  Created by huang jiming on 12-11-21.
//
//

#import "PADCartPromotinView.h"
#import "CartService.h"
#import "GlobalValue.h"
#import "MobilePromotionVO.h"
#import "DataHandler.h"

@implementation PADCartPromotinView
@synthesize delegate=m_Delegate;

- (id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO delegate:(id<PADCartPromotionViewDelegate>)delegate
{
    self=[super initWithFrame:frame];
    if (self) {
        m_CartVO=[cartVO retain];
        m_Delegate=delegate;
        m_LoadingView=[[OtsPadLoadingView alloc] init];
        if ([GlobalValue getGlobalValueInstance].token!=nil) {
//            [self newThreadGetAllPromotion];
            //缓存不为空 取缓存
            CartVO * cacheCart = [DataHandler sharedDataHandler].cart;
            m_GiftArray = [cacheCart.mobileGifItemtList retain];
            m_RedemptionArray = [cacheCart.mobileRedemptionItemList retain];
            if (m_GiftArray && m_RedemptionArray) {
                [self initPromotionView];
                [self newThreadGetAllPromotionToCache];
            }
            else
                [self newThreadGetAllPromotion];
        } else {
            [self initPromotionView];
        }
    }
    return self;
}

-(void)updateWithCartVO:(CartVO *)cartVO
{
    if (m_CartVO!=nil) {
        [m_CartVO release];
    }
    m_CartVO=[cartVO retain];
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self newThreadGetAllPromotion];
}

-(void)initPromotionView
{
    CGFloat yValue=15.0;
    //赠品
    int i;
    for (i=0; i<[m_GiftArray count]; i++) {
        MobilePromotionVO *mobilePromotionVO=[OTSUtility safeObjectAtIndex:i inArray:m_GiftArray];
        PADCartPageView *pageView=[[PADCartPageView alloc] initWithFrame:CGRectMake(15, yValue, PAGEVIEW_WIDTH, PAGEVIEW_HEIGHT) cartVO:m_CartVO mobilePromotionVO:mobilePromotionVO type:PAGE_VIEW_GIFT delegate:self];
        [self addSubview:pageView];
        [pageView release];
        yValue+=PAGEVIEW_HEIGHT;
    }
    
    //换购
    for (i=0; i<[m_RedemptionArray count]; i++) {
        MobilePromotionVO *mobilePromotionVO=[OTSUtility safeObjectAtIndex:i inArray:m_RedemptionArray];
        PADCartPageView *pageView=[[PADCartPageView alloc] initWithFrame:CGRectMake(15, yValue, PAGEVIEW_WIDTH, PAGEVIEW_HEIGHT) cartVO:m_CartVO mobilePromotionVO:mobilePromotionVO type:PAGE_VIEW_REDEMPTION delegate:self];
        [self addSubview:pageView];
        [pageView release];
        yValue+=PAGEVIEW_HEIGHT;
    }
    
    [self setContentSize:CGSizeMake(1024, yValue+45.0)];
}

//获取所有赠品和换购
//增加缓存
-(void)newThreadGetAllPromotion
{
    [m_LoadingView showInView:m_Delegate];
    __block NSArray *tempGiftArray;
    __block NSArray *tempRedemptionArray;
    [self performInThreadBlock:^{
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        CartService *pServ=[[[CartService alloc] init] autorelease];
        //赠品
        tempGiftArray=[[pServ getGiftList:[GlobalValue getGlobalValueInstance].token] retain];
        //换购
        tempRedemptionArray=[[pServ getRedemptionList:[GlobalValue getGlobalValueInstance].token] retain];
        //赠品
        if (m_GiftArray!=nil) {
            [m_GiftArray release];
        }
        if (tempGiftArray==nil || [tempGiftArray isKindOfClass:[NSNull class]] || [tempGiftArray count]==0) {
            m_GiftArray=nil;
        } else {
            m_GiftArray=tempGiftArray;
        }
        //换购
        if (m_RedemptionArray!=nil) {
            [m_RedemptionArray release];
        }
        if (tempRedemptionArray==nil || [tempRedemptionArray isKindOfClass:[NSNull class]] || [tempRedemptionArray count]==0) {
            m_RedemptionArray=nil;
        } else {
            m_RedemptionArray=tempRedemptionArray;
        }

        //缓存赠品及换购数据
        CartVO * cacheCart = [DataHandler sharedDataHandler].cart;
        [cacheCart.mobileGifItemtList removeAllObjects];
        [cacheCart.mobileRedemptionItemList removeAllObjects];
        [cacheCart setMobileGifItemtList:[NSMutableArray arrayWithArray:tempGiftArray]];
        [cacheCart setMobileRedemptionItemList:[NSMutableArray arrayWithArray:tempRedemptionArray]];
        [[DataHandler sharedDataHandler] setCart:cacheCart];
        
        [pool drain];
    } completionInMainBlock:^{
        [m_LoadingView hide];
        [self initPromotionView];
        
    }];
}

-(void)newThreadGetAllPromotionToCache
{
    [self performInThreadBlock:^(){
        NSArray *tempGiftArray;
        NSArray *tempRedemptionArray;
        
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        CartService *pServ=[[[CartService alloc] init] autorelease];
        tempGiftArray=[[pServ getGiftList:[GlobalValue getGlobalValueInstance].token] retain];
        //换购
        tempRedemptionArray=[[pServ getRedemptionList:[GlobalValue getGlobalValueInstance].token] retain];
        //赠品
        if (m_GiftArray!=nil) {
            [m_GiftArray release];
        }
        if (tempGiftArray==nil || [tempGiftArray isKindOfClass:[NSNull class]] || [tempGiftArray count]==0) {
            m_GiftArray=nil;
        } else {
            m_GiftArray=tempGiftArray;
        }
        //换购
        if (m_RedemptionArray!=nil) {
            [m_RedemptionArray release];
        }
        if (tempRedemptionArray==nil || [tempRedemptionArray isKindOfClass:[NSNull class]] || [tempRedemptionArray count]==0) {
            m_RedemptionArray=nil;
        } else {
            m_RedemptionArray=tempRedemptionArray;
        }
        //缓存赠品及换购数据
        CartVO * cacheCart = [DataHandler sharedDataHandler].cart;
        [cacheCart.mobileGifItemtList removeAllObjects];
        [cacheCart.mobileRedemptionItemList removeAllObjects];
        [cacheCart setMobileGifItemtList:[NSMutableArray arrayWithArray:tempGiftArray]];
        [cacheCart setMobileRedemptionItemList:[NSMutableArray arrayWithArray:tempRedemptionArray]];
        [[DataHandler sharedDataHandler] setCart:cacheCart];
        [pool drain];
    }];
}


#pragma mark - PADCartPageViewDelegate
-(void)receiveGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
    if ([m_Delegate respondsToSelector:@selector(receiveGift:withTarget:selector:object:)]) {
        [m_Delegate receiveGift:productVO withTarget:target selector:selector object:object];
    }
}

-(void)receiveRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
    if ([m_Delegate respondsToSelector:@selector(receiveRedemption:withTarget:selector:object:)]) {
        [m_Delegate receiveRedemption:productVO withTarget:target selector:selector object:object];
    }
}

-(void)deleteGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
    if ([m_Delegate respondsToSelector:@selector(deleteGift:withTarget:selector:object:)]) {
        [m_Delegate deleteGift:productVO withTarget:target selector:selector object:object];
    }
}

-(void)deleteRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object
{
    if ([m_Delegate respondsToSelector:@selector(deleteRedemption:withTarget:selector:object:)]) {
        [m_Delegate deleteRedemption:productVO withTarget:target selector:selector object:object];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_CartVO);
    OTS_SAFE_RELEASE(m_GiftArray);
    OTS_SAFE_RELEASE(m_RedemptionArray);
    m_Delegate=nil;
    OTS_SAFE_RELEASE(m_LoadingView);
    [super dealloc];
}

@end
