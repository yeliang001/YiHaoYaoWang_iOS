//
//  PADCartTableViewCell.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-23.
//
//
typedef enum {
    CARTITEM_TYPE_NORMAL=0,
    CARTITEM_TYPE_GIFT,
    CARTITEM_TYPE_CASH,
    CARTITEM_TYPE_REDEMPTION
} CartItemType;

typedef enum {
    CARTITEM_FAVORITE_SUCCESS=1,
    CARTITEM_HAVE_FAVORITED
} CartItemFavoriteResult;

#import <UIKit/UIKit.h>
@class PADCartTableViewCell;

@protocol PADCartTableViewCellDelegate

//修改商品数量
-(void)tableViewCell:(PADCartTableViewCell *)cell setCartItemCount:(int)count;
//删除item
-(void)tableViewCellDeleteCartItem:(PADCartTableViewCell *)cell;
//收藏
-(void)tableViewCellAddFavorite:(PADCartTableViewCell *)cell;

@end

@interface PADCartTableViewCell : UITableViewCell {
    id m_Delegate;
    UIImageView *m_ImageView;
    UIImageView *m_TypeImage;
    UILabel *m_NameLabel;
    UILabel *m_UnitPriceLabel;
    UIButton *m_MinusBtn;
    UIButton *m_CountBtn;
    UIButton *m_AddBtn;
    UILabel *m_WeightLabel;
    UILabel *m_TotalPriceLabel;
    UIButton *m_DeleteBtn;
    UIButton *m_FavoriteBtn;
    CartItemVO *m_CartItemVO;
    UIImageView *m_FavoriteSuccess;
    UIImageView *m_HaveFavorited;
}

@property(nonatomic,assign) id<PADCartTableViewCellDelegate> delegate;
@property(nonatomic,readonly) CartItemVO *cartItemVO;

-(void)updateWithCartItemVO:(CartItemVO *)cartItemVO type:(CartItemType)type;
-(void)showFavoriteTip:(CartItemFavoriteResult)result;
@end
