//
//  ProductListViewController.h
//  yhd
//
//  Created by  on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  DESCRIPTION: 产品列表VC

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PopViewController.h"
#import "CartView.h"
#import "Cate2Cell.h"
#import "CateCell.h"
#import "WEPopoverController.h"
#import "HotPointNewVO.h"
#import "CmsPageVO.h"
#import "CmsColumnVO.h"

enum ProductListType{  //列表类型:0.默认列表 1.搜索列表 2.促销精选 3.首页轮播促销 4.浏览历史 5.抵用券 6.订单商品页
    ListType_Category = 0,
    ListType_Search,
    ListType_Promotion,
    ListType_Pages,
    ListType_History,
    ListType_Coupon,
    ListType_orderProducts
};

@class CategoryVO,SearchBrandVO,SearchPriceVO;
@class TopView,ProductView,ProductListTopView;
@interface ProductListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,PopViewControllerDelegate,CartViewDelegate>{
    TopView *topView;
    ProductListTopView *productListTopView;
    CartView *cartView;
    
    CGRect oldViewRect;
    
    IBOutlet UITableView *productTableView;
    NSMutableArray *productListData;
    NSInteger viewNumInCell;
    
    NSNumber *cateid;
    CategoryVO* cate1;
    CategoryVO* cate2;
    CategoryVO* cate3;
    NSArray *listData;
    NSMutableArray *categories;
    NSMutableDictionary *cate2Dic;
    UIView *cateView;
    UIView *cateDetailView;
    UITableView *cateTableView;
    UIImageView *cateTableViewBgView;
    
    NSString *keyword;
    NSString *price;
    NSString *filter;
    NSNumber *sortType;
    NSString *attributes;
    NSNumber *brandId;
    
    NSArray *searchAttributes;
    SearchBrandVO *searchBrandVO;
    SearchPriceVO *searchPriceVO;
    
    WEPopoverController *currentPopover;
    UIButton *priceBut;
    UIButton *filterBut;
    UIButton *salesBut;
    UIButton *evaluateBut;
    UIButton *defBut;
    UILabel *searcheLabel;
    UIImageView *butBg;
    UIButton *cleanHistory;
    UIView   *clearHistoryView;
    
    BOOL isLoadFinish;
    NSNumber *currentPage;
    NSArray *butArray;
    UIView *popTag;
    NSInteger productListType;//列表类型:0.默认列表 1.搜索列表 2.促销精选 3.首页轮播促销 4.浏览历史 5.抵用券
    
    NSNumber *activityID;
    NSString *activityTitle;
    NSNumber *isYihaodian;//筛选条件的是否只含1号店商品，0是所有，1是自营商品
}
@property(nonatomic,retain)NSMutableArray *productListData;
@property(nonatomic,retain)NSArray *listData;
@property(nonatomic,retain)NSNumber *cateid;
@property(nonatomic,retain)CategoryVO* cate1;
@property(nonatomic,retain)CategoryVO* cate2;
@property(nonatomic,retain)CategoryVO* cate3;
@property(nonatomic,retain)NSMutableArray *categories;
@property(nonatomic,retain)NSMutableDictionary *cate2Dic;
@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,copy)NSString *filter;

@property(nonatomic,copy)NSString *attributes;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSNumber *brandId;

@property(nonatomic,copy)NSNumber *sortType;
@property(nonatomic,copy)NSNumber *currentPage;
@property(nonatomic,retain)NSArray *searchAttributes;
@property(nonatomic,retain)SearchBrandVO *searchBrandVO;
@property(nonatomic,retain)SearchPriceVO *searchPriceVO;
@property(nonatomic,retain)NSArray *butArray;
@property (retain, nonatomic)WEPopoverController *currentPopover;
@property (nonatomic)NSInteger productListType;
@property(nonatomic,retain)NSNumber *activityID;
@property(nonatomic,copy)NSString *activityTitle;
@property(nonatomic,retain)NSNumber *isYihaodian;
-(void)cateSelected:(NSNumber *)acateid;
-(void)reloadListData;
- (void)loadProductListTop;
@end
