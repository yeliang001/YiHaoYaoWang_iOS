//
//  PADCartBrowseHistoryView.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//
#define BROWSE_HISTORY_HEIGHT   542

#import <UIKit/UIKit.h>
#import "PADTableViewCell.h"

@protocol PADCartBrowseHistoryViewDelegate

-(void)handelLongPressForAddProduct:(UILongPressGestureRecognizer*)aGesture;
-(void)enterProductDetail:(ProductVO *)productVO;
-(void)addProduct:(ProductVO *)productVO;

@end

@interface PADCartBrowseHistoryView : UIView<UITableViewDataSource,UITableViewDelegate,PADTableViewCellDelegate,PADTableViewColumnCellDelegate> {
    NSArray *m_AllProducts;
    UITableView *m_TableView;
    UIView *m_NilView;
    id m_Delegate;
}

-(id)initWithFrame:(CGRect)frame delegate:(id<PADCartBrowseHistoryViewDelegate>)delegate;
-(void)updateSelf;
@end
