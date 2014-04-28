//
//  Filter.h
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultVO.h"
#import "SearchParameterVO.h"

#define FROM_CATEGORY   1
#define FROM_SEARCH     2

@interface Filter : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
    IBOutlet UIScrollView *m_ScrollView;//
    IBOutlet UIView *m_SecondView;//
    IBOutlet UITableView *m_SecondTableView;//
    IBOutlet UIButton *m_SecondRtnBtn;//
    IBOutlet UILabel *m_SecondTitle;//
    
    NSInteger m_CurrentTableIndex;
    NSArray *m_SecondArray;
    
    NSInteger m_FilterNum;
    NSMutableArray *m_PromotionTypes;
    SearchParameterVO* sPrama;
    SearchResultVO *m_SearchResultVO;//传入参数
    NSMutableDictionary *m_SelectedConditions;//传入参数，用户所选的筛选条件
    NSInteger m_FromTag;//传入参数，1从分类进入 2从搜索进入
}

@property(retain,nonatomic) SearchResultVO *m_SearchResultVO;//传入参数
@property(retain,nonatomic) NSMutableDictionary *m_SelectedConditions;//传入参数，用户所选的
@property(nonatomic) NSInteger m_FromTag;//传入参数，1从分类进入 2从搜索进入

-(void)initFilter;
-(void)initSecondView;
-(IBAction)cancelBtnClicked:(id)sender;
-(IBAction)finishBtnClicked:(id)sender;
-(IBAction)secondReturnBtnClicked:(id)sender;

@end
