//
//  PADCartPageViewCell.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-22.
//
//
typedef enum {
    PAGE_VIEW_CELL_GIFT=1,
    PAGE_VIEW_CELL_REDEMPTION
} PageViewCellType;

#import <UIKit/UIKit.h>
@class MobilePromotionVO;

@protocol PADCartPageViewCellDelegate

@required
-(void)selectGiftPageViewCellAtIndex:(NSNumber *)index;
-(void)selectRedemptionPageViewCellAtIndex:(NSNumber *)index;
-(void)deleteGiftPageViewCellAtIndex:(NSNumber *)index;
-(void)deleteRedemptionPageViewCellAtIndex:(NSNumber *)index;

@end

@interface PADCartPageViewCell : UIView {
    CartVO *m_CartVO;
    MobilePromotionVO *m_MobilePromotionVO;
    id m_Delegate;
    int m_Tag;
    PageViewCellType m_Type;
    UIImageView *m_SelectStateImageView;
    BOOL m_Selected;
}

-(id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO mobilePromotionVO:(MobilePromotionVO *)mobilePromotionVO tag:(int)tag type:(PageViewCellType)type delegate:(id<PADCartPageViewCellDelegate>)delegate;
-(void)setSelectedState:(BOOL)selected;
@end
