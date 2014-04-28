//
//  PADCartBuyRecordDetailView.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-26.
//
//

#import <UIKit/UIKit.h>
#import "PADTableViewColumnCell.h"

@protocol PADCartBuyRecordDetailViewDelegate

-(void)enterProductDetail:(ProductVO *)productVO;
-(void)handelLongPressForAddProduct:(UILongPressGestureRecognizer*)aGesture;
-(void)addProduct:(ProductVO *)productVO;

@end

@interface PADCartBuyRecordDetailView : UIScrollView<PADTableViewColumnCellDelegate> {
    CGPoint m_OriginPoint;
    OrderV2 *m_OrderV2;
    id m_Delegate;
    NSMutableArray *m_AllView;
}

-(id)initWithFrame:(CGRect)frame originPoint:(CGPoint)point orderV2:(OrderV2 *)orderV2 delegate:(id<PADCartBuyRecordDetailViewDelegate>)delegate;
@end
