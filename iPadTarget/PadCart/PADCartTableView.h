//
//  PADCartTableView.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-20.
//
//
#define TABLEVIEW_WIDTH     978
#define TABLEVIEW_HEIGHT    650
#define TABLEVIEW_FRAME CGRectMake(23, 0, TABLEVIEW_WIDTH, TABLEVIEW_HEIGHT)

#import <UIKit/UIKit.h>
#import "PADCartTableViewCell.h"
@class PADCartTableView;

@protocol PADCartTableViewDelegate

//修改商品数量
-(void)tableView:(PADCartTableView *)tableView cartItem:(CartItemVO *)cartItem setCount:(int)count;
//删除普通商品
-(void)tableView:(PADCartTableView *)tableView deleteCartItem:(CartItemVO *)cartItem;
//删除赠品
-(void)tableView:(PADCartTableView *)tableView deleteGift:(CartItemVO *)cartItem;
//删除换购
-(void)tableView:(PADCartTableView *)tableView deleteRedemption:(CartItemVO *)cartItem;
//收藏
-(void)tableView:(PADCartTableView *)tableView cell:(PADCartTableViewCell *)cell addFavoriteForCartItem:(CartItemVO *)cartItem;
//点击item
-(void)tableView:(PADCartTableView *)tableView didSelectCartItem:(CartItemVO *)cartItem;
//清空购物车
-(void)clearCartForTableView:(PADCartTableView *)tableView;
//继续购物
-(void)goShopForTableView:(PADCartTableView *)tableView;
//去结算
-(void)enterCheckOrderForTableView:(PADCartTableView *)tableView;

//去掉促销提示标签
-(void)removePromotTag;

@end

@interface PADCartTableView : UIView<UITableViewDataSource,UITableViewDelegate,PADCartTableViewCellDelegate> {
    UITableView *m_TableView;
    UILabel *m_CountLabel;
    UILabel *m_TotalPriceLabel;
    UILabel *m_FootLabel;
    CartVO *m_CartVO;
    id m_Delegate;
    UIView *m_ClearCartView;
    UIView *m_DeleteCartItemView;
    NSIndexPath *m_DeleteCartItemIndexPath;
}
-(id)initWithFrame:(CGRect)frame promotions:(BOOL)promot cartVO:(CartVO *)cartVO delegate:(id<PADCartTableViewDelegate>)delegate;
-(void)updateWithCartVO:(CartVO *)cartVO promotions:(BOOL)promot delegate:(id<PADCartTableViewDelegate>)delegate;
-(void)hideConfirmView;//隐藏确认删除按钮
@end
