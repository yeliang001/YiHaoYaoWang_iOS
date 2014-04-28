//
//  BalanceDetailedUse.h
//  TheStoreApp
//
//  Created by xuexiang on 12-7-10.
//  Copyright 2012 OneTheStore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSBaseViewController.h"
#import "LoadingMoreLabel.h"

@interface BalanceDetailedUse : OTSBaseViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIScrollViewDelegate>{
	IBOutlet UILabel *balanceTotalLabel;
	IBOutlet UILabel *balanceCanUseLabel;
	IBOutlet UILabel *balanceFrozenLabel;
    
    IBOutlet UILabel *cardAvalableFeeLabel;
    IBOutlet UILabel *cardForzenFeeLabel;
    
	IBOutlet UITableView *m_tableView;
	IBOutlet UIScrollView *m_scrollView;
	IBOutlet UIView *m_TypeView;
	
	NSNumber * amount;						// 账户总余额（传入参数）
	NSNumber * availableAmount;				// 账户可用金额（传入参数）
    NSNumber * frozenAmount;				// 账户冻结金额（传入参数）
	
	int m_currentBtnTag;				    // 当前所在类型，用以在点击相同目类下不做处理
	int m_currentPageIndex;
	int m_amountDirection;					// 接口参数，目类种类
	int maxPage;							// 最多多少页正确数据
	BOOL m_ThreadRunning;
	BOOL m_isLoadingMore;
	NSMutableArray *m_DetailArray;
	int m_DetailTotalCount;
	
	UIView *nullView;
	UILabel *nullLabel;
	
	LoadingMoreLabel* m_LoadMoreLabel;
}
@property(nonatomic, retain)NSNumber * amount;
@property(nonatomic, retain)NSNumber * availableAmount;	
@property(nonatomic, retain)NSNumber * frozenAmount;
@property(nonatomic, retain)NSNumber * avalablaeCardFee;
@property(nonatomic, retain)NSNumber * frozenCardFee;

-(IBAction)backToPrevious:(id)sender;
-(IBAction)typeBtnClicked:(id)sender;
-(IBAction)telePhone:(id)sender;
-(void)setUpThread;
-(void)stopThread;
@end
