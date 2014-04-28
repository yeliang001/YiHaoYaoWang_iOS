//
//  CategoryViewController.h
//  TheStoreApp
//
//  Created by jun yuan on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSBaseViewController.h"
#import "NSMutableArray+Stack.h"
@interface CategoryViewController : OTSBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*    cateTable; //显示列表
    NSNumber*       categoryId; //当前分类id
    NSMutableArray* categoryArray;//数据
    UILabel* infoLabel;
    NSString* titleText;
    NSNumber* cateLevel;//分类级数，从0开始到2后，再点非全部就进入商品列表
    NSMutableArray* cateLeveltrackArray;//跟踪分类筛选的层级
    
    UIAlertView *_errorAlert;
}
@property(nonatomic,retain)NSNumber* cateLevel;
@property(nonatomic,retain)NSNumber* categoryId;
@property(nonatomic ,retain)NSString* titleText;
- (void)initViews;
-(void)enterTopCategory:(BOOL)inCategory;
-(void)refreshCategory;
@end
