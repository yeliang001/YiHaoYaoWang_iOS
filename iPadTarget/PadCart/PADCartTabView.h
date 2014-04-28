//
//  PADCartTabView.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-20.
//
//

#define TABVIEW_Y   654
#define TABVIEW_HEIGHT  583
#define TABVIEW_FRAME   CGRectMake(0, TABVIEW_Y, 1024, TABVIEW_HEIGHT)

#import <UIKit/UIKit.h>
#import "PADCartPromotinView.h"
#import "PADCartBuyRecordView.h"
#import "PADCartBrowseHistoryView.h"
#import "PADCartFavoritesView.h"

@class PADCartTabView;

@protocol PADCartTabViewDelegate

@required
-(void)tabView:(PADCartTabView *)tabView receiveGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;
-(void)tabView:(PADCartTabView *)tabView receiveRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;

-(void)tabView:(PADCartTabView *)tabView deleteGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;
-(void)tabView:(PADCartTabView *)tabView deleteRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;

-(void)tabView:(PADCartTabView *)tabView tabClickedAtIndex:(int)index;
-(void)tabView:(PADCartTabView *)tabView handelLongPressForRebuyOrder:(UILongPressGestureRecognizer*)aGesture;
-(void)tabView:(PADCartTabView *)tabView handelLongPressForAddProduct:(UILongPressGestureRecognizer*)aGesture;
-(void)tabView:(PADCartTabView *)tabView enterProductDetail:(ProductVO *)productVO;
-(void)tabView:(PADCartTabView *)tabView addProduct:(ProductVO *)productVO;
@end

@class PADCartPromotinView;

@interface PADCartTabView : UIView<PADCartPromotionViewDelegate,PADCartBuyRecordViewDelegate,PADCartBrowseHistoryViewDelegate,PADCartFavoritesViewDelegate> {
    NSArray *m_Titles;
    NSArray *m_SelectImages;
    NSArray *m_UnselectImages;
    CartVO *m_CartVO;
    id m_Delegate;
    int m_SelectedIndex;
    UIView *m_MainView;
    NSMutableArray *m_TitleButtons;
    NSMutableArray *m_TitleImages;
    PADCartPromotinView *m_PromotionView;
    PADCartBuyRecordView *m_BuyRecordView;
    PADCartBrowseHistoryView *m_BrowseHistory;
    PADCartFavoritesView *m_FavoritesView;
    BOOL m_NeedUpdatePromotion;
}

@property(nonatomic,readonly) PADCartPromotinView *promotionView;
@property(nonatomic,readonly) PADCartBuyRecordView *buyRecordView;
@property(nonatomic,readonly) PADCartBrowseHistoryView *browseHistory;
@property(nonatomic,readonly) PADCartFavoritesView *favoritesView;
@property(nonatomic,assign) id delegate;

-(id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO delegate:(id<PADCartTabViewDelegate>)delegate;
-(void)updateWithCartVO:(CartVO *)cartVO;
@end
