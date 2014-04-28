//
//  PADCartPromotinView.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-21.
//
//

#import <UIKit/UIKit.h>
#import "PADCartPageView.h"
#import "OtsPadLoadingView.h"

@protocol PADCartPromotionViewDelegate

@required
-(void)receiveGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;
-(void)receiveRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;

-(void)deleteGift:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;
-(void)deleteRedemption:(ProductVO *)productVO withTarget:(id)target selector:(SEL)selector object:(id)object;

@end

@interface PADCartPromotinView : UIScrollView<PADCartPageViewDelegate> {
    CartVO *m_CartVO;
    NSArray *m_GiftArray;                   //list<MobilePromotionVO>
    NSArray *m_RedemptionArray;             //list<MobilePromotionVO>
    id m_Delegate;
    OtsPadLoadingView *m_LoadingView;
}

@property(nonatomic,assign) id delegate;

-(id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO delegate:(id<PADCartPromotionViewDelegate>)delegate;
-(void)updateWithCartVO:(CartVO *)cartVO;
@end
