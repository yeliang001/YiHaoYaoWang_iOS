//
//  PADCartPageView.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-21.
//
//

#define PAGEVIEW_WIDTH  994
#define PAGEVIEW_HEIGHT 356

typedef enum {
    PAGE_VIEW_GIFT=1,
    PAGE_VIEW_REDEMPTION
} PageViewType;

#import <UIKit/UIKit.h>
#import "PADCartPageViewCell.h"
@class MobilePromotionVO;

@protocol PADCartPageViewDelegate

@required
-(void)receiveGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;
-(void)receiveRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;

-(void)deleteGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;
-(void)deleteRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;

@end

@interface PADCartPageView : UIView<PADCartPageViewCellDelegate> {
    CartVO *m_CartVO;
    MobilePromotionVO *m_MobilePromotionVO;
    PageViewType m_Type;
    id m_Delegate;
    NSMutableArray *m_AllPageViewCell;
    UILabel *m_StateInfo;
    UIImageView *m_ReceiveSuccess;
}

-(id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO mobilePromotionVO:(MobilePromotionVO *)mobilePromotionVO type:(PageViewType)type delegate:(id<PADCartPageViewDelegate>)delegate;
@end
