//
//  RecommendListView.h
//  TheStoreApp
//
//  Created by 林盼 on 14-4-2.
//
//  热门推荐里面的内容View

#import <UIKit/UIKit.h>
#import "mobidea4ec.h"

@protocol RecommendViewDelegate <NSObject>

- (void)selectedProductId:(NSString *)productId;

@end

@interface RecommendListView : UIView<UITableViewDataSource,UITableViewDelegate,mobideaRecProtocol>
{
    UITableView *_tableView;
    NSMutableArray *_productList;
    
    UIActivityIndicatorView *_loadingView;
}

@property (assign,nonatomic)id delegate;
@property (copy,nonatomic)NSString *recommendType;

- (void)startLoadData:(NSString *)reommendType;

@end
