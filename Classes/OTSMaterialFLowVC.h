//
//  OTSMaterialFLowVC.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  描述：物流查询页面VC

#import <UIKit/UIKit.h>

@class LoadingMoreLabel;


@interface OTSMaterialFLowVC : OTSBaseViewController<UITableViewDelegate, UITableViewDataSource>
{

    BOOL isLoadingMore;
    
    NSMutableArray *_orderList;
    UIScrollView *_scrollView;
}

@end
