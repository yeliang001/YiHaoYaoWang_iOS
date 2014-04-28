//
//  OTSGrouponDetail.h
//  yhd
//
//  Created by jiming huang on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoginViewController.h"
#import "WebViewController.h"
#import "WEPopoverController.h"
#import "OTSPopViewController.h"

@class TopView;

@interface OTSGrouponDetail : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIWebViewDelegate,LoginDelegate,OTSPopViewControllerDelegate> {
    TopView *m_TopView;
    UIButton *m_CategoryButton;
    WEPopoverController *m_WEPopoverController;
    UITableView *m_RightTableView;
    UILabel *m_CategoryLabel;
    
    NSMutableDictionary *m_InputDictionary;//传入参数
    NSMutableArray *m_GrouponList;
    int m_GrouponId;
    int m_GrouponTotalNumber;
    int m_AreaId;
    int m_CategoryId;
    int m_PageIndex;
    GrouponVO *m_CurrentGrouponVO;
    WebViewController* webVC;
    NSArray *m_CategoryArray;
    int m_CurrentIndex;
    
    UIView *m_LoadingView;
}

@property(nonatomic,retain)NSMutableDictionary *m_InputDictionary;//传入参数

-(void)switchToCategory:(int)categoryId;
@end
