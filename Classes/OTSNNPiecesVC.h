//
//  OTSNNPiecesVC.h
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import "OTSNNPiecesTopView.h"
#import "OTSNNPiecesTableCell.h"

@interface OTSNNPiecesVC : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,OTSNNPiecesTopProductsDelegate,OTSNNPiecesTableCellDelegate>
{
    int currentPageIndex; //当前页面
    int productTotalCount;//结果总数量
    BOOL isLoadingMore;//是否正在加载更多
}

@property(nonatomic,retain) NSNumber *promotionId;
@property(nonatomic,retain) NSNumber *promotionLevelId;
@property(nonatomic,retain) NSString *nnpiecesTitle;
@property(nonatomic,retain) NSMutableArray *topviewproductsArray; //顶部的商品数据
@property(nonatomic) BOOL showCart; //显示购物车
@property(nonatomic) BOOL fromCart; //从购物车加载的在置换n元n件之前始终要显示购物车按钮

@end
