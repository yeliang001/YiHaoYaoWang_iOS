//
//  RecommendViewController.h
//  TheStoreApp
//
//  Created by 林盼 on 14-3-31.
//
//

#import "OTSBaseViewController.h"
#import "mobidea4ec.h"
#import "RecommendListView.h"



@interface RecommendViewController : OTSBaseViewController<UIScrollViewDelegate,mobideaRecProtocol,RecommendViewDelegate>
{
    NSArray *_tabNameArr;
    
    UIView *_dynamicLine;
    NSMutableArray *_recommendListViews;
    NSMutableArray *_tabTitleButtons;
    UIScrollView *_contentSv;
}

@end
