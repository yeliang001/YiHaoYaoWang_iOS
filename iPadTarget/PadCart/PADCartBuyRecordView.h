//
//  PADCartBuyRecordView.h
//  TheStoreApp
//
//  Created by huang jiming on 12-11-23.
//
//

#import <UIKit/UIKit.h>
#import "PADCartBuyRecordDetailView.h"
#import "PADTableViewCell.h"

#define BUYRECORD_HEIGHT    542

@class PADCartBuyRecordView;
@class OtsPadLoadingView;

@protocol PADCartBuyRecordViewDelegate

@required
-(void)handelLongPressForRebuyOrder:(UILongPressGestureRecognizer*)aGesture;
-(void)handelLongPressForAddProduct:(UILongPressGestureRecognizer*)aGesture;
-(void)enterProductDetail:(ProductVO *)productVO;
-(void)addProduct:(ProductVO *)productVO;

@end

@interface PADCartBuyRecordView : UIView<UITableViewDataSource,UITableViewDelegate,PADCartBuyRecordDetailViewDelegate,PADTableViewCellDelegate,PADTableViewColumnCellDelegate> {
    id m_Delegate;
    NSMutableArray *m_AllOrder;
    int m_PageIndex;
    int m_TotalCount;
    int m_RealCount;
    UITableView *m_TableView;
    UIView *m_NilView;
    OtsPadLoadingView *m_LoadingView;
}

-(id)initWithFrame:(CGRect)frame delegate:(id<PADCartBuyRecordViewDelegate>)delegate;
@end
