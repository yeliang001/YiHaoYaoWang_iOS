//
//  PADCartFavoritesView.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//
#define FAVORITES_HEIGHT   542

#import <UIKit/UIKit.h>
#import "PADTableViewCell.h"
#import "OtsPadLoadingView.h"

@protocol PADCartFavoritesViewDelegate

-(void)handelLongPressForAddProduct:(UILongPressGestureRecognizer*)aGesture;
-(void)enterProductDetail:(ProductVO *)productVO;
-(void)addProduct:(ProductVO *)productVO;

@end

@interface PADCartFavoritesView : UIView<UITableViewDataSource,UITableViewDelegate,PADTableViewCellDelegate,PADTableViewColumnCellDelegate> {
    NSMutableArray *m_AllProducts;
    int m_PageIndex;
    int m_TotalCount;
    UITableView *m_TableView;
    UIView *m_NilView;
    id m_Delegate;
    OtsPadLoadingView *m_LoadingView;
}

-(id)initWithFrame:(CGRect)frame delegate:(id<PADCartFavoritesViewDelegate>)delegate;
-(void)updateSelf;
@end
