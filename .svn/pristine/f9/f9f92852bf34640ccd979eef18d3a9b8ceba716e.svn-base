//
//  PADCartProductColumnCell.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//
typedef enum {
    CELL_FOR_BROWSE=1,
    CELL_FOR_FAVORITE,
    CELL_OTHER
} ProductColumnCellType;

#import "PADTableViewColumnCell.h"

@protocol PADCartProductColumnCellDelegate

@required
-(void)tableViewColumnCell:(PADTableViewColumnCell *)cell addProductAtIndex:(NSInteger)index;

@end

@interface PADCartProductColumnCell : PADTableViewColumnCell {
    UIImageView *m_ImageView;
    UILabel *m_Name;
    UILabel *m_Price;
    UIButton *m_Cart;
    ProductVO *m_ProductVO;
    int m_Type;
}

@property(nonatomic,readonly) UIImageView *imageView;
@property(nonatomic,readonly) ProductVO *productVO;
@property(nonatomic,readonly) int type;

-(id)initWithFrame:(CGRect)frame delegate:(id<PADTableViewColumnCellDelegate>)delegate type:(ProductColumnCellType)type;
@end
