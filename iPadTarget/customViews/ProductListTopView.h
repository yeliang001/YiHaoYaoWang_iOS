//
//  ProductListTopView.h
//  yhd
//
//  Created by xuexiang on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryVO.h"
#import "Cate2Cell.h"
#import "CateCell.h"

typedef enum
{
    //类型，0 默认列表(分类) 1，搜索列表 2，促销精选 3,首页轮播促销 4,浏览历史
    kProductTopviewTypeCategory = 0
    , kProductTopviewTypeSearch        
    , kProductTopviewTypePromotion         
    , kProductTopviewTypePage
    , kProductTopviewTypeHistory
    , kProductTopviewTypeCoupon
    , kProductTopviewTypeOrderProducts

}EOtsProductTopviewType;

#define SearchLabelTag 101

@class ProductListViewController;
@interface ProductListTopView : UIView<UITableViewDataSource, UITableViewDelegate,Cate2CellDelegate,CateCellDelegate>{
    CategoryVO *cate1;
    CategoryVO *cate2;
    CategoryVO *cate3;
    NSNumber *cateid;
    NSArray *listData;
    NSString* activityTitle;
    UIViewController* rootViewController;
    UILabel* searchLabel;
    UIImageView* cateTableViewBgView;
}
@property(nonatomic, retain)CategoryVO *cate1;
@property(nonatomic, retain)CategoryVO *cate2;
@property(nonatomic, retain)CategoryVO *cate3;
@property(nonatomic, retain)NSNumber *cateid;
@property(nonatomic, retain)NSArray *listData;
@property(nonatomic, retain)UILabel* searchLabel;
@property(nonatomic, retain)NSString* activityTitle;
@property(nonatomic, assign)UIViewController* rootViewController;
@property(nonatomic, retain)UIImageView* cateTableViewBgView;

- (id)initWithFrame:(CGRect)frame type:(EOtsProductTopviewType)aType;
- (void)fitTheUI;
@end
