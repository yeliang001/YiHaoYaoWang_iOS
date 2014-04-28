//
//  OTSProductCommentViewV3.h
//  TheStoreApp
//
//  Created by towne on 13-4-2.
//
//

#import "OTSBaseViewController.h"
#import "ProductVO.h"
#import "OTSTabView.h"

@protocol OTSProductCommentTopCellDelegate
@required
-(void)iCommentRefreshgRPercentValueLabel:(NSNumber *)index;
@end

@interface OTSProductCommentViewV2 : OTSBaseViewController<UITableViewDataSource,UITableViewDelegate,OTSTabViewDelegate>
{
    int  currentPageIndex; //当前页面
    int  totalCount;//结果总数量
    BOOL isLoadingMore;//是否正在加载更多
}

@end
