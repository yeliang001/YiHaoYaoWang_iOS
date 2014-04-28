//
//  CategoryProductsViewController.h
//  TheStoreApp
//
//  Created by jun yuan on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSBaseViewController.h"
#import "Filter.h"
#import "SearchResultVO.h"
#import "BackToTopView.h"
#import "NSObject+OTS.h"
#import "CartAnimation.h"
@class CategoryInfo;
@class PromotionInfo;
@class ConditionInfo;

@interface CategoryProductsViewController : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,CartAnimationDelegate>{
    NSString* titleText;
    NSString* titleLableText;  //标题
    UITableView* productsTable;//商品列表
    NSString * cateId;
//    NSNumber *promotionId;     //促销活动id
    
	NSNumber * buyQuantity;							// 购买商品数量

    UITableView* selectionTable;//排序和分类选择 共用table
    
    int selectionType;
    UIImageView*nullImg;//空态
    UIView* selectionBG;
    UIButton* selectionBTN;
    NSInteger sortType;//排序的类型
    int m_CurrentPageIndex;//当前页
    int m_ProductTotalCount;

    BOOL isLoadingMore;
    //筛选器

    BOOL isCashPromotionList;//状态，当前是否是满减列表
    BOOL isLastLevel;//表示从第三级分类进入的

    NSMutableDictionary *m_FilterDictionary;

    UIButton* cateBtn;
    UIButton* sortBtn;
    UIImageView*sortArrow;
    UIImageView*cateArrow;
    NSMutableArray* categoryTypeArray,/*传入的分类种类数据*/ *sortArray;//排序的种类数据
    
    BackToTopView *m_backToTop;						// 返回顶部
    UIImageView *cateBtnBG;
    UIButton *selectedProvince;
    
    UIAlertView *_errorAlert;
    
}
@property(nonatomic,assign)BOOL isLastLevel;
//@property(nonatomic,assign)BOOL isFailSatisfyFullDiscount;
@property(nonatomic,assign)BOOL isCashPromotionList;
@property(nonatomic,retain)NSString* titleText;
@property(nonatomic,retain)NSString* titleLableText;
@property(nonatomic,retain)NSMutableArray* categoryTypeArray;
@property(nonatomic,retain)NSString *cateId;

@property(nonatomic,assign)BOOL isTuangou; //是不是团购列表
@property(retain,nonatomic)CategoryInfo *currentCategory; //当前的分类
@property(assign,nonatomic)BOOL bSelectAllCategory;//是否选择了全部分类
@property(retain, nonatomic)PromotionInfo *promotion; //促销的id 用于显示促销详情
@property(retain, nonatomic)ConditionInfo *condition; //促销中当前的促销条件

- (void)initTop;
- (void)inittable;
- (void)sendRequset;
- (void)dismissSelection;
@end
