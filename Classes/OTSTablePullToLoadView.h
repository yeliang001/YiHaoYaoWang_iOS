//
//  OTSTablePullToLoadView.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTSTablePullToLoadView;

@interface OTSPullTableView : UITableView 
@property(nonatomic, retain)OTSTablePullToLoadView* pullToLoadView;
@property(nonatomic, assign)float   originalContentHeight;
@property(nonatomic, assign)BOOL    isReloadingOK;
@end



@interface OTSTablePullToLoadView : UIView
{
    OTSPullTableView        *tableView;
    OTSTablePullToLoadView  *pullToLoadView;
    //BOOL                    isShowing;
}

-(id)initWithTableView:(OTSPullTableView*)aTableView;
-(void)updateMyPos;

-(void)show:(BOOL)aShow;
-(void)showMe;
-(void)hideMe;
@end
