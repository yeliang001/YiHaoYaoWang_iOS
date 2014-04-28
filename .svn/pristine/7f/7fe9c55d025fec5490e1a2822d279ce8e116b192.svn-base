//
//  PADCartFloatView.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-23.
//
//
#define FLOATVIEW_WIDTH     984
#define FLOATVIEW_HEIGHT    106
#define FLOATVIEW_FRAME     CGRectMake(20, -FLOATVIEW_HEIGHT, FLOATVIEW_WIDTH, FLOATVIEW_HEIGHT)

#import <UIKit/UIKit.h>
@class PADCartFloatView;

@protocol PADCartFloatViewDelegate

@required
-(void)floatView:(PADCartFloatView *)floatView cartItem:(CartItemVO *)cartItem setCount:(int)count;
-(void)enterCheckOrderForFloatView:(PADCartFloatView *)floatView;

@end

@interface PADCartFloatView : UIView {
    CartVO *m_CartVO;
    id m_Delegate;
    UIImageView *m_ImageView;
    UILabel *m_PriceLabel;
    UIButton *m_MinusBtn;
    UIButton *m_CountBtn;
    UIButton *m_AddBtn;
    UILabel *m_CountLabel;
    UILabel *m_TotalLabel;
    UILabel *m_TotalPriceLabel;
    UIButton *m_BuyBtn;
    UILabel *m_NilView;
    UIImageView *m_DragPromp;
}

-(id)initWithFrame:(CGRect)frame cartVO:(CartVO *)cartVO delegate:(id<PADCartFloatViewDelegate>)delegate;
-(void)updateWithCartVO:(CartVO *)cartVO;
-(void)showDragPrompt;//显示拖动加入购物车提示
-(void)hideDragPrompt;//隐藏拖动加入购物车提示
@end
